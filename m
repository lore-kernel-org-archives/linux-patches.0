Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D75259CAD;
	Tue, 25 Mar 2025 12:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905789; cv=none; b=EK02KgUab346jLzHrI18awfZvioRZcJ+PHrZGu/U15yu7yoMc6zMAU0fEIaaePmyRsuylC+3xWwJqXFrnP4JYIT1ERxy8nIwSWJjMGHb/LlyP8dtNYrqF/SCpJYzkQNH6cbLS0dBBYgQIMhwrP6bgRz+kl7o1boIeuHoL9l+D+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905789; c=relaxed/simple;
	bh=cdUZhuh3o/M4EFP256WNDJUDyKOOMkmdjQYMJB45bW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUO1HV4wsnKYFoG1orQqNtR5JjsZsX2pnIr2B+0AOz2uhmFmsoc3mREnXwROZp8aRK4jiqtIpmiIWZNStTayP5a19Eu5MfUld+AEWKnK4v8ViPMmAhFlpx7k0ceNAesME8BLZqYajRIMsrn5g/rR/xXGwXA1u2Aw+dsS/8Ww/Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3OX6F4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3OX6F4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592F6C4CEE4;
	Tue, 25 Mar 2025 12:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905789;
	bh=cdUZhuh3o/M4EFP256WNDJUDyKOOMkmdjQYMJB45bW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3OX6F4di8H0+5AiBQs1p6yiDfOBkYo9p7WyWLARVQBxvWuyOLxRRTOHZdPZYOxkJ
	 r4wyESe8n89dRDoIDsqXDrJP8KkD2+WEjg4n18uEcIUKRbOImCRiWBVq2HZrrl5jmo
	 1qYoDBa9ry0pX2FGSixmf1ySpo8si+V/tt7HIgbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/198] net: atm: fix use after free in lec_send()
Date: Tue, 25 Mar 2025 08:22:06 -0400
Message-ID: <20250325122200.955017871@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit f3009d0d6ab78053117f8857b921a8237f4d17b3 ]

The ->send() operation frees skb so save the length before calling
->send() to avoid a use after free.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/c751531d-4af4-42fe-affe-6104b34b791d@stanley.mountain
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/atm/lec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index 6257bf12e5a00..ac3cfc1ae5102 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -181,6 +181,7 @@ static void
 lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
+	unsigned int len = skb->len;
 
 	ATM_SKB(skb)->vcc = vcc;
 	atm_account_tx(vcc, skb);
@@ -191,7 +192,7 @@ lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	}
 
 	dev->stats.tx_packets++;
-	dev->stats.tx_bytes += skb->len;
+	dev->stats.tx_bytes += len;
 }
 
 static void lec_tx_timeout(struct net_device *dev, unsigned int txqueue)
-- 
2.39.5



