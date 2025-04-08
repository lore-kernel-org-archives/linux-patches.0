Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A152686BC;
	Tue,  8 Apr 2025 12:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114263; cv=none; b=t1EoJTyRrw2ysnk1Hn1nDHqALuGCa1juCGmSCnskjhjErT59i/MaMGxFdYs+lIcygtA2iQFDG4pDyesQ66AYUGKVuyUOYXzTK4B5OoefnwMPAZUnElxGQp9XVrEmx44XvEq0jyDXBgR1ViKIB4nUIl9xUhFETi6A4o15UMfC+Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114263; c=relaxed/simple;
	bh=zpiLYDrILTXHEX9QPxaKBZwydK/F3Tu48kl1cIc3Psc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZZK6bsW7Yv7y5MP6DFOQ/fvJv6TN6f8XKsqCB4RFkkuoy7FD7swLhvcMhlD0ivn/iV2cghvG/efdc3iemvdYIwCTgYH0NkRzFflZ9Z+nuiwq9j24HXjyiP1sL5bHfICHJ0GHNZttCL2xJfOJVNfYYHORU9j5Yba1J2pVpAPPaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2BO1x7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2BO1x7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD9EC4CEE5;
	Tue,  8 Apr 2025 12:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114263;
	bh=zpiLYDrILTXHEX9QPxaKBZwydK/F3Tu48kl1cIc3Psc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2BO1x7a6vVTGgFHEpznKirySROmWP2+mqCkm/gelEqfltXoV+rTZK2hlmWjItxjs
	 n3pdpOSm63CUgt9SIQ65DuswsvzB1L9v9eSUhEi3rH5Lte2NE6jLXIoEMB/kTI0edH
	 rEk0wECxu0vh3c4b7KQ0GyZfRFRHaMWNVUsHjQ5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 006/499] smack: dont compile ipv6 code unless ipv6 is configured
Date: Tue,  8 Apr 2025 12:43:38 +0200
Message-ID: <20250408104851.413859309@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit bfcf4004bcbce2cb674b4e8dbd31ce0891766bac ]

I want to be sure that ipv6-specific code
is not compiled in kernel binaries
if ipv6 is not configured.

[1] was getting rid of "unused variable" warning, but,
with that, it also mandated compilation of a handful ipv6-
specific functions in ipv4-only kernel configurations:

smk_ipv6_localhost, smack_ipv6host_label, smk_ipv6_check.

Their compiled bodies are likely to be removed by compiler
from the resulting binary, but, to be on the safe side,
I remove them from the compiler view.

[1]
Fixes: 00720f0e7f28 ("smack: avoid unused 'sip' variable warning")

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack.h     |  6 ++++++
 security/smack/smack_lsm.c | 10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index dbf8d7226eb56..1c3656b5e3b91 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -152,6 +152,7 @@ struct smk_net4addr {
 	struct smack_known	*smk_label;	/* label */
 };
 
+#if IS_ENABLED(CONFIG_IPV6)
 /*
  * An entry in the table identifying IPv6 hosts.
  */
@@ -162,7 +163,9 @@ struct smk_net6addr {
 	int			smk_masks;	/* mask size */
 	struct smack_known	*smk_label;	/* label */
 };
+#endif /* CONFIG_IPV6 */
 
+#ifdef SMACK_IPV6_PORT_LABELING
 /*
  * An entry in the table identifying ports.
  */
@@ -175,6 +178,7 @@ struct smk_port_label {
 	short			smk_sock_type;	/* Socket type */
 	short			smk_can_reuse;
 };
+#endif /* SMACK_IPV6_PORT_LABELING */
 
 struct smack_known_list_elem {
 	struct list_head	list;
@@ -314,7 +318,9 @@ extern struct smack_known smack_known_web;
 extern struct mutex	smack_known_lock;
 extern struct list_head smack_known_list;
 extern struct list_head smk_net4addr_list;
+#if IS_ENABLED(CONFIG_IPV6)
 extern struct list_head smk_net6addr_list;
+#endif /* CONFIG_IPV6 */
 
 extern struct mutex     smack_onlycap_lock;
 extern struct list_head smack_onlycap_list;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0c476282e2794..bc8f0d0b4c7cd 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2508,6 +2508,7 @@ static struct smack_known *smack_ipv4host_label(struct sockaddr_in *sip)
 	return NULL;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 /*
  * smk_ipv6_localhost - Check for local ipv6 host address
  * @sip: the address
@@ -2575,6 +2576,7 @@ static struct smack_known *smack_ipv6host_label(struct sockaddr_in6 *sip)
 
 	return NULL;
 }
+#endif /* CONFIG_IPV6 */
 
 /**
  * smack_netlbl_add - Set the secattr on a socket
@@ -2679,6 +2681,7 @@ static int smk_ipv4_check(struct sock *sk, struct sockaddr_in *sap)
 	return rc;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 /**
  * smk_ipv6_check - check Smack access
  * @subject: subject Smack label
@@ -2711,6 +2714,7 @@ static int smk_ipv6_check(struct smack_known *subject,
 	rc = smk_bu_note("IPv6 check", subject, object, MAY_WRITE, rc);
 	return rc;
 }
+#endif /* CONFIG_IPV6 */
 
 #ifdef SMACK_IPV6_PORT_LABELING
 /**
@@ -3043,7 +3047,9 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 		return 0;
 	if (addrlen < offsetofend(struct sockaddr, sa_family))
 		return 0;
-	if (IS_ENABLED(CONFIG_IPV6) && sap->sa_family == AF_INET6) {
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sap->sa_family == AF_INET6) {
 		struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;
 		struct smack_known *rsp = NULL;
 
@@ -3063,6 +3069,8 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 
 		return rc;
 	}
+#endif /* CONFIG_IPV6 */
+
 	if (sap->sa_family != AF_INET || addrlen < sizeof(struct sockaddr_in))
 		return 0;
 	rc = smk_ipv4_check(sock->sk, (struct sockaddr_in *)sap);
-- 
2.39.5



