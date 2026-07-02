Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F1D335066;
	Thu,  2 Jul 2026 16:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011537; cv=none; b=lgYP5E5ooqzn8oAOJr4Xb9mbLWROhDj/9qY0qTec6eSzxJZSn3AZalVZAHF12a1H1EgTM1opoCCmPcbr0mTAPSbFL5m16hCHCySHNJzNOvdurD1cilkDLGwW6eyP+zy4/txGHEA5LEa3yBXDzvjMzFo+dq1P6AsZthUuSGGsTCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011537; c=relaxed/simple;
	bh=2hyBUjuLzYZcbJg++UIrGOm4kVfLfHmUasJCKJvn9sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o8K8C0IdsLIIQCLyYs9tKw4OyYpmRprU4RCGbu9Y+nIRBqZrIKMgeLoN+J+EaoUBTCD+Bt6dOAidb2jENLxj0vPha9JIFLOfqW2AGq0P5ZT3EMxq2b6AMEaOZJJfNX+xRnXur6skkVoB+V6lu12WTn4crKgs8ygWxmc+oOIoPzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaK9ho5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaK9ho5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6D31F00A3A;
	Thu,  2 Jul 2026 16:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011536;
	bh=GpMeX5QRbz74WXumC1HHFuypGXazY+gidJseum3wxqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qaK9ho5Rs/padXHbKt6um1HjSkK1I1Z81po5D3VlLiK8sKDuMyPzyxdDIjip3GHdQ
	 RQJgrb5Sf3p+j4X9e1p3q33UZkPZFp+jpZnUldC4hLSg8r0P5dB5inyX3X2lEp7LO4
	 G44A08dxUJhxWkmOPgNQgwflTe8wS73X66YhAueg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	John Johansen <john.johansen@canonical.com>
Subject: [PATCH 7.1 036/120] apparmor: mediate the implicit connect of TCP fast open sendmsg
Date: Thu,  2 Jul 2026 18:20:32 +0200
Message-ID: <20260702155113.708240416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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
@@ -1422,7 +1422,21 @@ static int aa_sock_msg_perm(const char *
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
 
 static int apparmor_socket_recvmsg(struct socket *sock,


