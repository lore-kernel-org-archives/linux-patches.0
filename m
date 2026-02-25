Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1DF1EB5E1;
	Wed, 25 Feb 2026 01:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983368; cv=none; b=BONdfsfpvUbkz+GQlVwNirM5PRr31T1O0Osd1NCzw/6GWhSJJuMLgxL1Rqh2U2OaK7ipa/XNrdjJCDiAsLlbAwHAefA351R60cb6G02DM5amLE+iZUC0sCBdulzTErxeOYRJpTjmLDM/RL0nqmkNkn8b5455itCbeGJ/N4POkMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983368; c=relaxed/simple;
	bh=GOzk4/2xjuQ6uY+hG0q3yI4xOuArZILwOpqKoEXywuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0SK4iJzcWqsVrYWK3bThkgXsozmOAzrXj0Np3OUb8wORWCuKuvLrdAgJHese56nAn4V7Z9RJtS2lh4zgLFfA93Q8XgoQGO7gxptwcruy+auS6GkzGhXwauLfrMftK9j2WtinoRuktK9XTgsyr3THGp1Iw5P7sx+HomKxPi+eFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rk7sXhQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rk7sXhQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25961C116D0;
	Wed, 25 Feb 2026 01:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983368;
	bh=GOzk4/2xjuQ6uY+hG0q3yI4xOuArZILwOpqKoEXywuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rk7sXhQ3wi/55JTNSQsQQFmq8yBfwegBXLC+uDkeZhYcGEDfFawXUY8zgGR7DxX28
	 bThPB38NyMqCtgQrfn/HnsOLBTFIBIrQu4pXJ1aCMzXmxYZtnZkGtzvPhVH0vA3lsy
	 FR1xrqjLA3bnrX4zLgvZ/mTfu63WQrI7MBcR+aVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Nikita Travkin <nikita@trvn.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 494/781] power: supply: pm8916_lbc: Fix use-after-free for extcon in IRQ handler
Date: Tue, 24 Feb 2026 17:20:03 -0800
Message-ID: <20260225012411.925196326@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit 23067259919663580c6f81801847cfc7bd54fd1f ]

Using the `devm_` variant for requesting IRQ _before_ the `devm_`
variant for allocating/registering the `extcon` handle, means that the
`extcon` handle will be deallocated/unregistered _before_ the interrupt
handler (since `devm_` naturally deallocates in reverse allocation
order). This means that during removal, there is a race condition where
an interrupt can fire just _after_ the `extcon` handle has been
freed, *but* just _before_ the corresponding unregistration of the IRQ
handler has run.

This will lead to the IRQ handler calling `extcon_set_state_sync()` with
a freed `extcon` handle. Which usually crashes the system or otherwise
silently corrupts the memory...

Fix this racy use-after-free by making sure the IRQ is requested _after_
the registration of the `extcon` handle.

Fixes: f8d7a3d21160 ("power: supply: Add driver for pm8916 lbc")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Reviewed-by: Nikita Travkin <nikita@trvn.ru>
Link: https://patch.msgid.link/e2a4cd2fcd42b6cd97d856c17c097289a2aed393.1769163273.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/pm8916_lbc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/pm8916_lbc.c b/drivers/power/supply/pm8916_lbc.c
index 3ca717d84aade..6b631012a7959 100644
--- a/drivers/power/supply/pm8916_lbc.c
+++ b/drivers/power/supply/pm8916_lbc.c
@@ -327,11 +327,6 @@ static int pm8916_lbc_charger_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	ret = devm_request_threaded_irq(dev, irq, NULL, pm8916_lbc_charger_state_changed_irq,
-					IRQF_ONESHOT, "pm8916_lbc", chg);
-	if (ret)
-		return ret;
-
 	chg->edev = devm_extcon_dev_allocate(dev, pm8916_lbc_charger_cable);
 	if (IS_ERR(chg->edev))
 		return PTR_ERR(chg->edev);
@@ -340,6 +335,11 @@ static int pm8916_lbc_charger_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return dev_err_probe(dev, ret, "failed to register extcon device\n");
 
+	ret = devm_request_threaded_irq(dev, irq, NULL, pm8916_lbc_charger_state_changed_irq,
+					IRQF_ONESHOT, "pm8916_lbc", chg);
+	if (ret)
+		return ret;
+
 	ret = regmap_read(chg->regmap, chg->reg[LBC_USB] + PM8916_INT_RT_STS, &tmp);
 	if (ret)
 		goto comm_error;
-- 
2.51.0



