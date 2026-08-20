Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4736137E5D8;
	Thu, 20 Aug 2026 15:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239165; cv=none; b=ASntyypDp15IwTxGF/UFwchG+DVJOtGRVxsXrYjj48PmaCQLD2r8T9a+YFjhO4EAR8AjKLiKXRehewlH46/Q9zuaxJAvuyDdWLahYR58fAdxydZqJwrVAnSv7WShfolCpth5iOOE68cushb7Jt+znlkNquV7o3FuNqdu76apzFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239165; c=relaxed/simple;
	bh=gnxOwL35gLMIlU7NV9tihovla4OVJwoeVScjG+6xC8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3LobnoXxO0tF/xDOJfHbZ0URcd8ZIM6avfK5I3k4CWg0eJlc78j735UaQanCCwPkdZG6pRb2MCJKUVtrr7++IKznfBKaE08nxAfH1WrSoFJlitzOJU2A4SS+EtJk90wV3h4Rnobhl9LrH0tt15zXDkb3dnwWXZH1Ov6xLsJCrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTkoKyUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTkoKyUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ADE1F000E9;
	Thu, 20 Aug 2026 15:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239164;
	bh=R5AtWKnx6g0QhLOaDrAmt6QaAKAUSzMa+VHeW43bsJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FTkoKyUqb3GHxTDYAfbvwCWcUIkfkdMcdSiATEQVYV5Ta4qfJ6dtHMj8XCr6LJCKa
	 oZSPfRmHIMygfEmjaIiDAx8C5JlQn7/5giV1hGL6wrPaOT4svrSdnc095jyhSps+QT
	 QdfzUFhsI5f/RuLNWYUzoV08qIC0uRykZiMe8wgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralf Lici <ralf@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/217] ovpn: finish crypto callback cleanup before peer release
Date: Thu, 20 Aug 2026 16:55:41 +0200
Message-ID: <20260820145242.945555324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit 9e163917a86c6adfbe150e13f4c73653a54616de ]

Crypto completion callbacks hold both key-slot and peer references. The
peer reference pins the netdev, and dropping the last peer reference can
let netdev unregistration and module removal make progress.

Do not release that peer reference before the callback has finished its
own cleanup. If ovpn_crypto_key_slot_put runs after ovpn_peer_put, it can
schedule an RCU callback backed by module text after ovpn_cleanup
rcu_barrier has already run. The TX error path also freed the remaining
skb after ovpn_peer_put, leaving callback cleanup outside the peer/netdev
lifetime window.

Release the key slot and free any remaining skb first, then drop the peer
reference as the last callback action.

Fixes: 8534731dbf2d ("ovpn: implement packet processing")
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/io.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ovpn/io.c b/drivers/net/ovpn/io.c
index 0008a3d30c198..65a904c64e056 100644
--- a/drivers/net/ovpn/io.c
+++ b/drivers/net/ovpn/io.c
@@ -199,10 +199,10 @@ void ovpn_decrypt_post(void *data, int ret)
 		ovpn_dev_dstats_rx_dropped(peer->ovpn->dev);
 	kfree_skb(skb);
 drop_nocount:
-	if (likely(peer))
-		ovpn_peer_put(peer);
 	if (likely(ks))
 		ovpn_crypto_key_slot_put(ks);
+	if (likely(peer))
+		ovpn_peer_put(peer);
 }
 
 /* RX path entry point: decrypt packet and forward it to the device */
@@ -299,11 +299,11 @@ void ovpn_encrypt_post(void *data, int ret)
 err:
 	if (unlikely(skb))
 		ovpn_dev_dstats_tx_dropped(peer->ovpn->dev);
-	if (likely(peer))
-		ovpn_peer_put(peer);
+	kfree_skb(skb);
 	if (likely(ks))
 		ovpn_crypto_key_slot_put(ks);
-	kfree_skb(skb);
+	if (likely(peer))
+		ovpn_peer_put(peer);
 }
 
 static bool ovpn_encrypt_one(struct ovpn_peer *peer, struct sk_buff *skb)
-- 
2.53.0



