Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037180;
	b=GX7P9A9Z7t6KGKENVgHG8AAF/Lf9BeMC4oD22/Q0se4NZaity+3vZozGQDmMiNqNRHFy
	 p/Fvlc/XhbAnbQ1NCYm+NcQGpwNc7ogbENcokRgIAza28dS0cly96oCBA0vlTTx4B+Baw
	 JShSg1TidTe4I/+vREJ+lsVGu/upWsY+tSAgC2pCewy9Hwrnj+EL8xbq4qRz63rPm9yVr
	 m2TUGCJ40MXQePUnkDmO8MP42o39YO2qidKv/3CVfEo514nRYOk7u+YFRQbQQsEC9sPQ+
	 ITn9vOpA4I/R17yHH9FCtAjlJ2s7vturowoShh/vUVHFk2kJksUzvkjx3G9fy+IkWlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C8uQTH/vnQlhF+qVNsR5JqLfhzeiDCp7zeGmRo1RIo0=;
	b=skKgQ90iscYEOYum9jkxjWXU7zSfHAWyFAyRE4kTqkCgdfeFSwobzs9gkInFwSMKU3nS
	 QMXfzTqoW00rr1Ec3dgUYsl3MYE9h0yoOGciF2tUztMbhwV7tXnnHPERMmOCOlB8VBlKj
	 vhhEGf6Etmv05G+FJamQiL4wDNZAAZ5OaSi6a1N4S5aFQMIWeN9pHrLGgQkXHqzGbZP+n
	 6msQ9mwh+bPBsKClof++3e7Ln92evBKnMVHFCYXWK4CffwufgJmqBeSCF/nVIkweCg6oq
	 6Nx4lWEdvHXJqw69VrfMHj5C4SR4W0Oyg8skbM6aISmk2QtrjK0szyueUIxTmdPMdPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yzTEvHt+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F107606A407;
	Wed, 18 Nov 2026 21:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yzTEvHt+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DA91F000C4;
	Wed, 18 Nov 2026 21:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037180;
	bh=C8uQTH/vnQlhF+qVNsR5JqLfhzeiDCp7zeGmRo1RIo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzTEvHt+5TSaq31VdDZ/9G8y6nHaJTu1VDVixxPWYnymiK+ys7m1Q3oJAEI9203U3
	 2WZfp1Xrk21fxLtjPNuLj+GMQ4n9Ta+Z2HYy0g4vFQmTc3jKm4UL5pO6V6mJF+C1Jq
	 7hacmctcszZLBx0IjtYQsgsHWay+uP99kUdxnyeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d5c77cabf7a3492aa650@syzkaller.appspotmail.com,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1321/3318] NFSD: Move the cld upcall message out of the callers stack frame
Date: Wed, 18 Nov 2026 15:32:23 +0100
Message-ID: <20261118150359.946492569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit c559b05610557fa3c6c30259261f6dae523b3f23 ]

__cld_pipe_upcall() builds its struct rpc_pipe_msg on the stack and
hands it to rpc_queue_upcall(), which links it into a list the pipe
owns until the message is released. Only the completion rules keep that
frame alive for as long as the pipe refers to it, and the peer that
drives those rules is an untrusted userspace daemon. The gss and idmap
upcalls do not take that on: each keeps the message in the object it
already allocates.

Do the same here and put the message in struct cld_upcall, beside the
reply buffer it carries. cld_pipe_destroy_msg() then reaches the upcall
from the message directly rather than through msg->data.

Reported-by: syzbot+d5c77cabf7a3492aa650@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d5c77cabf7a3492aa650
Link: https://patch.msgid.link/20260901-alemi-v2-2-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Stable-dep-of: 2a83fcb50f3c ("NFSD: Complete a cld upcall when the daemon closes the pipe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index c6e8a853bf5f5..ba50a7764ebc9 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -726,6 +726,7 @@ struct cld_upcall {
 	struct completion	 cu_done;
 	/* daemon has read the whole upcall; protected by cn_lock */
 	bool			 cu_inflight;
+	struct rpc_pipe_msg	 cu_pipe_msg;
 	union {
 		struct cld_msg_hdr	 cu_hdr;
 		struct cld_msg		 cu_msg;
@@ -737,22 +738,22 @@ static int
 __cld_pipe_upcall(struct rpc_pipe *pipe, void *cmsg, struct nfsd_net *nn)
 {
 	int ret;
-	struct rpc_pipe_msg msg;
 	struct cld_upcall *cup = container_of(cmsg, struct cld_upcall, cu_u);
+	struct rpc_pipe_msg *msg = &cup->cu_pipe_msg;
 
-	memset(&msg, 0, sizeof(msg));
-	msg.data = cmsg;
-	msg.len = nn->client_tracking_ops->msglen;
+	memset(msg, 0, sizeof(*msg));
+	msg->data = cmsg;
+	msg->len = nn->client_tracking_ops->msglen;
 
-	ret = rpc_queue_upcall(pipe, &msg);
+	ret = rpc_queue_upcall(pipe, msg);
 	if (ret < 0) {
 		goto out;
 	}
 
 	wait_for_completion(&cup->cu_done);
 
-	if (msg.errno < 0)
-		ret = msg.errno;
+	if (msg->errno < 0)
+		ret = msg->errno;
 out:
 	return ret;
 }
@@ -924,9 +925,8 @@ cld_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 static void
 cld_pipe_destroy_msg(struct rpc_pipe_msg *msg)
 {
-	struct cld_msg *cmsg = msg->data;
-	struct cld_upcall *cup = container_of(cmsg, struct cld_upcall,
-						 cu_u.cu_msg);
+	struct cld_upcall *cup = container_of(msg, struct cld_upcall,
+						 cu_pipe_msg);
 	struct cld_net *cn = cup->cu_net;
 
 	/*
-- 
2.53.0



