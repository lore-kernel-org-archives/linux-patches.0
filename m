Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A901A2DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301863; cv=none; b=dc/vVEnUwzMvH6wkubXzNIjWAKHITmyxHKdmLyqniQDA6G93AB+gOpxfZKkjC0vfCV5aW9S1/4qNGjyofZytRUK/i6GvqfEJbj5PBGNqntxeyQ1vfeq0GhjWOFeGyG8x0w+NRIS8SI2CNW9vzITpflGTLD6PfXKq3o9I7V22jYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301863; c=relaxed/simple;
	bh=IzgKjF09oD/Bye43Y/AyMG7BJrZLvBnfPyLybBNUiAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqeaBWJq2prcFeoVn47SDTt9ihRNMVy+oLeWhVQmgaEM4d6t0RWm3GHkYTRF1T4QksRln04shalzoWD6kkAFKjDxcycPVl2oXz2Mid8X6GjzfIqqKkB+jzEzUbtte4k49dpsZlu7sEzRcZKKrWCq4eIB5iwR1BKqI9Njnzn6BUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJJ9KBKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJJ9KBKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02817C19424;
	Sat, 28 Feb 2026 18:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301863;
	bh=IzgKjF09oD/Bye43Y/AyMG7BJrZLvBnfPyLybBNUiAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJJ9KBKWvaDowZpplC5Qpuv7rpEN1FBpjIDlucC9ERLOeeYZyqsepO2Gu9uzMuIW6
	 ISc+0D+PIjT9kAPwyajaDlIrdDdtG8RoSjssdqSeC23bgOdaKfpbLyI9c1EUQLBH3S
	 /LY3+pKurJFsXmhI9Xg0ckYLUbI8j6JBEsH+pT3QTsV0guUZurU/UAu5QaK/HUzRvU
	 VoWwsQoBT0bbxReU2PCLFPA7z+mCzzLtv6NhaeFTJ8rDynKR/ds0MesrppLfSY77s7
	 4p9v4hHkV2XiW8kyqQyHoP5D5QTVJVmRmkPYhaHrGQBSICbW1oFLFHWjBpRjxWHN5I
	 DeEjPyq2ZwZrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Nikita Travkin <nikita@trvn.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 286/385] power: supply: pm8916_lbc: Fix use-after-free for extcon in IRQ handler
Date: Sat, 28 Feb 2026 12:58:28 -0500
Message-ID: <20260228180011.1568201-286-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index ab324ce3b8721..e6c44f342eeb4 100644
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

