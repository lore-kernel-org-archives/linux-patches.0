Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061176;
	b=aD6ExUAmFnj0qxKcTfL4ocO6BX9A2x+Bw5fR21VnrbAH2IrQGQ5rVrKSgD0nLT2gHNvl
	 zTAjK7R7JYls140KCNl6QI6/5SQhOxUQ4lhR6Ovsjn4TkgIhwiR88k1T5S0AecEvL5xlj
	 v1rNy0Zm/bhaQdjBxwzFTLECTAbP8m7qz1Q6TXCBaRYayCZNcex9N2wXZYQiX6yqp82iV
	 RwR4Dt42WUSBswmzxmcXXIVbXb4zhWR0NeoWqStml2coW6cszOBvFjtxmytfHMRxhrwZ4
	 is2bPJYGtX6cA+vAiItd568oUukgpElVFDnh0cB7vd3VeQVSI3C5uuaFoOL4O39l21w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E9DLgDQXEK+K6WhVungqsAb3Q1pyzHTeLvIhJtVRku8=;
	b=wbe5997rXauHxJZ3CwUs7RVUKeWMaOyjIfQO1Y8hkgC5ihz64qp6tzY4Fwyh7Pb2Ner+
	 j3Aj/L60WMELbs5IEZxDS0CsAOhHZ5qqwnorqv2vvWp58Lae+BoLlW9bln5pRCq2Np69S
	 ERsWHfVuyX20k/BdUc99LMZbcntDQo7wpg5SU/9pbh48k4l6rY4MG47BQo5G/H63DXT3w
	 C28XpNKA12y2ghmxZVNgTlrb7b3gwdTEu2PQgES9vIbjFuZ9tD2pToBJyctqo07PtOVBu
	 WwH7Ev5RCcc1XrEn5dDfF6fFSAP1XUgXmemUSNspXm0vNTEtGNXNxYj1BCq7s2ScDBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UF+ZNYhZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9C6606A325;
	Thu, 19 Nov 2026 04:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UF+ZNYhZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7791F000C4;
	Thu, 19 Nov 2026 04:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061176;
	bh=E9DLgDQXEK+K6WhVungqsAb3Q1pyzHTeLvIhJtVRku8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UF+ZNYhZsqsa8Th76n1jkprq9KIIAthA0m8BKFgB3TxeCaEm+J1I4pGHtjuYiUmf/
	 apfOi7GzrJxzjqFsK/+ONmWVgUX1isQXw+KijlLfZCRzyQQZ+IC7ss3qXATvcpeLlK
	 KDeHt84paMxruoyAW4rPErYk8QucVur9nNZ8p+AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Cooper <codekipper@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1457/1848] power: supply: ab8500_charger: Oneshot threaded IRQs
Date: Wed, 18 Nov 2026 15:58:15 +0100
Message-ID: <20261118150020.371843914@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 532b623f3c86d5166a8bb8acaa94fc3629d8ba97 ]

Make sure the threaded IRQs requested by the charger are
flagged as "oneshot". Usually this is what you want, and
since the interrupts are shared with the USB phy on the
AB8500 we will get a conflict like this if we don't,
since the phy request them threaded oneshot:

genirq: Flags mismatch irq 83. 00004084 (USB_LINK_STATUS
  vs. 00006084 (usb-link-status)
ab8500-charger ab8500-charger.0: failed to request
  USB_LINK_STATUS IRQ 83: -16

Cc: Marcus Cooper <codekipper@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Stable-dep-of: 1098c619ce75 ("power: supply: ab8500_charger: Handle detection errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 8dadea5d158eb..2c8ea8d833e74 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3612,7 +3612,7 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 		}
 
 		ret = request_threaded_irq(irq, NULL, ab8500_charger_irq[i].isr,
-			IRQF_SHARED | IRQF_NO_SUSPEND,
+			IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
 			ab8500_charger_irq[i].name, di);
 
 		if (ret != 0) {
-- 
2.53.0



