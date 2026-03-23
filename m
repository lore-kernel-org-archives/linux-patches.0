Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1262B3BB9E8;
	Mon, 23 Mar 2026 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282512; cv=none; b=hERGMZegikuLouSJfpdChq+8lSEVQEEEE6iXoU98nRvTYV+MkVxhgjHWyLmVVxR0T7KlgDnTktbSvKKNh54tBpvs3/kb5PODC1VjJOJBUtfzrKkhE4lKsK/5k8PoRBDvxXF1QGUEnTt4TC9TYpDrsfjlFpQgbu9U1rewdGdy7Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282512; c=relaxed/simple;
	bh=umHeD6cZM720wCRKv2N2IcyQ9xhcTPbxcM052ybsTvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z0SLZb8eLaG3Pa3aLwBiYU5+viaIVisdMqdOQq18mnxVNIusKNjleXB5IjgAagjuj1x9utEv4UfxlyXBWxbsmxEKJVljZCKd8iqhOYT+Zxji30q1cgUQZE/8QWK7Nisa0GepUfRUcXWkYmyACb6Qoegl0XruY8oBG8E1p89YTXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ps6eSB+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ps6eSB+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D988C2BC9E;
	Mon, 23 Mar 2026 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282511;
	bh=umHeD6cZM720wCRKv2N2IcyQ9xhcTPbxcM052ybsTvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ps6eSB+VRcDU8bB/x6PnMnWn4zhe+e12nlg/HvFU3G4OFWE/05OTkADZw/zp59Bph
	 U2M7l0+dYy9RuWFOe1qikgFhyp71mVElobAsjytvPYncXVHNk/OMQkkC/pt+RoG3xK
	 bx/fUS1gSyGM5Oqxsoq1jvq2kSEUv6Bt6OBoaPD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/481] regulator: pca9450: Correct interrupt type
Date: Mon, 23 Mar 2026 14:42:44 +0100
Message-ID: <20260323134529.642937842@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 5d0efaf47ee90ac60efae790acee3a3ed99ebf80 ]

Kernel warning on i.MX8MP-EVK when doing module test:
irq: type mismatch, failed to map hwirq-3 for gpio@30200000!

Per PCA945[X] specification: The IRQ_B pin is pulled low when any unmasked
interrupt bit status is changed and it is released high once application
processor read INT1 register.

So the interrupt should be configured as IRQF_TRIGGER_LOW, not
IRQF_TRIGGER_FALLING.

Fixes: 0935ff5f1f0a4 ("regulator: pca9450: add pca9450 pmic driver")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260310-pca9450-irq-v1-1-36adf52c2c55@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 8848afa48598f..7922af4f7895b 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -782,7 +782,7 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 	if (pca9450->irq) {
 		ret = devm_request_threaded_irq(pca9450->dev, pca9450->irq, NULL,
 						pca9450_irq_handler,
-						(IRQF_TRIGGER_FALLING | IRQF_ONESHOT),
+						(IRQF_TRIGGER_LOW | IRQF_ONESHOT),
 						"pca9450-irq", pca9450);
 		if (ret != 0) {
 			dev_err(pca9450->dev, "Failed to request IRQ: %d\n",
-- 
2.51.0



