Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A0D2343D2;
	Mon, 23 Mar 2026 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275354; cv=none; b=eK4hButazAOgj1cncsjE/Bhvnmc0M1Ekjfv6p4e3J5Fia4WsmHcD8IRnh6xhuibaqv1tqdrcsUCEAFSYYTdxzpnf1CXF7BXZLvh84X24FRwiQUHS+T6BT1AwpkqUhRGAr7AsJa/6OJd2/B1t6B4irWpxzh7kBwfgdLTmudRFQHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275354; c=relaxed/simple;
	bh=HHdRa1IM8ETrjbSK7Irhc3E0vYFufTMMp7dVSaE9ajk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhJXf7IFPIe2F1IMGSsUhpJ2Biil1oezxAwPuyOu3I+G/EcrZXvidCGbrm/wzZ30kjmoz9m/JZwZ7QGEsJphD14a43x6x7i9QRePoMxsgQJJdQNLIXvCr9Cocd3ieDsnPQrnRPMtS7lEi1+YDWMtEjmeVY5HHaj1xlNvq4QW6ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opRUdpr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opRUdpr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2AFC4CEF7;
	Mon, 23 Mar 2026 14:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275354;
	bh=HHdRa1IM8ETrjbSK7Irhc3E0vYFufTMMp7dVSaE9ajk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opRUdpr3w4bpMS0Kjb43cavujo25dRAT63N9V1QTRlJS+xDsjgArDo1TAKk7zq1Yh
	 0ag0gtZDFYkwQQ4gK+jQIiFHWAxVPT5F4uXfejh4pVIr8H5Z5r/49YcREAmrKwxRB1
	 HHW009GZSjOxyrBcFFPv/OB2KKKtDjmzHMhYzj0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/460] regulator: pca9450: Correct interrupt type
Date: Mon, 23 Mar 2026 14:41:05 +0100
Message-ID: <20260323134528.394494689@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1ffa145319f23..2a0fac873f9c1 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -965,7 +965,7 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
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



