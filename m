Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663AC403E9B;
	Tue, 21 Jul 2026 18:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658538; cv=none; b=mGYHVAEy2nrRIUloBIVhwUOFPQjiemmyt0C+7v+z26chdHbpfKTVOMuk7nRipI7mr0WnGAPJXtEIoDC9Tj2pHUg1YHf3H28nItkbhajgL/GOrp7bGUuo2/5caXbObq+SeaPqFQPE9pK8L2BRji5WKiU4GYgOHEO80uZovN124n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658538; c=relaxed/simple;
	bh=U+CXMSpqjnRekjuhLjBmbxYgDnR6N71Ndz4RLM9lDrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTtir8Y3AJ8z4bHtsG+bGtQu3Fr/VILuDR8hq4BAemQfB8+wq0yK7IemcwRrYMrcFklrI+fyLMNxabCWvjMu3RaOnvIxAfWduHCEbSTBSvt7y+C1TIjKhKWKI1FlNUrA3Mwco/+oFM6EFoHsXygiOCPcBKARApzsHytGwGpmb6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pSvczzcn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pSvczzcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64B91F000E9;
	Tue, 21 Jul 2026 18:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658537;
	bh=WOKxnKltT+h32DNVIpWBCxYRx6hGN8mRitLG5e0Chvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSvczzcnKytrspXDk3eh97qqmJet2LJ3n/5jxv/XcspK/TDjP7rISXCmihwHDPqwD
	 p2bZnkute/oFnKoX7mV8fcFg7KZxvnAVRjsIBzbHES7CTrZ3eUNFdHJl9Zx0SI2Zs+
	 LwHEHOq9BMeGOxXY+lOVUJBGZm2IEn0fcOOFxDMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Tristan Madani <tristan@talencesecurity.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.18 1181/1611] selinux: avoid sk_socket dereference in selinux_sctp_bind_connect()
Date: Tue, 21 Jul 2026 17:21:37 +0200
Message-ID: <20260721152541.997079868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

commit 56acfeb10019e200ab6787d01f8d7cbe0f01526f upstream.

selinux_sctp_bind_connect() dereferences sk->sk_socket to pass a
struct socket * to selinux_socket_bind() and
selinux_socket_connect_helper().  However, when the hook is invoked
from the ASCONF softirq path (sctp_process_asconf), there is no file
reference guaranteeing that sk->sk_socket is non-NULL.  The setsockopt
callers (bindx, connectx, set_primary, sendmsg connect) hold a file
reference and are not affected.

Both selinux_socket_bind() and selinux_socket_connect_helper()
immediately resolve sock->sk, never using the struct socket * for
anything else.  Refactor the inner logic into helpers that take a
struct sock * directly so that selinux_sctp_bind_connect() never needs
to touch sk->sk_socket at all.

Cc: stable@vger.kernel.org
Fixes: d452930fd3b9 ("selinux: Add SCTP support")
Suggested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4974,9 +4974,8 @@ static int selinux_socket_socketpair(str
    Need to determine whether we should perform a name_bind
    permission check between the socket and the port number. */
 
-static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen)
+static int __selinux_socket_bind(struct sock *sk, struct sockaddr *address, int addrlen)
 {
-	struct sock *sk = sock->sk;
 	struct sk_security_struct *sksec = selinux_sock(sk);
 	u16 family;
 	int err;
@@ -5106,13 +5105,17 @@ err_af:
 	return -EAFNOSUPPORT;
 }
 
+static int selinux_socket_bind(struct socket *sock, struct sockaddr *address, int addrlen)
+{
+	return __selinux_socket_bind(sock->sk, address, addrlen);
+}
+
 /* This supports connect(2) and SCTP connect services such as sctp_connectx(3)
  * and sctp_sendmsg(3) as described in Documentation/security/SCTP.rst
  */
-static int selinux_socket_connect_helper(struct socket *sock,
+static int selinux_socket_connect_helper(struct sock *sk,
 					 struct sockaddr *address, int addrlen)
 {
-	struct sock *sk = sock->sk;
 	struct sk_security_struct *sksec = selinux_sock(sk);
 	int err;
 
@@ -5201,7 +5204,7 @@ static int selinux_socket_connect(struct
 	int err;
 	struct sock *sk = sock->sk;
 
-	err = selinux_socket_connect_helper(sock, address, addrlen);
+	err = selinux_socket_connect_helper(sk, address, addrlen);
 	if (err)
 		return err;
 
@@ -5703,13 +5706,11 @@ static int selinux_sctp_bind_connect(str
 	int len, err = 0, walk_size = 0;
 	void *addr_buf;
 	struct sockaddr *addr;
-	struct socket *sock;
 
 	if (!selinux_policycap_extsockclass())
 		return 0;
 
 	/* Process one or more addresses that may be IPv4 or IPv6 */
-	sock = sk->sk_socket;
 	addr_buf = address;
 
 	while (walk_size < addrlen) {
@@ -5738,14 +5739,14 @@ static int selinux_sctp_bind_connect(str
 		case SCTP_PRIMARY_ADDR:
 		case SCTP_SET_PEER_PRIMARY_ADDR:
 		case SCTP_SOCKOPT_BINDX_ADD:
-			err = selinux_socket_bind(sock, addr, len);
+			err = __selinux_socket_bind(sk, addr, len);
 			break;
 		/* Connect checks */
 		case SCTP_SOCKOPT_CONNECTX:
 		case SCTP_PARAM_SET_PRIMARY:
 		case SCTP_PARAM_ADD_IP:
 		case SCTP_SENDMSG_CONNECT:
-			err = selinux_socket_connect_helper(sock, addr, len);
+			err = selinux_socket_connect_helper(sk, addr, len);
 			if (err)
 				return err;
 


