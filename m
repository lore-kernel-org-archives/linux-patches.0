Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746E24AF63;
	Wed, 20 Dec 2023 16:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YnJZMdOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE37EC433C7;
	Wed, 20 Dec 2023 16:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088749;
	bh=g15DwPA+0UViPx+Q+nqLXfGgA4tAyDzTGP3FVQladQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YnJZMdOLlQkLOSWadniAnxLj/rq+1Fe7/9veATW7q7Lvi9wIAyoHSCmEyeXjmJFEH
	 P1fpoi4qeOhm8k07LBfHEabQzoPZFtr95rwujkmYtzUkNczXdau0PXWRbjATSUhsZJ
	 IRdv8L5x8mt7szmn1fvXTIQd3SA42SqDKIFX4uTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 045/159] ksmbd: use wait_event instead of schedule_timeout()
Date: Wed, 20 Dec 2023 17:08:30 +0100
Message-ID: <20231220160933.415858856@linuxfoundation.org>
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

[ Upstream commit a14c573870a664386adc10526a6c2648ea56dae1 ]

ksmbd threads eating masses of cputime when connection is disconnected.
If connection is disconnected, ksmbd thread waits for pending requests
to be processed using schedule_timeout. schedule_timeout() incorrectly
is used, and it is more efficient to use wait_event/wake_up than to check
r_count every time with timeout.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c |    6 +++---
 fs/ksmbd/connection.h |    1 +
 fs/ksmbd/oplock.c     |   35 ++++++++++++++++++++++-------------
 fs/ksmbd/server.c     |    8 +++++++-
 4 files changed, 33 insertions(+), 17 deletions(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -66,6 +66,7 @@ struct ksmbd_conn *ksmbd_conn_alloc(void
 	conn->outstanding_credits = 0;
 
 	init_waitqueue_head(&conn->req_running_q);
+	init_waitqueue_head(&conn->r_count_q);
 	INIT_LIST_HEAD(&conn->conns_list);
 	INIT_LIST_HEAD(&conn->requests);
 	INIT_LIST_HEAD(&conn->async_requests);
@@ -165,7 +166,6 @@ int ksmbd_conn_write(struct ksmbd_work *
 	struct kvec iov[3];
 	int iov_idx = 0;
 
-	ksmbd_conn_try_dequeue_request(work);
 	if (!work->response_buf) {
 		pr_err("NULL response header\n");
 		return -EINVAL;
@@ -358,8 +358,8 @@ int ksmbd_conn_handler_loop(void *p)
 
 out:
 	/* Wait till all reference dropped to the Server object*/
-	while (atomic_read(&conn->r_count) > 0)
-		schedule_timeout(HZ);
+	wait_event(conn->r_count_q, atomic_read(&conn->r_count) == 0);
+
 
 	unload_nls(conn->local_nls);
 	if (default_conn_ops.terminate_fn)
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -58,6 +58,7 @@ struct ksmbd_conn {
 	unsigned int			outstanding_credits;
 	spinlock_t			credits_lock;
 	wait_queue_head_t		req_running_q;
+	wait_queue_head_t		r_count_q;
 	/* Lock to protect requests list*/
 	spinlock_t			request_lock;
 	struct list_head		requests;
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -616,18 +616,13 @@ static void __smb2_oplock_break_noti(str
 	struct ksmbd_file *fp;
 
 	fp = ksmbd_lookup_durable_fd(br_info->fid);
-	if (!fp) {
-		atomic_dec(&conn->r_count);
-		ksmbd_free_work_struct(work);
-		return;
-	}
+	if (!fp)
+		goto out;
 
 	if (allocate_oplock_break_buf(work)) {
 		pr_err("smb2_allocate_rsp_buf failed! ");
-		atomic_dec(&conn->r_count);
 		ksmbd_fd_put(work, fp);
-		ksmbd_free_work_struct(work);
-		return;
+		goto out;
 	}
 
 	rsp_hdr = smb2_get_msg(work->response_buf);
@@ -668,8 +663,16 @@ static void __smb2_oplock_break_noti(str
 
 	ksmbd_fd_put(work, fp);
 	ksmbd_conn_write(work);
+
+out:
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	/*
+	 * Checking waitqueue to dropping pending requests on
+	 * disconnection. waitqueue_active is safe because it
+	 * uses atomic operation for condition.
+	 */
+	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
+		wake_up(&conn->r_count_q);
 }
 
 /**
@@ -732,9 +735,7 @@ static void __smb2_lease_break_noti(stru
 
 	if (allocate_oplock_break_buf(work)) {
 		ksmbd_debug(OPLOCK, "smb2_allocate_rsp_buf failed! ");
-		ksmbd_free_work_struct(work);
-		atomic_dec(&conn->r_count);
-		return;
+		goto out;
 	}
 
 	rsp_hdr = smb2_get_msg(work->response_buf);
@@ -772,8 +773,16 @@ static void __smb2_lease_break_noti(stru
 	inc_rfc1001_len(work->response_buf, 44);
 
 	ksmbd_conn_write(work);
+
+out:
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	/*
+	 * Checking waitqueue to dropping pending requests on
+	 * disconnection. waitqueue_active is safe because it
+	 * uses atomic operation for condition.
+	 */
+	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
+		wake_up(&conn->r_count_q);
 }
 
 /**
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -266,7 +266,13 @@ static void handle_ksmbd_work(struct wor
 
 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
-	atomic_dec(&conn->r_count);
+	/*
+	 * Checking waitqueue to dropping pending requests on
+	 * disconnection. waitqueue_active is safe because it
+	 * uses atomic operation for condition.
+	 */
+	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
+		wake_up(&conn->r_count_q);
 }
 
 /**


