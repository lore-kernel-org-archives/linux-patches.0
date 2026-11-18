Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044550;
	b=riorzIkUvBiIA0PWrKFlsOk/t0xFtSyLC0qgtqCLmP5yI+KBImlkuX7A2a/a5vMRwk6n
	 K+GRI0/9OlHANcbjESfUGd6JBrBl/RxhLVJSLw/a69VObwEoAah/mFhKXJ3juOzNoJho9
	 IDow0UM2hjNCGq6821Pv1bosyx5EQBX1Xcrtk/KSaKxAiZ8jFWTeZz7IMW1niIze/RsDW
	 Pp74wSl66srjc6Zq4bbZF97S+7amnbcNPMCk4qkd7MjgIpZawvxeROkzcgqHgaD6HdiwM
	 x7VfVZwwEhnqMo72CVql+iI70ryVBGkj1SeNL6P/nQmHyXvyzHT2f6kNzo6l655WMXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4uGouKvL6Y4DGwjBv2qXPWfyDFFoS77+TO5ojzkGzng=;
	b=zJ87VTGd+hczzqpZOkStwovtMssey7Ma+iXU4WtI6E0wACnoLSOdYuq41lz8KO6j3kVg
	 He09iUMQ7ITOPBgDDUhO2tq084vXLdBqGcESRC/SH3GDBRYCRakUnW7DtOOSuusHzjR5D
	 9tmdHWTWK8hY6Vy4D0xoDhrUtdvw1SPg3NPsajbrBph5ZrNb+gAqODSd9L4owfUYMROft
	 xHrEM18+tIoLNcM3EnvN3XXpjwe3U5OZ2T0RgchjAKbrpKPxCHRrkExPHamww4ra38NZS
	 CoRj378R4VSRS8YGtP3PALrMM+Rt2HkiI2I9PPiYS/6DrwAhdh5aStV+fLfIRbxGaYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQ0kipNO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80F1606A325;
	Wed, 18 Nov 2026 23:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vQ0kipNO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5851F000C4;
	Wed, 18 Nov 2026 23:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044550;
	bh=4uGouKvL6Y4DGwjBv2qXPWfyDFFoS77+TO5ojzkGzng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQ0kipNOgfyHNMQyTst94qwIkz5NHVG48PCOXGuNBQQ68EGidkNCsTToMB0uhi9bO
	 gH35BVlxOuxWoEgh9xJEaxdez4chnzySVW/x6YubU3dA+PO89hwkXf1Jfgm7Mf7xZ4
	 8KcYI47L3D8W5Vlci4DEJVS/y05liijzUe5HLT4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0606/2857] NFSD: Dont complete a cld upcall the daemon has not read
Date: Wed, 18 Nov 2026 15:27:20 +0100
Message-ID: <20261118150223.309475973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -724,6 +724,8 @@ struct cld_upcall {
 	struct list_head	 cu_list;
 	struct cld_net		*cu_net;
 	struct completion	 cu_done;
+	/* daemon has read the whole upcall; protected by cn_lock */
+	bool			 cu_inflight;
 	union {
 		struct cld_msg_hdr	 cu_hdr;
 		struct cld_msg		 cu_msg;
@@ -883,6 +885,13 @@ cld_pipe_downcall(struct file *filp, con
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
@@ -891,9 +900,9 @@ cld_pipe_downcall(struct file *filp, con
 	}
 	spin_unlock(&cn->cn_lock);
 
-	/* couldn't find upcall? */
+	/* no upcall to complete? */
 	if (!cup) {
-		dprintk("%s: couldn't find upcall -- xid=%u\n", __func__, xid);
+		dprintk("%s: no completable upcall -- xid=%u\n", __func__, xid);
 		return -EINVAL;
 	}
 
@@ -913,8 +922,16 @@ cld_pipe_destroy_msg(struct rpc_pipe_msg
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
 


