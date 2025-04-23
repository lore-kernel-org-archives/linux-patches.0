Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C4A27F4D1;
	Wed, 23 Apr 2025 15:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421105; cv=none; b=cWBCDB47Ys4rkQsc1oMYpNLVPAeZSfLpgZrNLMl+ObtaQoYzucMj2PlctkDsMly1knlI0Y4wM/4HPmb6+fU59BNzgzrcLMY+Gj8atnX+k2TkQoVxlaieQooq8M0N2CwCFHModo/prKb45VpoS8tZj9T6MlcPhA3wHU+TAtyIXnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421105; c=relaxed/simple;
	bh=hz9Os8Ix1ivrN0xL3Yg7dy0SgWY22T+StdHNHgb/C0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pzm/2utAdy9kZU6m6BJroyY9HK5cMQxup/3ua4FJqoyt5su7oxjyG8s/HqFwWZzE+KXDeVvdWyEEXWMoJ0VXsZTsQhp3OHd0E+e+85+VNWXZ1kZVr3cb1B5zLEaE2KjWMTOuAp5tnpUpA6Kr+8SmOc9/madtTObfjXm9rzW9piM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6PNdmO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6PNdmO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB430C4CEE2;
	Wed, 23 Apr 2025 15:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421105;
	bh=hz9Os8Ix1ivrN0xL3Yg7dy0SgWY22T+StdHNHgb/C0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6PNdmO7jz678j57nYtIPsyy3+CiR+XhgrRWrgRchNQdBi4/3j5TZPKAgJzJUslld
	 oYWQanp3iy37K1u1u/QhDY9Z5X5be4mrJzeQhuu3Ay1LWwmnE4aKzjPkQx13FFg4Sr
	 fYVfFEtha8Ugy9ulK2898br/SHXJtJayJN2Yisz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 147/393] mptcp: sockopt: fix getting IPV6_V6ONLY
Date: Wed, 23 Apr 2025 16:40:43 +0200
Message-ID: <20250423142649.455843877@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -1393,6 +1393,20 @@ static int mptcp_getsockopt_v4(struct mp
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
 static int mptcp_getsockopt_sol_mptcp(struct mptcp_sock *msk, int optname,
 				      char __user *optval, int __user *optlen)
 {
@@ -1432,6 +1446,8 @@ int mptcp_getsockopt(struct sock *sk, in
 
 	if (level == SOL_IP)
 		return mptcp_getsockopt_v4(msk, optname, optval, option);
+	if (level == SOL_IPV6)
+		return mptcp_getsockopt_v6(msk, optname, optval, option);
 	if (level == SOL_TCP)
 		return mptcp_getsockopt_sol_tcp(msk, optname, optval, option);
 	if (level == SOL_MPTCP)


