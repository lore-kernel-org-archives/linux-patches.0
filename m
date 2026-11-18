Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062082;
	b=WVWdsDfhyUVHnvPkPtG6vwqQu+Q5cwFQcw+uurlZUwbTchkxay+HMGa7dVRan6Zs6LXS
	 NAcquO7aUzR4ZZVAOZY93gargQxQHs7eTXVoeOPoevaOhkdD9sQl+caWxNM5FwJ9baKlI
	 tsCHAd9vD9DrKe8ke5cg7daMGM8Y2ZSHFVv+CEc8sfidq0grqiaBuMR4MqhWqauWOfUA+
	 LvYyA6UcqITBpw9CPzvI8C/4mJb7N1QXaSAV9+jbJtQSWrmVcc6u/6qyK4SZQJcIQP7ek
	 OnadiUqpI0vBc38MlbWUjlxUO1CsBTgMR0hpCsgpX9XsJs/yFBnJi8afzSoNj30OO4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jnkavBKBLHDU1nv0kiA4nmbWp9T0HpXBTp2EwWpGtmI=;
	b=n/r+dLDyRC8IirsESuVrCmMf33dP4SqagJv53Gmt00h34sqU/2OyuSZ8iAFtq/wcgWfc
	 RGmflpirgKw4tOWuYFiaZkDPnwmRX2xCbsJt1OEt5kKuKxtVEkCQ2Qaa7p4ITwGNZIrx1
	 YMDbbY3LDIZ1sX/o7hIwF2nR07VqPTInPwz9CVaq+I/QuItHO/vyAdSTWL9Irm0+AOMkB
	 RhWr7pFfSssss+xUoE2YWlOzoIdPDwW0IOt6h7XXIlooWfkJGfzA2m1ZVRKiJ+WkCFXiO
	 BGCszAp4ewjrY7/2rMFdPy6iN/OtmQG0yYo6HG8roCCc0xSHyU5AL03ogDTPzEcAkRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XVj4cAND;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9768606A32A;
	Thu, 19 Nov 2026 04:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XVj4cAND
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C661F000C4;
	Thu, 19 Nov 2026 04:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062082;
	bh=jnkavBKBLHDU1nv0kiA4nmbWp9T0HpXBTp2EwWpGtmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVj4cANDq1zHadcCt0qKORcmKkjethgJpjS8zbtjLHKy+JG3eJia0DLxno9owUYAl
	 PYGFC2+A1QQy8Z6GF/3UZitBPzYpZI2W7qn25BKZ3EoDL70W6FJYMbDx6Z5s8KA/so
	 DyjDWHYkY+8EESqiwNsNrbZE+hngCbLnusw5bbdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1784/1848] net: usb: cdc_mbim: dont enable BHs in tx_fixup under netpoll
Date: Wed, 18 Nov 2026 16:03:42 +0100
Message-ID: <20261118150034.014692677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e4f17974644f0..b59a157c04724 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -288,9 +288,10 @@ static struct sk_buff *cdc_mbim_tx_fixup(struct usbnet *dev, struct sk_buff *skb
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



