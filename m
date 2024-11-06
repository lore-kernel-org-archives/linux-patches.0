Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3921DEFF5;
	Wed,  6 Nov 2024 12:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895199; cv=none; b=kNbG/TZmLFlnuMm+oHWcTJHyoPv9VknVogaYQDh2FOf/XzdWUef60t5m92gUzleZTawQ6HPBxEV/S8ar6uCfo5UYkRbJ6NOe977u8hN0yIzdR1Yl5K2gMUFJCQOc5H9peV7+r+zfAGa/QIS/dQ2AQocqeiHzRaMJWDOKw+ksGWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895199; c=relaxed/simple;
	bh=DQWTTBVYYY2Zdv3izqE34yHM9pR2W2cXuq0oErquVzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PplBs5aZ8KeZ2YVchV1bOkLXO594Z/Mj7e1CGj9U0h6x6WPjnV8JdeDm1f+RAMWOXVMqnbt2Z5wUNX3lIWITr9tLbDDWaWPhgHf72w0hjzh1JEkMVJFxBOwGMJ1VXK3U3hSDYK1EvWdfBFWGZXdmudLbQv+c+xEUMv+e2vUxbPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxCRjFBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxCRjFBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B05C4CECD;
	Wed,  6 Nov 2024 12:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895199;
	bh=DQWTTBVYYY2Zdv3izqE34yHM9pR2W2cXuq0oErquVzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxCRjFBeLnZJlym1/668XRWCS4O49MjgsZ3NxBpRqVODT52gJ/xvX2R/q96qBReek
	 oMkKCX4JB7R0S11FV2xSM3GmTyXz63aHyz4Dbug7NsWskd5whywwfsWIL64Fxr9eTF
	 m6HoJ3RE6WxX6vlR9VLUk0x1fdV+52hCuri6KiCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 138/350] net: ethernet: lantiq_etop: fix memory disclosure
Date: Wed,  6 Nov 2024 13:01:06 +0100
Message-ID: <20241106120324.317659525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 45c0de18ff2dc9af01236380404bbd6a46502c69 ]

When applying padding, the buffer is not zeroed, which results in memory
disclosure. The mentioned data is observed on the wire. This patch uses
skb_put_padto() to pad Ethernet frames properly. The mentioned function
zeroes the expanded buffer.

In case the packet cannot be padded it is silently dropped. Statistics
are also not incremented. This driver does not support statistics in the
old 32-bit format or the new 64-bit format. These will be added in the
future. In its current form, the patch should be easily backported to
stable versions.

Ethernet MACs on Amazon-SE and Danube cannot do padding of the packets
in hardware, so software padding must be applied.

Fixes: 504d4721ee8e ("MIPS: Lantiq: Add ethernet driver")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20240923214949.231511-2-olek2@wp.pl
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/lantiq_etop.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/lantiq_etop.c b/drivers/net/ethernet/lantiq_etop.c
index b41822d08649d..d492b8899d32a 100644
--- a/drivers/net/ethernet/lantiq_etop.c
+++ b/drivers/net/ethernet/lantiq_etop.c
@@ -478,7 +478,9 @@ ltq_etop_tx(struct sk_buff *skb, struct net_device *dev)
 	unsigned long flags;
 	u32 byte_offset;
 
-	len = skb->len < ETH_ZLEN ? ETH_ZLEN : skb->len;
+	if (skb_put_padto(skb, ETH_ZLEN))
+		return NETDEV_TX_OK;
+	len = skb->len;
 
 	if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) || ch->skb[ch->dma.desc]) {
 		netdev_err(dev, "tx ring full\n");
-- 
2.43.0



