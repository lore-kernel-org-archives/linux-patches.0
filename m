Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED4B146D68;
	Thu, 13 Jun 2024 12:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280353; cv=none; b=VwvnSL84LBSRhlZjtJwLSnxOndoOT08LEn89X0yccnBCrzmh7QZ/buFTg1H8D9fn2Jh8ygyH4gsL0gO387d1injI24HcOVQgAe6+fttZCWqmlAJQu0WLMps0u3P4imwKkZ9j2Mmy4w4V0B2Qf/AMMEMZkC7ha90oxwBkTAnLquU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280353; c=relaxed/simple;
	bh=8BNnPyJcgdPpPGjBIrnk1TliY3bsbhpcZFeGkRy/XjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+e3opxGjFqG1dkWficLntTenDkAYlkNheH5VbAOPM13Euk4UpqR1KnebhGVD3T9MsSZshroI8gLPjJzg77KV08uS1lUwe+X05B2y8hd0GRdr4reCSXJLXfgC/9kBlhcbF3qnGRBXKGUAMMGxuK12AVOQBpvWd0YswoBe/Ier5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fz6yJmTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fz6yJmTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF15EC2BBFC;
	Thu, 13 Jun 2024 12:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280353;
	bh=8BNnPyJcgdPpPGjBIrnk1TliY3bsbhpcZFeGkRy/XjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fz6yJmTAehFdkPcHsdOho84hQ8n5xApVznxC8JbSLxM2qXuPD3nJ1p8RsNG/WLKUO
	 wdTjlQCpbSXG4tLvdPs/F/bGkCkfDOQPeFS2h7TnkevuxIcE14PBRADYSzj49RsJn8
	 XyS3Wn5yH79W9YbzuMX8DuyfUrlMl4J/Z1w0XiFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 007/137] mptcp: cleanup SOL_TCP handling
Date: Thu, 13 Jun 2024 13:33:07 +0200
Message-ID: <20240613113223.570693571@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 7f71a337b5152ea0e7bef408d1af53778a919316 upstream.

Most TCP-level socket options get an integer from user space, and
set the corresponding field under the msk-level socket lock.

Reduce the code duplication moving such operations in the common code.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bd11dc4fb969 ("mptcp: fix full TCP keep-alive support")
[ Without TCP_NOTSENT_LOWAT support, as it is not in this version, see
  commit 29b5e5ef8739 ("mptcp: implement TCP_NOTSENT_LOWAT support") ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |   61 ++++++++++++++++++++++------------------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -621,18 +621,11 @@ static int mptcp_setsockopt_sol_tcp_cong
 	return ret;
 }
 
-static int mptcp_setsockopt_sol_tcp_cork(struct mptcp_sock *msk, sockptr_t optval,
-					 unsigned int optlen)
+static int __mptcp_setsockopt_sol_tcp_cork(struct mptcp_sock *msk, int val)
 {
 	struct mptcp_subflow_context *subflow;
 	struct sock *sk = (struct sock *)msk;
-	int val, ret;
 
-	ret = mptcp_get_int_option(msk, optval, optlen, &val);
-	if (ret)
-		return ret;
-
-	lock_sock(sk);
 	sockopt_seq_inc(msk);
 	msk->cork = !!val;
 	mptcp_for_each_subflow(msk, subflow) {
@@ -644,23 +637,15 @@ static int mptcp_setsockopt_sol_tcp_cork
 	}
 	if (!val)
 		mptcp_check_and_set_pending(sk);
-	release_sock(sk);
 
 	return 0;
 }
 
-static int mptcp_setsockopt_sol_tcp_nodelay(struct mptcp_sock *msk, sockptr_t optval,
-					    unsigned int optlen)
+static int __mptcp_setsockopt_sol_tcp_nodelay(struct mptcp_sock *msk, int val)
 {
 	struct mptcp_subflow_context *subflow;
 	struct sock *sk = (struct sock *)msk;
-	int val, ret;
-
-	ret = mptcp_get_int_option(msk, optval, optlen, &val);
-	if (ret)
-		return ret;
 
-	lock_sock(sk);
 	sockopt_seq_inc(msk);
 	msk->nodelay = !!val;
 	mptcp_for_each_subflow(msk, subflow) {
@@ -672,8 +657,6 @@ static int mptcp_setsockopt_sol_tcp_node
 	}
 	if (val)
 		mptcp_check_and_set_pending(sk);
-	release_sock(sk);
-
 	return 0;
 }
 
@@ -786,25 +769,10 @@ static int mptcp_setsockopt_sol_tcp(stru
 	int ret, val;
 
 	switch (optname) {
-	case TCP_INQ:
-		ret = mptcp_get_int_option(msk, optval, optlen, &val);
-		if (ret)
-			return ret;
-		if (val < 0 || val > 1)
-			return -EINVAL;
-
-		lock_sock(sk);
-		msk->recvmsg_inq = !!val;
-		release_sock(sk);
-		return 0;
 	case TCP_ULP:
 		return -EOPNOTSUPP;
 	case TCP_CONGESTION:
 		return mptcp_setsockopt_sol_tcp_congestion(msk, optval, optlen);
-	case TCP_CORK:
-		return mptcp_setsockopt_sol_tcp_cork(msk, optval, optlen);
-	case TCP_NODELAY:
-		return mptcp_setsockopt_sol_tcp_nodelay(msk, optval, optlen);
 	case TCP_DEFER_ACCEPT:
 		/* See tcp.c: TCP_DEFER_ACCEPT does not fail */
 		mptcp_setsockopt_first_sf_only(msk, SOL_TCP, optname, optval, optlen);
@@ -817,7 +785,30 @@ static int mptcp_setsockopt_sol_tcp(stru
 						      optval, optlen);
 	}
 
-	return -EOPNOTSUPP;
+	ret = mptcp_get_int_option(msk, optval, optlen, &val);
+	if (ret)
+		return ret;
+
+	lock_sock(sk);
+	switch (optname) {
+	case TCP_INQ:
+		if (val < 0 || val > 1)
+			ret = -EINVAL;
+		else
+			msk->recvmsg_inq = !!val;
+		break;
+	case TCP_CORK:
+		ret = __mptcp_setsockopt_sol_tcp_cork(msk, val);
+		break;
+	case TCP_NODELAY:
+		ret = __mptcp_setsockopt_sol_tcp_nodelay(msk, val);
+		break;
+	default:
+		ret = -ENOPROTOOPT;
+	}
+
+	release_sock(sk);
+	return ret;
 }
 
 int mptcp_setsockopt(struct sock *sk, int level, int optname,


