Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829055;
	b=q7uEg4xjG45sgiAsOdVpKbpTAPwZwEHVJHY33hkZXhOGqKiGKrZwHhUtJ0DoOqkwitXf
	 nks/yW2bUAsNNzESJq9zGsGtwRsvFYIyUL4geExNIaMOCkFYUNs5/43Nc6/lWjo7TEB8r
	 Dbz367eCbmkv0P0d7yo+F6DfiNgv7jUb5nvt9D5jTvDoQWg+aQeiCadZCMTW2+Gik68YM
	 4a7yoWJfAj3/G1v+AQUyIKYv3ip0WzPOyiUVYs0iSbD3JhEEEdgEAY4KMJKhEmhs67g8n
	 KLYWtiaSMcZkWOLufy01UKNLTdSTeR2fC/TWM49I46eT+Jslk0rhSbeMtzSyhV6brdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Dp3AACjbNG1FlcBUZFZ8lq01zjD9Thz4i/mF7fiOf0=;
	b=Y7YVNR7lVG72LIzbuIr4a2tfJtkzCNPrI6sGgRCYgolWAmpjTM4kA4I3QYpJLk0feSoU
	 wpmM54mUR05CaRsqwHk+q3IlLnwzO9LzJUTdwDmPbqsFH4E1P7VHMmhBmDYVvt4E5SMFL
	 pOv92OnhNtz5iq0IgXn5F82QUeCw2pVNWbDMAk3VU1L+/MR6fCBaBLZJxDP2PZEKLfmM8
	 buSxwOPgNPsJSHaarlNcmLl0XF6wGNpAouN+T4qncFsV0989mf5mmeswrAdK+YA5SgDPA
	 RSo/UgoaYkWqW6gD1+Ylom8LlZHhyY+o96qr5lP450zv2U0jarShyTvUiD90qoj/Fdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msU2Ttvp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BFF60807BE;
	Wed,  4 Nov 2026 21:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msU2Ttvp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C3B1F00919;
	Wed,  4 Nov 2026 21:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829054;
	bh=/Dp3AACjbNG1FlcBUZFZ8lq01zjD9Thz4i/mF7fiOf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msU2TtvpPxfpefsGN1NSyGoxd6WwuSRyysXb3qRXR73CgTbLmoU/gaWsWp/UTRgsi
	 gl14V8o/PqrXr4LbS/pmVP4cGWHOfDvLbhtkXv58r2lkcE16SlhmfRTiQHMq2BTdIu
	 cY93w5igRE1rkyiGWQJ6bPDU902S7s33CGzFXk/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 415/547] NFSD: Dont complete a cld upcall the daemon has not read
Date: Wed,  4 Nov 2026 16:09:59 -0500
Message-ID: <20261104211050.111477459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 7f4bf851aca4e18940ebf2bddf4ba6783802ee81 upstream.

cld_pipe_downcall() matches a reply to its upcall on the xid alone.
A write that arrives before the daemon has read that upcall
completes __cld_pipe_upcall() while its struct rpc_pipe_msg is still
queued on the pipe. The waiter returns, its stack frame goes away,
and the pipe keeps a list_head that points into it. The next
rpc_queue_upcall() walks that pointer:

  BUG: KASAN: vmalloc-out-of-bounds in __list_add_valid_or_report
  Read of size 8 at addr ffffc90007027950 by task syz.0.96/13066
   __list_add_valid_or_report+0x6a/0x130
   rpc_queue_upcall
   cld_pipe_upcall
   nfsd4_cld_grace_start
   nfsd4_cld_tracking_init

The pipe is mode 0600 in rpc_pipefs, so the trigger is a broken or
hostile nfsdcld rather than an unprivileged task.

Record whether the daemon has consumed the whole message and
complete only when it has. cld_pipe_destroy_msg() runs on every path
by which the pipe releases a message, so it can maintain that flag
under cn_lock. nfsdcld sends its -EINPROGRESS downcalls only after
reading the upcall, so the new check does not break the GraceStart
record stream.

Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
Cc: stable@vger.kernel.org
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/linux-nfs/CA+0ovCjVF58WLeen2ctdzHyWUASAAW3Y=Yjihyq0pFApYawtDg@mail.gmail.com/
Link: https://patch.msgid.link/20260901-alemi-v2-1-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4recover.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -647,6 +647,8 @@ struct cld_upcall {
 	struct list_head	 cu_list;
 	struct cld_net		*cu_net;
 	struct completion	 cu_done;
+	/* daemon has read the whole upcall; protected by cn_lock */
+	bool			 cu_inflight;
 	union {
 		struct cld_msg_hdr	 cu_hdr;
 		struct cld_msg		 cu_msg;
@@ -807,6 +809,13 @@ cld_pipe_downcall(struct file *filp, con
 	spin_lock(&cn->cn_lock);
 	list_for_each_entry(tmp, &cn->cn_list, cu_list) {
 		if (get_unaligned(&tmp->cu_u.cu_hdr.cm_xid) == xid) {
+			/*
+			 * Completing now would return the waiter
+			 * while its message is still queued on the
+			 * pipe.
+			 */
+			if (!tmp->cu_inflight)
+				break;
 			cup = tmp;
 			if (status != -EINPROGRESS)
 				list_del_init(&cup->cu_list);
@@ -815,9 +824,9 @@ cld_pipe_downcall(struct file *filp, con
 	}
 	spin_unlock(&cn->cn_lock);
 
-	/* couldn't find upcall? */
+	/* no upcall to complete? */
 	if (!cup) {
-		dprintk("%s: couldn't find upcall -- xid=%u\n", __func__, xid);
+		dprintk("%s: no completable upcall -- xid=%u\n", __func__, xid);
 		return -EINVAL;
 	}
 
@@ -837,8 +846,16 @@ cld_pipe_destroy_msg(struct rpc_pipe_msg
 	struct cld_msg *cmsg = msg->data;
 	struct cld_upcall *cup = container_of(cmsg, struct cld_upcall,
 						 cu_u.cu_msg);
+	struct cld_net *cn = cup->cu_net;
+
+	/*
+	 * errno >= 0 means the daemon read the whole message and a
+	 * downcall will complete the upcall.
+	 */
+	spin_lock(&cn->cn_lock);
+	cup->cu_inflight = msg->errno >= 0;
+	spin_unlock(&cn->cn_lock);
 
-	/* errno >= 0 means we got a downcall */
 	if (msg->errno >= 0)
 		return;
 


