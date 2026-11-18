Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050551;
	b=R2ltVnMdmYQKvBveHzq+qlu7KGzx3dC9oaNWwIeYKD3DVXTqUC8q32mGB2g1YuJX6bls
	 XOw3PwVK5TD2WD0j6Dhhpnj1OVthDSi8otGWe+Erxo/rtFhcjpWS/fg2jpogLDFKZJalT
	 jiRqLjGf2x+zs6u1tXJ/n1/F1LBwUbeGEeDDB92g9Mxhlh8FujLbgI9WIa99iLjsgTyEY
	 5IdmV7zXp0eBQZ4Ty5+zw1ws0ruCynHdhMElADk1gLDwGqmKxG9O283aZYNZkPygmGGFy
	 NkdWztsHlT0GiAQs9XxLtu1EJ4Yhnb0JIhBA4QtFbkrNCMFzwvvHZW0dIjUHaNVv7bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XiV7hEZck1jCDmr7uqaWtDNtx1Zy1PXrbPiW9putxtc=;
	b=LSahtuAvLoMgXjKQCYc2iaSUZW49zXuHV1Sc+fZ5EPwbrCmNeMtgaOikSO+fw8T/qp2D
	 vUYShWVIl4avbzQCmBYt7xRjfoxxQ+Oe5jybWbHF23ORjCpWXYqiT4e4oSwQkPqxTDoBX
	 KYB3k1TSkQBAhSTRAmu8yOxH1L0x6nmU4H2S45Kl+2XuPXSPChDcSMr6jK408jibMZtlF
	 9Bj38mybu39wXTNQmBf+3NglFof+wFCT7K+r8q4ZthtRAbeZxFH3iuVKoH7asqfKDgsrB
	 xp+3AHISLV6o2YcuVepAJ3U1yh7aA37vknjcKprQ8RBXWPhc+sDCxx1ZynWmgcidejw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwyT9tU8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20199606A32F;
	Thu, 19 Nov 2026 01:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kwyT9tU8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797D21F000C4;
	Thu, 19 Nov 2026 01:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050551;
	bh=XiV7hEZck1jCDmr7uqaWtDNtx1Zy1PXrbPiW9putxtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kwyT9tU8mj9sEdclfXReUS4lmFgowCP3pkMwwFhTzWBNmv/zjQALXTeCRyPePTisx
	 PqGyhps5KfJjP23v0/9DzbgArJ3FvrCzJHhbWl8XzFrNTRv8SDm2CmG2uZqsmv9H1p
	 m/UG7r3LNKpAQ0HtL6PPbWNwzxRA4rVWLuG2EndU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2747/2857] net: usb: cdc_mbim: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:03:01 +0100
Message-ID: <20261118150340.522182897@linuxfoundation.org>
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
index de50405d7da04..f1ea8f808cb64 100644
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



