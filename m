Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4FE17727;
	Mon, 27 May 2024 19:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838264; cv=none; b=r+eUiGBrJsZoh3xzK4ulOca+HhRptBJp5KsCOBRGFWB11L23OvJ7Xq2wqj5P8IZ2fMhT2b35UCNhn0K2vNOLAElfDr6T1gUFD/UcuomI8ilVN7eAZzGdEng08JCZo/wRTgVwaaX81dYeJIcestqGV4buSGNTvnq+vISqrlqm5/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838264; c=relaxed/simple;
	bh=f5DvIUotpr112/eLozPycO2O3vEACfmnSLBIbb/vG9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ii+dJRrYRTjnkoHk2oW35V6di0wbrmdxYx4wvOLUzFacML9ef7aFOqYlVsrloibAoLXx9YsuHAjMabKms0FnZELdbi6/JSohXLkOOCzn978rYeby5KiRwzGECCk3w9sHlM/YmLoC6HZqv0W/SdYJitNlP2So+FeUFqkyReEWsaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQ/+Bvf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQ/+Bvf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83436C2BBFC;
	Mon, 27 May 2024 19:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838263;
	bh=f5DvIUotpr112/eLozPycO2O3vEACfmnSLBIbb/vG9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQ/+Bvf8nu3kwPxo2gTn19JJjRUSuHbY3h/8IYCsSMluPViAvZUwYMi7psdMq2q8n
	 cxmk6ImS1YI3LwNNULoCC5GOBJELWQNqVry4fDH6EBBHvDHqy9QCa/sLHVF45UGMmI
	 giaQzr69vp6VO4zZPixMEjTfCcs5G7uE70JbXG/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 327/493] mptcp: cleanup writer wake-up
Date: Mon, 27 May 2024 20:55:29 +0200
Message-ID: <20240527185640.964506938@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 037db6ea57da7a134a8183dead92d64ef92babee ]

After commit 5cf92bbadc58 ("mptcp: re-enable sndbuf autotune"), the
MPTCP_NOSPACE bit is redundant: it is always set and cleared together with
SOCK_NOSPACE.

Let's drop the first and always relay on the latter, dropping a bunch
of useless code.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bd11dc4fb969 ("mptcp: fix full TCP keep-alive support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 15 +++------------
 net/mptcp/protocol.h | 16 ++++++----------
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 74c1faec271d1..fcd85adc621c1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1687,15 +1687,6 @@ static void __mptcp_subflow_push_pending(struct sock *sk, struct sock *ssk, bool
 	}
 }
 
-static void mptcp_set_nospace(struct sock *sk)
-{
-	/* enable autotune */
-	set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
-
-	/* will be cleared on avail space */
-	set_bit(MPTCP_NOSPACE, &mptcp_sk(sk)->flags);
-}
-
 static int mptcp_disconnect(struct sock *sk, int flags);
 
 static int mptcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
@@ -1869,7 +1860,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		continue;
 
 wait_for_memory:
-		mptcp_set_nospace(sk);
+		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		__mptcp_push_pending(sk, msg->msg_flags);
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret)
@@ -3944,8 +3935,8 @@ static __poll_t mptcp_check_writeable(struct mptcp_sock *msk)
 	if (sk_stream_is_writeable(sk))
 		return EPOLLOUT | EPOLLWRNORM;
 
-	mptcp_set_nospace(sk);
-	smp_mb__after_atomic(); /* msk->flags is changed by write_space cb */
+	set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+	smp_mb__after_atomic(); /* NOSPACE is changed by mptcp_write_space() */
 	if (sk_stream_is_writeable(sk))
 		return EPOLLOUT | EPOLLWRNORM;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 07f6242afc1ae..6b83869ef7938 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -113,10 +113,9 @@
 #define MPTCP_RST_TRANSIENT	BIT(0)
 
 /* MPTCP socket atomic flags */
-#define MPTCP_NOSPACE		1
-#define MPTCP_WORK_RTX		2
-#define MPTCP_FALLBACK_DONE	4
-#define MPTCP_WORK_CLOSE_SUBFLOW 5
+#define MPTCP_WORK_RTX		1
+#define MPTCP_FALLBACK_DONE	2
+#define MPTCP_WORK_CLOSE_SUBFLOW 3
 
 /* MPTCP socket release cb flags */
 #define MPTCP_PUSH_PENDING	1
@@ -792,12 +791,9 @@ static inline bool mptcp_data_fin_enabled(const struct mptcp_sock *msk)
 
 static inline void mptcp_write_space(struct sock *sk)
 {
-	if (sk_stream_is_writeable(sk)) {
-		/* pairs with memory barrier in mptcp_poll */
-		smp_mb();
-		if (test_and_clear_bit(MPTCP_NOSPACE, &mptcp_sk(sk)->flags))
-			sk_stream_write_space(sk);
-	}
+	/* pairs with memory barrier in mptcp_poll */
+	smp_mb();
+	sk_stream_write_space(sk);
 }
 
 static inline void __mptcp_sync_sndbuf(struct sock *sk)
-- 
2.43.0



