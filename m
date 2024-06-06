Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7B21BE253;
	Thu,  6 Jun 2024 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683534; cv=none; b=m9mwSf3axSJYl+2ZGDYGWjYrzA8Z3jjGV/sjkHq6rGh8cDIw314kpsKP2uPosZFMQmxFFwC+d6D6pyyQzLPumrRI4ULEpLczhLON2KW3QTIwKAHWrvZiBEYaHRPLIxxBQZWj7jsS8GBIOfmQaGPugAiJJWAiodO+EdexZEtCQ0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683534; c=relaxed/simple;
	bh=135WcnQcoUrY/hyuz8QJLQYDPXy5F8fEpI0OMIG0K28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQ4mayvHOD/FK56HJ6dNUnmJzrQm++LwoCzIZNxiiRW7N6ITuSBtXcRqTvcDB54PFFl2iT3HtVVp9UC3KK9K8msQMCwJ5Slf+cP7dGNsmSzrBCHzGt0sXMrZ8+OgnrmfcCrquATujz8XbW8MlZeC1cMnwPVBGKCOuwxFIk0Cn3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGJB5LpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGJB5LpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC9EC2BD10;
	Thu,  6 Jun 2024 14:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683534;
	bh=135WcnQcoUrY/hyuz8QJLQYDPXy5F8fEpI0OMIG0K28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGJB5LpMaTo7nY7USLBeOy8lfJ4XMtHFI44ApzzTGgDnnuUXmcLUbb8q3ivBvocHz
	 ZhlmaVdbk7pL/unLIJJBIlMgcDm+VRQQSrDZoe1TVTn+wntcrRwkVRoJ2Jd7Y5QuI5
	 jSf5CXJIDcemKNKwXZYeMOaLOYvLoT4PyMehMWV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 425/473] inet: factor out locked section of inet_accept() in a new helper
Date: Thu,  6 Jun 2024 16:05:54 +0200
Message-ID: <20240606131713.812006802@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 711bdd5141d81ab21dbe0a533024d594210d5ba4 ]

No functional changes intended. The new helper will be used
by the MPTCP protocol in the next patch to avoid duplicating
a few LoC.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 26afda78cda3 ("net: relax socket state check at accept time.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_common.h |  2 ++
 net/ipv4/af_inet.c        | 32 +++++++++++++++++---------------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index 4673bbfd2811f..a75333342c4ec 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -31,6 +31,8 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 		       int addr_len, int flags);
 int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 		bool kern);
+void __inet_accept(struct socket *sock, struct socket *newsock,
+		   struct sock *newsk);
 int inet_send_prepare(struct sock *sk);
 int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
 void inet_splice_eof(struct socket *sock);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 9408dc3bb42d3..56d4ec955b851 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -744,6 +744,20 @@ int inet_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 }
 EXPORT_SYMBOL(inet_stream_connect);
 
+void __inet_accept(struct socket *sock, struct socket *newsock, struct sock *newsk)
+{
+	sock_rps_record_flow(newsk);
+	WARN_ON(!((1 << newsk->sk_state) &
+		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
+		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
+
+	if (test_bit(SOCK_SUPPORT_ZC, &sock->flags))
+		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
+	sock_graft(newsk, newsock);
+
+	newsock->state = SS_CONNECTED;
+}
+
 /*
  *	Accept a pending connection. The TCP layer now gives BSD semantics.
  */
@@ -757,24 +771,12 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
 	sk2 = READ_ONCE(sk1->sk_prot)->accept(sk1, flags, &err, kern);
 	if (!sk2)
-		goto do_err;
+		return err;
 
 	lock_sock(sk2);
-
-	sock_rps_record_flow(sk2);
-	WARN_ON(!((1 << sk2->sk_state) &
-		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
-		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
-
-	if (test_bit(SOCK_SUPPORT_ZC, &sock->flags))
-		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
-	sock_graft(sk2, newsock);
-
-	newsock->state = SS_CONNECTED;
-	err = 0;
+	__inet_accept(sock, newsock, sk2);
 	release_sock(sk2);
-do_err:
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL(inet_accept);
 
-- 
2.43.0



