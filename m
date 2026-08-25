Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA20392C21;
	Tue, 25 Aug 2026 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665931; cv=none; b=gmy3eiTNsdOm6ZDvM/FS+L/7yTd/B5/m92Ka7k5lmIT5+8X9wJ480M2n7OoOnacxPDqGMi1UmDJKDdt4cOR471jXk8SA2UUVdifcs3qFTpCp8hPeovwLMpc2cBOo2+1f15KpibcLfdKR+SQQPpmQGBhRnY8LqaD00DGK/yMvvbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665931; c=relaxed/simple;
	bh=IuXuoJIwg3GMRhWMxQikROP8jhyOlYv8RJEPNBGK1DU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOcRytYHMyubfe3NZFTH5e/ifeRl4i3bpcjHmZ9AYxryvF1wsY0ZIDplBYzefNK2XJUB7myqiVv6fdCTiVnDKibWszpStVDtGuWbySAVEMyA9UAR39X+3Fkms4pZxUHUxf8J1aHINHCO/TU1bbY8drCpojnozOZYJZ54v0mAFWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmA2/DlI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmA2/DlI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9BE1F000E9;
	Tue, 25 Aug 2026 13:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665929;
	bh=VvFtW5GMAogCAU6YRYLLh91vGn82KUFO5MoPXMVPWN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmA2/DlIMFg0ARzNiYb2Pb8Rz0ZSr3tNu+mdUsUddyPOjv+zTWt3MAX3whkjXB2vI
	 p3kKi3e5ByV3RljkcGzlpbx7IwREevqj/l2N+GxcFZwgbnZHu6vt1g3dfIZ6BdSb0U
	 LECKU2FkWA/hIkoIwjjHfctAN/DBUap00xYHuXBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 26/79] net/packet: convert po->pressure to an atomic flag
Date: Tue, 25 Aug 2026 15:26:06 +0200
Message-ID: <20260825132542.720132013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 791a3e9f1a86fe8eb09173c9788493b8b5c957f4 ]

Not only this removes some READ_ONCE()/WRITE_ONCE(),
this also removes one integer.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 1a35da325cac ("packet: synchronize pressure clearing with ring reconfiguration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   14 ++++++++------
 net/packet/internal.h  |    2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1358,22 +1358,23 @@ static int __packet_rcv_has_room(const s
 
 static int packet_rcv_has_room(struct packet_sock *po, struct sk_buff *skb)
 {
-	int pressure, ret;
+	bool pressure;
+	int ret;
 
 	ret = __packet_rcv_has_room(po, skb);
 	pressure = ret != ROOM_NORMAL;
 
-	if (READ_ONCE(po->pressure) != pressure)
-		WRITE_ONCE(po->pressure, pressure);
+	if (packet_sock_flag(po, PACKET_SOCK_PRESSURE) != pressure)
+		packet_sock_flag_set(po, PACKET_SOCK_PRESSURE, pressure);
 
 	return ret;
 }
 
 static void packet_rcv_try_clear_pressure(struct packet_sock *po)
 {
-	if (READ_ONCE(po->pressure) &&
+	if (packet_sock_flag(po, PACKET_SOCK_PRESSURE) &&
 	    __packet_rcv_has_room(po, NULL) == ROOM_NORMAL)
-		WRITE_ONCE(po->pressure,  0);
+		packet_sock_flag_set(po, PACKET_SOCK_PRESSURE, false);
 }
 
 static void packet_sock_destruct(struct sock *sk)
@@ -1462,7 +1463,8 @@ static unsigned int fanout_demux_rollove
 	i = j = min_t(int, po->rollover->sock, num - 1);
 	do {
 		po_next = pkt_sk(rcu_dereference(f->arr[i]));
-		if (po_next != po_skip && !READ_ONCE(po_next->pressure) &&
+		if (po_next != po_skip &&
+		    !packet_sock_flag(po_next, PACKET_SOCK_PRESSURE) &&
 		    packet_rcv_has_room(po_next, skb) == ROOM_NORMAL) {
 			if (i != j)
 				po->rollover->sock = i;
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -117,7 +117,6 @@ struct packet_sock {
 	spinlock_t		bind_lock;
 	struct mutex		pg_vec_lock;
 	unsigned long		flags;
-	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
 	struct packet_rollover	*rollover;
@@ -146,6 +145,7 @@ enum packet_sock_flags {
 	PACKET_SOCK_TP_LOSS,
 	PACKET_SOCK_HAS_VNET_HDR,
 	PACKET_SOCK_RUNNING,
+	PACKET_SOCK_PRESSURE,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,


