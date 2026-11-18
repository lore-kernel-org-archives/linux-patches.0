Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056849;
	b=GaUTS8LES8QGWfPLZv4b01WMG7J2QshAek4SRmkAzgVBdZz2JDOB26Kckd2m50BHLr/d
	 qz0XQIsHIZG+lxGJYfd77wtD7OuyxftblvXdakzEBaLdlUXyD1ZMO1Rs5HICPXJrmMba9
	 QClHJksxFW4IF4dQ88irMxTvk19mHBzmWhqB5On4OlaHKtj0csXn/a2/jmDZaVy2zg6HJ
	 qjRWhCrsw4BUeZY0MtH2mC8NipQ9xXupGmGIJx3b2q1hcqeU77SNoM5z19xY6ChF6Fsj9
	 cuWe5bCTy/JV/yoQY2c22pJXrSM/nVjnFy67u6fws+a7ZduIvfge4zGqtJ1NMKqKlBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MAhNpnsWR5OPAo/CQaUbzEoUGOvo1M5/Xy5njSswsNM=;
	b=NTalLVlueHQMuCruLvtiQ4cphHW8ndsVe1HJNQNeqsExG+nzE3hfu1nCa2tNX2JXQwuc
	 8PZko6pNJMRSNxSt6KcAMYqdCiDgWVMjjcRzYl4UaAm3vj6AvO+b7XBGyWp9ptue1/kLV
	 jj/bAC7PaGdq1MSKNps0y4SS78e2bEvVR6+7hyzKbdfAPFpAd1E6IFd4QiMeuhq26aunU
	 Zf27uGzyoRWSi1I5Ii6CNVwM7QXv8fn0inQjygR4YX09hpp13hQiBjPO8V+oHCnaEPrG8
	 UjMQhW5+AA02weFN45JiM/AM2lEZdzjv+uRj3VeHC2ZRVvQk58tjOhTkWewtDXSHcHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziCMny56;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFD3606A332;
	Thu, 19 Nov 2026 02:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziCMny56
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C879C1F000C4;
	Thu, 19 Nov 2026 02:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056849;
	bh=MAhNpnsWR5OPAo/CQaUbzEoUGOvo1M5/Xy5njSswsNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ziCMny56odTBFGoaUY2eM1tF4hqEWjr5YywCUE31eqAtma2u9IJsOjKmS6sJzoWQk
	 L2cNNhyMmDD88Gmd/1YTFOHaYj0IjYDmp37CB09Po8yAortDAQT2sEW8p/r5yxo8+0
	 bFVhIoI4ZX9pDSmgVkagZ5HWXKcNSQRGAWxkuYXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2135/2214] net: usb: cdc_mbim: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:03:31 +0100
Message-ID: <20261118150135.937157016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e795e3636f7db..47acf7552efcf 100644
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



