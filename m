Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79DE35AC38
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302723; cv=none; b=G97XqODbE5cZCQ3vwu6GgpeJZzqF/lmG6sL33Xa9yEMgkad836FBXrr0aTVtwBsd7cI5novm3MjUK84Y4mv+EC8NDD/VHEYKQ/13AuCpg6W0HPh5O4MtZAi2/iLmbKKiO73GqW8BlmZoGh3b5d16A+w9tJzb0asx5BSyomO5VZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302723; c=relaxed/simple;
	bh=dRzv2RxLXz5ZLUILogWL4amW/1BmOTX263qwNH0UcLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8RzSX5vbJXS9KH/3DzVxHj9DwYwLVUBSckRnpld5qFwsRaxIlwLadUdN105v77ypd81MShtFn5zK+50XuPhwUh4uUawHMUpUDg2fal6msnLQId5WbXoHbAI8Sr4xt0QMlp5YCATerduXcPdTdtKZPaF2CqsXX7+95KSapCeFJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8mL6SXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8mL6SXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A9CC116D0;
	Sat, 28 Feb 2026 18:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302723;
	bh=dRzv2RxLXz5ZLUILogWL4amW/1BmOTX263qwNH0UcLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8mL6SXU2pcO43vh0I1cW2Cw6e8k2JDf/fTlQuOoUPqK0IZLstc/GSwOq8R25suQ5
	 syzz1nO2yCrMl52CgZKc1rrJpZ08d9tBGaseRHeRuLFvProyx+OevT7oBY0JdRgVC9
	 Mf80DjbXdzf8i0FtwOwR6pv42j9hIj1vsF5UJtXPtduzBcqWxWbX1URKTF9vhqWlnL
	 GS9vrxog09Q42rCDNNR+qnJ4ZPipUWr1mvAySqHtB+Ck4Ji01fGDR2ZWlzAoGwtzmv
	 z8aULZ3pdszTc9DLPLlRfVBH8JPGqEOmDz2FoUYZZYQirzzPHhbldqG8oFcCix+871
	 rfqd2xYSeNm7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/147] power: supply: act8945a: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 13:16:32 -0500
Message-ID: <20260228181736.1605592-84-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 5f3eb6941d058..a12cbfeca1123 100644
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

