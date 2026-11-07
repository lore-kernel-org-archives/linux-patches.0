Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063409;
	b=qCpMEOfUE3c+GcMlrQKhhOZ1wy7XEIijmqdKZdpL2x5poQs10jO7zBKZAmwfKxpdS9Zb
	 LCYKybaL8Dazj0nL/KMjDYkS8DR1A3XUVqaj0RR1VIMlNnlao6AFcp14acVHaE7Ly6TeD
	 xkPfyVRzRKlhVjJG7+rZZkcCW9G4V+V1n9TwcJ8vhPPMojh6cNNGH7VTBRWH6RJCfwFCR
	 2HY/pzvX5LdH6MGqu8Ao2JXi5qY4fJ74zW35ZdekKNv+Zg2Z/tNvVT7anvYyK8cK0G3Rb
	 ndRU0T2cGY8d18/uNffeJG37+Ow3wVCgI/GfOcqBJp0u4a5aW+vfr//dtiDXWvmMs9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7IPYM53Ps9luV2idogAEgANlPWCdz4bEPUVAsf2UleE=;
	b=L+n9Sr67dcLA22Ec36w/yfi9vchxlgF/SYwjui5QwupLBkABXOk2/sIMX59UCwN5q74R
	 mqTkAzYIC3avb8A+5g/G4W0YrdgrpyzpvW6hB3Www028cuENi3svX0Lq7uYMZTVvDNq83
	 jsgto/4AnQz7IJwNVdux3Ve/fAEpqxmng/0ZUMJN7uMeSHpQenn1UmvqwDKxrVKyG+tkE
	 6dv8W676D8JbQpgfUe/Uf94iy+5XKP3UywZNlEobXmpXq3l1xYXo+ELzmbzroRsKPpQzW
	 LhL1SW0xM5VpbgbZeBZtDxvG7Uyk2Y3zMdHajQmSpkLJA6SpeqS+VN2m3mvi+Dfe80Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jf496xWT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645206082BF4;
	Sat,  7 Nov 2026 14:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jf496xWT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2F91F0089F;
	Sat,  7 Nov 2026 14:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063409;
	bh=7IPYM53Ps9luV2idogAEgANlPWCdz4bEPUVAsf2UleE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jf496xWTXfuvmr03Wor7899PdrVVy+73MVjNKY8U3/jLcRWQ5t/znr7gjxKpwaAMH
	 Zg0dPAgc2B96hdHAnVu1wXkecTfy3AJInp/i4R6wdBbUknr3cRGhhr+NjDwmi6GLL1
	 d06xsFT0S6WvXumwP2PD2OuaPFa8ePt6EvjdGAfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 578/869] irqchip/mchp-eic: Fix clock reference leak in mchp_eic_probe()
Date: Sat,  7 Nov 2026 08:54:20 -0500
Message-ID: <20261107134912.796952819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit af9c707eb065a7d48eb92dc15acdb4346acf5db0 ]

of_clk_get_by_name() returns the clock with an elevated reference count
that mchp_eic_probe() keeps for the lifetime of the driver, but none of
the probe error paths drops it, so the reference is leaked whenever
probe fails after the clock has been obtained.

Put the reference in the error cleanup.  The clk_prepare_enable()
failure path must jump there directly as it cannot call
clk_disable_unprepare() on a clock that was never enabled.

Fixes: 00fa3461c86d ("irqchip/mchp-eic: Add support for the Microchip EIC")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260916190349.2094401-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mchp-eic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-mchp-eic.c b/drivers/irqchip/irq-mchp-eic.c
index 31093a8ab67c3..82cb0513bbb8d 100644
--- a/drivers/irqchip/irq-mchp-eic.c
+++ b/drivers/irqchip/irq-mchp-eic.c
@@ -233,7 +233,7 @@ static int mchp_eic_probe(struct platform_device *pdev, struct device_node *pare
 
 	ret = clk_prepare_enable(eic->clk);
 	if (ret)
-		goto unmap;
+		goto clk_put;
 
 	for (i = 0; i < MCHP_EIC_NIRQ; i++) {
 		struct of_phandle_args irq;
@@ -270,6 +270,8 @@ static int mchp_eic_probe(struct platform_device *pdev, struct device_node *pare
 
 clk_unprepare:
 	clk_disable_unprepare(eic->clk);
+clk_put:
+	clk_put(eic->clk);
 unmap:
 	iounmap(eic->base);
 free:
-- 
2.53.0



