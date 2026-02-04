Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9551642188D;
	Wed,  4 Feb 2026 15:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218563; cv=none; b=IiLzNMIGXSOSha7R890zskovmXjPasrJUlL3ccC/iMnhYlonqmpNF/8fvorQMh4SD10bw2JTXwj17LZrP39cictTHfQP0e4ubdZQ3dtI0nkLvk8hB2AcrZZXKwg5tXFwlSTYTa1M3S57CnJDRRZYx2jrEls3R/z5cx7fvQWU3z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218563; c=relaxed/simple;
	bh=bMkEpfz59UE83EY+szsmkWFahSkJl2VSp7ONwXjKPyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NemaGdjUOq5JsUcobPvxAMoMGhOyb5Ew4unUfDW+cl6BdjEscVm/3Z8H8Q/8SgLOoXZgCHpmwaEQABrY5Oul0uHdUYqA7n4WC2+lGrFEGWkf1wcRJgnP19u2NLlqcdCbEhpdI0LTVzdsRo7YP5NysuI0WfM4hUUNMgfD7u/sq8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lXyJui0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lXyJui0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0497EC4CEF7;
	Wed,  4 Feb 2026 15:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218563;
	bh=bMkEpfz59UE83EY+szsmkWFahSkJl2VSp7ONwXjKPyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lXyJui0KpC3PEZCtllnehAU9pUxb+P3MOLNopbrrcrkLx6bhkHaHtCEliZsNJzUF
	 FPZ4xY1GtgJ7f2AAvcOZN/qDoDNyKeNRBAvH8E1q7YDkwgaFHp1WDJcknRjZ0fq/Ve
	 rrAEETx8VXK1rYOEBtYWAhMglGXiLv3+SGHUscJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.6 67/72] ksmbd: fix recursive locking in RPC handle list access
Date: Wed,  4 Feb 2026 15:41:10 +0100
Message-ID: <20260204143848.069797467@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Marios Makassikis <mmakassikis@freebox.fr>

[ Upstream commit 88f170814fea74911ceab798a43cbd7c5599bed4 ]

Since commit 305853cce3794 ("ksmbd: Fix race condition in RPC handle list
access"), ksmbd_session_rpc_method() attempts to lock sess->rpc_lock.

This causes hung connections / tasks when a client attempts to open
a named pipe. Using Samba's rpcclient tool:

 $ rpcclient //192.168.1.254 -U user%password
 $ rpcclient $> srvinfo
 <connection hung here>

Kernel side:
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:kworker/0:0 state:D stack:0 pid:5021 tgid:5021 ppid:2 flags:0x00200000
  Workqueue: ksmbd-io handle_ksmbd_work
  Call trace:
  __schedule from schedule+0x3c/0x58
  schedule from schedule_preempt_disabled+0xc/0x10
  schedule_preempt_disabled from rwsem_down_read_slowpath+0x1b0/0x1d8
  rwsem_down_read_slowpath from down_read+0x28/0x30
  down_read from ksmbd_session_rpc_method+0x18/0x3c
  ksmbd_session_rpc_method from ksmbd_rpc_open+0x34/0x68
  ksmbd_rpc_open from ksmbd_session_rpc_open+0x194/0x228
  ksmbd_session_rpc_open from create_smb2_pipe+0x8c/0x2c8
  create_smb2_pipe from smb2_open+0x10c/0x27ac
  smb2_open from handle_ksmbd_work+0x238/0x3dc
  handle_ksmbd_work from process_scheduled_works+0x160/0x25c
  process_scheduled_works from worker_thread+0x16c/0x1e8
  worker_thread from kthread+0xa8/0xb8
  kthread from ret_from_fork+0x14/0x38
  Exception stack(0x8529ffb0 to 0x8529fff8)

The task deadlocks because the lock is already held:
  ksmbd_session_rpc_open
    down_write(&sess->rpc_lock)
    ksmbd_rpc_open
      ksmbd_session_rpc_method
        down_read(&sess->rpc_lock)   <-- deadlock

Adjust ksmbd_session_rpc_method() callers to take the lock when necessary.

Fixes: 305853cce3794 ("ksmbd: Fix race condition in RPC handle list access")
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |    7 ++-----
 fs/smb/server/smb2pdu.c           |    9 ++++++++-
 fs/smb/server/transport_ipc.c     |   12 ++++++++++++
 3 files changed, 22 insertions(+), 6 deletions(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -147,14 +147,11 @@ void ksmbd_session_rpc_close(struct ksmb
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id)
 {
 	struct ksmbd_session_rpc *entry;
-	int method;
 
-	down_read(&sess->rpc_lock);
+	lockdep_assert_held(&sess->rpc_lock);
 	entry = xa_load(&sess->rpc_handle_list, id);
-	method = entry ? entry->method : 0;
-	up_read(&sess->rpc_lock);
 
-	return method;
+	return entry ? entry->method : 0;
 }
 
 void ksmbd_session_destroy(struct ksmbd_session *sess)
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4614,8 +4614,15 @@ static int smb2_get_info_file_pipe(struc
 	 * pipe without opening it, checking error condition here
 	 */
 	id = req->VolatileFileId;
-	if (!ksmbd_session_rpc_method(sess, id))
+
+	lockdep_assert_not_held(&sess->rpc_lock);
+
+	down_read(&sess->rpc_lock);
+	if (!ksmbd_session_rpc_method(sess, id)) {
+		up_read(&sess->rpc_lock);
 		return -ENOENT;
+	}
+	up_read(&sess->rpc_lock);
 
 	ksmbd_debug(SMB, "FileInfoClass %u, FileId 0x%llx\n",
 		    req->FileInfoClass, req->VolatileFileId);
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -778,6 +778,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_writ
 	if (!msg)
 		return NULL;
 
+	lockdep_assert_not_held(&sess->rpc_lock);
+
+	down_read(&sess->rpc_lock);
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
 	req->handle = handle;
@@ -786,6 +789,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_writ
 	req->flags |= KSMBD_RPC_WRITE_METHOD;
 	req->payload_sz = payload_sz;
 	memcpy(req->payload, payload, payload_sz);
+	up_read(&sess->rpc_lock);
 
 	resp = ipc_msg_send_request(msg, req->handle);
 	ipc_msg_free(msg);
@@ -802,6 +806,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_read
 	if (!msg)
 		return NULL;
 
+	lockdep_assert_not_held(&sess->rpc_lock);
+
+	down_read(&sess->rpc_lock);
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
 	req->handle = handle;
@@ -809,6 +816,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_read
 	req->flags |= rpc_context_flags(sess);
 	req->flags |= KSMBD_RPC_READ_METHOD;
 	req->payload_sz = 0;
+	up_read(&sess->rpc_lock);
 
 	resp = ipc_msg_send_request(msg, req->handle);
 	ipc_msg_free(msg);
@@ -829,6 +837,9 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioct
 	if (!msg)
 		return NULL;
 
+	lockdep_assert_not_held(&sess->rpc_lock);
+
+	down_read(&sess->rpc_lock);
 	msg->type = KSMBD_EVENT_RPC_REQUEST;
 	req = (struct ksmbd_rpc_command *)msg->payload;
 	req->handle = handle;
@@ -837,6 +848,7 @@ struct ksmbd_rpc_command *ksmbd_rpc_ioct
 	req->flags |= KSMBD_RPC_IOCTL_METHOD;
 	req->payload_sz = payload_sz;
 	memcpy(req->payload, payload, payload_sz);
+	up_read(&sess->rpc_lock);
 
 	resp = ipc_msg_send_request(msg, req->handle);
 	ipc_msg_free(msg);


