Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032962;
	b=Tec51qL4tpVcsg4WEIJTKKHl4bHAaO9dWY+6qBjYVLpHJECUtTrmpaJRkhjQ96MVn334
	 kqbX6LZr93TFkmZJ23VFcTJbDMbRT01HMnlMifKYDtMq9nWWDA/YagLf8opkCL5aWKkde
	 nHdnOrXfCQQPaui49S6WLFK3zS0CtpNfd6VWYnhjEYdJRlS58F795H0uhpTXUshJ7Gh9w
	 fzaQTjtCoSzhOThM5y59L/+zLY/nx2tK5lV8Sjl1YZxN2uYzWBVfNF6PCnQBWoFRSnlx/
	 a1/V537CM+ATK+MFyyf6mnJepVg9AdRr480u3O0tu/AblJEde0G8ENmq455M86E3xiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B3DRqzq/EAdmzkxw7emAu1agjcaIu965wLHyaVpSoPo=;
	b=sYSnQ4ib5uh8iQa8tuWuwvrM/INUpLbtQeg54lQnzJZqCRm94Ur5WM5vccGnwr3KHf5y
	 nM8r1fyp3FYeMS+im4A0pf6hTROysm7XnpazlyGtLUs+cLf7YJhicAITvYiyuaEStL5vj
	 P2pgAmu19zHnuxE0DN3psrQO2mP3b4nhQt7xyJ8TmNqytuGf4bkIpj3Zgzlt6+9AQyChT
	 xTS9tDIcFUwgJcCOZnCN8WWpjN3Co6a/+i/y7vU32dbhvQozvLl8gKjT5epuo/VFT3sdm
	 LbYzM0TXyAcvj2ABrJ1z4Mh+MtC4aMrilOu5ZykUDwwZisZzXdX18AQV1oN9f69cUnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bsRcs+xR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677A4606A33E;
	Wed, 18 Nov 2026 20:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bsRcs+xR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72501F000C4;
	Wed, 18 Nov 2026 20:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032962;
	bh=B3DRqzq/EAdmzkxw7emAu1agjcaIu965wLHyaVpSoPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bsRcs+xR94ciQOKGNNvmy6ZHL24CyAnTnfZtVNgncK3zZbooMd9+IeqUbvT4A5Qu8
	 w3PSmUPgxG7CLje4d4sP/FvGLDQjPHGy6Y9que/pSkIwqUVDsiuF7zL1eetaRhBkvS
	 ilwi/lT6Wgspk3dr5SebWW0dlmJUH+Z1Z9VKkeqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1596/1756] net: usb: cdc_mbim: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:02:03 +0100
Message-ID: <20261118150113.452404453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit bfd7ced012c7857b5ab5edf7e416c2789b652702 ]

cdc_mbim_tx_fixup() has the same spin_unlock_bh() as cdc_ncm_tx_fixup().
Under netpoll it runs pending softirqs while the txq lock is held, and
a transmit from one of them spins on that lock.

Use plain spin_lock() as in cdc_ncm.

Fixes: 9bf211a30b3f ("net: cdc_mbim: adding MBIM driver")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20261024-cdc-ncm-netpoll-v3-2-6284ca03f967@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_mbim.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 917c8637533b2..3571c4f37b9d6 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -290,9 +290,10 @@ static struct sk_buff *cdc_mbim_tx_fixup(struct usbnet *dev, struct sk_buff *skb
 		}
 	}
 
-	spin_lock_bh(&ctx->mtx);
+	/* BHs or IRQs are always off here, see cdc_ncm_tx_fixup() */
+	spin_lock(&ctx->mtx);
 	skb_out = cdc_ncm_fill_tx_frame(dev, skb, sign);
-	spin_unlock_bh(&ctx->mtx);
+	spin_unlock(&ctx->mtx);
 	return skb_out;
 
 error:
-- 
2.53.0



