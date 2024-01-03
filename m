Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F6C1C294;
	Wed,  3 Jan 2024 16:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/qs9/fV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723A1C433C8;
	Wed,  3 Jan 2024 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301101;
	bh=swCnAicNF1MjPvH5m6TSfz09JgIhYvEMfd1z+WUU5kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/qs9/fVwmEn0jEXxg8BVFHYBxE4TIK2p0mFyCEWTHsWgz87xPsPdOa9Q3dvjMzR+
	 SRgkCjJ6RIHgaput3y73cMdMNa/ZT/3u+epWM0yF1rY/Fs6YzvOWE6x9LnzpbLDduz
	 cISpdiqlaDf6EqVU0PEdA2Ybdh+d885cvOAAObrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/100] ksmbd: fix wrong interim response on compound
Date: Wed,  3 Jan 2024 17:54:25 +0100
Message-ID: <20240103164901.483571909@linuxfoundation.org>
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

[ Upstream commit 041bba4414cda37d00063952c9bff9c3d5812a19 ]

If smb2_lock or smb2_open request is compound, ksmbd could send wrong
interim response to client. ksmbd allocate new interim buffer instead of
using resonse buffer to support compound request.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_work.c | 10 ++++++----
 fs/smb/server/ksmbd_work.h |  2 +-
 fs/smb/server/oplock.c     | 14 ++------------
 fs/smb/server/smb2pdu.c    | 26 +++++++++++++++++---------
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/smb/server/ksmbd_work.c b/fs/smb/server/ksmbd_work.c
index f49c2e01ea9fc..51def3ca74c01 100644
--- a/fs/smb/server/ksmbd_work.c
+++ b/fs/smb/server/ksmbd_work.c
@@ -160,9 +160,11 @@ int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
 	return __ksmbd_iov_pin_rsp(work, ib, len, aux_buf, aux_size);
 }
 
-void ksmbd_iov_reset(struct ksmbd_work *work)
+int allocate_interim_rsp_buf(struct ksmbd_work *work)
 {
-	work->iov_idx = 0;
-	work->iov_cnt = 0;
-	*(__be32 *)work->iov[0].iov_base = 0;
+	work->response_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE, GFP_KERNEL);
+	if (!work->response_buf)
+		return -ENOMEM;
+	work->response_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
+	return 0;
 }
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 255157eb26dc4..8ca2c813246e6 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -131,5 +131,5 @@ bool ksmbd_queue_work(struct ksmbd_work *work);
 int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
 			   void *aux_buf, unsigned int aux_size);
 int ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len);
-void ksmbd_iov_reset(struct ksmbd_work *work);
+int allocate_interim_rsp_buf(struct ksmbd_work *work);
 #endif /* __KSMBD_WORK_H__ */
diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 4e12e3031bc53..90a035c27130f 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -616,15 +616,6 @@ static int oplock_break_pending(struct oplock_info *opinfo, int req_op_level)
 	return 0;
 }
 
-static inline int allocate_oplock_break_buf(struct ksmbd_work *work)
-{
-	work->response_buf = kzalloc(MAX_CIFS_SMALL_BUFFER_SIZE, GFP_KERNEL);
-	if (!work->response_buf)
-		return -ENOMEM;
-	work->response_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
-	return 0;
-}
-
 /**
  * __smb2_oplock_break_noti() - send smb2 oplock break cmd from conn
  * to client
@@ -647,7 +638,7 @@ static void __smb2_oplock_break_noti(struct work_struct *wk)
 	if (!fp)
 		goto out;
 
-	if (allocate_oplock_break_buf(work)) {
+	if (allocate_interim_rsp_buf(work)) {
 		pr_err("smb2_allocate_rsp_buf failed! ");
 		ksmbd_fd_put(work, fp);
 		goto out;
@@ -752,7 +743,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
 	struct lease_break_info *br_info = work->request_buf;
 	struct smb2_hdr *rsp_hdr;
 
-	if (allocate_oplock_break_buf(work)) {
+	if (allocate_interim_rsp_buf(work)) {
 		ksmbd_debug(OPLOCK, "smb2_allocate_rsp_buf failed! ");
 		goto out;
 	}
@@ -843,7 +834,6 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 			setup_async_work(in_work, NULL, NULL);
 			smb2_send_interim_resp(in_work, STATUS_PENDING);
 			list_del(&in_work->interim_entry);
-			ksmbd_iov_reset(in_work);
 		}
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 0a40b793cedf4..dfb4fd4cb42f6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -152,8 +152,8 @@ void smb2_set_err_rsp(struct ksmbd_work *work)
 		err_rsp->ByteCount = 0;
 		err_rsp->ErrorData[0] = 0;
 		err = ksmbd_iov_pin_rsp(work, (void *)err_rsp,
-				  work->conn->vals->header_size +
-				  SMB2_ERROR_STRUCTURE_SIZE2);
+					__SMB2_HEADER_STRUCTURE_SIZE +
+						SMB2_ERROR_STRUCTURE_SIZE2);
 		if (err)
 			work->send_no_response = 1;
 	}
@@ -709,13 +709,24 @@ void release_async_work(struct ksmbd_work *work)
 void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 {
 	struct smb2_hdr *rsp_hdr;
+	struct ksmbd_work *in_work = ksmbd_alloc_work_struct();
 
-	rsp_hdr = ksmbd_resp_buf_next(work);
-	smb2_set_err_rsp(work);
+	if (allocate_interim_rsp_buf(in_work)) {
+		pr_err("smb_allocate_rsp_buf failed!\n");
+		ksmbd_free_work_struct(in_work);
+		return;
+	}
+
+	in_work->conn = work->conn;
+	memcpy(smb2_get_msg(in_work->response_buf), ksmbd_resp_buf_next(work),
+	       __SMB2_HEADER_STRUCTURE_SIZE);
+
+	rsp_hdr = smb2_get_msg(in_work->response_buf);
+	smb2_set_err_rsp(in_work);
 	rsp_hdr->Status = status;
 
-	ksmbd_conn_write(work);
-	rsp_hdr->Status = 0;
+	ksmbd_conn_write(in_work);
+	ksmbd_free_work_struct(in_work);
 }
 
 static __le32 smb2_get_reparse_tag_special_file(umode_t mode)
@@ -7050,8 +7061,6 @@ int smb2_lock(struct ksmbd_work *work)
 				list_del(&work->fp_entry);
 				spin_unlock(&fp->f_lock);
 
-				ksmbd_iov_reset(work);
-
 				if (work->state != KSMBD_WORK_ACTIVE) {
 					list_del(&smb_lock->llist);
 					spin_lock(&work->conn->llist_lock);
@@ -7069,7 +7078,6 @@ int smb2_lock(struct ksmbd_work *work)
 						goto out;
 					}
 
-					init_smb2_rsp_hdr(work);
 					rsp->hdr.Status =
 						STATUS_RANGE_NOT_LOCKED;
 					kfree(smb_lock);
-- 
2.43.0



