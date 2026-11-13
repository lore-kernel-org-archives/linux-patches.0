Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585382;
	b=E20ei6+lxtZO5L8aVwluGW7CyprVKaZbpq4vD9KYyRZsyr4GxBQ/hs/4xQJLPsnHMni7
	 Yh6qleqroCOiVASg1oMho68oLUsa/6kVydM0GjhuRFO5gJo9wZBjaxmVev9ubyXaN4G9f
	 736JrQuUqwUxMrKXuGqXaWAr62lb3FjBCO1WghecolEKiLtnHbur+d8WU52uTnebLVpRV
	 yaGQhAC/EdD9uJakO8KPHa3dy2pdbSLiaq8v//DzP1SimyHZQoJiHyvAp04jtXy2Pe8Me
	 t6RU/19CZtla7Os76pSVOZTsRSgEs2R2JcrqQns01/KQ1PUomxFzr42FnjlGilpAShA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585382;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Dq4RLf55jxHV5YlBCaCbM/ko2rMABpRmz0TRhBxnlQ=;
	b=Y8lmkka+jBI5o+ikjMfzy3nXeGFpBd5+SHQl+OUJ2W/1fss7ljpLawvsy9k6ciwgEGgI
	 qeGyj50FCa8d080EDyvFqSVQuoD9SZikuhLi/41VRSVAugaVl1SybXu1x4KE6C781h6hJ
	 Q+V/JDAEzl5pFcjiosL+0QRGojqfg39xuzhVWcPJjo2vkbPJOFdjXEtxiJJBqqmWejhh7
	 nc1Gd16QPOOxK5jSOKZ2hSCF06uJMhkCnoGvtsjqYk6T4tQU/00/NmUifiLUBnv972Ukz
	 w8lGj3yuA8lfH2qjR91/NqecEb/6lUZv19oUQ1j7F+Pq866+1SbS3CPPFz35lCqY6/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=So7Jo3d9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E27606BAB3;
	Fri, 13 Nov 2026 15:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=So7Jo3d9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242501F000D3;
	Fri, 13 Nov 2026 15:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585382;
	bh=1Dq4RLf55jxHV5YlBCaCbM/ko2rMABpRmz0TRhBxnlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=So7Jo3d9URzbVdGXQIsbKyyL5X1CnIuRkEp4xCQz8yAGEn5N3w/01KAhZDf8CplAr
	 SU+mSImZaW6BVeu2lfqOULJnYX6occe1FOCk98X6l2YroBJ2GaBmXyLDxGqHgpOKQ+
	 1SzriB9yn6vFV2IbuO6URNwmxVyJvUA73hl95GM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d5c77cabf7a3492aa650@syzkaller.appspotmail.com,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 017/507] NFSD: Move the cld upcall message out of the callers stack frame
Date: Fri, 13 Nov 2026 10:45:21 -0500
Message-ID: <20261113153754.003406425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index 6441e54283a35..6b0c51b8938b5 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -649,6 +649,7 @@ struct cld_upcall {
 	struct completion	 cu_done;
 	/* daemon has read the whole upcall; protected by cn_lock */
 	bool			 cu_inflight;
+	struct rpc_pipe_msg	 cu_pipe_msg;
 	union {
 		struct cld_msg_hdr	 cu_hdr;
 		struct cld_msg		 cu_msg;
@@ -660,22 +661,22 @@ static int
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
@@ -848,9 +849,8 @@ cld_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
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



