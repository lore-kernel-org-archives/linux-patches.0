Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E888626982F;
	Tue,  8 Apr 2025 12:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115592; cv=none; b=a5i2Py89jzxpHu46B7T4sJ64c6ppvKFz0b2V+Wf9Ps6jUAMoCia9g95+6tgbU7vBKwHv9J3rFYKXJtBy9HBXxJy8h6rBUq7MSB4BPTO+rrPlVyXeX+/Cfh0EbJ6H+UCyWEel5/HqJBNqNx4sSRqGLCO5MTKbERW6Ht2DwqaBF4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115592; c=relaxed/simple;
	bh=xH6Vn5uHBdfPHrnkDUuJKMW1yFRYLd4XLW5JQAiRWoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=swmqdXvjD1ZItmC/ZG84b6ykY8BYNV/559fW07yFG80Er4sjHgQabVOsfplgrHC+kTG66DLgXRxjhqg4cF7rOv6jK9Uo3FgUF56wv7VEOg/HXowTmiTWkS07Ws7OXkS9qexliGfT5fDFUh7v7osGP+GDwT0p3Ey5KjnYvPorgMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlgGCDvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlgGCDvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5DFC4CEE5;
	Tue,  8 Apr 2025 12:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115591;
	bh=xH6Vn5uHBdfPHrnkDUuJKMW1yFRYLd4XLW5JQAiRWoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlgGCDvq52oXckSzp/3grQat6slaO5bnfXpu3O3XMXqSu6YxRmsL06h+/581IfPTo
	 65HFuvSiU40SdGI+NHEE5alODNMK1F7/nDVbz8iWLplJE6TPi0+iH1AS8joywb561a
	 dhQnYBcS3U3/gJjS120O6GZo5hbIvoYkpgTfEAEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/204] smack: dont compile ipv6 code unless ipv6 is configured
Date: Tue,  8 Apr 2025 12:48:54 +0200
Message-ID: <20250408104820.411913754@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aa15ff56ed6e7..eb22090f3bb85 100644
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
index 25995df15e82d..285103ffc75c6 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2405,6 +2405,7 @@ static struct smack_known *smack_ipv4host_label(struct sockaddr_in *sip)
 	return NULL;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 /*
  * smk_ipv6_localhost - Check for local ipv6 host address
  * @sip: the address
@@ -2472,6 +2473,7 @@ static struct smack_known *smack_ipv6host_label(struct sockaddr_in6 *sip)
 
 	return NULL;
 }
+#endif /* CONFIG_IPV6 */
 
 /**
  * smack_netlbl_add - Set the secattr on a socket
@@ -2575,6 +2577,7 @@ static int smk_ipv4_check(struct sock *sk, struct sockaddr_in *sap)
 	return rc;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 /**
  * smk_ipv6_check - check Smack access
  * @subject: subject Smack label
@@ -2607,6 +2610,7 @@ static int smk_ipv6_check(struct smack_known *subject,
 	rc = smk_bu_note("IPv6 check", subject, object, MAY_WRITE, rc);
 	return rc;
 }
+#endif /* CONFIG_IPV6 */
 
 #ifdef SMACK_IPV6_PORT_LABELING
 /**
@@ -2939,7 +2943,9 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 		return 0;
 	if (addrlen < offsetofend(struct sockaddr, sa_family))
 		return 0;
-	if (IS_ENABLED(CONFIG_IPV6) && sap->sa_family == AF_INET6) {
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sap->sa_family == AF_INET6) {
 		struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;
 		struct smack_known *rsp = NULL;
 
@@ -2959,6 +2965,8 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 
 		return rc;
 	}
+#endif /* CONFIG_IPV6 */
+
 	if (sap->sa_family != AF_INET || addrlen < sizeof(struct sockaddr_in))
 		return 0;
 	rc = smk_ipv4_check(sock->sk, (struct sockaddr_in *)sap);
-- 
2.39.5



