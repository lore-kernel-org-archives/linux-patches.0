Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBC82E7379;
	Thu, 28 May 2026 20:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001079; cv=none; b=cPCE9ReVVUSpbJwIQxpbpdmCQDcKAehTHK96c/+6qF74NhCoCJN9H96uO1yG3d1ee09X0kwnI8msP7FyCnc6j+hVnE27uKU1sb62t2UFPV+nTkosXGQwJU9pQAXtUEkKwcD2jHewRT31SjYqUGsOic8gIN5xGiqVpCSGrNXZeLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001079; c=relaxed/simple;
	bh=S/XlP6jlJ6R3S/2R5DEmlkEhtYYlYNxLmA71BJU2wOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hMkFdSdb3RUzh3z2ZmXxCMV3YudyktCwGk5270qTwf/mG9uXnUA1hf2hwEJWZ9Lz2dCWdM+M8I8jEv4B70rGYHzDv7Rm3KoptBA49CyMRFn1c6iJ2NQfnPCme70qqFOjTndGZKLu7J7sG0caTduxMiULFrtkfOIFt0EIBlncfHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We8eWslc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We8eWslc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD14B1F000E9;
	Thu, 28 May 2026 20:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001078;
	bh=Nxxh4D8vjmSWu3okW0LPhvLFpN8SbceM/Pnp6dT/wSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=We8eWslcBg8WHvwu+Kq4SEdikIg8/8Jsk+Xxp8YHdbhSsbPT9gUr/ehexR/74gvMm
	 ZhRC/6vfhHniBx5SenxzRXKwXpkfw57R/317gzh6rlhnImlRI3O6ywQB4JO+Y7Ljiz
	 Z912C1tjYZoc6QkVnM2hc9EmhOMTuDapeSImLSWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Maximilian Heyne <mheyne@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 272/272] landlock: Fix TCP handling of short AF_UNSPEC addresses
Date: Thu, 28 May 2026 21:50:46 +0200
Message-ID: <20260528194636.686963779@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Buffet <matthieu@buffet.re>

[ Upstream commit e4d82cbce2258f454634307fdabf33aa46b61ab0 ]

current_check_access_socket() treats AF_UNSPEC addresses as
AF_INET ones, and only later adds special case handling to
allow connect(AF_UNSPEC), and on IPv4 sockets
bind(AF_UNSPEC+INADDR_ANY).
This would be fine except AF_UNSPEC addresses can be as
short as a bare AF_UNSPEC sa_family_t field, and nothing
more. The AF_INET code path incorrectly enforces a length of
sizeof(struct sockaddr_in) instead.

Move AF_UNSPEC edge case handling up inside the switch-case,
before the address is (potentially incorrectly) treated as
AF_INET.

Fixes: fff69fb03dde ("landlock: Support network rules with TCP bind and connect")
Signed-off-by: Matthieu Buffet <matthieu@buffet.re>
Link: https://lore.kernel.org/r/20251027190726.626244-4-matthieu@buffet.re
Signed-off-by: Mickaël Salaün <mic@digikod.net>
[ There was a conflict due to missing commit 9f74411a40ce ("landlock:
  Log TCP bind and connect denials") ]
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/net.c | 118 +++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 51 deletions(-)

diff --git a/security/landlock/net.c b/security/landlock/net.c
index 104b6c01fe503..53d479893475f 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -72,6 +72,61 @@ static int current_check_access_socket(struct socket *const sock,
 
 	switch (address->sa_family) {
 	case AF_UNSPEC:
+		if (access_request == LANDLOCK_ACCESS_NET_CONNECT_TCP) {
+			/*
+			 * Connecting to an address with AF_UNSPEC dissolves
+			 * the TCP association, which have the same effect as
+			 * closing the connection while retaining the socket
+			 * object (i.e., the file descriptor).  As for dropping
+			 * privileges, closing connections is always allowed.
+			 *
+			 * For a TCP access control system, this request is
+			 * legitimate. Let the network stack handle potential
+			 * inconsistencies and return -EINVAL if needed.
+			 */
+			return 0;
+		} else if (access_request == LANDLOCK_ACCESS_NET_BIND_TCP) {
+			/*
+			 * Binding to an AF_UNSPEC address is treated
+			 * differently by IPv4 and IPv6 sockets. The socket's
+			 * family may change under our feet due to
+			 * setsockopt(IPV6_ADDRFORM), but that's ok: we either
+			 * reject entirely or require
+			 * %LANDLOCK_ACCESS_NET_BIND_TCP for the given port, so
+			 * it cannot be used to bypass the policy.
+			 *
+			 * IPv4 sockets map AF_UNSPEC to AF_INET for
+			 * retrocompatibility for bind accesses, only if the
+			 * address is INADDR_ANY (cf. __inet_bind). IPv6
+			 * sockets always reject it.
+			 *
+			 * Checking the address is required to not wrongfully
+			 * return -EACCES instead of -EAFNOSUPPORT or -EINVAL.
+			 * We could return 0 and let the network stack handle
+			 * these checks, but it is safer to return a proper
+			 * error and test consistency thanks to kselftest.
+			 */
+			if (sock->sk->__sk_common.skc_family == AF_INET) {
+				const struct sockaddr_in *const sockaddr =
+					(struct sockaddr_in *)address;
+
+				if (addrlen < sizeof(struct sockaddr_in))
+					return -EINVAL;
+
+				if (sockaddr->sin_addr.s_addr !=
+				    htonl(INADDR_ANY))
+					return -EAFNOSUPPORT;
+			} else {
+				if (addrlen < SIN6_LEN_RFC2133)
+					return -EINVAL;
+				else
+					return -EAFNOSUPPORT;
+			}
+		} else {
+			WARN_ON_ONCE(1);
+		}
+		/* Only for bind(AF_UNSPEC+INADDR_ANY) on IPv4 socket. */
+		fallthrough;
 	case AF_INET:
 		if (addrlen < sizeof(struct sockaddr_in))
 			return -EINVAL;
@@ -90,57 +145,18 @@ static int current_check_access_socket(struct socket *const sock,
 		return 0;
 	}
 
-	/* Specific AF_UNSPEC handling. */
-	if (address->sa_family == AF_UNSPEC) {
-		/*
-		 * Connecting to an address with AF_UNSPEC dissolves the TCP
-		 * association, which have the same effect as closing the
-		 * connection while retaining the socket object (i.e., the file
-		 * descriptor).  As for dropping privileges, closing
-		 * connections is always allowed.
-		 *
-		 * For a TCP access control system, this request is legitimate.
-		 * Let the network stack handle potential inconsistencies and
-		 * return -EINVAL if needed.
-		 */
-		if (access_request == LANDLOCK_ACCESS_NET_CONNECT_TCP)
-			return 0;
-
-		/*
-		 * For compatibility reason, accept AF_UNSPEC for bind
-		 * accesses (mapped to AF_INET) only if the address is
-		 * INADDR_ANY (cf. __inet_bind).  Checking the address is
-		 * required to not wrongfully return -EACCES instead of
-		 * -EAFNOSUPPORT.
-		 *
-		 * We could return 0 and let the network stack handle these
-		 * checks, but it is safer to return a proper error and test
-		 * consistency thanks to kselftest.
-		 */
-		if (access_request == LANDLOCK_ACCESS_NET_BIND_TCP) {
-			/* addrlen has already been checked for AF_UNSPEC. */
-			const struct sockaddr_in *const sockaddr =
-				(struct sockaddr_in *)address;
-
-			if (sock->sk->__sk_common.skc_family != AF_INET)
-				return -EINVAL;
-
-			if (sockaddr->sin_addr.s_addr != htonl(INADDR_ANY))
-				return -EAFNOSUPPORT;
-		}
-	} else {
-		/*
-		 * Checks sa_family consistency to not wrongfully return
-		 * -EACCES instead of -EINVAL.  Valid sa_family changes are
-		 * only (from AF_INET or AF_INET6) to AF_UNSPEC.
-		 *
-		 * We could return 0 and let the network stack handle this
-		 * check, but it is safer to return a proper error and test
-		 * consistency thanks to kselftest.
-		 */
-		if (address->sa_family != sock->sk->__sk_common.skc_family)
-			return -EINVAL;
-	}
+	/*
+	 * Checks sa_family consistency to not wrongfully return
+	 * -EACCES instead of -EINVAL.  Valid sa_family changes are
+	 * only (from AF_INET or AF_INET6) to AF_UNSPEC.
+	 *
+	 * We could return 0 and let the network stack handle this
+	 * check, but it is safer to return a proper error and test
+	 * consistency thanks to kselftest.
+	 */
+	if (address->sa_family != sock->sk->__sk_common.skc_family &&
+	    address->sa_family != AF_UNSPEC)
+		return -EINVAL;
 
 	id.key.data = (__force uintptr_t)port;
 	BUILD_BUG_ON(sizeof(port) > sizeof(id.key.data));
-- 
2.53.0



