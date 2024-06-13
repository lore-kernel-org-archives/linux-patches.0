Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28650384;
	Thu, 13 Jun 2024 12:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282846; cv=none; b=K4LgG1wWbJmvsV5qCZ+aLGmNi7keeqkvzv5mQ/FrvrZIS/mSdrHFRF2L8mE3V+wSbhwsHBNgYf+uCbnHhFcbA2Qk6fzViS+DKmDcSETp25+Ic5fdwVDGx8DXOCt7EKjqP9E6F+gzJkIFDPn2fABdroTEk6NgmBMdLgPOGXSl4tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282846; c=relaxed/simple;
	bh=xWmtLIna0ABqwCA7WiYN6nA/QQ7I1EAC2t5nzp/q4W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7SH39sHfxFKRbHcwc3x7/+adfog0XVhWcnqfCyNouf5WpRQylQb9mksobpahdTqw86UF8j3M3GY7bqGhV9mMqAVFkiBLo1wG5X/8411Bcz0mRTXkw//qtVKt/zH7A/i126h2j7iLDg/KUF7lL1/sCiq1m6wNHtS1ArOuyKO/MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTTruzAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTTruzAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52AFC32786;
	Thu, 13 Jun 2024 12:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282846;
	bh=xWmtLIna0ABqwCA7WiYN6nA/QQ7I1EAC2t5nzp/q4W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTTruzAmfeKQfzguCe3DYX82klA0JjRWuUXGsKLyb035PV5R4Tn3TYJF8K6Qfw9c+
	 DYsree4DGlpvVzIJrMaB6ZYat65m37jWBYEWr1grzEflYikpDtJWCTrYcw3huzgQ3E
	 yQShZxo/SsnH51BI6xIfPOz/ofLrKxFDxLYbLg4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 13/85] mptcp: fix full TCP keep-alive support
Date: Thu, 13 Jun 2024 13:35:11 +0200
Message-ID: <20240613113214.654150864@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit bd11dc4fb969ec148e50cd87f88a78246dbc4d0b upstream.

SO_KEEPALIVE support has been added a while ago, as part of a series
"adding SOL_SOCKET" support. To have a full control of this keep-alive
feature, it is important to also support TCP_KEEP* socket options at the
SOL_TCP level.

Supporting them on the setsockopt() part is easy, it is just a matter of
remembering each value in the MPTCP sock structure, and calling
tcp_sock_set_keep*() helpers on each subflow. If the value is not
modified (0), calling these helpers will not do anything. For the
getsockopt() part, the corresponding value from the MPTCP sock structure
or the default one is simply returned. All of this is very similar to
other TCP_* socket options supported by MPTCP.

It looks important for kernels supporting SO_KEEPALIVE, to also support
TCP_KEEP* options as well: some apps seem to (wrongly) consider that if
the former is supported, the latter ones will be supported as well. But
also, not having this simple and isolated change is preventing MPTCP
support in some apps, and libraries like GoLang [1]. This is why this
patch is seen as a fix.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/383
Fixes: 1b3e7ede1365 ("mptcp: setsockopt: handle SO_KEEPALIVE and SO_PRIORITY")
Link: https://github.com/golang/go/issues/56539 [1]
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20240514011335.176158-3-martineau@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in the same context, because commit 29b5e5ef8739 ("mptcp:
  implement TCP_NOTSENT_LOWAT support") (new feature) and commit
  013e3179dbd2 ("mptcp: fix rcv space initialization") (not backported
  because of the various conflicts, and because the race fixed by this
  commit "does not produce ill effects in practice") are not in this
  version. Also, TCP_KEEPINTVL and TCP_KEEPCNT value had to be set
  without lock, the same way it was done on TCP side prior commit
  6fd70a6b4e6f ("tcp: set TCP_KEEPINTVL locklessly") and commit
  84485080cbc1 ("tcp: set TCP_KEEPCNT locklessly"). ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |    3 +
 net/mptcp/sockopt.c  |   79 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -288,6 +288,9 @@ struct mptcp_sock {
 			fastopening:1,
 			in_accept_queue:1,
 			free_first:1;
+	int		keepalive_cnt;
+	int		keepalive_idle;
+	int		keepalive_intvl;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -616,6 +616,52 @@ static int mptcp_setsockopt_sol_tcp_cong
 	return ret;
 }
 
+static int __tcp_sock_set_keepintvl(struct sock *sk, int val)
+{
+	if (val < 1 || val > MAX_TCP_KEEPINTVL)
+		return -EINVAL;
+
+	WRITE_ONCE(tcp_sk(sk)->keepalive_intvl, val * HZ);
+
+	return 0;
+}
+
+static int __tcp_sock_set_keepcnt(struct sock *sk, int val)
+{
+	if (val < 1 || val > MAX_TCP_KEEPCNT)
+		return -EINVAL;
+
+	/* Paired with READ_ONCE() in keepalive_probes() */
+	WRITE_ONCE(tcp_sk(sk)->keepalive_probes, val);
+
+	return 0;
+}
+
+static int __mptcp_setsockopt_set_val(struct mptcp_sock *msk, int max,
+				      int (*set_val)(struct sock *, int),
+				      int *msk_val, int val)
+{
+	struct mptcp_subflow_context *subflow;
+	int err = 0;
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+		int ret;
+
+		lock_sock(ssk);
+		ret = set_val(ssk, val);
+		err = err ? : ret;
+		release_sock(ssk);
+	}
+
+	if (!err) {
+		*msk_val = val;
+		sockopt_seq_inc(msk);
+	}
+
+	return err;
+}
+
 static int __mptcp_setsockopt_sol_tcp_cork(struct mptcp_sock *msk, int val)
 {
 	struct mptcp_subflow_context *subflow;
@@ -805,6 +851,22 @@ static int mptcp_setsockopt_sol_tcp(stru
 	case TCP_NODELAY:
 		ret = __mptcp_setsockopt_sol_tcp_nodelay(msk, val);
 		break;
+	case TCP_KEEPIDLE:
+		ret = __mptcp_setsockopt_set_val(msk, MAX_TCP_KEEPIDLE,
+						 &tcp_sock_set_keepidle_locked,
+						 &msk->keepalive_idle, val);
+		break;
+	case TCP_KEEPINTVL:
+		ret = __mptcp_setsockopt_set_val(msk, MAX_TCP_KEEPINTVL,
+						 &__tcp_sock_set_keepintvl,
+						 &msk->keepalive_intvl, val);
+		break;
+	case TCP_KEEPCNT:
+		ret = __mptcp_setsockopt_set_val(msk, MAX_TCP_KEEPCNT,
+						 &__tcp_sock_set_keepcnt,
+						 &msk->keepalive_cnt,
+						 val);
+		break;
 	default:
 		ret = -ENOPROTOOPT;
 	}
@@ -1163,6 +1225,8 @@ static int mptcp_put_int_option(struct m
 static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    char __user *optval, int __user *optlen)
 {
+	struct sock *sk = (void *)msk;
+
 	switch (optname) {
 	case TCP_ULP:
 	case TCP_CONGESTION:
@@ -1178,6 +1242,18 @@ static int mptcp_getsockopt_sol_tcp(stru
 		return mptcp_put_int_option(msk, optval, optlen, msk->cork);
 	case TCP_NODELAY:
 		return mptcp_put_int_option(msk, optval, optlen, msk->nodelay);
+	case TCP_KEEPIDLE:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    msk->keepalive_idle ? :
+					    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_keepalive_time) / HZ);
+	case TCP_KEEPINTVL:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    msk->keepalive_intvl ? :
+					    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_keepalive_intvl) / HZ);
+	case TCP_KEEPCNT:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    msk->keepalive_cnt ? :
+					    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_keepalive_probes));
 	}
 	return -EOPNOTSUPP;
 }
@@ -1282,6 +1358,9 @@ static void sync_socket_options(struct m
 		tcp_set_congestion_control(ssk, msk->ca_name, false, true);
 	__tcp_sock_set_cork(ssk, !!msk->cork);
 	__tcp_sock_set_nodelay(ssk, !!msk->nodelay);
+	tcp_sock_set_keepidle_locked(ssk, msk->keepalive_idle);
+	__tcp_sock_set_keepintvl(ssk, msk->keepalive_intvl);
+	__tcp_sock_set_keepcnt(ssk, msk->keepalive_cnt);
 
 	inet_sk(ssk)->transparent = inet_sk(sk)->transparent;
 	inet_sk(ssk)->freebind = inet_sk(sk)->freebind;


