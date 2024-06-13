Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A613384;
	Thu, 13 Jun 2024 12:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282843; cv=none; b=QOi5XdZH9/1Dmq1txGV/7aps828Hqfp3J6XdGEX6mlCkg0W5pvvMIXRDTeDblbayxv3c5dBldCfAK3tp3QNLLhLZ4JMI0n4+Edm5S/xwBmfsp9KROo+CcwyrvfIjDsWLPQEeASwuchRRd0aQek68KpSvb889lnugWyjcq5lDalY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282843; c=relaxed/simple;
	bh=IHgNvbGrug/nbvAGgFke6A5CyFAZsfyVN8PeAgDd83o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nM9INLTeYdydtT38EI+c4oq8SpdFHhOHop5sGLscO+rv2xDsB/bvTj91iMxolr9CjJEQDhVFENV+afdso7/msoNHh1lP4JEkeD35Y7cdNxFHpOxub76wvX/TcTYbEMb8qpchkXQByUGoj6jramdy34zaC1Pov3nZUtptnuPT3Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/GTc3Tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/GTc3Tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55CAC2BBFC;
	Thu, 13 Jun 2024 12:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282843;
	bh=IHgNvbGrug/nbvAGgFke6A5CyFAZsfyVN8PeAgDd83o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/GTc3Tlc5c3opw5ZVgJu8OWFdyWJPBKzKchXs/B8kY6cDunzs8uHP0KaShSPTbdw
	 y60q3Jv15qZyWYKUG5wFQSW69s8exSUrK/PhGNkqsJTx1GAY20QxxCt26F0GkGwh/q
	 RhX50eIImK9uwSoHv/mnCo69UXclSFoLRp17fLgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 12/85] mptcp: cleanup SOL_TCP handling
Date: Thu, 13 Jun 2024 13:35:10 +0200
Message-ID: <20240613113214.615386427@linuxfoundation.org>
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
@@ -616,18 +616,11 @@ static int mptcp_setsockopt_sol_tcp_cong
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
@@ -639,23 +632,15 @@ static int mptcp_setsockopt_sol_tcp_cork
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
@@ -667,8 +652,6 @@ static int mptcp_setsockopt_sol_tcp_node
 	}
 	if (val)
 		mptcp_check_and_set_pending(sk);
-	release_sock(sk);
-
 	return 0;
 }
 
@@ -793,25 +776,10 @@ static int mptcp_setsockopt_sol_tcp(stru
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
 		return mptcp_setsockopt_sol_tcp_defer(msk, optval, optlen);
 	case TCP_FASTOPEN_CONNECT:
@@ -819,7 +787,30 @@ static int mptcp_setsockopt_sol_tcp(stru
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


