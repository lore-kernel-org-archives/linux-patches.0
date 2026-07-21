Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71CB415F16;
	Tue, 21 Jul 2026 20:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665110; cv=none; b=JgwglBjP5RhwDkNzFLsIvR1IRJEnVTBQEfGLsJu7jtxAmtMpJp8rMNJx/tPcpgrFM4uE9I62ti5BeuzIoA2Wv7Lm/uwxApA/Gg8gSWTQdBPlvMtS2Sa1KZ/quSzZzuy7kd37/FAH5/+9rT1BSixVJ+M+RxX+sT/o8mUZ3vZdLV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665110; c=relaxed/simple;
	bh=6D7oLPzh8pChBMp0lyTO7c2Y8LYuLGmIqiADfChM9LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbkLy8FXlPBF0C7Eq57t5iQ9/LAk15azA2pITjgABBlyB+KgTkBuqOx4fbjKsJSRWGabaIvo0BD5C18cBWjfuK9pSs6OUHig9lHP12C94sEXVzmYXpQiHtM1+JUSO1mV8vhfWw+4Yzubsmts4NGpP1bw/eANpj4J+Xr8FsudS/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWIrtYcB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWIrtYcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4997E1F000E9;
	Tue, 21 Jul 2026 20:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665108;
	bh=HpNJMhUeM//SsZ69/rWIqyo/foRbfticamAKzDwblrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWIrtYcB8QkOZsqxXCFCXx+poMZSUlX9zrvEgZ55pSedcDifD6jVO2B+YfT/ZxwbB
	 DeRggNvwg6lIcjdhWZc1WfROOWyuW7q4/yLXLxpuS3EM1ybW6X+P00hCqeBR0KxDW/
	 MkbI2Rg8pWWtu4MKo6cpZkqtZyXyM3I6pDVgDfcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c1e9aedbd913fadad617@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0178/1266] fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()
Date: Tue, 21 Jul 2026 17:10:15 +0200
Message-ID: <20260721152445.791032351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit d7ea8495fd307b58f8867acd81a1b40075b1d3ba ]

When a compressed or sparse attribute has its clusters frame-aligned,
vcn is rounded down to the frame start using cmask, which can result
in vcn != vcn0. In this case, vcn and vcn0 may reside in different
attribute segments.

The code already handles the case where vcn is in a different segment
by loading its runs before allocation. However, it fails to load runs
for vcn0 when vcn0 resides in a different segment than vcn. This causes
run_lookup_entry() to return SPARSE_LCN for vcn0 since its segment was
never loaded into the in-memory run list, triggering the WARN_ON(1).

Fix this by adding a missing check for vcn0 after the existing vcn
segment check. If vcn0 falls outside the current segment range
[svcn, evcn1), find and load the attribute segment containing vcn0
before performing the run lookup.

The following scenario triggers the bug:
  attr_data_get_block_locked()
    vcn = vcn0 & cmask        <- vcn != vcn0 after frame alignment
    load runs for vcn segment <- vcn0 segment not loaded!
    attr_allocate_clusters()  <- allocation succeeds
    run_lookup_entry(vcn0)    <- vcn0 not in run -> SPARSE_LCN
    WARN_ON(1)                <- bug fires here!

Reported-by: syzbot+c1e9aedbd913fadad617@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c1e9aedbd913fadad617
Fixes: c380b52f6c57 ("fs/ntfs3: Change new sparse cluster processing")
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 8f033e30e0d799..a590c541861332 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1045,6 +1045,20 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
 			if (err)
 				goto out;
 		}
+
+		if (vcn0 < svcn || evcn1 <= vcn0) {
+			struct ATTRIB *attr2;
+
+			attr2 = ni_find_attr(ni, attr_b, &le_b, ATTR_DATA, NULL,
+					       0, &vcn0, &mi);
+			if (!attr2) {
+				err = -EINVAL;
+				goto out;
+			}
+			err = attr_load_runs(attr2, ni, run, NULL);
+			if (err)
+				goto out;
+		}
 	}
 
 	if (vcn + to_alloc > asize)
-- 
2.53.0



