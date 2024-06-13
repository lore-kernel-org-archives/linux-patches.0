Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BFC5384;
	Thu, 13 Jun 2024 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282840; cv=none; b=Q7DuRwDMe3dVq/luE7PjxE386CbVcKm/pmgZIB/4eLJJzbjrYXm01uqO2TCBW4ScfgbqCuGOb5uOQWJFdp4QcMF+GdTDMM29E8ZdYLSUDIAg8MieFhdStKwN3g+ktp2FxvV96dmRml+usovNZyzH6IDJTPbm7C1zDW0yqh6AGrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282840; c=relaxed/simple;
	bh=kfjM9SuUpcjv7ejWD2Rwa2m+R9BFI6ysxqR1ENx6jqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWq6YrILy3noFwdzqb/5+BvhBM6m3TWk6TpFpL/z4o4+v72z5SLV1VA8YxTQCliekfqraELh5hNd/9EeoOuTBJ2/zrntbjA+VHTz08wP7iVKo2cwC5U0MIuIVI859TJwQEyNmxbwD9DXe8nC9KSJyjTKr5NYjnLQdcDzci8J6BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KygRqIOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KygRqIOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A00C2BBFC;
	Thu, 13 Jun 2024 12:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282840;
	bh=kfjM9SuUpcjv7ejWD2Rwa2m+R9BFI6ysxqR1ENx6jqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KygRqIOtLloVY1V0uQkMD/f1t0+BuVYFW0tRtFcVgrSdpMBnbVHAKk2wRdDZfYUHM
	 6wBNE2vPUDz1ngihddqdm4SrqKwgeylNheLQUq8JS8B1MDNYCa7CIowgg/XzszxXXO
	 clCbWAjiDc1HBwgVUzXvJwTt/bHRILLb3k5iTGH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 11/85] mptcp: avoid some duplicate code in socket option handling
Date: Thu, 13 Jun 2024 13:35:09 +0200
Message-ID: <20240613113214.575635027@linuxfoundation.org>
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

commit a74762675f700a5473ebe54a671a0788a5b23cc9 upstream.

The mptcp_get_int_option() helper is needless open-coded in a
couple of places, replace the duplicate code with the helper
call.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bd11dc4fb969 ("mptcp: fix full TCP keep-alive support")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -621,13 +621,11 @@ static int mptcp_setsockopt_sol_tcp_cork
 {
 	struct mptcp_subflow_context *subflow;
 	struct sock *sk = (struct sock *)msk;
-	int val;
+	int val, ret;
 
-	if (optlen < sizeof(int))
-		return -EINVAL;
-
-	if (copy_from_sockptr(&val, optval, sizeof(val)))
-		return -EFAULT;
+	ret = mptcp_get_int_option(msk, optval, optlen, &val);
+	if (ret)
+		return ret;
 
 	lock_sock(sk);
 	sockopt_seq_inc(msk);
@@ -651,13 +649,11 @@ static int mptcp_setsockopt_sol_tcp_node
 {
 	struct mptcp_subflow_context *subflow;
 	struct sock *sk = (struct sock *)msk;
-	int val;
-
-	if (optlen < sizeof(int))
-		return -EINVAL;
+	int val, ret;
 
-	if (copy_from_sockptr(&val, optval, sizeof(val)))
-		return -EFAULT;
+	ret = mptcp_get_int_option(msk, optval, optlen, &val);
+	if (ret)
+		return ret;
 
 	lock_sock(sk);
 	sockopt_seq_inc(msk);


