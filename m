Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB0B17BED0;
	Sat, 17 Oct 2026 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255711; cv=none; b=EhTICkX5gjeAgHOnZX69L432JAxPWWKcbod43DitDMF8xNk6z5DYHzRWrOAOcLHU6zFL5F0/KpO4pXPolG4LmFZQBbzBpqEhEoP6ii7LQ1om5JBGlSS55zNJGcvbkVogwDaH5tafphlqb/bo0ZZunDnBmqCHvm7gSmKMzhxVZ3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255711; c=relaxed/simple;
	bh=NY4oqUtEJcB4vVvy4FunWMq8m9c20O1yYv77O52uswM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLdDq1bcDbYjqVWXnY3oZVORPr3EzD0q304rbqSNICzQICiQjkysxE0fkNPrgZ0TfwbzZNVgTkhlcwFaSXi3KFUWKqn3iVjtSkcgRBibong9SsplRlDq50WR4v0+N4uax4ZHUqb5OygAlm0T6ID00yKP7hJV3r5aMyTH3XUGzK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjZDnp59; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjZDnp59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2961F1F000C4;
	Sat, 17 Oct 2026 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255710;
	bh=EDurl6TPfU3vHHwYyfCO+fid9zgq2fzBvpQGECWIwgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjZDnp59vPf26vQqi319f5Efl+T6GaiE7z4upK2lub/F2BWkPFMZBAQ3C51zbWivg
	 kiDLRviLaqRFW5AMmFudaSkTJN4UQXdujqoJ1KEMbh4AUuEkIeHsyK8BMTW7/6Iyk4
	 SrFOkKB2BhN8m8JgKMTxpCvAo1kmLIjS+anCvQ7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mattia Meleleo <mattia.meleleo@coralogix.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 866/869] bpf, sockmap: Account for receive queue in FIONREAD without a verdict program
Date: Sat, 17 Oct 2026 18:01:47 +0200
Message-ID: <20261017160059.060890644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mattia Meleleo <mattia.meleleo@coralogix.com>

[ Upstream commit 04af4efde58a4a4ef4feab7360c46af9ec0b83a0 ]

tcp_bpf_ioctl() answers SIOCINQ from psock->msg_tot_len, which only
counts bytes in ingress_msg. Without a stream/skb verdict program
nothing is diverted there: data stays in sk_receive_queue, so FIONREAD
returns 0 even though read() returns data.

Add tcp_inq() to the reported value when the psock has no verdict
program. The two queues are disjoint, so bytes redirected into
ingress_msg from other sockets stay correctly accounted through
msg_tot_len.

Remove unused sk_psock_msg_inq().

Fixes: 929e30f93125 ("bpf, sockmap: Fix FIONREAD for sockmap")
Signed-off-by: Mattia Meleleo <mattia.meleleo@coralogix.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20260708-fionread-no-verdict-v3-1-b4ee31b3af53@coralogix.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 14 --------------
 net/ipv4/tcp_bpf.c    | 17 ++++++++++++++++-
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index ce8464324d42f..ae2b34cc10eea 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -561,20 +561,6 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 	return !!psock->saved_data_ready;
 }
 
-/* for tcp only, sk is locked */
-static inline ssize_t sk_psock_msg_inq(struct sock *sk)
-{
-	struct sk_psock *psock;
-	ssize_t inq = 0;
-
-	psock = sk_psock_get(sk);
-	if (likely(psock)) {
-		inq = sk_psock_get_msg_len_nolock(psock);
-		sk_psock_put(sk, psock);
-	}
-	return inq;
-}
-
 /* for udp only, sk is not locked */
 static inline ssize_t sk_msg_first_len(struct sock *sk)
 {
diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 0e7e121179134..4d3315ff45227 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -335,6 +335,7 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 
 static int tcp_bpf_ioctl(struct sock *sk, int cmd, int *karg)
 {
+	struct sk_psock *psock;
 	bool slow;
 
 	if (cmd != SIOCINQ)
@@ -345,7 +346,21 @@ static int tcp_bpf_ioctl(struct sock *sk, int cmd, int *karg)
 		return -EINVAL;
 
 	slow = lock_sock_fast(sk);
-	*karg = sk_psock_msg_inq(sk);
+	psock = sk_psock_get(sk);
+	if (unlikely(!psock)) {
+		unlock_sock_fast(sk, slow);
+		return tcp_ioctl(sk, cmd, karg);
+	}
+	*karg = sk_psock_get_msg_len_nolock(psock);
+	/* Without a verdict program, ingress data is never diverted to
+	 * ingress_msg: it stays in sk_receive_queue and is read through
+	 * the fallback to tcp_recvmsg(), so account for it like
+	 * tcp_ioctl() does.
+	 */
+	if (!READ_ONCE(psock->progs.stream_verdict) &&
+	    !READ_ONCE(psock->progs.skb_verdict))
+		*karg += tcp_inq(sk);
+	sk_psock_put(sk, psock);
 	unlock_sock_fast(sk, slow);
 
 	return 0;
-- 
2.53.0



