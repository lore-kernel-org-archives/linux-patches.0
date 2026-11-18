Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021861;
	b=TjyjBF85iaM6YRg1KsdARa1rPdtUtLvL6rXTljk2j1EBx8CtAm1yJ0MSXa31/r81RHpU
	 kU6Cs5yr7pyfnyvGd+bEJ5kXoWFQLIu+5Tj+neiLe7qXPIyHQWnEVxdwM0Iz4aygB+/9S
	 NCA9aQIfybyH15uS5pyZuWi/Crbu/m0L//rBgdmC/Dg89h07nwUzmSK07hwMSOJkl5Dzo
	 /MJnovDBYWZJ+2LmzWFBTxO1Y8HHRwkPc8X/GbNV/UTWMOVCCPDqQg7AlIcELXX8ULfqQ
	 uwcX530s/C0WqoPz73sNX62rBQpj0m3t+IAwOz6AJ+b7kkykSpZnFPciwcjMz09v5Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nnQPT39Xq21CK9ZRNcewWQWL7+RaxD+TbUmDWKpXzP8=;
	b=mKgKpBWJzzkUrMBQMdzqUbEo/KOVnP9JP4zIQ15jMwoTw8qyZE40llETU67SSmy/eatI
	 rpE665mIxlsMywYeKoocK/rQ6U1sVQYdTrtQ4Q/KW2PdP+bNHaVaTLswQ0dMAMHJ0Ze2M
	 5dom14NmdyOAJXCyTtwX8qsentJ8mKLv4HnH4tvKa6Wvy9xUNOb2Z7MZCcg7lPkHRl4WK
	 u8p7CHjcvRL4m7upboaqBb/Emxu3J/ScFxwfzyM+yTVnei36Vk9zZ746oPS9sUfnCDXFA
	 keG4O/wyZp5ZYjXSLmJqkcFRoBGJJPRKSRJdOBg7mHdYOLQ0z87E1BOf4pTWX9tOhyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fiiytPfw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586E6606A33F;
	Wed, 18 Nov 2026 17:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fiiytPfw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C2D1F000C5;
	Wed, 18 Nov 2026 17:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021861;
	bh=nnQPT39Xq21CK9ZRNcewWQWL7+RaxD+TbUmDWKpXzP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiiytPfw0jzbKYpETxMcKpRT1nix+YgroFgg7f2Kyw5jDfRbx+duIOw47oGomP01j
	 wF16MFDqoYaryuejC7YzBBS6O4coYpOpcFArTH1gskj5f6eS4P54IZHcKwM+xsb0If
	 mM2zDiqe/fkwZQviQwF+ngJCCDum7sODjBK5i+n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2458/2651] net: usb: cdc_mbim: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:01:38 +0100
Message-ID: <20261118150413.555066381@linuxfoundation.org>
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
index a7010a0664c7d..8f5734ac35b8c 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -289,9 +289,10 @@ static struct sk_buff *cdc_mbim_tx_fixup(struct usbnet *dev, struct sk_buff *skb
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



