Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6024A0F;
	Thu, 13 Jun 2024 12:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282649; cv=none; b=mZ7gFDz+9zOJxslaeZp4X7VOjSXkPSuHHI5a67Z1Y1ktoSAClVRIBDFsMrVr1Lg935LtyknK1jYS6TNl3n54r8PqrNpNOA+awPgcwOFtsdnHusIgmVdSPKLMwKYqNlbhPCmovn+gzlZJc66K69TMvQ4tYwmId0rYQTFnOR0qPws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282649; c=relaxed/simple;
	bh=YD97bZoLgfQsgeJ/hGWwe/nHEjDmzA2huiz36MFl+xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhuS6tSc184JRFPWRxbBWXOdGYSuZ6uo0DfYdZS7baP6y4wWmSZD/GtI61GkHgPS2ZdexqfINOnanwdTg1RvzX6Y1ncHRF9Qlxy1DDiEFgeNZuz6DZa27ReNWFBesfYdyn2QxaCxA5XC9Ok1waT9pQqY9jwRYd2g3CIq2fT+eiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ks6qCwhn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ks6qCwhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E25EC2BBFC;
	Thu, 13 Jun 2024 12:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282649;
	bh=YD97bZoLgfQsgeJ/hGWwe/nHEjDmzA2huiz36MFl+xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ks6qCwhn75MkP7MBzODejShokjBiB1vySx1B7KQ4lu/9DeaeeQRDQm33H+tlEy5xW
	 ykQGl2r6y6xa3riXA63jfjUIbb5WB1pxeeFY2jHFvOjBTb6X8GXq+oIhLrUDApmCCJ
	 Xbv3xKECe+oDDc1xSHVNOy7y9MXAEtQ4oA+TybPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 347/402] mptcp: fix full TCP keep-alive support
Date: Thu, 13 Jun 2024 13:35:04 +0200
Message-ID: <20240613113315.670650624@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

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
  implement TCP_NOTSENT_LOWAT support") (new feature), commit
  013e3179dbd2 ("mptcp: fix rcv space initialization") (not backported
  because of the various conflicts, and because the race fixed by this
  commit "does not produce ill effects in practice"), and commit
  4f6e14bd19d6 ("mptcp: support TCP_CORK and TCP_NODELAY") are not in
  this version. The adaptations done by 7f71a337b515 ("mptcp: cleanup
  SOL_TCP handling") have been adapted to this case here. Also,
  TCP_KEEPINTVL and TCP_KEEPCNT value had to be set without lock, the
  same way it was done on TCP side prior commit 6fd70a6b4e6f ("tcp: set
  TCP_KEEPINTVL locklessly") and commit 84485080cbc1 ("tcp: set
  TCP_KEEPCNT locklessly"). ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |    3 +
 net/mptcp/sockopt.c  |  115 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 118 insertions(+)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -250,6 +250,9 @@ struct mptcp_sock {
 	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
 	bool		csum_enabled;
 	spinlock_t	join_list_lock;
+	int		keepalive_cnt;
+	int		keepalive_idle;
+	int		keepalive_intvl;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
 	struct rb_root  out_of_order_queue;
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -593,6 +593,60 @@ static int mptcp_setsockopt_sol_tcp_cong
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
+static int mptcp_setsockopt_set_val(struct mptcp_sock *msk, int max,
+				    int (*set_val)(struct sock *, int),
+				    int *msk_val, sockptr_t optval,
+				    unsigned int optlen)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	int val, err;
+
+	err = mptcp_get_int_option(msk, optval, optlen, &val);
+	if (err)
+		return err;
+
+	lock_sock(sk);
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
+	release_sock(sk);
+
+	return err;
+}
+
 static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    sockptr_t optval, unsigned int optlen)
 {
@@ -601,6 +655,21 @@ static int mptcp_setsockopt_sol_tcp(stru
 		return -EOPNOTSUPP;
 	case TCP_CONGESTION:
 		return mptcp_setsockopt_sol_tcp_congestion(msk, optval, optlen);
+	case TCP_KEEPIDLE:
+		return mptcp_setsockopt_set_val(msk, MAX_TCP_KEEPIDLE,
+						&tcp_sock_set_keepidle_locked,
+						&msk->keepalive_idle,
+						optval, optlen);
+	case TCP_KEEPINTVL:
+		return mptcp_setsockopt_set_val(msk, MAX_TCP_KEEPINTVL,
+						&__tcp_sock_set_keepintvl,
+						&msk->keepalive_intvl,
+						optval, optlen);
+	case TCP_KEEPCNT:
+		return mptcp_setsockopt_set_val(msk, MAX_TCP_KEEPCNT,
+						&__tcp_sock_set_keepcnt,
+						&msk->keepalive_cnt,
+						optval, optlen);
 	}
 
 	return -EOPNOTSUPP;
@@ -667,9 +736,40 @@ out:
 	return ret;
 }
 
+static int mptcp_put_int_option(struct mptcp_sock *msk, char __user *optval,
+				int __user *optlen, int val)
+{
+	int len;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+	if (len < 0)
+		return -EINVAL;
+
+	if (len < sizeof(int) && len > 0 && val >= 0 && val <= 255) {
+		unsigned char ucval = (unsigned char)val;
+
+		len = 1;
+		if (put_user(len, optlen))
+			return -EFAULT;
+		if (copy_to_user(optval, &ucval, 1))
+			return -EFAULT;
+	} else {
+		len = min_t(unsigned int, len, sizeof(int));
+		if (put_user(len, optlen))
+			return -EFAULT;
+		if (copy_to_user(optval, &val, len))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    char __user *optval, int __user *optlen)
 {
+	struct sock *sk = (void *)msk;
+
 	switch (optname) {
 	case TCP_ULP:
 	case TCP_CONGESTION:
@@ -677,6 +777,18 @@ static int mptcp_getsockopt_sol_tcp(stru
 	case TCP_CC_INFO:
 		return mptcp_getsockopt_first_sf_only(msk, SOL_TCP, optname,
 						      optval, optlen);
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
@@ -746,6 +858,9 @@ static void sync_socket_options(struct m
 
 	if (inet_csk(sk)->icsk_ca_ops != inet_csk(ssk)->icsk_ca_ops)
 		tcp_set_congestion_control(ssk, msk->ca_name, false, true);
+	tcp_sock_set_keepidle_locked(ssk, msk->keepalive_idle);
+	__tcp_sock_set_keepintvl(ssk, msk->keepalive_intvl);
+	__tcp_sock_set_keepcnt(ssk, msk->keepalive_cnt);
 }
 
 static void __mptcp_sockopt_sync(struct mptcp_sock *msk, struct sock *ssk)


