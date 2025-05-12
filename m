Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A562505C5;
	Mon, 12 May 2025 17:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072786; cv=none; b=Ho1B5Qjw/T+uA/975DVO/OUTE0Nv5xaWfsLqXnyij1uTwSTas/UoGmbT5eynSM7TWmJ3PeERH0+w1WTE98rdCaPeRhbV4B3h+Y5BYko2pJMNuWtvnTzsNk3wtI5619MWPYi720TP+ahRBSFfiPAWcCbjtV1I46up1ZFSozzDo6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072786; c=relaxed/simple;
	bh=vldq36FlZSlV3/Ae0/IGzVKOCmPXLWzOUg3I2H+7Dao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLVlpZ+PMJ4WswAuFqG1dtuAuwezULkTSdCvzGKhskeFrO61fYPi6q6cKMu8MQmou/22VuBhPjXpni2id3SjKv6ejVgTeYlppZyWaHKv7sD7+kSm2GClbbUo2z2VbNk46g1z+hLQ5EU17Zge3UbYFkd3fsGprd1x3YUCoscDvm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z74wAv0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z74wAv0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311E0C4CEE7;
	Mon, 12 May 2025 17:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072786;
	bh=vldq36FlZSlV3/Ae0/IGzVKOCmPXLWzOUg3I2H+7Dao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z74wAv0Y4yNZ0/K18Ar8HqQ6z3lvGjjcHcDFLLYV6EVOh3cGa5HUSC8K0Y59nrbgs
	 f8go/zf9afhVQg8haIvrtKqaw2foBxh9aVgvvTBy2rtisXUF4XBISp4dYeJ/qdrsF9
	 2tzGmQAkb92nG78WE5SVf0dIkMwYfcnZl9yTdNd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Bisson <bisson.gary@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 056/184] Input: mtk-pmic-keys - fix possible null pointer dereference
Date: Mon, 12 May 2025 19:44:17 +0200
Message-ID: <20250512172044.018037249@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gary Bisson <bisson.gary@gmail.com>

commit 11cdb506d0fbf5ac05bf55f5afcb3a215c316490 upstream.

In mtk_pmic_keys_probe, the regs parameter is only set if the button is
parsed in the device tree. However, on hardware where the button is left
floating, that node will most likely be removed not to enable that
input. In that case the code will try to dereference a null pointer.

Let's use the regs struct instead as it is defined for all supported
platforms. Note that it is ok setting the key reg even if that latter is
disabled as the interrupt won't be enabled anyway.

Fixes: b581acb49aec ("Input: mtk-pmic-keys - transfer per-key bit in mtk_pmic_keys_regs")
Signed-off-by: Gary Bisson <bisson.gary@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/mtk-pmic-keys.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/keyboard/mtk-pmic-keys.c
+++ b/drivers/input/keyboard/mtk-pmic-keys.c
@@ -147,8 +147,8 @@ static void mtk_pmic_keys_lp_reset_setup
 	u32 value, mask;
 	int error;
 
-	kregs_home = keys->keys[MTK_PMIC_HOMEKEY_INDEX].regs;
-	kregs_pwr = keys->keys[MTK_PMIC_PWRKEY_INDEX].regs;
+	kregs_home = &regs->keys_regs[MTK_PMIC_HOMEKEY_INDEX];
+	kregs_pwr = &regs->keys_regs[MTK_PMIC_PWRKEY_INDEX];
 
 	error = of_property_read_u32(keys->dev->of_node, "power-off-time-sec",
 				     &long_press_debounce);


