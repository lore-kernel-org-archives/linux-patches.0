Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8670839C659;
	Wed,  4 Feb 2026 10:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770199980; cv=none; b=r5ZEbF57ppxVd1vDZYypEv+ywenF0nfdDFu0sjw+pgQ5kGuQ88bXk1h1gw34L0D2sTOjeNzEk34hTcioFpJ6o+wyzdGKZSuFnY/yowEVNsNO1UwQz9Q7jbF9Jxg6nfbwdsSiBpT+pIKOmlIWRv+3QiWeRMDXwhKVZTj7WKwoBk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770199980; c=relaxed/simple;
	bh=6CVQRM4bwpoWNIYexb/zB37wlyrMveKrDWQxZOU3D94=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=lNN3yZSsf44jVdNUacxYtoIfddRu6j+Kf77KhmIwSpBtpzi0l+N9SMGY9Kq4Tdbi9gKOGwaQsfuvx+rgYsg4aSom15y3vfuRxr6Ox/gl0LDm3TBKf9lQpCrbl7fNrPOp4T80exnvq7Io1DxmiKsSJvG4s355ocyCo1W9kc5p2ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+PPP6UV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+PPP6UV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4198C16AAE;
	Wed,  4 Feb 2026 10:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770199980;
	bh=6CVQRM4bwpoWNIYexb/zB37wlyrMveKrDWQxZOU3D94=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=z+PPP6UVejnBhE3SZ38TqzxOMx8Uceyxt4K1wwL+QoL3Df9K0jI1qpwrQj8GnhkvB
	 o+otOdx4NQgKUbjv41bZP3HGLqIM2VrtVhtz+u2ShASmjSA44NR1SupP+0j2dvtnsF
	 W09KAZodXbcnqCLMnp66eJJFoG6woYNJ2BAlMp4Q=
Subject: Patch "ksmbd: fix recursive locking in RPC handle list access" has been added to the 6.6-stable tree
To: 1468888505@139.com,akendo@akendo.eu,gregkh@linuxfoundation.org,linkinjeon@kernel.org,mmakassikis@freebox.fr,patches@lists.linux.dev,senozhatsky@chromium.org,set_pte_at@outlook.com,sfrench@samba.org,stfrench@microsoft.com,tom@talpey.com,ysk@kzalloc.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Wed, 04 Feb 2026 11:12:39 +0100
In-Reply-To: <20260204022205.3204230-1-1468888505@139.com>
Message-ID: <2026020439-smock-gentile-cb10@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    ksmbd: fix recursive locking in RPC handle list access

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ksmbd-fix-recursive-locking-in-rpc-handle-list-access.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-213337-greg=kroah.com@vger.kernel.org Wed Feb  4 03:22:32 2026
From: Li hongliang <1468888505@139.com>
Date: Wed,  4 Feb 2026 10:22:05 +0800
Subject: ksmbd: fix recursive locking in RPC handle list access
To: mmakassikis@freebox.fr, gregkh@linuxfoundation.org, stable@vger.kernel.org, ysk@kzalloc.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, akendo@akendo.eu, set_pte_at@outlook.com, linux-cifs@vger.kernel.org, stfrench@microsoft.com
Message-ID: <20260204022205.3204230-1-1468888505@139.com>

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


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/drm-radeon-delete-radeon_fence_process-in-is_signaled-no-deadlock.patch
queue-6.6/ksmbd-fix-race-condition-in-rpc-handle-list-access.patch
queue-6.6/wifi-ath11k-add-srng-lock-for-ath11k_hal_srng_-in-monitor-mode.patch
queue-6.6/drm-amdgpu-replace-mutex-with-spinlock-for-rlcg-register-access-to-avoid-priority-inversion-in-sriov.patch
queue-6.6/ksmbd-fix-recursive-locking-in-rpc-handle-list-access.patch
