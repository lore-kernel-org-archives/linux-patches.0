Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DAB2512C6;
	Tue, 29 Apr 2025 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947033; cv=none; b=KSW3m0Os18T2boqcLbS15TfbrAbq5uphwbhIv/AoP9/LtdVokticSZV8W6SUfKJTPVFKj9gOds0zH0J2urytb6LpJwyXQveVM1ubaTHRSZjTSswH3PXEy30JmOhfv2GIk+LbdiHr8cQkDBsLlGzqoMambLWenFeko+djyT7x6x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947033; c=relaxed/simple;
	bh=mg0BXOGZgwtarsCWyWmMKNCxBfUPAu10+QedH787ZX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPDsgxIYV0ggLgeuAOk3W+k7Q5dtfslhPDyqWbUN4c9hLO2SwXZjcGTjCgsBBk1YhR7wap8hod6eM/kZ7tdKlYdfyQQRQuA7Kllk6HkdHaqcBoNsbZKy5GJBtw280UX60YEOLN0P9ouwhds1o7rcBBvgFjdmTYI2OYdxaoOoUNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luPqats5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luPqats5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECDDC4CEE3;
	Tue, 29 Apr 2025 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947033;
	bh=mg0BXOGZgwtarsCWyWmMKNCxBfUPAu10+QedH787ZX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luPqats5yhqtGcTOiKbJ839iid7Y6VPC5SMIp/jO5+jCgCCtQwKuhShFkswme0xSD
	 /fnAfwX19e1gL9nw3MDaewmTkrRy1nMFOK+gAU8K52A/ufJRYS+Os0K5NZ4KkI7sJs
	 YOcyA6ZyVVs0TAobNGl06Mm6EcZLSr04QEMQLctA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 149/286] mptcp: sockopt: fix getting IPV6_V6ONLY
Date: Tue, 29 Apr 2025 18:40:53 +0200
Message-ID: <20250429161114.014921161@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Conflicts in sockopt.c in the context, because commit 0abdde82b163
  ("mptcp: move sockopt function into a new file") is not in this
  release. The modifications can still be done in protocol.c without
  difficulties. A particularity is that the mptcp_put_int_option()
  helper is required, and imported from newer versions without taking
  the extra features introduced with them in commit 2c9e77659a0c
  ("mptcp: add TCP_INQ cmsg support") and commit 3b1e21eb60e8 ("mptcp:
  getsockopt: add support for IP_TOS"). ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2395,6 +2395,49 @@ static int mptcp_setsockopt(struct sock
 	return -EOPNOTSUPP;
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
 static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 			    char __user *optval, int __user *option)
 {
@@ -2415,6 +2458,8 @@ static int mptcp_getsockopt(struct sock
 	if (ssk)
 		return tcp_getsockopt(ssk, level, optname, optval, option);
 
+	if (level == SOL_IPV6)
+		return mptcp_getsockopt_v6(msk, optname, optval, option);
 	return -EOPNOTSUPP;
 }
 


