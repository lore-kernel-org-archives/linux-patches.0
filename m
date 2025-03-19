Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36410221F2E;
	Wed, 19 Mar 2025 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395248; cv=none; b=d+FkBZzI9n18Y33OrnBcAlOwR0YYvFP904qZ7oV2330jBIYOM1lxS0v/dIiOJfcjmtgB8jZuqfi94pT/SLD4M0l6OK1eUT0hRfZNTz8iizs5L9NKybHSxUIjqI9GRChVafmDuji5GlzumAbt3ybI45wtIBFhZ0DYx2kpMBP2AzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395248; c=relaxed/simple;
	bh=+8R8xKP4ItTgj506hU43HOOC7YNNvaoQIYtalzYkrrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXKVjtL0a0XzNJEN5UTZwDKdFXiER7TYkmlxqkt7EQQ+20jpO1EHclf3XKcvX162DHDtYMxPr7FbpPvjy2ZgMYtd9FjzAUa5Ia6FByp07tCb2SdkJVYGb8oUlUkMRfjepNTtG0zggCLaySiGH4l5BcIrevjfn7JvsdUbDxzEit4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IrNzbJ5S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IrNzbJ5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7AEC4CEE8;
	Wed, 19 Mar 2025 14:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395248;
	bh=+8R8xKP4ItTgj506hU43HOOC7YNNvaoQIYtalzYkrrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IrNzbJ5SSsckTDfNMFIC3qvTxzPwVrm7VmrHEVTN8U6awMsxt0tjyDlLvZor8hjDc
	 +IZXYIFz4Qwhrsys1zkGGbxm/f/tbIBAWhgKnKKgxhuNGKTRnWf+r2O0qIRhspOhNZ
	 39oRxjTJeuHwCr/BiWWNSZz2pvwNp0J1oo1YxhEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 128/166] ksmbd: prevent connection release during oplock break notification
Date: Wed, 19 Mar 2025 07:31:39 -0700
Message-ID: <20250319143023.481000425@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 3aa660c059240e0c795217182cf7df32909dd917 upstream.

ksmbd_work could be freed when after connection release.
Increment r_count of ksmbd_conn to indicate that requests
are not finished yet and to not release the connection.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c |   20 ++++++++++++++++++++
 fs/smb/server/connection.h |    2 ++
 fs/smb/server/oplock.c     |    6 ++++++
 fs/smb/server/server.c     |   14 ++------------
 4 files changed, 30 insertions(+), 12 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -432,6 +432,26 @@ void ksmbd_conn_init_server_callbacks(st
 	default_conn_ops.terminate_fn = ops->terminate_fn;
 }
 
+void ksmbd_conn_r_count_inc(struct ksmbd_conn *conn)
+{
+	atomic_inc(&conn->r_count);
+}
+
+void ksmbd_conn_r_count_dec(struct ksmbd_conn *conn)
+{
+	/*
+	 * Checking waitqueue to dropping pending requests on
+	 * disconnection. waitqueue_active is safe because it
+	 * uses atomic operation for condition.
+	 */
+	atomic_inc(&conn->refcnt);
+	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
+		wake_up(&conn->r_count_q);
+
+	if (atomic_dec_and_test(&conn->refcnt))
+		kfree(conn);
+}
+
 int ksmbd_conn_transport_init(void)
 {
 	int ret;
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -168,6 +168,8 @@ int ksmbd_conn_transport_init(void);
 void ksmbd_conn_transport_destroy(void);
 void ksmbd_conn_lock(struct ksmbd_conn *conn);
 void ksmbd_conn_unlock(struct ksmbd_conn *conn);
+void ksmbd_conn_r_count_inc(struct ksmbd_conn *conn);
+void ksmbd_conn_r_count_dec(struct ksmbd_conn *conn);
 
 /*
  * WARNING
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -634,6 +634,7 @@ static void __smb2_oplock_break_noti(str
 {
 	struct smb2_oplock_break *rsp = NULL;
 	struct ksmbd_work *work = container_of(wk, struct ksmbd_work, work);
+	struct ksmbd_conn *conn = work->conn;
 	struct oplock_break_info *br_info = work->request_buf;
 	struct smb2_hdr *rsp_hdr;
 	struct ksmbd_file *fp;
@@ -689,6 +690,7 @@ static void __smb2_oplock_break_noti(str
 
 out:
 	ksmbd_free_work_struct(work);
+	ksmbd_conn_r_count_dec(conn);
 }
 
 /**
@@ -723,6 +725,7 @@ static int smb2_oplock_break_noti(struct
 	work->sess = opinfo->sess;
 
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
+		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_oplock_break_noti);
 		ksmbd_queue_work(work);
 
@@ -744,6 +747,7 @@ static void __smb2_lease_break_noti(stru
 {
 	struct smb2_lease_break *rsp = NULL;
 	struct ksmbd_work *work = container_of(wk, struct ksmbd_work, work);
+	struct ksmbd_conn *conn = work->conn;
 	struct lease_break_info *br_info = work->request_buf;
 	struct smb2_hdr *rsp_hdr;
 
@@ -790,6 +794,7 @@ static void __smb2_lease_break_noti(stru
 
 out:
 	ksmbd_free_work_struct(work);
+	ksmbd_conn_r_count_dec(conn);
 }
 
 /**
@@ -829,6 +834,7 @@ static int smb2_lease_break_noti(struct
 	work->sess = opinfo->sess;
 
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
+		ksmbd_conn_r_count_inc(conn);
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
 		wait_for_break_ack(opinfo);
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -270,17 +270,7 @@ static void handle_ksmbd_work(struct wor
 
 	ksmbd_conn_try_dequeue_request(work);
 	ksmbd_free_work_struct(work);
-	/*
-	 * Checking waitqueue to dropping pending requests on
-	 * disconnection. waitqueue_active is safe because it
-	 * uses atomic operation for condition.
-	 */
-	atomic_inc(&conn->refcnt);
-	if (!atomic_dec_return(&conn->r_count) && waitqueue_active(&conn->r_count_q))
-		wake_up(&conn->r_count_q);
-
-	if (atomic_dec_and_test(&conn->refcnt))
-		kfree(conn);
+	ksmbd_conn_r_count_dec(conn);
 }
 
 /**
@@ -310,7 +300,7 @@ static int queue_ksmbd_work(struct ksmbd
 	conn->request_buf = NULL;
 
 	ksmbd_conn_enqueue_request(work);
-	atomic_inc(&conn->r_count);
+	ksmbd_conn_r_count_inc(conn);
 	/* update activity on connection */
 	conn->last_active = jiffies;
 	INIT_WORK(&work->work, handle_ksmbd_work);


