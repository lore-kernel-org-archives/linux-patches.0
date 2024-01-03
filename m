Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8281BDE7;
	Wed,  3 Jan 2024 16:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkOZ4t9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A2AC433C8;
	Wed,  3 Jan 2024 16:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301009;
	bh=VuwoGLv1UN8vceph7veK1OlMEA62E9eXyTa8mLEwKGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkOZ4t9G1H740Spm6VM4PSRduzJAEuUk00zF7bXU/KeoQX75hm2e8JhKmD5y9UpNP
	 5VqQnsBXxlWWR5Rdo3pOd512s6s8M7F7OxAt6BlAWaFk4M32A9S6yDBI4lXuRZI30W
	 /T532dxWxBmDHItptpwysZTQASkq5XppClp+fQjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <set_pte_at@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/100] ksmbd: fix typo, syncronous->synchronous
Date: Wed,  3 Jan 2024 17:53:56 +0100
Message-ID: <20240103164857.296838533@linuxfoundation.org>
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

From: Dawei Li <set_pte_at@outlook.com>

[ Upstream commit f8d6e7442aa716a233c7eba99dec628f8885e00b ]

syncronous->synchronous

Signed-off-by: Dawei Li <set_pte_at@outlook.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/connection.c | 4 ++--
 fs/smb/server/ksmbd_work.h | 2 +-
 fs/smb/server/smb2pdu.c    | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index ff97cad8d5b45..e885e0eb0dc35 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -116,7 +116,7 @@ void ksmbd_conn_enqueue_request(struct ksmbd_work *work)
 
 	if (conn->ops->get_cmd_val(work) != SMB2_CANCEL_HE) {
 		requests_queue = &conn->requests;
-		work->syncronous = true;
+		work->synchronous = true;
 	}
 
 	if (requests_queue) {
@@ -141,7 +141,7 @@ int ksmbd_conn_try_dequeue_request(struct ksmbd_work *work)
 	spin_lock(&conn->request_lock);
 	if (!work->multiRsp) {
 		list_del_init(&work->request_entry);
-		if (work->syncronous == false)
+		if (!work->synchronous)
 			list_del_init(&work->async_request_entry);
 		ret = 0;
 	}
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 5ece58e40c979..3234f2cf6327c 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -68,7 +68,7 @@ struct ksmbd_work {
 	/* Request is encrypted */
 	bool                            encrypted:1;
 	/* Is this SYNC or ASYNC ksmbd_work */
-	bool                            syncronous:1;
+	bool                            synchronous:1;
 	bool                            need_invalidate_rkey:1;
 
 	unsigned int                    remote_key;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 21d0416f11012..d3939fd481497 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -508,7 +508,7 @@ int init_smb2_rsp_hdr(struct ksmbd_work *work)
 	rsp_hdr->SessionId = rcv_hdr->SessionId;
 	memcpy(rsp_hdr->Signature, rcv_hdr->Signature, 16);
 
-	work->syncronous = true;
+	work->synchronous = true;
 	if (work->async_id) {
 		ksmbd_release_id(&conn->async_ida, work->async_id);
 		work->async_id = 0;
@@ -671,7 +671,7 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 		pr_err("Failed to alloc async message id\n");
 		return id;
 	}
-	work->syncronous = false;
+	work->synchronous = false;
 	work->async_id = id;
 	rsp_hdr->Id.AsyncId = cpu_to_le64(id);
 
-- 
2.43.0



