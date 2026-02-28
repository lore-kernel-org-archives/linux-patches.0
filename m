Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC62383C86
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302173; cv=none; b=oiWJ2f+t9MxK8Y0i766pssO25agGjyXXYdzgCF0JC9zi9BtB2zLfxpCCHO+j6H1tH5ZJ0sitAnF6ndS4uJCEmYncVX4yMp50DhowySCX+gqBSts6qhmj7UTDXsjxkq/TKKpc4/Q9wpGtApKYgck7/iybpHIfVIngQ+l6NbJUojc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302173; c=relaxed/simple;
	bh=kZi7OZe27VLaOkSuUngfm8ZQ5CdSQVVe8NPz2POfPh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTSNywdE07/CUd4OByy3sDG4ilck5g4XYEAukvwJGv9GCJG63s76+wY/0+tPL04ymlPgfqeYd4+nmUl9eqf/V44fHF7TMk5f28aUN1zhq241FVjQHWqBvD9XHIaKko1PvwSWpuniQIbqZKY4jYithmL8ezH2WBGvIqmCMEDqhlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQDXD57O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQDXD57O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC84C116D0;
	Sat, 28 Feb 2026 18:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302173;
	bh=kZi7OZe27VLaOkSuUngfm8ZQ5CdSQVVe8NPz2POfPh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQDXD57OCUSv6exRrulZ/3P9U19RcieTZhoM2dJpJaERKVVraEjoDHuWLngChKFPI
	 XDFqXdJ19Aea4cAEfjblzrt1xINcKFPVr03ebg9adzUth5W2I36TO/6EadgOwaa/DZ
	 4IZQKgRFUhtlRnvG60b+At/5ckykkWD07KJMJCaasJVfSeOvGeBU3IL2cFA+cz2lin
	 BSOm5zLue1e1iu1Er8zBkG9GRrhMq7T+W7dxrga/9MPL81XeBWNXIIxdkoupMtU26I
	 JHU+NfHV6zjdERaIbmvB6FnKa8lfcqszzPDxMtRKZ41ssvFJn6cLvupZ1vUsTt0d0T
	 xffTqk+7nrOgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/283] power: supply: act8945a: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:05:13 -0500
Message-ID: <20260228180709.1583486-171-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit 3291c51d4684d048dd2eb91b5b65fcfdaf72141f ]

Using the `devm_` variant for requesting IRQ _before_ the `devm_`
variant for allocating/registering the `power_supply` handle, means that
the `power_supply` handle will be deallocated/unregistered _before_ the
interrupt handler (since `devm_` naturally deallocates in reverse
allocation order). This means that during removal, there is a race
condition where an interrupt can fire just _after_ the `power_supply`
handle has been freed, *but* just _before_ the corresponding
unregistration of the IRQ handler has run.

This will lead to the IRQ handler calling `power_supply_changed()` with
a freed `power_supply` handle. Which usually crashes the system or
otherwise silently corrupts the memory...

Note that there is a similar situation which can also happen during
`probe()`; the possibility of an interrupt firing _before_ registering
the `power_supply` handle. This would then lead to the nasty situation
of using the `power_supply` handle *uninitialized* in
`power_supply_changed()`.

Fix this racy use-after-free by making sure the IRQ is requested _after_
the registration of the `power_supply` handle.

Fixes: a09209acd6a8 ("power: supply: act8945a_charger: Add status change update support")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/bcf3a23b5187df0bba54a8c8fe09f8b8a0031dee.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/act8945a_charger.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/power/supply/act8945a_charger.c b/drivers/power/supply/act8945a_charger.c
index e9b5f42837729..e9cb06daecea9 100644
--- a/drivers/power/supply/act8945a_charger.c
+++ b/drivers/power/supply/act8945a_charger.c
@@ -597,14 +597,6 @@ static int act8945a_charger_probe(struct platform_device *pdev)
 		return irq ?: -ENXIO;
 	}
 
-	ret = devm_request_irq(&pdev->dev, irq, act8945a_status_changed,
-			       IRQF_TRIGGER_FALLING, "act8945a_interrupt",
-			       charger);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to request nIRQ pin IRQ\n");
-		return ret;
-	}
-
 	charger->desc.name = "act8945a-charger";
 	charger->desc.get_property = act8945a_charger_get_property;
 	charger->desc.properties = act8945a_charger_props;
@@ -625,6 +617,14 @@ static int act8945a_charger_probe(struct platform_device *pdev)
 		return PTR_ERR(charger->psy);
 	}
 
+	ret = devm_request_irq(&pdev->dev, irq, act8945a_status_changed,
+			       IRQF_TRIGGER_FALLING, "act8945a_interrupt",
+			       charger);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to request nIRQ pin IRQ\n");
+		return ret;
+	}
+
 	platform_set_drvdata(pdev, charger);
 
 	INIT_WORK(&charger->work, act8945a_work);
-- 
2.51.0

