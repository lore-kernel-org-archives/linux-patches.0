Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A3643D4E2;
	Tue, 21 Jul 2026 21:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669966; cv=none; b=Ls17FhCbbdczsyUPQQFAHuwR5FA0tvZsulUXW1h6tFiRkdjMgdEJn+1FFew7Q4MCxHhUbqk23Ua+PoJ6+8o/614MDto/SENJ0IA2Y5QeiudUc7zKd9Jl7g9l8agx8VMHSpnyvHYOFDT591Lw49uH2SlbXWCcs8DMrrap6B7WH5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669966; c=relaxed/simple;
	bh=nRjkjT4rrXHKowR9NIAanHgaTabbMn0L2bEOW9bP6Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgqhTn/RFFfi6vQznP+grhkWH7LSViydV0pHw9dj14mfLgJISJOS5o5oA7CUDiYkj4+JzRT1thZwWAOlBS03bEWLe85uhrzoXDfmFa1JH6XsYyWyB8ruk2flSZxycm7IaEaRggbaunEgvxKXVPJ2monHQhJyLBIFsJxelDf3+ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C4o5sUHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C4o5sUHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE5C1F000E9;
	Tue, 21 Jul 2026 21:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669965;
	bh=WgjtEaxFVRuuWwACFA1LKJ/nZNllnH/ZR95sttcabJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4o5sUHNhnWNinrUBgL7s0xRr2O5Zh8g2TcF/pTjgESH92ddwAgMRG0utkEn5OV8v
	 oUmQoyGtOj8NuY/M3+ktW4Psgd1mauypAspVw0CXp5AAVzHy+FJQ+fm6mKZRFzZzY3
	 tkL390qJZ1ZDmcY4qOcsGyqOvXmXSJPFuGQ00USQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Matthieu Buffet <matthieu@buffet.re>,
	Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.1 0755/1067] selinux: check connect-related permissions on TCP Fast Open
Date: Tue, 21 Jul 2026 17:22:36 +0200
Message-ID: <20260721152441.463083097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4957,7 +4957,24 @@ static int selinux_socket_accept(struct
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


