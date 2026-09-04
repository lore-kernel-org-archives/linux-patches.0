Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92333A1E69;
	Fri,  4 Sep 2026 05:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499582; cv=none; b=P+FAYNFI6U1ENgIF5vTZ9mWnyrPqA7EQdlPTOiVFD6s+MRl/PQ3G5zfMdyVcogutkzt6I+zIayJwHnBbw4xstEXou0UEJgyOqRZnHGYpD0jL0qcfYASsguh6bltw4F1Rc5mRD0zeK4P7D5A8NUQGprufy0PFpokCNDTF5jQReOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499582; c=relaxed/simple;
	bh=Ai9egHsZFwEsp6GGLSsKvmpyeiAmAPg9wkEP3LTJRCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSLIFaqEf5UutHOIwcVTYv1pzsoSRFqbswa2qZcY9k+fEiC4NTv3xchhV7xa5xKpwPCuUcVbhY15ndWPI9bBI1Y4230xZAeMOLqu3XuUTOmVOEKrO2++2dfOqIb+nsLNQHBrGsTiEP6STgZkoDSDM4l6JQcMDJsOMwt2JhFhQDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnSrqL9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnSrqL9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153F81F00A3D;
	Fri,  4 Sep 2026 05:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499581;
	bh=SuzT7pf0VrDycv9dw9BW8vaCCkNxQMTBxTvTo0A4zz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnSrqL9Okzk3zW7W7R1TX6lcQAHlMHtFbuLTRPfbTVp0snpzi33PAtLcZIj7JzKq6
	 19I8u62HgYSL8aZCkv2r0JV9sSpM225nlmy/pP4PQcpatzv5V0tXOLJ/ADXK0TLm8L
	 sdNfhxBFX7i0Tan9hAN6tedt6S1ZQfe7fHT3DFI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 468/713] ocfs2: fix cached cluster count after suballocator reclaim
Date: Fri,  4 Sep 2026 06:57:16 +0200
Message-ID: <20260904045814.313372561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

commit 621c2bcb87548ff6fe7ec1116f9b27ed87fbeb48 upstream.

When reclaiming a suballocator block group, first reduce the on-disk
cluster count by cl_cpg.  The current code then subtracts that new count
(fe->i_clusters) from the old cached count
(OCFS2_I(alloc_inode)->ip_clusters).

For an allocator with N block groups, that leaves the cache at

    N * cl_cpg - (N * cl_cpg - cl_cpg) = cl_cpg

i.e.  ip_clusters -= (fe->i_clusters - cl_cpg) leaves ip_clusters equal to
cl_cpg regardless of N.  This happens to be correct when reclaiming from
two block groups, but undercounts the clusters from three block groups
onwards.  The incorrect cache value is also used immediately to update
i_blocks.

Assign the updated on-disk count to the cache, matching the allocation and
inode refresh paths.

In a QEMU test using a clean 256 MiB OCFS2 image and a 10,000-file
create/delete workload, the first buggy reclaim left the on-disk
(fe->i_clusters) and cached (ip_clusters) counts at 2048 and 512 clusters
respectively; later reclaims underflowed the cache.  With this change, the
cache matched the on-disk count across all four reclaims: 2048, 1536,
1024, and 512 clusters.

Link: https://lore.kernel.org/20260805113920.385959-1-matthias.goergens@gmail.com
Fixes: 4a54331616b3 ("ocfs2: give ocfs2 the ability to reclaim suballocator free bg")
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/suballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/suballoc.c b/fs/ocfs2/suballoc.c
index a4a2b87a45fe..20c3aec6b987 100644
--- a/fs/ocfs2/suballoc.c
+++ b/fs/ocfs2/suballoc.c
@@ -2759,7 +2759,7 @@ static int _ocfs2_reclaim_suballoc_to_main(handle_t *handle,
 	fe->i_clusters = cpu_to_le32(tmp_used - le16_to_cpu(cl->cl_cpg));
 
 	spin_lock(&OCFS2_I(alloc_inode)->ip_lock);
-	OCFS2_I(alloc_inode)->ip_clusters -= le32_to_cpu(fe->i_clusters);
+	OCFS2_I(alloc_inode)->ip_clusters = le32_to_cpu(fe->i_clusters);
 	fe->i_size = cpu_to_le64(ocfs2_clusters_to_bytes(alloc_inode->i_sb,
 					     le32_to_cpu(fe->i_clusters)));
 	spin_unlock(&OCFS2_I(alloc_inode)->ip_lock);
-- 
2.55.0



