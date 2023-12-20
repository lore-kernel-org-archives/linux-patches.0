Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BF048782;
	Wed, 20 Dec 2023 16:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4F+5Jp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD389C433C7;
	Wed, 20 Dec 2023 16:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088823;
	bh=GgfTSq+EqZl8qnvxadz9iMwFcvtsfxu0vvBJYOXeHJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4F+5Jp0Wt9E+caWPPGGMD3wOoA7MwGI4UxiMnLsv2xXCgHHOZoaV+ME+Ed9vHBgB
	 qpHLb63g4IMMGEfBSydtBEh6B/PqsP0jPvDp0iiaeOJl0AvMRZhZaN6MM+4hVhgk7g
	 8xr6FgqBbByI+V2Yd4GP8B0kOOozNE7RpSfzPfoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <set_pte_at@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 072/159] ksmbd: fix typo, syncronous->synchronous
Date: Wed, 20 Dec 2023 17:08:57 +0100
Message-ID: <20231220160934.732972052@linuxfoundation.org>
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

From: Dawei Li <set_pte_at@outlook.com>

[ Upstream commit f8d6e7442aa716a233c7eba99dec628f8885e00b ]

syncronous->synchronous

Signed-off-by: Dawei Li <set_pte_at@outlook.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    4 ++--
 fs/ksmbd/ksmbd_work.h |    2 +-
 fs/ksmbd/smb2pdu.c    |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -114,7 +114,7 @@ void ksmbd_conn_enqueue_request(struct k
 
 	if (conn->ops->get_cmd_val(work) != SMB2_CANCEL_HE) {
 		requests_queue = &conn->requests;
-		work->syncronous = true;
+		work->synchronous = true;
 	}
 
 	if (requests_queue) {
@@ -139,7 +139,7 @@ int ksmbd_conn_try_dequeue_request(struc
 	spin_lock(&conn->request_lock);
 	if (!work->multiRsp) {
 		list_del_init(&work->request_entry);
-		if (work->syncronous == false)
+		if (!work->synchronous)
 			list_del_init(&work->async_request_entry);
 		ret = 0;
 	}
--- a/fs/ksmbd/ksmbd_work.h
+++ b/fs/ksmbd/ksmbd_work.h
@@ -68,7 +68,7 @@ struct ksmbd_work {
 	/* Request is encrypted */
 	bool                            encrypted:1;
 	/* Is this SYNC or ASYNC ksmbd_work */
-	bool                            syncronous:1;
+	bool                            synchronous:1;
 	bool                            need_invalidate_rkey:1;
 
 	unsigned int                    remote_key;
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -512,7 +512,7 @@ int init_smb2_rsp_hdr(struct ksmbd_work
 	rsp_hdr->SessionId = rcv_hdr->SessionId;
 	memcpy(rsp_hdr->Signature, rcv_hdr->Signature, 16);
 
-	work->syncronous = true;
+	work->synchronous = true;
 	if (work->async_id) {
 		ksmbd_release_id(&conn->async_ida, work->async_id);
 		work->async_id = 0;
@@ -675,7 +675,7 @@ int setup_async_work(struct ksmbd_work *
 		pr_err("Failed to alloc async message id\n");
 		return id;
 	}
-	work->syncronous = false;
+	work->synchronous = false;
 	work->async_id = id;
 	rsp_hdr->Id.AsyncId = cpu_to_le64(id);
 


