Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7843A7836;
	Wed, 21 Jan 2026 18:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020159; cv=none; b=tixoB36Mogu0yNLUxny+bC4EQPXOycX8XAE5xkdOvvqif1yIEZjhyEkgWkvyIXospQyTFtNSAvfJ5TiHsdGB+8xMv/xoWh7Tj2EA7LemjgX5rzuCZVKANlseQuNcU8Pj8VMQApkzEmnpQnLl0K224BhS4s2LcChTOuX0cKbK64M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020159; c=relaxed/simple;
	bh=AJ/EspyCfJJDf7pXNXpdCM0CtDryGwKkStbY2hWX050=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cP/RLAPk06I9eW59ziFOMwbUYhNWRAbvrkVV0UyNNgwE0ExDorRz68D0I24STRe/dbVoHhDyt2WBfdbOiF7j0mUMhKa8hcWNKCt00j9fQnP3j1BWB2vnKYjwKAfzTQhDo/0PZ+KdXcfXdKqaAltnNFzGNrQLYkEMktATDQ7PnEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCbIwW5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCbIwW5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B01DC4CEF1;
	Wed, 21 Jan 2026 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020158;
	bh=AJ/EspyCfJJDf7pXNXpdCM0CtDryGwKkStbY2hWX050=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCbIwW5E0f/1sX/dJjlNQJy6Dei2SitV+gPefzn2fFXbooTdvvQ8lG3WBgFFoqw4k
	 5GnqzFYreL8gxmL0Mv0kU4vSqkzr0ilziXlCHR1wa3qMdFjAPTwRPiyZN2xi+DVZkW
	 gvpZTNy9kt4wRjKnezy+SB/GyTgBNcl5HFiG7ttI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Buffet <matthieu@buffet.re>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/198] landlock: Fix TCP handling of short AF_UNSPEC addresses
Date: Wed, 21 Jan 2026 19:15:05 +0100
Message-ID: <20260121181421.332562395@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/net.c | 118 +++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 51 deletions(-)

diff --git a/security/landlock/net.c b/security/landlock/net.c
index 1f3915a90a808..e6367e30e5b0e 100644
--- a/security/landlock/net.c
+++ b/security/landlock/net.c
@@ -71,6 +71,61 @@ static int current_check_access_socket(struct socket *const sock,
 
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
 	case AF_INET: {
 		const struct sockaddr_in *addr4;
 
@@ -119,57 +174,18 @@ static int current_check_access_socket(struct socket *const sock,
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
2.51.0



