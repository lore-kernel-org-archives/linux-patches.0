Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763543E49C8;
	Tue, 21 Jul 2026 17:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654221; cv=none; b=uDF3w3Qko0FSRQnjGpTaTKYnL3Xbkum0gfas0RuX1C7WMtDuz82dE/d6Cjoe2glQP5eud2AoKeI3XtoYddnjFC+xcp/9PqQ4kzX/Nhjz5DLhtf8T7uUWd65TpbjWpUIzNL5n+BsmheEiml2yJMeNvP9n97upIMaN2vXJczz/RyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654221; c=relaxed/simple;
	bh=nPPZAfhRW+5zUkhHUrp8zGDAD0bX+XK/dpoGFlPL5UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSi+xyb2rfu9yQfvJTQCATuw0i2cQ+8qpqNd98LROOMCYvdiYR9G3l1GW0ZzUTMGNYxU7MYAmljv3kBn/dJPXIQormzr5uRkbkE1bpAfgQzkzarg7/TX3BrlJxpgVczxC2HECebHqzmEsg3uzPz1D8C3ANFbG4w7B6DKwSlF/mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qE/9ksWU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qE/9ksWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC42A1F00A3E;
	Tue, 21 Jul 2026 17:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654219;
	bh=LgOfKiE9UhqzX+KSA4/5O591ZibCfJb+xiiGYodiV0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qE/9ksWUvYaP+a3qGN9nOUT7FB8rgOOx00ZdVqL1jffigNVrK7v1bTbco4Yh+WRYU
	 n6NA8fyj45gUvTWOYH0jQdkaI/icEfWIjexRCJM5oA1wWDH7HxXrK1xtmH5ynmwn20
	 SPo6z1LphxCNJT4+hMbtjkcwDuwEQR1WQ9ouDDsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Matthieu Buffet <matthieu@buffet.re>,
	Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.1 1623/2077] selinux: check connect-related permissions on TCP Fast Open
Date: Tue, 21 Jul 2026 17:21:36 +0200
Message-ID: <20260721152631.039981488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit 44c74d27d1b9aaa99fa8a83640c1223575262b80 upstream.

Similar to Landlock, SELinux was not updated when TCP Fast Open
support was introduced to ensure connect-related permissions are
checked when using TCP Fast Open. Update its socket_sendmsg() hook to
call selinux_socket_connect() when MSG_FASTOPEN is passed.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-security-module/20260616201615.275032-1-hexlabsecurity@proton.me/
Link: https://lore.kernel.org/linux-security-module/20260617180526.15627-2-matthieu@buffet.re/
Reported-by: Bryam Vargas <hexlabsecurity@proton.me>
Reported-by: Matthieu Buffet <matthieu@buffet.re>
Reported-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5266,7 +5266,24 @@ static int selinux_socket_accept(struct
 static int selinux_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 				  int size)
 {
-	return sock_has_perm(sock->sk, SOCKET__WRITE);
+	int rc;
+	struct sockaddr *const addr = msg->msg_name;
+	const int addrlen = msg->msg_namelen;
+
+	rc = sock_has_perm(sock->sk, SOCKET__WRITE);
+	if (rc)
+		return rc;
+
+	if (addr && (msg->msg_flags & MSG_FASTOPEN) &&
+	    (sk_is_tcp(sock->sk) ||
+	     (sk_is_inet(sock->sk) && sock->sk->sk_type == SOCK_STREAM &&
+	      sock->sk->sk_protocol == IPPROTO_MPTCP))) {
+		rc = selinux_socket_connect(sock, addr, addrlen);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
 }
 
 static int selinux_socket_recvmsg(struct socket *sock, struct msghdr *msg,


