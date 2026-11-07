Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061718;
	b=CxmoAunxI++sT1LIF+v3YvlBI92vSeIYvAIw87pVy8CbJYOo+VwjPnfMuMoooYj/HNih
	 kckoSh0wJdw679Kq41m3J6fDp4g51K+2V6+C3D0zcT3q34h1pCAj1wyCJg3UoxIYrODEo
	 P+DDpCvNwrfIq6luuVi8qtGvZHXUNLD5LCbx/+65JU8rExnW66d1SQSq2Y9LVkxFWynFM
	 FtKqXRhCSrmlBOiW/I5wupLbshXJKbpe12XllQI/SnGC/ZBZbB0mmkgweOkiz5I6H2pgM
	 6a9j8gzxUTFE5uyOPmE0AVMzrxYRmsJejEOAJqhuhjgIva9N6c4S6plXyLFBwbgOtGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mPhZtjaJCDWOWY/xsiZjtdGLbobb0mJGUR/KsDQ3YzU=;
	b=PBJ/KS1ma+rQe6zXH8qaqK0WBTmfWzffZ1NbnuUfu09jGOootCH+nk0BWiGtLrmMnjYH
	 Ir4T1a8G3V04an0y8ui0+uIJ8FbGkj8BfftZnuWu0FJq8NAhbMSriBSmIqersfAfBTo9h
	 vaNsMM+vmf6qMUsm5akHhNRwBWo/bop4p3PLIw/zraWO9TBMCvZvHtvBroTooncNtF44y
	 EcDw68xiU+tqViv4sxfk6j2tAJeLP16NJIeeWoHm+14Pn8IUbwld29lmivEb5T/e+01up
	 6fIx2jwTVG3XxZB/mzLaPTtB/p23mOELUgZr7xhGVqsqok87zEGlFMpWaHRhmQgfTrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jiLY8gFu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD70B606A32E;
	Sat,  7 Nov 2026 14:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jiLY8gFu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BDE11F008A1;
	Sat,  7 Nov 2026 14:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061717;
	bh=mPhZtjaJCDWOWY/xsiZjtdGLbobb0mJGUR/KsDQ3YzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jiLY8gFuja5Mj91WmoNdKyHBUQVz3579CbXXf800BrQ2BaxA/G+Zem5xvfJjbMkz7
	 bYjZakZt0npNemJCaeRBn+eUDKYJG+0mopj4tj6vJT096+wRBCe8TYpZbiOZNUH5LA
	 kLIK0X4z95Po/vOkhHEo+TvFaHNQoGYCCJ9T2g/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0763/1536] NFSD: Dont complete a cld upcall the daemon has not read
Date: Sat,  7 Nov 2026 08:46:19 -0500
Message-ID: <20261107135018.962289817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -728,6 +728,8 @@ struct cld_upcall {
 	struct list_head	 cu_list;
 	struct cld_net		*cu_net;
 	struct completion	 cu_done;
+	/* daemon has read the whole upcall; protected by cn_lock */
+	bool			 cu_inflight;
 	union {
 		struct cld_msg_hdr	 cu_hdr;
 		struct cld_msg		 cu_msg;
@@ -888,6 +890,13 @@ cld_pipe_downcall(struct file *filp, con
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
@@ -896,9 +905,9 @@ cld_pipe_downcall(struct file *filp, con
 	}
 	spin_unlock(&cn->cn_lock);
 
-	/* couldn't find upcall? */
+	/* no upcall to complete? */
 	if (!cup) {
-		dprintk("%s: couldn't find upcall -- xid=%u\n", __func__, xid);
+		dprintk("%s: no completable upcall -- xid=%u\n", __func__, xid);
 		return -EINVAL;
 	}
 
@@ -918,8 +927,16 @@ cld_pipe_destroy_msg(struct rpc_pipe_msg
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
 


