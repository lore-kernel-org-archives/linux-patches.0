Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE9B47A61;
	Wed, 20 Dec 2023 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuHjqq7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57176C433C8;
	Wed, 20 Dec 2023 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088958;
	bh=R3g2WNwbYwSoq7GjvBurSYWRyttSuKK50QwkI1jxcRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuHjqq7oxq103vsDkZgrdfiJ+jmevKyoBDM4cOhDhtRMBGIFxNoBd/Y+97aTEwf6B
	 NwVBIPOrjQnO+lwVMc/EjcGkehjd2XDzEbOSV4lKAN1Oz430U7FKKxQ38/U3kxUuLh
	 GvrCSNJtPIQkTxFO+xdk742ej7lzvQKiIaeNRxpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 120/159] ksmbd: fix wrong interim response on compound
Date: Wed, 20 Dec 2023 17:09:45 +0100
Message-ID: <20231220160936.943025991@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 041bba4414cda37d00063952c9bff9c3d5812a19 ]

If smb2_lock or smb2_open request is compound, ksmbd could send wrong
interim response to client. ksmbd allocate new interim buffer instead of
using resonse buffer to support compound request.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/ksmbd_work.c |   10 ++++++----
 fs/ksmbd/ksmbd_work.h |    2 +-
 fs/ksmbd/oplock.c     |   14 ++------------
 fs/ksmbd/smb2pdu.c    |   26 +++++++++++++++++---------
 4 files changed, 26 insertions(+), 26 deletions(-)

--- a/fs/ksmbd/ksmbd_work.c
+++ b/fs/ksmbd/ksmbd_work.c
@@ -160,9 +160,11 @@ int ksmbd_iov_pin_rsp_read(struct ksmbd_
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
--- a/fs/ksmbd/ksmbd_work.h
+++ b/fs/ksmbd/ksmbd_work.h
@@ -131,5 +131,5 @@ bool ksmbd_queue_work(struct ksmbd_work
 int ksmbd_iov_pin_rsp_read(struct ksmbd_work *work, void *ib, int len,
 			   void *aux_buf, unsigned int aux_size);
 int ksmbd_iov_pin_rsp(struct ksmbd_work *work, void *ib, int len);
-void ksmbd_iov_reset(struct ksmbd_work *work);
+int allocate_interim_rsp_buf(struct ksmbd_work *work);
 #endif /* __KSMBD_WORK_H__ */
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -616,15 +616,6 @@ static int oplock_break_pending(struct o
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
@@ -647,7 +638,7 @@ static void __smb2_oplock_break_noti(str
 	if (!fp)
 		goto out;
 
-	if (allocate_oplock_break_buf(work)) {
+	if (allocate_interim_rsp_buf(work)) {
 		pr_err("smb2_allocate_rsp_buf failed! ");
 		ksmbd_fd_put(work, fp);
 		goto out;
@@ -752,7 +743,7 @@ static void __smb2_lease_break_noti(stru
 	struct lease_break_info *br_info = work->request_buf;
 	struct smb2_hdr *rsp_hdr;
 
-	if (allocate_oplock_break_buf(work)) {
+	if (allocate_interim_rsp_buf(work)) {
 		ksmbd_debug(OPLOCK, "smb2_allocate_rsp_buf failed! ");
 		goto out;
 	}
@@ -843,7 +834,6 @@ static int smb2_lease_break_noti(struct
 			setup_async_work(in_work, NULL, NULL);
 			smb2_send_interim_resp(in_work, STATUS_PENDING);
 			list_del(&in_work->interim_entry);
-			ksmbd_iov_reset(in_work);
 		}
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -153,8 +153,8 @@ void smb2_set_err_rsp(struct ksmbd_work
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
@@ -710,13 +710,24 @@ void release_async_work(struct ksmbd_wor
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
@@ -7052,8 +7063,6 @@ skip:
 				list_del(&work->fp_entry);
 				spin_unlock(&fp->f_lock);
 
-				ksmbd_iov_reset(work);
-
 				if (work->state != KSMBD_WORK_ACTIVE) {
 					list_del(&smb_lock->llist);
 					spin_lock(&work->conn->llist_lock);
@@ -7071,7 +7080,6 @@ skip:
 						goto out;
 					}
 
-					init_smb2_rsp_hdr(work);
 					rsp->hdr.Status =
 						STATUS_RANGE_NOT_LOCKED;
 					kfree(smb_lock);


