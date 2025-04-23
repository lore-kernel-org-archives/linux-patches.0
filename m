Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0151228A3F9;
	Wed, 23 Apr 2025 15:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422470; cv=none; b=J6Q+5MJw5oNNd7xnK0gYeUxWR+upJjMSNiPylpZyrReT/mcDvu+D0LZi+wsmzU9JJN7x1aoEkO/eLx9rfv0TPkZlEyBt3ReFgLlJb0hHWOZeXL0JbXjBNJK1lZy2e056vlhFikFK3XbZC6kke8mxJYDFKQ4MHXg3RUxIh3IToC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422470; c=relaxed/simple;
	bh=DE0u17QtPogXiPExhxqezUWmxhGEf8Ft0hlspoy1STA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCMjhuzL0cMFVrQOJKOd7Gg1QQYOjV/Kz7pbNlT4Vpn+oPBUDYYzVrT6yCpkymCygBCk5ApFruYoiaFTugZwKAlb1fhQld9Kb+AsGfNKZANSCSSIPtwYC6vPcovGxpMXq94GuIhvlkx9Kz+YPvBCTi1nqCwRXN6qCYf9+qGi7cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2bNqu8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2bNqu8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85873C4CEE2;
	Wed, 23 Apr 2025 15:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422469;
	bh=DE0u17QtPogXiPExhxqezUWmxhGEf8Ft0hlspoy1STA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2bNqu8ovyf0hESSXTa/77Jc2z9nHhB0Wc2tH/mv5YZQo5Mkp2BHcnkrkgtpEY/PO
	 Hb3io5/M5OJC5iezc/VpeFF6GiFENqPOMp0/50vO6nN1aADC1xCAd4sosbeuG9lOjH
	 eTlD+0yIZ3XtZGTm+SL+n7pxdx7LrgpbUpz0ESk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 363/393] mptcp: sockopt: fix getting freebind & transparent
Date: Wed, 23 Apr 2025 16:44:19 +0200
Message-ID: <20250423142658.332763031@linuxfoundation.org>
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

commit e2f4ac7bab2205d3c4dd9464e6ffd82502177c51 upstream.

When adding a socket option support in MPTCP, both the get and set parts
are supposed to be implemented.

IP(V6)_FREEBIND and IP(V6)_TRANSPARENT support for the setsockopt part
has been added a while ago, but it looks like the get part got
forgotten. It should have been present as a way to verify a setting has
been set as expected, and not to act differently from TCP or any other
socket types.

Everything was in place to expose it, just the last step was missing.
Only new code is added to cover these specific getsockopt(), that seems
safe.

Fixes: c9406a23c116 ("mptcp: sockopt: add SOL_IP freebind & transparent options")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250314-net-mptcp-fix-data-stream-corr-sockopt-v1-3-122dbb249db3@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflict in sockopt.c due to commit e08d0b3d1723 ("inet: implement
  lockless IP_TOS") not being in this version. The conflict is in the
  context and the modification can still be applied in
  mptcp_getsockopt_v4() after the IP_TOS case. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -1388,6 +1388,12 @@ static int mptcp_getsockopt_v4(struct mp
 	switch (optname) {
 	case IP_TOS:
 		return mptcp_put_int_option(msk, optval, optlen, inet_sk(sk)->tos);
+	case IP_FREEBIND:
+		return mptcp_put_int_option(msk, optval, optlen,
+				inet_test_bit(FREEBIND, sk));
+	case IP_TRANSPARENT:
+		return mptcp_put_int_option(msk, optval, optlen,
+				inet_test_bit(TRANSPARENT, sk));
 	}
 
 	return -EOPNOTSUPP;
@@ -1402,6 +1408,12 @@ static int mptcp_getsockopt_v6(struct mp
 	case IPV6_V6ONLY:
 		return mptcp_put_int_option(msk, optval, optlen,
 					    sk->sk_ipv6only);
+	case IPV6_TRANSPARENT:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    inet_test_bit(TRANSPARENT, sk));
+	case IPV6_FREEBIND:
+		return mptcp_put_int_option(msk, optval, optlen,
+					    inet_test_bit(FREEBIND, sk));
 	}
 
 	return -EOPNOTSUPP;


