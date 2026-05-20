Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4033EAC8F;
	Wed, 20 May 2026 16:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296103; cv=none; b=owDGUlsq0jkLW2LKx/7J55p2g9FcGQImucxFC2pLz/r0KIATe2v2YZin34mCZnldT7u/WZse7j0sDUSeCNhnOzeqfdhuu4KIPrDW7m2Gp1v0mWgvM866YMiKynBjIY2sT3AYeKnmAYKoGAfOHc3cI0lLnqUs/Y6cNZRwpno3l/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296103; c=relaxed/simple;
	bh=E13KsS+ghHiDyaQvJUAVmGAOGAUKeom2lrKYeG0pPVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAuzgGzNnMSoI5/d6BRqJWHAxQI+TLGk+A1c/x+g8iBFcRk/wVcHW2kT5vLa+vloPU/xtoABZz/jWJPDYnBKtEa3HyTHWlJ1oUAEmXMKqzLAvqjqu9/xD4E6br2qIFynhj2PTMgQH477Wnk8WQw5RdcUgzNSlsgrcqk+ICPRONw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3Ih7RIY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3Ih7RIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248D81F000E9;
	Wed, 20 May 2026 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296102;
	bh=tXUj1hFOjQKlz+Z4M9caHixF8lTqW0bwU2kUWd/ZG8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3Ih7RIYg/BpeRcoWSvUE729nhp8XmPuiXSaKjIqWIEG61epw+ASvGLcJkqOym2wP
	 sJT5OU4AgYQ78+LTcVY73TFidhq1D+6gk+o5tVGCEQfTdEaGIROh/jTiFXH1stK9Qa
	 ha1grxEUOLqueiaWLYvnvNSg/V9n+7IM3lU/elvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c1e9aedbd913fadad617@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0672/1146] fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()
Date: Wed, 20 May 2026 18:15:22 +0200
Message-ID: <20260520162203.393748646@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ntfs3/attrib.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 6cb9bc5d605c2..76e581d3961d0 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1152,6 +1152,21 @@ int attr_data_get_block_locked(struct ntfs_inode *ni, CLST vcn, CLST clen,
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
+
 		da = false; /* no delalloc for compressed file. */
 	}
 
-- 
2.53.0



