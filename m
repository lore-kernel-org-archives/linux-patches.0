Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2276F2FFDEA;
	Tue, 17 Mar 2026 17:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767535; cv=none; b=Nrb4Ikowada//H9SjNuhkMMKD6h6QCDpBi2WII/ufAduYGoM4/LAEQ1ZOZF7Wkn01kio+B/0dFuH2/E1xWHSxYVTkEaFfaUDScP6GOzY6EYUpCdfypJHm9BKVQK5LEPdAxi/Tzn8s8TrWp7ZsLvHS/W5eU7WeBviA2KVbdNQ1gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767535; c=relaxed/simple;
	bh=NSW3CwxQPBv9t/Uk/B+JyTdHyZGPvk0C3E+h7uoVVEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoipmP+tYMjKoWGptjcrck+V0oWcINo0FTML/DXb0rqpBUuagRIjjL6vjQzFSLwjbLF0FL8++Qh2aE2gyDtAVqDcgwexV/tVXPtTTGJ+H2ldrfw41HH8BWochhtih0gZTIHCFN5EidgE66eL2j8uGQykpCixYCXaHgrrB2Yz3x0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIB6Jqy5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIB6Jqy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210ECC4CEF7;
	Tue, 17 Mar 2026 17:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767534;
	bh=NSW3CwxQPBv9t/Uk/B+JyTdHyZGPvk0C3E+h7uoVVEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIB6Jqy5bncAsSv0BQPNufkPRIw43AMfUWO81zQCJa7zY8Iy3RhGWpBmn7yojaYrb
	 eB9utDl/wvRbyOXj7XclEAFnFkKcSsBRMjzZ5SXYNPmpMSSSD4XAygUDA6aw2zTNMi
	 ngk8bLwTBrNrlxJUfc6ICv70Ez2Q7R4cs+VdETrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/333] regulator: pca9450: Correct interrupt type
Date: Tue, 17 Mar 2026 17:31:43 +0100
Message-ID: <20260317163002.120295155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 91b96dbab328b..086ea88413828 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -1203,7 +1203,7 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 	if (pca9450->irq) {
 		ret = devm_request_threaded_irq(pca9450->dev, pca9450->irq, NULL,
 						pca9450_irq_handler,
-						(IRQF_TRIGGER_FALLING | IRQF_ONESHOT),
+						(IRQF_TRIGGER_LOW | IRQF_ONESHOT),
 						"pca9450-irq", pca9450);
 		if (ret != 0)
 			return dev_err_probe(pca9450->dev, ret, "Failed to request IRQ: %d\n",
-- 
2.51.0



