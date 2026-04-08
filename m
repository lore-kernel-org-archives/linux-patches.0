Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD33534AB06;
	Wed,  8 Apr 2026 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674533; cv=none; b=OapVcWOkmOBQrufM2engfsMXOhR+vnqf5NxUbJbC/Ss3Pj+SMdajLBcy64+x6XYyeQN4sfwRoLvQoyeCzFqkxZ3kgPuB1YWx8zNIzfSjtR/9lQ8GM5/Pb1tDIq7PPiaXpV3qXY0jnl2xgbNt2i43zXdr1X7+wqup7o9h/Whu40k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674533; c=relaxed/simple;
	bh=LnJTqpQUY/1FGgSyUzBFDR6BXEO/ex1stkgHmQmS+c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRzvx1IGkdtFvBkKidnZ0qBT9vuHb5mYZQRqkvK9RliLu+9DU5ezEpN63DOE42gFsD0dw6P6oC2UjXWz2W8hc8WQLWhfpnzej/9/DlbZvfWGCUz6Pmbova7pAqPzzd5ctCKFaYBkK203vE7X/SwvLb3lyLZanK/Px7GiMDhtCqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tR0pzit9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tR0pzit9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EE0C19421;
	Wed,  8 Apr 2026 18:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674533;
	bh=LnJTqpQUY/1FGgSyUzBFDR6BXEO/ex1stkgHmQmS+c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tR0pzit9+BxBfxyqJeQeyhnaHPnevBxDUkrmvKJAkH+fkqo9FK8wgxTJQEMFWAU7/
	 8I51lyGqsU4W7hdYu/pGSXA+IL/prBzbIDIqPcRBXbgab8++ay7g3MtakuJf06tBtm
	 /R5PDUJU8DgZZnKg4iFcAbZl2xGPzTtFCoywIIh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 133/311] gpio: qixis-fpga: Fix error handling for devm_regmap_init_mmio()
Date: Wed,  8 Apr 2026 20:02:13 +0200
Message-ID: <20260408175944.383560416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 8de4e0f44c638c66cdc5eeb4d5ab9acd61c31e4f ]

devm_regmap_init_mmio() returns an ERR_PTR() on failure, not NULL.
The original code checked for NULL which would never trigger on error,
potentially leading to an invalid pointer dereference.
Use IS_ERR() and PTR_ERR() to properly handle the error case.

Fixes: e88500247dc3 ("gpio: add QIXIS FPGA GPIO controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260320-qixis-v1-1-a8efc22e8945@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-qixis-fpga.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-qixis-fpga.c b/drivers/gpio/gpio-qixis-fpga.c
index 6e67f43ac0bdd..3ced47db1521c 100644
--- a/drivers/gpio/gpio-qixis-fpga.c
+++ b/drivers/gpio/gpio-qixis-fpga.c
@@ -60,8 +60,8 @@ static int qixis_cpld_gpio_probe(struct platform_device *pdev)
 			return PTR_ERR(reg);
 
 		regmap = devm_regmap_init_mmio(&pdev->dev, reg, &regmap_config_8r_8v);
-		if (!regmap)
-			return -ENODEV;
+		if (IS_ERR(regmap))
+			return PTR_ERR(regmap);
 
 		/* In this case, the offset of our register is 0 inside the
 		 * regmap area that we just created.
-- 
2.53.0



