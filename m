Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021651;
	b=Kus5i3iq0uWoxKZvJMJ1WAT6XBAEoBaSXuUhruJEpD61vvt5jcu+O9MWk9Jq/KfJ9VFK
	 P9qiIInyO7evkdxENU/IWwD4irPekqqMM17iEn2ZZ3YaZeJXl6hojwAZEGcxPH2v42NWr
	 tjKi8mzop2LIxcc0aete6RPqA/7en3LCJisizMCwXA2x/eP6D/YU0UmakxpsKx2baQgPN
	 15rdmy7IkVZQhosiG+HcH2esIO5NirOTaFGA47SnpVmzJjsuTNDeUOD/82WarJV67FY/N
	 MZP71wzJ/HOOBQ79TA0KZHfx7q/3m9NOkjANqciSD/wbCa4mTmeZyAtPCiijatr3PRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kC5ulXXe4zdCThCT/2e7qekLTbjq5yxtP9UnTKucQ/U=;
	b=dgS9v8IFWK13DLPsiTUDvDD3AIoGGQMbI7WvJ5AJSWglkD3Hf7786911mOd2FJOvXFQi
	 wMfuqFhgcElMOmouhSDI4tdR8wN/KuTKtoWYVM98/3JdDqOolvZXasCAccCaphcB1eSBP
	 Yr8WOeCQFE+0lDLlxaZU/lG2zIJ0ILSDocPp1ObDlk8Y6A9pRfHX3UVKRz+XxeO14FrKt
	 WHU2118ljZlnuBGcgSWsPLZu9ToLOKgRjiVwaT4Gjz5NuEVXIB5oTKyoXLXfBnGdrdtSz
	 MiD8NM0zwEXg1VQF47FARPmG6tc4Pbt7K7/RSQ8ho99w22GyIO1XMnD3QFIDnG3S4tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OFOYmQ3v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85234606A320;
	Wed, 18 Nov 2026 17:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OFOYmQ3v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9241F000C4;
	Wed, 18 Nov 2026 17:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021651;
	bh=kC5ulXXe4zdCThCT/2e7qekLTbjq5yxtP9UnTKucQ/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OFOYmQ3vY1NOFrYRNcbXDJxWrOsC7CHhjsPhoZo+TUySnRbDxjCMRpwJKDhCnZTGh
	 19XnWjrv6FAjee9PlMuJS8DttFgml8nzYTHbP+NeNLykDDd1CyXOEeETfqbIg5wbRh
	 yyvDAGVdpbfXU4PlRF96JXP8KHNRF7W4owL83MYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2383/2651] net/rds: keep the connected peers scope id apart from the bound one
Date: Wed, 18 Nov 2026 16:00:23 +0100
Message-ID: <20261118150411.229082169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 3fe64a5f670dbd6c7c84c2345b0b9726b3b79b31 ]

rds_connect() has nowhere to keep the scope of a link-local peer, so
it stores it in rs_bound_scope_id, the scope of the socket's own
bound address, for rds_bind() to check a later link-local bind
against.  That field is then also what a send without a destination
uses as the request's scope, what getpeername() and recvmsg() report
as the peer's scope, and what a later bind() overwrites:
rds_add_bound() stores the bound address's scope unconditionally,
which for a non-link-local address is 0.

So after connect(fe80::x%ifA) followed by bind(global), a send() with
no destination asks for fe80::x with scope 0.  rds_conn_lookup() keys
on the interface, so that finds or creates a connection with c_dev_if
0, which the TCP transport then tries to connect through
sin6_scope_id 0 and tcp_v6_connect() rejects for a link-local peer:
the connected socket's data is queued on a connection that can never
come up.  In the other order, bind(global) then connect(fe80::x%ifB),
the connect leaves a global-bound socket with rs_bound_scope_id ifB,
so sends to other link-local peers are refused as off-link and sends
to global peers inherit a meaningless interface.

Give the connected peer its own rs_conn_scope_id.  rds_connect()
records it there and leaves the bound scope alone, rds_bind()'s
connected-socket check compares against it, and the destination-less
send takes its scope from it - falling back to the bound scope for a
non-link-local peer, so that send() and sendto() to the connected
peer compute the same scope, and so the same connection.
getpeername() reports the connected peer with its own scope.
recvmsg() used to report every sender with the socket's bound scope;
a connected socket receives from any peer, so neither the bound scope
nor the connected peer's scope is right for an arbitrary sender.  It
now reports a link-local sender with the interface recorded on its
connection, c_dev_if: the TCP accept path takes it from the incoming
socket, and the IB passive side resolves it from the local address,
the closest the CM gets to the arrival interface.  Any other sender
is reported with scope 0, the inet6 convention.  Either way, a reply
to the address an application was given reaches the same connection.

Found by inspection while reworking the sendmsg connection cache; not
observed in the field.

Fixes: 1e2b44e78eea ("rds: Enable RDS IPv6 support")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20261020002816.3087414-3-achender@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/af_rds.c | 15 +++++++++------
 net/rds/bind.c   |  4 ++--
 net/rds/rds.h    |  2 ++
 net/rds/recv.c   | 11 ++++++++++-
 net/rds/send.c   |  6 +++++-
 5 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index d5defe9172e36..e84d00bbe9a15 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -136,8 +136,7 @@ static int rds_getname(struct socket *sock, struct sockaddr *uaddr,
 			sin6->sin6_port = rs->rs_conn_port;
 			sin6->sin6_addr = rs->rs_conn_addr;
 			sin6->sin6_flowinfo = 0;
-			/* scope_id is the same as in the bound address. */
-			sin6->sin6_scope_id = rs->rs_bound_scope_id;
+			sin6->sin6_scope_id = rs->rs_conn_scope_id;
 			uaddr_len = sizeof(*sin6);
 		}
 	} else {
@@ -572,6 +571,7 @@ static int rds_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 		}
 		ipv6_addr_set_v4mapped(sin->sin_addr.s_addr, &rs->rs_conn_addr);
 		rs->rs_conn_port = sin->sin_port;
+		rs->rs_conn_scope_id = 0;
 		break;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -616,11 +616,14 @@ static int rds_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 				ret = -EINVAL;
 				break;
 			}
-			/* Remember the connected address scope ID.  It will
-			 * be checked against the binding local address when
-			 * the socket is bound.
+			/* Remember the connected address scope ID.  It is
+			 * checked against the binding local address when
+			 * the socket is bound, and gives a send without a
+			 * destination its scope.
 			 */
-			rs->rs_bound_scope_id = sin6->sin6_scope_id;
+			rs->rs_conn_scope_id = sin6->sin6_scope_id;
+		} else {
+			rs->rs_conn_scope_id = 0;
 		}
 		rs->rs_conn_addr = sin6->sin6_addr;
 		rs->rs_conn_port = sin6->sin6_port;
diff --git a/net/rds/bind.c b/net/rds/bind.c
index f800d920d9690..3ac59cd512a21 100644
--- a/net/rds/bind.c
+++ b/net/rds/bind.c
@@ -233,8 +233,8 @@ int rds_bind(struct socket *sock, struct sockaddr_unsized *uaddr, int addr_len)
 	 * non-link local address (scope_id is 0).
 	 */
 	if (!ipv6_addr_any(&rs->rs_conn_addr) && scope_id &&
-	    rs->rs_bound_scope_id &&
-	    scope_id != rs->rs_bound_scope_id) {
+	    rs->rs_conn_scope_id &&
+	    scope_id != rs->rs_conn_scope_id) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 2db49573dacd5..9b1ffc49c0a61 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -646,6 +646,8 @@ struct rds_sock {
 	struct in6_addr		rs_conn_addr;
 #define rs_conn_addr_v4		rs_conn_addr.s6_addr32[3]
 	__be16			rs_conn_port;
+	/* scope of rs_conn_addr when it is link-local, 0 otherwise */
+	__u32			rs_conn_scope_id;
 	struct rds_transport    *rs_transport;
 
 	/*
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 93ee4546ae362..00ab60f2d9969 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -791,7 +791,16 @@ int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 				sin6->sin6_port = inc->i_hdr.h_sport;
 				sin6->sin6_addr = inc->i_saddr;
 				sin6->sin6_flowinfo = 0;
-				sin6->sin6_scope_id = rs->rs_bound_scope_id;
+				/* A link-local sender is reported with the
+				 * interface recorded on its connection (the
+				 * accepting socket's device for TCP, the one
+				 * resolved for the local address on IB); any
+				 * other sender has no scope.
+				 */
+				sin6->sin6_scope_id =
+					(ipv6_addr_type(&inc->i_saddr) &
+					 IPV6_ADDR_LINKLOCAL) ?
+					inc->i_conn->c_dev_if : 0;
 				msg->msg_namelen = sizeof(*sin6);
 			}
 		}
diff --git a/net/rds/send.c b/net/rds/send.c
index 38b9cc9e0d20b..f38967f65af18 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1256,7 +1256,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		lock_sock(sk);
 		daddr = rs->rs_conn_addr;
 		dport = rs->rs_conn_port;
-		scope_id = rs->rs_bound_scope_id;
+		/* The connected peer's scope for a link-local peer, else
+		 * the bound scope, as an explicit send to that peer would
+		 * compute below.
+		 */
+		scope_id = rs->rs_conn_scope_id ?: rs->rs_bound_scope_id;
 		release_sock(sk);
 	}
 
-- 
2.53.0



