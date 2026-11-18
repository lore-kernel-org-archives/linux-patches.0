Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050548;
	b=xpY62kZTtHm0M0xwePeDWWnGoblN7Fx++D7Lj/mTh3DPXhlt/zL8RcS0hXMC3GxXuEjk
	 NJErcKM1/15BAh1jiWj1aIA4F51iWSMMyqb9JlJxFLRzh73GXNYAAlx3nFW3KQgveNKrg
	 SKaYoQ/6M9WzWgg90fbkVvA93qc0plMCRdr7TrYQujEfh0FubDwYaUFrT0L3ZkKhlMuwT
	 lYbNNkJLYxEML8994dpt/Va1vlHEknvRrmFVerSPNUi2F92UDqw3SanqtSMN6TYIn1ihB
	 GxbwxETYrTOaSIqxWh+Tnm6flV/XJHLrpYLXzN1s/vsbmEmIEpxprITroGCFwZmyOYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g8k8Vzrl+i0Dm79QI0gK70m9H+pHb2X3srQkufFy2UA=;
	b=wZFpMJhpbWKhGw1mZdm6shU+t/HcoQlTb83bYxmCdx48Vz3FoeJZXkvS4HK24dN0XIf6
	 DB85PrOX4+LcT5qGUAvZ1gou34EoZ/Jvz2LCtt52PBQWqeBQwI2ojN10OO7GGs7HlcWM/
	 kP4otcSsAG4vgOgHa94EulqVRX55asTh8julykekUKf6gZ8GWkNwQkRmE/AuTYaG4tgkQ
	 HxEJ9CjMvPtl0TJduOcqZmBK/A0zyLsbveYvfOOaV0NiaKQJpkQdSRCAUWPMHdm/bIBdb
	 5/bEr/Syx3jOwkLiCQuQQRggI6Frsiz/0oOjr/fgvnPpFhakS9kjmTZCr6ZYdsA7A+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KRWujery;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726D5606A31C;
	Thu, 19 Nov 2026 01:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KRWujery
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B151F000C4;
	Thu, 19 Nov 2026 01:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050548;
	bh=g8k8Vzrl+i0Dm79QI0gK70m9H+pHb2X3srQkufFy2UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRWujeryf1qiWx90np7G0Tg5gUZwqC8d08HO6VO7caybHSyGk/j5smeDWzG6xsjFT
	 +l9e21q2U5dmiM384m7i1cJexnhiClfp3/HGqWtHHn7RczG/mSHDFgYnr+onN/6OL1
	 Sk5alm6XJhOMcmngtO/YkE4670RnX8vgPvALae6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikkel Eskildsen <mke@visotia.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2746/2857] net: usb: cdc_ncm: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:03:00 +0100
Message-ID: <20261118150340.488007376@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 108ca34cf4b453f6375a70079e32b11866b02601 ]

netpoll holds the txq lock and calls ndo_start_xmit() with IRQs off but
BHs on. The spin_unlock_bh() in cdc_ncm_tx_fixup() then runs pending
softirqs. If one of them transmits, it spins on the txq lock that
netpoll holds. With netconsole on a cdc_ncm device this ends in a soft
or hard lockup.

Every caller of cdc_ncm_tx_fixup() holds the txq lock with BHs or IRQs
off, so the softirq user of ctx->mtx cannot interrupt it. Use plain
spin_lock().

Fixes: c84ff1d6dff3 ("cdc_ncm: reduce driver latency in the data path")
Reported-by: Mikkel Eskildsen <mke@visotia.com>
Closes: https://lore.kernel.org/netdev/PRAP189MB185019A5A8D411482BB6E0CDA9982@PRAP189MB1850.EURP189.PROD.OUTLOOK.COM/
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20261024-cdc-ncm-netpoll-v3-1-6284ca03f967@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index a73ad0cd20fc3..76687d57adb97 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1534,14 +1534,17 @@ cdc_ncm_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 	if (ctx == NULL)
 		goto error;
 
-	spin_lock_bh(&ctx->mtx);
+	/* BHs or IRQs are always off here. netpoll only disables IRQs, and
+	 * spin_unlock_bh() would then run softirqs with the txq lock held.
+	 */
+	spin_lock(&ctx->mtx);
 
 	if (ctx->is_ndp16)
 		skb_out = cdc_ncm_fill_tx_frame(dev, skb, cpu_to_le32(USB_CDC_NCM_NDP16_NOCRC_SIGN));
 	else
 		skb_out = cdc_ncm_fill_tx_frame(dev, skb, cpu_to_le32(USB_CDC_NCM_NDP32_NOCRC_SIGN));
 
-	spin_unlock_bh(&ctx->mtx);
+	spin_unlock(&ctx->mtx);
 	return skb_out;
 
 error:
-- 
2.53.0



