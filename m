Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8AB1C292;
	Wed,  3 Jan 2024 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCEva1GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D46CC433C8;
	Wed,  3 Jan 2024 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301233;
	bh=D4tDjuS3y6bH04rWOarhMCVr5JyA2DzOD1mBFNjxbMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCEva1GFlVqdhnhcaoeZUIQhzlLZ4xI6pSbmzkwezp/RoZR0cuN0N+KySavGmaH2o
	 2Mked+ij8DBkM/yNj2xBzp8Fp9VfVDHAGX38y1DRrjholiExIgBVUQyBhtIbpAC52Z
	 0CGYIlMclN3K3Yt8M5R5/NC2Ye0iWvIBSGQwqzGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luosili <rootlab@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/100] ksmbd: fix race condition with fp
Date: Wed,  3 Jan 2024 17:54:34 +0100
Message-ID: <20240103164902.800439898@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 5a7ee91d1154f35418367a6eaae74046fd06ed89 ]

fp can used in each command. If smb2_close command is coming at the
same time, UAF issue can happen by race condition.

                           Time
                            +
Thread A                    | Thread B1 B2 .... B5
smb2_open                   | smb2_close
                            |
 __open_id                  |
   insert fp to file_table  |
                            |
                            |   atomic_dec_and_test(&fp->refcount)
                            |   if fp->refcount == 0, free fp by kfree.
 // UAF!                    |
 use fp                     |
                            +
This patch add f_state not to use freed fp is used and not to free fp in
use.

Reported-by: luosili <rootlab@huawei.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c   |  4 +++-
 fs/smb/server/vfs_cache.c | 23 ++++++++++++++++++++---
 fs/smb/server/vfs_cache.h |  9 +++++++++
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 42697ea86d47b..d5bf1f480700a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3370,8 +3370,10 @@ int smb2_open(struct ksmbd_work *work)
 	}
 	ksmbd_revert_fsids(work);
 err_out1:
-	if (!rc)
+	if (!rc) {
+		ksmbd_update_fstate(&work->sess->file_table, fp, FP_INITED);
 		rc = ksmbd_iov_pin_rsp(work, (void *)rsp, iov_len);
+	}
 	if (rc) {
 		if (rc == -EINVAL)
 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 94ad8fa07b46e..f600279b0a9ee 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -332,6 +332,9 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
 
 static struct ksmbd_file *ksmbd_fp_get(struct ksmbd_file *fp)
 {
+	if (fp->f_state != FP_INITED)
+		return NULL;
+
 	if (!atomic_inc_not_zero(&fp->refcount))
 		return NULL;
 	return fp;
@@ -381,15 +384,20 @@ int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 		return 0;
 
 	ft = &work->sess->file_table;
-	read_lock(&ft->lock);
+	write_lock(&ft->lock);
 	fp = idr_find(ft->idr, id);
 	if (fp) {
 		set_close_state_blocked_works(fp);
 
-		if (!atomic_dec_and_test(&fp->refcount))
+		if (fp->f_state != FP_INITED)
 			fp = NULL;
+		else {
+			fp->f_state = FP_CLOSED;
+			if (!atomic_dec_and_test(&fp->refcount))
+				fp = NULL;
+		}
 	}
-	read_unlock(&ft->lock);
+	write_unlock(&ft->lock);
 
 	if (!fp)
 		return -EINVAL;
@@ -569,6 +577,7 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	fp->tcon		= work->tcon;
 	fp->volatile_id		= KSMBD_NO_FID;
 	fp->persistent_id	= KSMBD_NO_FID;
+	fp->f_state		= FP_NEW;
 	fp->f_ci		= ksmbd_inode_get(fp);
 
 	if (!fp->f_ci) {
@@ -590,6 +599,14 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	return ERR_PTR(ret);
 }
 
+void ksmbd_update_fstate(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
+			 unsigned int state)
+{
+	write_lock(&ft->lock);
+	fp->f_state = state;
+	write_unlock(&ft->lock);
+}
+
 static int
 __close_file_table_ids(struct ksmbd_file_table *ft,
 		       struct ksmbd_tree_connect *tcon,
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index fcb13413fa8d9..03d0bf941216f 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -60,6 +60,12 @@ struct ksmbd_inode {
 	__le32				m_fattr;
 };
 
+enum {
+	FP_NEW = 0,
+	FP_INITED,
+	FP_CLOSED
+};
+
 struct ksmbd_file {
 	struct file			*filp;
 	u64				persistent_id;
@@ -98,6 +104,7 @@ struct ksmbd_file {
 	/* if ls is happening on directory, below is valid*/
 	struct ksmbd_readdir_data	readdir_data;
 	int				dot_dotdot[2];
+	unsigned int			f_state;
 };
 
 static inline void set_ctx_actor(struct dir_context *ctx,
@@ -142,6 +149,8 @@ int ksmbd_close_inode_fds(struct ksmbd_work *work, struct inode *inode);
 int ksmbd_init_global_file_table(void);
 void ksmbd_free_global_file_table(void);
 void ksmbd_set_fd_limit(unsigned long limit);
+void ksmbd_update_fstate(struct ksmbd_file_table *ft, struct ksmbd_file *fp,
+			 unsigned int state);
 
 /*
  * INODE hash
-- 
2.43.0



