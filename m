Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971EC1F7582;
	Tue, 17 Dec 2024 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455620; cv=none; b=Olj6tDtmKSxrhuUvlKG7T5gtm9nC6brFaF0Qn+Ta7LvUbZJPvcRpnDRggqu6DGpdDzr8aH6S+BgHPgq1vtAWzotuf5jfIW9+jTX6ztPN4YZ8ArSIzKPOO0dS1RxjU2Fw9O2EFp05dJI918Mnb20bpS3HFPoGQPIqGv0E2/uTTpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455620; c=relaxed/simple;
	bh=tB7a9Q5Sn0mSArZ+7BPfcJMc8dDHSFGVJoDXNwbYPaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjIVTbzAjiZpmAeBDdm4cxw2fqUntX1iF9mw12oqlmYJzHB6g5csqke/0MiM2NAVsjBdbewY101xpzhA7pnrnWDf51tiaD4J98Xq4Av0Fles8yuO3kW4fF/+IopBC6MfG7gQfBVZbGTXRG0r03sGEJF4HQ4RxkA3Hhd5Kb1Zoso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsHs6fFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsHs6fFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D3FC4CED3;
	Tue, 17 Dec 2024 17:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455620;
	bh=tB7a9Q5Sn0mSArZ+7BPfcJMc8dDHSFGVJoDXNwbYPaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsHs6fFfj5v+Dob4SVm/019FtmCuh4aXZxPwaX1mdaNG68FNVmiPEqQq8LzXgunvu
	 CU2pYLyDcJiTIPBNFaYHvJh0TOnaYRaa0LP6S5GDbDJ8zWsLm29+dPWLWm/a8utm3a
	 ymAyHxMdTVVmDgfCDpM7pR5/RspZXTLUtbtLZ4XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/51] net: sparx5: fix FDMA performance issue
Date: Tue, 17 Dec 2024 18:07:21 +0100
Message-ID: <20241217170521.444917128@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit f004f2e535e2b66ccbf5ac35f8eaadeac70ad7b7 ]

The FDMA handler is responsible for scheduling a NAPI poll, which will
eventually fetch RX packets from the FDMA queue. Currently, the FDMA
handler is run in a threaded context. For some reason, this kills
performance.  Admittedly, I did not do a thorough investigation to see
exactly what causes the issue, however, I noticed that in the other
driver utilizing the same FDMA engine, we run the FDMA handler in hard
IRQ context.

Fix this performance issue, by  running the FDMA handler in hard IRQ
context, not deferring any work to a thread.

Prior to this change, the RX UDP performance was:

Interval           Transfer     Bitrate         Jitter
0.00-10.20  sec    44.6 MBytes  36.7 Mbits/sec  0.027 ms

After this change, the rx UDP performance is:

Interval           Transfer     Bitrate         Jitter
0.00-9.12   sec    1.01 GBytes  953 Mbits/sec   0.020 ms

Fixes: 10615907e9b5 ("net: sparx5: switchdev: adding frame DMA functionality")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 174d89ee6374..ccfad6fba5b4 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -647,12 +647,11 @@ static int sparx5_start(struct sparx5 *sparx5)
 	err = -ENXIO;
 	if (sparx5->fdma_irq >= 0) {
 		if (GCB_CHIP_ID_REV_ID_GET(sparx5->chip_id) > 0)
-			err = devm_request_threaded_irq(sparx5->dev,
-							sparx5->fdma_irq,
-							NULL,
-							sparx5_fdma_handler,
-							IRQF_ONESHOT,
-							"sparx5-fdma", sparx5);
+			err = devm_request_irq(sparx5->dev,
+					       sparx5->fdma_irq,
+					       sparx5_fdma_handler,
+					       0,
+					       "sparx5-fdma", sparx5);
 		if (!err)
 			err = sparx5_fdma_start(sparx5);
 		if (err)
-- 
2.39.5



