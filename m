Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C26168C4;
	Mon, 27 May 2024 19:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837398; cv=none; b=Nzjt1DMOFF1TuRK/ptUL6mFqJUtyfhR37bmjco/GFDBFcnsNRxgS6jPYr3XyPkHoA1wb2hnP6ALlnL91d4sZkW31JJhp+uCUety8hYgricrNFPKaoRLpa0P9+45WkmKGORuh4/6h4aGNWUG9eGT/0L7tVZ0FLVKif7LEi8bJGsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837398; c=relaxed/simple;
	bh=LmgSl6nOwHG2wQ+PgeuyhplsegZMjS/52OXVIibf4hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCXX/lZFs/PjkIxNfhfvY15z1Vqv9koaGpJplM6CYu1pO8DkIhFp9XrGsDCs0BADUGojKDcpqN7Me8+M8ylT88Vni7Lju8A35Y6hAWr5VEh6qkvlGgxy0FlqhhCJw0cMplgI9w7SnbfxgeRa/wjXU3giYW+e9vZflfWx8ATxZfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjECls9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjECls9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9068AC32781;
	Mon, 27 May 2024 19:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837397;
	bh=LmgSl6nOwHG2wQ+PgeuyhplsegZMjS/52OXVIibf4hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjECls9PRfci6/Vnr7gHUCYxhcQnK9Ko/QzAX1XnO31hPgWoOwAakiSba0Ny/Dh5T
	 zWG+gwzJO52sazHnVkKNBfIKSrpP5LJGuPhzXTg4t0H2Df/uB1mXJUdgwyPJFljLrc
	 Naty7vOG9tsFa9bhpp32tIsH3QF3Bens7mOKQzSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Parkin <tparkin@katalix.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 425/427] l2tp: fix ICMP error handling for UDP-encap sockets
Date: Mon, 27 May 2024 20:57:52 +0200
Message-ID: <20240527185635.857875647@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Parkin <tparkin@katalix.com>

[ Upstream commit 6e828dc60e509b79ef09882264952f341cb58425 ]

Since commit a36e185e8c85
("udp: Handle ICMP errors for tunnels with same destination port on both endpoints")
UDP's handling of ICMP errors has allowed for UDP-encap tunnels to
determine socket associations in scenarios where the UDP hash lookup
could not.

Subsequently, commit d26796ae58940
("udp: check udp sock encap_type in __udp_lib_err")
subtly tweaked the approach such that UDP ICMP error handling would be
skipped for any UDP socket which has encapsulation enabled.

In the case of L2TP tunnel sockets using UDP-encap, this latter
modification effectively broke ICMP error reporting for the L2TP
control plane.

To a degree this isn't catastrophic inasmuch as the L2TP control
protocol defines a reliable transport on top of the underlying packet
switching network which will eventually detect errors and time out.

However, paying attention to the ICMP error reporting allows for more
timely detection of errors in L2TP userspace, and aids in debugging
connectivity issues.

Reinstate ICMP error handling for UDP encap L2TP tunnels:

 * implement struct udp_tunnel_sock_cfg .encap_err_rcv in order to allow
   the L2TP code to handle ICMP errors;

 * only implement error-handling for tunnels which have a managed
   socket: unmanaged tunnels using a kernel socket have no userspace to
   report errors back to;

 * flag the error on the socket, which allows for userspace to get an
   error such as -ECONNREFUSED back from sendmsg/recvmsg;

 * pass the error into ip[v6]_icmp_error() which allows for userspace to
   get extended error information via. MSG_ERRQUEUE.

Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
Signed-off-by: Tom Parkin <tparkin@katalix.com>
Link: https://lore.kernel.org/r/20240513172248.623261-1-tparkin@katalix.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 8d21ff25f1602..4a0fb8731eee9 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -887,22 +887,20 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	return 1;
 }
 
-/* UDP encapsulation receive handler. See net/ipv4/udp.c.
- * Return codes:
- * 0 : success.
- * <0: error
- * >0: skb should be passed up to userspace as UDP.
+/* UDP encapsulation receive and error receive handlers.
+ * See net/ipv4/udp.c for details.
+ *
+ * Note that these functions are called from inside an
+ * RCU-protected region, but without the socket being locked.
+ *
+ * Hence we use rcu_dereference_sk_user_data to access the
+ * tunnel data structure rather the usual l2tp_sk_to_tunnel
+ * accessor function.
  */
 int l2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 {
 	struct l2tp_tunnel *tunnel;
 
-	/* Note that this is called from the encap_rcv hook inside an
-	 * RCU-protected region, but without the socket being locked.
-	 * Hence we use rcu_dereference_sk_user_data to access the
-	 * tunnel data structure rather the usual l2tp_sk_to_tunnel
-	 * accessor function.
-	 */
 	tunnel = rcu_dereference_sk_user_data(sk);
 	if (!tunnel)
 		goto pass_up;
@@ -919,6 +917,29 @@ int l2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(l2tp_udp_encap_recv);
 
+static void l2tp_udp_encap_err_recv(struct sock *sk, struct sk_buff *skb, int err,
+				    __be16 port, u32 info, u8 *payload)
+{
+	struct l2tp_tunnel *tunnel;
+
+	tunnel = rcu_dereference_sk_user_data(sk);
+	if (!tunnel || tunnel->fd < 0)
+		return;
+
+	sk->sk_err = err;
+	sk_error_report(sk);
+
+	if (ip_hdr(skb)->version == IPVERSION) {
+		if (inet_test_bit(RECVERR, sk))
+			return ip_icmp_error(sk, skb, err, port, info, payload);
+#if IS_ENABLED(CONFIG_IPV6)
+	} else {
+		if (inet6_test_bit(RECVERR6, sk))
+			return ipv6_icmp_error(sk, skb, err, port, info, payload);
+#endif
+	}
+}
+
 /************************************************************************
  * Transmit handling
  ***********************************************************************/
@@ -1493,6 +1514,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 			.sk_user_data = tunnel,
 			.encap_type = UDP_ENCAP_L2TPINUDP,
 			.encap_rcv = l2tp_udp_encap_recv,
+			.encap_err_rcv = l2tp_udp_encap_err_recv,
 			.encap_destroy = l2tp_udp_encap_destroy,
 		};
 
-- 
2.43.0



