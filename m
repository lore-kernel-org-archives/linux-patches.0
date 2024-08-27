Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9931B1C579F;
	Tue, 27 Aug 2024 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770302; cv=none; b=sGi5ZxCX+mwKUXmix7yhUWFTSf9tP9ic1z2mqvWzw8+wKmnAKLWbfxYW29ylvKib1Pjg8U1u4qHYN1cAOIzAm64ZNCzctifLMy8wBceB240+Og6IXaiM1RE0mdxUxVbR2u1C6sYGN18QqM58y0cw7DRWOnVweN9N2fQeGFfDfVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770302; c=relaxed/simple;
	bh=rUZxcQ4LxvXNbFd/ZxYVjAL4mP1vFY5oSVq5VGI9sWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X74zD6OI9VKKPJ1zv4nUIZPEAcUeKizZlrnnW2ImP612UQvdj/XtqEMH4PUmGRb3Ge5dvw00xI3bEpceXHGwDm4GKjBHDgMtvVyUTv6ggrTpopRsaW2yQ2bk2p4wSljQ/fcSUff59DNcDQFYwYwBcJ0RvdteyILuQsViZhY+xxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4eaOF2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4eaOF2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBB2C4DE11;
	Tue, 27 Aug 2024 14:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770302;
	bh=rUZxcQ4LxvXNbFd/ZxYVjAL4mP1vFY5oSVq5VGI9sWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4eaOF2ZNJvG1xgFr34YtoIiAm2aIU0mKsz7X7D2tTPXOQBStJqV5DrVEymdlwtPz
	 6LN+fBF5UGWZIkBD3g1J7uiO0009kru5QqVoKvL331bvSlARAeunYP5po4aOUprgNs
	 vtWw1hqJIAozXpGfjMov6HPF+plvRunwrqf45X5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/341] fuse: fix UAF in rcu pathwalks
Date: Tue, 27 Aug 2024 16:36:28 +0200
Message-ID: <20240827143849.390893632@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 91e89e68177ee..b6cad106c37e4 100644
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
index 3e65cdc946316..4ce1a6fdc94f0 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -888,6 +888,7 @@ struct fuse_mount {
 
 	/* Entry on fc->mounts */
 	struct list_head fc_entry;
+	struct rcu_head rcu;
 };
 
 static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 04c7ba3ea03a2..735abf426a064 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -952,6 +952,14 @@ void fuse_conn_init(struct fuse_conn *fc, struct fuse_mount *fm,
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
@@ -963,13 +971,12 @@ void fuse_conn_put(struct fuse_conn *fc)
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
@@ -1387,7 +1394,7 @@ EXPORT_SYMBOL_GPL(fuse_send_init);
 void fuse_free_conn(struct fuse_conn *fc)
 {
 	WARN_ON(!list_empty(&fc->devices));
-	kfree_rcu(fc, rcu);
+	kfree(fc);
 }
 EXPORT_SYMBOL_GPL(fuse_free_conn);
 
@@ -1921,7 +1928,7 @@ static void fuse_sb_destroy(struct super_block *sb)
 void fuse_mount_destroy(struct fuse_mount *fm)
 {
 	fuse_conn_put(fm->fc);
-	kfree(fm);
+	kfree_rcu(fm, rcu);
 }
 EXPORT_SYMBOL(fuse_mount_destroy);
 
-- 
2.43.0



