Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046004;
	b=hjoimbIUxqXlsXBXXswOTGsFLYvmMKOyPZeH+rJM42JXjCLnpUxqB5ee3rkxxuJsexXx
	 LYf5I+4ASwYlB2RvowfBtK2rgZPDw9zDxppXIdyHjrAKKYX1bxI5XGXWDvA04giYG9FYq
	 KW9zzQSITQdnWF9+kqRgbxU/Sz869prgAZEtyUmQwqDoAMtUrZi3Okjyvi7MYOkKVW2lM
	 BZzFIVsLFzawuGJ6SVztr0b+dBF0O9tpYVCtOfkcTI/DBdPTvucVt/GUZXxprZkTqFe5L
	 zSVyC0N38/TIn2M/na9UrdsLegbCtPmGuPjJ3K55oGV9kEQtrcv6+9QJb/wbbx/RMNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046004;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g5XhjBurkI9T0qb9qr60aVwhHLP9CRhdNRMP6Xy3ktI=;
	b=GyYC3UoAwjtCqjfJhM1K5gNPYeglLVPZQgze+t+VBarjA+wdILVlTRnBwGkV8wJfWLk0
	 TOMEPkxHYeJXiMJqAcGA/1P8njFW9aSxA68FE1gKpVSlSCRAzJDwEcdZceuDr0AZEUcuq
	 jKVN8Eeucq2b31ee9GhecuEqCw/ugU4Dnd9GlrlH6cZ/7OLQMz2Aag91NE3geHEZQYG05
	 LoadJDQ43avKIcLb3X4mvOMg8VI2iD2T510IyFe4yLYvluSBV3fLgBUaBWUGWkCYL3MFb
	 r3EWIGBBOUVnA0P8YkI4n8T+7pL9NJmFVnVsX0a9h+pG6gg5+fQnZpDZXGjNoHM0cJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sbNXBh92;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E056E606A31C;
	Wed, 18 Nov 2026 23:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sbNXBh92
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B851F000C4;
	Wed, 18 Nov 2026 23:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046003;
	bh=g5XhjBurkI9T0qb9qr60aVwhHLP9CRhdNRMP6Xy3ktI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sbNXBh92RdDD+OCdvTelw92t6P7A82EolFuX06+tu+1JJgj4IDiCu93sfSO2YbfGh
	 hKidxjQaPF5qt8NtQmmP2KjWo47SIYl3tyAQmhkPPGze+erx2uSsF//WFDx/m0m9rF
	 MrjEp4wgMnAv7MeMmJR8GGdVW0/is6rM4gAnqyFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d5c77cabf7a3492aa650@syzkaller.appspotmail.com,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1127/2857] NFSD: Move the cld upcall message out of the callers stack frame
Date: Wed, 18 Nov 2026 15:36:01 +0100
Message-ID: <20261118150242.184973917@linuxfoundation.org>
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
index d91b912fb7d0b..fc3ee0861a688 100644
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



