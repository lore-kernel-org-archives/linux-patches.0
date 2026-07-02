Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194F233B6D1;
	Thu,  2 Jul 2026 16:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010018; cv=none; b=EzcMARKdJGcFuPNTJGUWyvyvCztJPSWLHxronzBkIF3LBhPaD4TWaJIV3TbNc+ZlnlfkeSuMjmrC1MkynyfUHOfaOQlVDFFDJOwEd7KWMPylLSntWevdqywKyGVpep7QSnYpUoYgqJOEMUdneDhiVsx/fVdaOZJgmrdOUE7JZ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010018; c=relaxed/simple;
	bh=oqv6PeugggcUIO7Pw1iu9O1lvuWX6w7b8CgAWMDoF9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEwD13v12U+NhUUcxJKJ0VacWn2XhM3VKC7B7guR2mbn/HPT7Q21d7skI7BbtBrnR7pmfrCeQvAwmUGlwFacazBg0JLCplPAlp6LQYnDNYGlGYWYU98INmv1gxMPvstdn4hXQ05OU+OakEFWAP5oWF0hHEqr4dcgHkVMXDsB/ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOgU2Uqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOgU2Uqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F46F1F000E9;
	Thu,  2 Jul 2026 16:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010017;
	bh=tRUc08sBEAWRQf9tQxEGJJeAcPUTqZrPlXvDQsric+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOgU2Uqdst5tJiSFKVvx3TLCFj0lyKFz39I1WAaHHLgPSO+SOxu8At/YZEn6Rx/Ji
	 ICRYJTGROq6KDcYsnAFD864BVFsHilidw6hns+Vj18xCmP50ROa/fqcIkJ22Ba43ss
	 WH6Matfa/G8LQp9TCEW+nmtGdeR11uYtqU4XZkxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 6.1 079/129] apparmor: mediate the implicit connect of TCP fast open sendmsg
Date: Thu,  2 Jul 2026 18:19:58 +0200
Message-ID: <20260702155113.773868504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 4d587cd8a72155089a627130bbd4716ec0856e21 upstream.

sendmsg()/sendto() with MSG_FASTOPEN is a combination of connect(2) and
write(2): it opens the connection in the SYN. apparmor_socket_sendmsg()
only checks AA_MAY_SEND, so a profile that grants send but denies connect
lets a confined task open an outbound TCP/MPTCP connection that connect(2)
would have refused, bypassing connect mediation.

Mediate the implicit connect when MSG_FASTOPEN is set and a destination
is supplied. Add it to apparmor_socket_sendmsg() (not the shared
aa_sock_msg_perm() helper, which recvmsg also uses) and call aa_sk_perm()
directly, mirroring the selinux and tomoyo fixes. sk_is_tcp() does not
cover MPTCP fast open, so the SOCK_STREAM/IPPROTO_MPTCP arm is explicit.

Fixes: cf60af03ca4e ("net-tcp: Fast Open client - sendmsg(MSG_FASTOPEN)")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/lsm.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -984,7 +984,21 @@ static int aa_sock_msg_perm(const char *
 static int apparmor_socket_sendmsg(struct socket *sock,
 				   struct msghdr *msg, int size)
 {
-	return aa_sock_msg_perm(OP_SENDMSG, AA_MAY_SEND, sock, msg, size);
+	int error = aa_sock_msg_perm(OP_SENDMSG, AA_MAY_SEND, sock, msg, size);
+
+	if (error)
+		return error;
+
+	/* TCP fast open carries connect() semantics in sendmsg(); mediate
+	 * the implicit connect so it cannot bypass the connect permission.
+	 */
+	if ((msg->msg_flags & MSG_FASTOPEN) && msg->msg_name &&
+	    (sk_is_tcp(sock->sk) ||
+	     (sk_is_inet(sock->sk) && sock->sk->sk_type == SOCK_STREAM &&
+	      sock->sk->sk_protocol == IPPROTO_MPTCP)))
+		error = aa_sk_perm(OP_CONNECT, AA_MAY_CONNECT, sock->sk);
+
+	return error;
 }
 
 /**


