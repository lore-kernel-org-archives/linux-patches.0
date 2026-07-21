Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7680644AB62;
	Tue, 21 Jul 2026 21:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670845; cv=none; b=KMhZcoXxkbRTz8M4MjxgpOuUK1/eQyw+FwALv0ankBRHm4ejmCu5w08Fw6X0bZyTglDQlsY6Dm8sY+csVuMjYIa1HLDEIA5E+eXcz3r73Phs4zefSgd+b6F0KxmQrD/SQ1ZlayuLiw5YDr7XbydZgQENnmwfKjRiDkHN3L/SI4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670845; c=relaxed/simple;
	bh=awydqNoaS6LOklDI4IRhCX9PW5n0wi1sn6az6wbPqnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M++Ku1+Pe1Yi/KNfvw4wtBfagrAY4b2Pmvcsfi9veRKHNh/D0t0OsFelPQDjMvT04W1HNdKHnuZRpUwGP+x4P9v1SNDuYanuME7GPoDW4XnSXxX7t+RSNZbbL/Ywxilp0TSyXyPCl/WwOauy0NJDQdEV6mfcZhlXaNSS85HypSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTj2qZb3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTj2qZb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCCB1F000E9;
	Tue, 21 Jul 2026 21:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670844;
	bh=ZYHMsyejSZSujyLcnNyobutZQ1oxuAHLO7jH+G+ThfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTj2qZb3qRtLSlzIPw57v6IyUBMr+JV3goCTToYX5JcvbbqA4yxaoBJ8NQyehufZv
	 3U1B+pbFbfG+nCS8X8N7DEtAGn+5OqBBEesoztrV3/Beg4UCA05I/kv4dbTQ47RasX
	 wxB2L/ZUgq2kBEDXKSzl2ztPqSpul0JgkuSqofZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/843] apparmor: mediate the implicit connect of TCP fast open sendmsg
Date: Tue, 21 Jul 2026 17:14:18 +0200
Message-ID: <20260721152406.484492284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 4d587cd8a72155089a627130bbd4716ec0856e21 ]

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
[ expanded sk_is_tcp() (absent in 5.15) into its equivalent sk_is_inet() && SOCK_STREAM && (IPPROTO_TCP || IPPROTO_MPTCP) check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/lsm.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -960,7 +960,21 @@ static int aa_sock_msg_perm(const char *
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
+	    (sk_is_inet(sock->sk) && sock->sk->sk_type == SOCK_STREAM &&
+	     (sock->sk->sk_protocol == IPPROTO_TCP ||
+	      sock->sk->sk_protocol == IPPROTO_MPTCP)))
+		error = aa_sk_perm(OP_CONNECT, AA_MAY_CONNECT, sock->sk);
+
+	return error;
 }
 
 /**


