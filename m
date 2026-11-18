Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050769;
	b=rxwCQWUvUbIXJneXAPypn9EGMrdB+97QnyxIzEs7w2unTOPhGDS+oCq1O5TVVjf1h9zP
	 YMHzdG22YGGY++fKgR/TaQ2qTUg2cI/fsCMwbpTKdr22fu+ASSD4v0pyp61ZebiqXE0Fp
	 NUlKxzXbYldWYXRHGLN2dzMFw0GR+1TxLVoWlFfRUkmWIuM60U2P1EOxMpy5vwodpf82u
	 oRUwvZVOn/yiPBbqWbWOQDiHEm0boKuvqOIa3KK+y0fNVNwN27r29ziyB897Ngb3TT4TQ
	 vPzP5emW8d+MCmyxFPr1+afNJeZ3p09ehFNRrVC5/AHEEcTgWkCGOrQe66/CbDCHT/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050769;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+5qVxRrqYkWTmaGsaeV5pUvvxxLAdEWWEBfSVKLfBgY=;
	b=T0Bulq/arA4zO8ny3UHCbm1av6h4DCMmpZmByR3dY7WoGIkRj/+BSsd4SbzUQOz91u4I
	 DYj63cvHqPbRifxoHJIVcXVP/AHIZVT10pThj+mSHpJpoT9pJHRNDFooE9X3ckEclcCO8
	 3JgdHU6iXrsxicaXmxniseAlV6BOEEY/alluTioH9cyqX1Z85oNFykn4pS6yC4lcddrGt
	 4CldUkF5RfPvfvLoFz3wTqSo45uQgHjprAPCmCgfBuHjZv8namfBmjanAlrIivLL4UI59
	 YB1qvOrq7Hhmy5GFm8m86qxbAf9huztY6t3hsHfjdldmzszy6AAylfZm4Y0TaD58bEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=romvL6qw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6547606A320;
	Thu, 19 Nov 2026 01:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=romvL6qw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B101F000C5;
	Thu, 19 Nov 2026 01:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050769;
	bh=+5qVxRrqYkWTmaGsaeV5pUvvxxLAdEWWEBfSVKLfBgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=romvL6qwpHviy63WKge5OeZ7BeGk1ZbFe9Go6NL1yZRKcRZa/NlAxykd2yAx8Fvpy
	 7vhrnXrmqME/bxNtkgNz/i+npeuoHjMiaThbOHaM7g47SiZVtqHU2o+dRqpTia1aRh
	 GWiaEulsahI1ozYn6GOa6U8ZRTNg/m8wKfUaXQec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Liang <shaw.leon@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2826/2857] tun: drop batched packets while the device is down
Date: Wed, 18 Nov 2026 16:04:20 +0100
Message-ID: <20261118150343.338455737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Liang <shaw.leon@gmail.com>

[ Upstream commit 8f44631ba02afe9fff2f0a0fb66560ab19df87fd ]

tun_sendmsg() handles TUN_MSG_PTR batches from vhost-net by calling
tun_xdp_one() instead of tun_get_user(). But this path does not check
IFF_UP, allowing packets from a guest to be injected into the host
receive path while the device is administratively down.

Check IFF_UP in tun_xdp_one() before running XDP or building an skb.
Drop the packet when the device is down, matching tun_get_user().

Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261027101830.85327-1-shaw.leon@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 573e97b1880b9..1b4700feed4db 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2472,6 +2472,12 @@ static int tun_xdp_one(struct tun_struct *tun,
 		return -EINVAL;
 	}
 
+	if (unlikely(!(READ_ONCE(tun->dev->flags) & IFF_UP))) {
+		put_page(virt_to_head_page(xdp->data));
+		dev_core_stats_rx_dropped_inc(tun->dev);
+		return -EIO;
+	}
+
 	xdp_prog = rcu_dereference(tun->xdp_prog);
 	if (xdp_prog) {
 		if (gso->gso_type) {
-- 
2.53.0



