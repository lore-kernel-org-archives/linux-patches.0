Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590037;
	b=ijnB3CvpLl5apO8tj8RDXkwxxBdIikRYYEBY0ePQXa9u6B/1XTfDZJNdHzPmF5DSKHuZ
	 3HhXuKDTrqhcnsuXcvUKxxPlA4ngmx3jwtlY8MmUjB7/Jow2Tvu+101vwOiwpmfOmglCJ
	 r27IyW1OGhB2NQT9kpJf2TF3Dx7Y+PaXbIwETxgOHtb2ezloOPHpmkbOAeyhJiZI4rM42
	 G2y0p5G0aaI+CH9mJPWpX3hlxptoZt2qfPuv7Gvi7lE5YYclfaw9JgvWuUDglPWsKp7FU
	 TyxMR/XVogYI4xTGC0vD6iVv5esnts7N5elZlaNc/Hcan3VUTe2JuaouL/ZjbFOw/Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FPZPiM8QH0BFMbq1HP3A2wAZZcsYUxor6LPxWAbA/Po=;
	b=fQk9uAj9bX72GCYySDGc6UvtDwijH/1MyyvGFw4htWS8EToAmoD/oLXlNxc49kHGT+8d
	 zaUp7/ZdkKo9hJR435ktBLCfSfsiTrAWA8XhbkS/07r9TP0QfVh9E9Ya61ZMOslH3PfS8
	 bp9YblfAfVk5wrbjMmlTzfhIAfxNQtLO2HJQY8fBstGICpLr46uDC3gL9u+RMzjw9ps0j
	 VB9sMJwSf1RA4ko4CXuk+HxLvvRPPQLF/I3NKWiuiyuQm3Nldk4ZcApBxBAmPnjUss2js
	 RZ+8qnSQ5RIGZrbUJTtpjrwhFgkFZ2+HWmjdnEKCNopkqyaldK/XwFVCg1Lx0sFjLpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4v4gADK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67276606A8BC;
	Fri, 13 Nov 2026 17:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4v4gADK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132831F000C5;
	Fri, 13 Nov 2026 17:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590037;
	bh=FPZPiM8QH0BFMbq1HP3A2wAZZcsYUxor6LPxWAbA/Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4v4gADKjpGHlOzytpegvqM3wb6xarzYejhT4LKcNCUg9sTrV/4ci0Q0yNKbqR6+8
	 CbJIuB3nAMiyqx0xBeRT6a4hAX0vcpqwXZTUr+vjGH00MMxgek/+WC3g4dupYR7Wmd
	 U1iLZ1zBBQhxah+lEE7x7uIwiJYcIS3dhwlksw5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d5c77cabf7a3492aa650@syzkaller.appspotmail.com,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/686] NFSD: Move the cld upcall message out of the callers stack frame
Date: Fri, 13 Nov 2026 10:43:00 -0500
Message-ID: <20261113153822.555574261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d04a7d3aabbc8..b001d3277b9f9 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -711,6 +711,7 @@ struct cld_upcall {
 	struct completion	 cu_done;
 	/* daemon has read the whole upcall; protected by cn_lock */
 	bool			 cu_inflight;
+	struct rpc_pipe_msg	 cu_pipe_msg;
 	union {
 		struct cld_msg_hdr	 cu_hdr;
 		struct cld_msg		 cu_msg;
@@ -722,22 +723,22 @@ static int
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
@@ -910,9 +911,8 @@ cld_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
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



