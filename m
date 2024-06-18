Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE8514F12F;
	Tue, 18 Jun 2024 13:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716000; cv=none; b=jXStoDHSoaYz2vKUPXlxKeGke4x5LEfpGn3ARg5hcLONplJtHgtNXAILTt+ZoTAf4gUkeyMS66u1D/PJQoOZHTR8Ug5A05FbCpHUD+iHVXkrBDHHI0NmqskGUsHzpgylYpqdjd5TSpE2kwmpol4jtVIpx+fZyuJ47iUFOPf0ZDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716000; c=relaxed/simple;
	bh=AGqtB2v68zmYfaNN43gshywy/7B+nbE+gaWHidHxsrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAh9bIiorC9f+yh1nUmjwoQ7GgVHIcby39/O3e603CPHJObhIkBGPBVkobQIe7SV/rCfHJlksGhlh2ryxr5dQ5z2EiM2DafkINJPArRQJSefUc9CV4+XhqoNOlV9a5TWGQzCWfyx0g0xvYKWNj+Nz+aNUxDwmu0J9vwALLb66Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSaLbyUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSaLbyUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D66C3277B;
	Tue, 18 Jun 2024 13:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716000;
	bh=AGqtB2v68zmYfaNN43gshywy/7B+nbE+gaWHidHxsrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSaLbyUTDYPDQiTiJyPtgdjfSb/dqSibpaM00U7WVzTzXU05+8mht8NnkcKxJiqPa
	 ToSOjxQ+a4oDFUId45Qs4ENUCVd4GEsLibhv4m3Yc5ko0cC7IA2ps0l0TH0gPhaJiY
	 bmGQq7/oAdcGe1910RKepfKBBpzSr6dbIVVrxprU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 498/770] nfsd: use fsnotify group lock helpers
Date: Tue, 18 Jun 2024 14:35:51 +0200
Message-ID: <20240618123426.540895573@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit b8962a9d8cc2d8c93362e2f684091c79f702f6f3 ]

Before commit 9542e6a643fc6 ("nfsd: Containerise filecache laundrette")
nfsd would close open files in direct reclaim context and that could
cause a deadlock when fsnotify mark allocation went into direct reclaim
and nfsd shrinker tried to free existing fsnotify marks.

To avoid issues like this in future code, set the FSNOTIFY_GROUP_NOFS
flag on nfsd fsnotify group to prevent going into direct reclaim from
fsnotify_add_inode_mark().

Link: https://lore.kernel.org/r/20220422120327.3459282-10-amir73il@gmail.com
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220321112310.vpr7oxro2xkz5llh@quack3.lan/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 7ae2b6611fb29..7e99e75b75d73 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -118,14 +118,14 @@ nfsd_file_mark_find_or_create(struct nfsd_file *nf)
 	struct inode *inode = nf->nf_inode;
 
 	do {
-		mutex_lock(&nfsd_file_fsnotify_group->mark_mutex);
+		fsnotify_group_lock(nfsd_file_fsnotify_group);
 		mark = fsnotify_find_mark(&inode->i_fsnotify_marks,
-				nfsd_file_fsnotify_group);
+					  nfsd_file_fsnotify_group);
 		if (mark) {
 			nfm = nfsd_file_mark_get(container_of(mark,
 						 struct nfsd_file_mark,
 						 nfm_mark));
-			mutex_unlock(&nfsd_file_fsnotify_group->mark_mutex);
+			fsnotify_group_unlock(nfsd_file_fsnotify_group);
 			if (nfm) {
 				fsnotify_put_mark(mark);
 				break;
@@ -133,8 +133,9 @@ nfsd_file_mark_find_or_create(struct nfsd_file *nf)
 			/* Avoid soft lockup race with nfsd_file_mark_put() */
 			fsnotify_destroy_mark(mark, nfsd_file_fsnotify_group);
 			fsnotify_put_mark(mark);
-		} else
-			mutex_unlock(&nfsd_file_fsnotify_group->mark_mutex);
+		} else {
+			fsnotify_group_unlock(nfsd_file_fsnotify_group);
+		}
 
 		/* allocate a new nfm */
 		new = kmem_cache_alloc(nfsd_file_mark_slab, GFP_KERNEL);
@@ -678,7 +679,7 @@ nfsd_file_cache_init(void)
 	}
 
 	nfsd_file_fsnotify_group = fsnotify_alloc_group(&nfsd_file_fsnotify_ops,
-							0);
+							FSNOTIFY_GROUP_NOFS);
 	if (IS_ERR(nfsd_file_fsnotify_group)) {
 		pr_err("nfsd: unable to create fsnotify group: %ld\n",
 			PTR_ERR(nfsd_file_fsnotify_group));
-- 
2.43.0



