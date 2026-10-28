Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208554;
	b=wR5Kmgkj5aj37gIvyYayikhkiuRAUsqMwYOfxyfRz2QPblwrRS/TRZTzt2BRUxhORQn9
	 uudnyHvne23mgniAsSs/HiqD0p/NwUy3vLlltghBW/hEe9OBZD0BdPVSLLmnxQhA4quAs
	 sHt1z1iW5eVrPNSXSF4TV0lEBaZJs0xCE10BvkinSd6BSCRsnNOjO2fuoTkawMQPiRk42
	 ea3lEwxTgyn2JAq3W9LcWFWfmM2ezFkFa0Ei9axE3aB12eV0xUubVPVw2kBqz4yBe1F8u
	 lNWuyLlSXxS7WrRKyb92j32Qn6gWhz659rhfzp+D37Ix4VbxmO0QdDRAEFFhs5jYP2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GRa9E6Do3CarecCSM4ZyMQS6jUnh08NFjrv6A1Qe5T4=;
	b=JQyR1XUyyjOMOtaRgHGnT8QWnYIQw8X4GTHh9Uw85mYjqF1V9BhH7tv5NcWm1x6Visvv
	 uwd82fwRfEUoebwr3y4kjOO3DaWxeOQfXmLaLsL7qJgLwZcXMhbWRSNUtcntMRWR5umRS
	 wslduDN/dAJYqK/HQmaRiactDR9lJs6UUJE3UKOHxem5ZXASDPwwkahbUfFccgI7G7/Qk
	 UMiMrMkkswu3uF/PLC2d65f8FLUgLdZ2Q1YlXhauEYIDhaA5IFOzwMdwyYx69Hne8zvHX
	 UX+vunIsCSmBugCslMjFTdTQTqCibg1wPCMscOSE34SRMri2pjJmSPHy7uN9/6Zr/hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g2IDAC3M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C60606A31A;
	Wed, 28 Oct 2026 17:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g2IDAC3M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155421F01825;
	Wed, 28 Oct 2026 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208553;
	bh=GRa9E6Do3CarecCSM4ZyMQS6jUnh08NFjrv6A1Qe5T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2IDAC3McE6433s1lGHm+P/k5q7NxXkbw2jQvRG6RQikp7tNsmk7sU5+mcjLOknse
	 LglCtxUUpMbJ7deHk/t8aRv+luLiSB0HtC2XELIRHVa9wzQefCPe2Scyjwf99E3pMP
	 AfT0aeNkt5aGKCl9bjgsFZckzNnX3qmTjcoZ1Z9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 143/516] rtc: spear: initialize IRQ state before requesting alarm IRQ
Date: Wed, 28 Oct 2026 17:54:55 +0100
Message-ID: <20261028170006.896555672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 055ef5ce9f67a6a3a1363fa663007f8196cc0fb8 upstream.

devm_request_irq() enables the interrupt before it returns, so the handler
may run while probe is still initializing the device. Initialize the MMIO
address and spinlock before requesting the alarm IRQ.

Fixes: 0942a71e435f ("rtc: add support for spear rtc")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260902080318.3498434-1-runyu.xiao@seu.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-spear.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -360,6 +360,12 @@ static int spear_rtc_probe(struct platfo
 	if (irq < 0)
 		return irq;
 
+	config->ioaddr = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(config->ioaddr))
+		return PTR_ERR(config->ioaddr);
+
+	spin_lock_init(&config->lock);
+
 	status = devm_request_irq(&pdev->dev, irq, spear_rtc_irq, 0, pdev->name,
 			config);
 	if (status) {
@@ -368,10 +374,6 @@ static int spear_rtc_probe(struct platfo
 		return status;
 	}
 
-	config->ioaddr = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(config->ioaddr))
-		return PTR_ERR(config->ioaddr);
-
 	config->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(config->clk))
 		return PTR_ERR(config->clk);
@@ -380,7 +382,6 @@ static int spear_rtc_probe(struct platfo
 	if (status < 0)
 		return status;
 
-	spin_lock_init(&config->lock);
 	platform_set_drvdata(pdev, config);
 
 	config->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,


