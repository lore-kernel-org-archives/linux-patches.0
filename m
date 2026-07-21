Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12942BEFF5;
	Tue, 21 Jul 2026 20:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667105; cv=none; b=rJP+fV/ikXUSORdDZqar+X4ifR6lksqWZfh/3Ue0QZFZ7UVTHLtn8J6iA5/0Z6oKJW7JQarFZ+msErjjDLn5p8bwyDtz3GkOcu8yRZ/1UxQqZlA9uY2LZJc44tqn1rifnKpdJ3WtlJdJp++uBOHVoNXmItullBYAbTR9lUqVcqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667105; c=relaxed/simple;
	bh=Dg1obq0SMujcFj+5BPw4qUZ5MqZTNa+jlfERAK9bPsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ou4tOwmfpD16SfdCCsqp5FRNPbADeCcLbQAD2dOi7XCqbNpg8KPzID7Efet3qvVdGYk2nE55debFTYSjUkSlJWX+mQbjZVPhmwfVSmm6/EH8w4BgtisCsgWiGcRBOBGV8Zq6sH9kfE96SFxGQjrGgU+Y9Om3w/Ye5Z4Fn+LYaJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3Xnu5Kz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3Xnu5Kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028E61F000E9;
	Tue, 21 Jul 2026 20:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667104;
	bh=7JvhjTj406m2E6kARjeicSLY81f/d95b1TeJz3IoCu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3Xnu5KzIfiq4o3o9MKflQiCEGLTVly3qzePPbC+gHwFjkomQE/mVwnhyzldsVd8n
	 IjDs+iS98EdFxqaFR1XsamvLKjnxwTXhlzdLhkUr/ZV85/ZeXIfCrdzlFhajax5VV4
	 G6IjhMUU2a451xkBn7uAMzGQoOvLJHqVxomOQozs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Matthieu Buffet <matthieu@buffet.re>,
	Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 0936/1266] selinux: check connect-related permissions on TCP Fast Open
Date: Tue, 21 Jul 2026 17:22:53 +0200
Message-ID: <20260721152502.778948041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5047,7 +5047,24 @@ static int selinux_socket_accept(struct
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


