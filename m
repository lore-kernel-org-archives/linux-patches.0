Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E857221DA7;
	Tue, 29 Apr 2025 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949049; cv=none; b=pvxrE56trt741mz3aICnARFtRmaTYefLvXHPrNL6yqe8rHFK3qvp4Qq1U/oSbrrrH9ALaLpyWY1VEOmPzdZd3ietJJ2JZkaWORu/u8fmspYzQLKxePY4tGuvcUDLXRvDXm1xwZkt4FUQ1S3QRx2L8aYZfdbPJjJhIs/F9l1Quqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949049; c=relaxed/simple;
	bh=AjhRstLQ3bkyH6Mo+TSRnoxLMEqgj2Sjxhx1UgcOpzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEOtu6mgF4DhttxzmaivSrPDTMjOLSka7Wb//BfIrFiU7mJyDZ8GdBHq5dfTkAGyzWoJhYU9+EffbazR0p41cDGP4ipof/KLOzx7RKHKHrWS9WbQHl3ys9XihNYgwLkchxglCe3ypFm1G/65+OE0xE7jaNJt2lib/KsY85ZL+Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmZ1WwzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmZ1WwzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B00C4CEE3;
	Tue, 29 Apr 2025 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949049;
	bh=AjhRstLQ3bkyH6Mo+TSRnoxLMEqgj2Sjxhx1UgcOpzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmZ1WwzWrLy5m2Vyips50Sa+Dc0YuAHO6c5utio0uDZo9Vqb8ZcnzB/pUs79yacQY
	 Z4fdK/vTkz8uKOH47PImPOrr5WIxvjDI20jZ1+hYr94e8IPGup8tgK9sbHvthEdr+O
	 XNfy1KMgAL8JacmzC/3VbKGNbazDfxLlGX6hFPTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 199/373] mptcp: sockopt: fix getting IPV6_V6ONLY
Date: Tue, 29 Apr 2025 18:41:16 +0200
Message-ID: <20250429161131.354131679@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 8c39633759885b6ff85f6d96cf445560e74df5e8 upstream.

When adding a socket option support in MPTCP, both the get and set parts
are supposed to be implemented.

IPV6_V6ONLY support for the setsockopt part has been added a while ago,
but it looks like the get part got forgotten. It should have been
present as a way to verify a setting has been set as expected, and not
to act differently from TCP or any other socket types.

Not supporting this getsockopt(IPV6_V6ONLY) blocks some apps which want
to check the default value, before doing extra actions. On Linux, the
default value is 0, but this can be changed with the net.ipv6.bindv6only
sysctl knob. On Windows, it is set to 1 by default. So supporting the
get part, like for all other socket options, is important.

Everything was in place to expose it, just the last step was missing.
Only new code is added to cover this specific getsockopt(), that seems
safe.

Fixes: c9b95a135987 ("mptcp: support IPV6_V6ONLY setsockopt")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/550
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250314-net-mptcp-fix-data-stream-corr-sockopt-v1-2-122dbb249db3@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in sockopt.c in the context, because commit 3b1e21eb60e8
  ("mptcp: getsockopt: add support for IP_TOS") is not in this release.
  The conflicts are in the context, the new helper can be added without
  issue. It depends on mptcp_put_int_option() which has been added via
  another backport, see commit 874aae15fbef ("mptcp: fix full TCP
  keep-alive support"). ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -793,6 +793,20 @@ static int mptcp_getsockopt_sol_tcp(stru
 	return -EOPNOTSUPP;
 }
 
+static int mptcp_getsockopt_v6(struct mptcp_sock *msk, int optname,
+			       char __user *optval, int __user *optlen)
+{
+	struct sock *sk = (void *)msk;
+
+	switch (optname) {
+	case IPV6_V6ONLY:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    sk->sk_ipv6only);
+	}
+
+	return -EOPNOTSUPP;
+}
+
 int mptcp_getsockopt(struct sock *sk, int level, int optname,
 		     char __user *optval, int __user *option)
 {
@@ -813,6 +827,8 @@ int mptcp_getsockopt(struct sock *sk, in
 	if (ssk)
 		return tcp_getsockopt(ssk, level, optname, optval, option);
 
+	if (level == SOL_IPV6)
+		return mptcp_getsockopt_v6(msk, optname, optval, option);
 	if (level == SOL_TCP)
 		return mptcp_getsockopt_sol_tcp(msk, optname, optval, option);
 	return -EOPNOTSUPP;


