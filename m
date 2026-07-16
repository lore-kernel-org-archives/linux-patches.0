Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DF5425882;
	Thu, 16 Jul 2026 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211996; cv=none; b=GONIlJu5TUTkhFrOMSCKNae7F/LqfTgOaplaMmGQG9n0LJCYUsOk82h63VTIEqm27VjdGDeFy7sNLCzZWZz4g5vZkeHU+tFDg82vQIEMmZc8C4Qu7ZOghfB3AO5KxQoCTxghV4y52iIIYGb5BUxMqdW8aSRYRPfwmO7hzp6UL4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211996; c=relaxed/simple;
	bh=89dM5Ke/LRX6ZOJMBC/TDOmJiFWuxbXRFUgINhmsBTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8xtcnW0vhhAgWwAJIARjM61r5cD7b5OZC0szUxoYZ8v+e470B6ipRenuhEMk724Glr3oTTn6kxrM647zrOwB8zQ/OhuCXCgBV9pr0UOrd1PPrRvw5JHYTWv3zHGXtmTLbPvTP6teTS57qx1d+wm1LRmMQnkWxyBBzMbRE3p3Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBl19I+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBl19I+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6951F000E9;
	Thu, 16 Jul 2026 14:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211994;
	bh=2REPC3Etb3pXeOSibF0GkmoGne8+O0ufp3sfJEZx5TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBl19I+By/ek80sldaafG6j2ySDKrgdqrRuzcYm77KSSPlYXXcRT/ffk5wwOFk4kp
	 odkHMbTEunZHIcu8MqdGUMciz/sPDJo2aQTrlunuDFFjg4SfSHlYKT44q0Nft6z8TF
	 IBrMmmfWqOPn3X+3okk0Mf0//kcILGhcM5JUaeUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c1e9aedbd913fadad617@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/349] fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()
Date: Thu, 16 Jul 2026 15:31:34 +0200
Message-ID: <20260716133036.961018241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4390c0e4bfb78a..940a8293abe9c0 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1044,6 +1044,20 @@ int attr_data_get_block(struct ntfs_inode *ni, CLST vcn, CLST clen, CLST *lcn,
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



