Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F14217C;
	Sun,  1 Sep 2024 17:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210130; cv=none; b=J64jLhyfqu/QKrppVi0TokTKkmSOoWZC3FOzI0Ncn/hVPA9y+poAwMUMKaU2G0r8j873D4AhRhEgNTHfEGghPBknNqWovFu2HQD9ggKaIThaX8cChKWTMxoK3NU7pFjngiN996ooeQe82lw8QSDmR4Y07Ny+mRVbSo5Ft/gG4b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210130; c=relaxed/simple;
	bh=y25OGzwl+Mhr/D2PPM2yGZaeXPV1HImcgF5lRAhesU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roDI9s3iXWmVH52Wyy5pDNc8voFVFfUME1iAsFmg8Xu0ukY+IytOlD7xE7aDIKHrjmO+QqHw6ZVtoHGD9PBJxpNhWh9JDqufCvnfux5/vtm0ecBTkQrEGT+6Cpxtr9PWKIwz49RfRbie9U5icy3bBl7bdPxFY0j5wuQQyXr4a2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjfPP9Rw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjfPP9Rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8A1C4CEC3;
	Sun,  1 Sep 2024 17:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210130;
	bh=y25OGzwl+Mhr/D2PPM2yGZaeXPV1HImcgF5lRAhesU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjfPP9Rwayc0L1kzxYrF+piJvY8ydE9P52IoP41Hv/LUxZyTr7HJtIrFuEb702A7M
	 tcyyK+SpZ976fT9eg4pUafMEn361+BN7Vduj6vGegg20o59QYSg2wBGqHNavV6c5QU
	 OMIgcQru6nWBd7jovELcRPT2Y7kOKm2JYi+WINiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/215] fuse: fix UAF in rcu pathwalks
Date: Sun,  1 Sep 2024 18:16:22 +0200
Message-ID: <20240901160825.998688907@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 053fc4f755ad43cf35210677bcba798ccdc48d0c ]

->permission(), ->get_link() and ->inode_get_acl() might dereference
->s_fs_info (and, in case of ->permission(), ->s_fs_info->fc->user_ns
as well) when called from rcu pathwalk.

Freeing ->s_fs_info->fc is rcu-delayed; we need to make freeing ->s_fs_info
and dropping ->user_ns rcu-delayed too.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/cuse.c   |  3 +--
 fs/fuse/fuse_i.h |  1 +
 fs/fuse/inode.c  | 15 +++++++++++----
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index c7d882a9fe339..295344a462e1d 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -474,8 +474,7 @@ static int cuse_send_init(struct cuse_conn *cc)
 
 static void cuse_fc_release(struct fuse_conn *fc)
 {
-	struct cuse_conn *cc = fc_to_cc(fc);
-	kfree_rcu(cc, fc.rcu);
+	kfree(fc_to_cc(fc));
 }
 
 /**
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 55b7ca26fb8ab..ac655c7a15db2 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -848,6 +848,7 @@ struct fuse_mount {
 
 	/* Entry on fc->mounts */
 	struct list_head fc_entry;
+	struct rcu_head rcu;
 };
 
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 396866f9d72c3..40a4c7680bd7e 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -883,6 +883,14 @@ void fuse_conn_init(struct fuse_conn *fc, struct fuse_mount *fm,
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
+static void delayed_release(struct rcu_head *p)
+{
+	struct fuse_conn *fc = container_of(p, struct fuse_conn, rcu);
+
+	put_user_ns(fc->user_ns);
+	fc->release(fc);
+}
+
 void fuse_conn_put(struct fuse_conn *fc)
 {
 	if (refcount_dec_and_test(&fc->count)) {
@@ -894,13 +902,12 @@ void fuse_conn_put(struct fuse_conn *fc)
 		if (fiq->ops->release)
 			fiq->ops->release(fiq);
 		put_pid_ns(fc->pid_ns);
-		put_user_ns(fc->user_ns);
 		bucket = rcu_dereference_protected(fc->curr_bucket, 1);
 		if (bucket) {
 			WARN_ON(atomic_read(&bucket->count) != 1);
 			kfree(bucket);
 		}
-		fc->release(fc);
+		call_rcu(&fc->rcu, delayed_release);
 	}
 }
 EXPORT_SYMBOL_GPL(fuse_conn_put);
@@ -1297,7 +1304,7 @@ EXPORT_SYMBOL_GPL(fuse_send_init);
 void fuse_free_conn(struct fuse_conn *fc)
 {
 	WARN_ON(!list_empty(&fc->devices));
-	kfree_rcu(fc, rcu);
+	kfree(fc);
 }
 EXPORT_SYMBOL_GPL(fuse_free_conn);
 
@@ -1836,7 +1843,7 @@ static void fuse_sb_destroy(struct super_block *sb)
 void fuse_mount_destroy(struct fuse_mount *fm)
 {
 	fuse_conn_put(fm->fc);
-	kfree(fm);
+	kfree_rcu(fm, rcu);
 }
 EXPORT_SYMBOL(fuse_mount_destroy);
 
-- 
2.43.0



