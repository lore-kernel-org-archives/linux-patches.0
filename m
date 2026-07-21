Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D057443318;
	Tue, 21 Jul 2026 22:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673055; cv=none; b=A/+IAQ8CPtSWeKX0sgwIaJg6HC/Fga9IpPT/SAZEJvt82Mb4PahoAxu9jXc3eRgP7blEqwFhEycpnshDwf1ytM42ue24uqDDJA8Mnjxnd0+BVILicl/rSGo/IgI9OaTEz6cpF9GyIg4j5zl++L4M0nBcylxckL5WbSJ9soKx01U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673055; c=relaxed/simple;
	bh=K6sHVwDN7GcRG3wJ9x4OrUUu19HbnwBorOPcmpZhZ7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNtXHGPV9HZFhlSnKH7TBtIULvZLSXfAVZBudWiLP6Hfvug2eHtaRNEsU0/fiXYj3owRCaSqg4bSrv3NE5zqcUn1gIEvWH/ZCb/asiz9Mq602Q/jXj55BHSdgo0fEowHIkI+uhhTO+3Lpi6B9t5rdgj8ylNk6fsjpD0jQyeJd6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lr3AHs8s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lr3AHs8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790D11F00A3A;
	Tue, 21 Jul 2026 22:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673050;
	bh=yPrUr7e/ZT/fnfYYSktIRlFsJCVWHsn4uToBpdy/Gtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lr3AHs8s5CK4/uYPYC4vSMwgqhoK977H+sRfe/Dt/tcN8ujkSfnhKd83g0Dchoa6X
	 oLUEwrTTkuTVTHliW4BQ89Lh3F2c+LdAn57DEmGpja3ROluswVij/N2kyqcNHh3ifv
	 Iq9MEQRVmVBLHTjOSFVqUIhTB/tJEpp2tpWby+Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 017/699] apparmor: mediate the implicit connect of TCP fast open sendmsg
Date: Tue, 21 Jul 2026 17:16:16 +0200
Message-ID: <20260721152356.077615704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ inlined absent sk_is_tcp()/sk_is_inet() helpers into the equivalent family/type/protocol checks ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/lsm.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -951,7 +951,23 @@ static int aa_sock_msg_perm(const char *
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
+	    (sock->sk->sk_family == AF_INET ||
+	     sock->sk->sk_family == AF_INET6) &&
+	    sock->sk->sk_type == SOCK_STREAM &&
+	    (sock->sk->sk_protocol == IPPROTO_TCP ||
+	     sock->sk->sk_protocol == IPPROTO_MPTCP))
+		error = aa_sk_perm(OP_CONNECT, AA_MAY_CONNECT, sock->sk);
+
+	return error;
 }
 
 /**


