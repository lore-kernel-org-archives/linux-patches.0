Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542FF1292FC;
	Mon,  8 Apr 2024 13:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583850; cv=none; b=Rm/nbrAxEKS1ulJZp+sGZHI2DqF/eBCFAQ/HDAjszGmN/0kqDiJAtTkSoxcVsDijbQslrndM7HOeY370NbGga3XycSnOm/HPBny/1+YM3dQQdIOTz7hEdti5p9PQeSswuFnRkuAwJhbr089bTzCcRJNzeY2U5ArZAtmtbaFx8hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583850; c=relaxed/simple;
	bh=TNQWf7L2DCmYkzA6M1vB3jBeK8LQ8ytMJKxUekvDZt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKekQsnCXwMiU1SgxNttFZFYIAtslEKO+sz74lO6jpyFx3b5l4Bc9mtWiu7I0embcFXfjza0n3ZH0j/3oLxsj+tpf9NzEOYOlQkbGZrzrdC8Kmap8znKmCpDcRwIuR2XhGq/0gq5JLh/01bB9Cdc0N4VQXitF51bSOikHeb4WHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDPmo9fU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDPmo9fU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D169FC43390;
	Mon,  8 Apr 2024 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583850;
	bh=TNQWf7L2DCmYkzA6M1vB3jBeK8LQ8ytMJKxUekvDZt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDPmo9fUcFWfqHmRZxV4WK6KvOWx9wi+vMlpVJZVxrtjxVrRRMMBnVQkLirMhWHQ9
	 qHCDNDVCzBwpKWDNuwE+/A7Vrga6iK5I9uGGXUrkjscyr/X3LOHh11vxY+/SVDdYTB
	 fHFOn9aVYZGJnQK/87cz2Goxh1T1sUwoJfOpN74s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 295/690] nfsd: use fsnotify group lock helpers
Date: Mon,  8 Apr 2024 14:52:41 +0200
Message-ID: <20240408125410.301421638@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfsd/filecache.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 97ca256a76323..b1afe6db589f2 100644
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
@@ -672,7 +673,7 @@ nfsd_file_cache_init(void)
 	}
 
 	nfsd_file_fsnotify_group = fsnotify_alloc_group(&nfsd_file_fsnotify_ops,
-							0);
+							FSNOTIFY_GROUP_NOFS);
 	if (IS_ERR(nfsd_file_fsnotify_group)) {
 		pr_err("nfsd: unable to create fsnotify group: %ld\n",
 			PTR_ERR(nfsd_file_fsnotify_group));
-- 
2.43.0



