Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B754F26A08C;
	Tue,  8 Apr 2025 12:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113817; cv=none; b=iaDpqJa///sbG7k6fbbnKCaVCmnW/W3Y390030TLGXJd397hqws80v6ozbboXmeUC/O3tFkXb0QjjPbn//74oXgAjUlNZbPdQjmwtViapXYtT80drSNtcpD1ewULsN8MfBwXp798qw/yMODa2uV3CmZ1bBj1aQWg+okGYSCppjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113817; c=relaxed/simple;
	bh=6ylfuBi72S+4scnb1ZhoaSwqPjKlsz9RDRB5S5aLv58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq5Xg8c9CBODeqQjh1a296IkJGOFAP1hfy459A6lrnB1/ZtVfyL9IVOCzGnEf0on5wV0C2IKJrYjuVKhuh2K6WYYPmFuxCjbtaUFAVSfVTOgGPMiRa+VzmdmgX5H7zao4R0tbSSxdF9lUgX3Ze9A37HfxVDrLJG8Rubc0JKSkcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLm81HMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLm81HMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435EFC4CEE5;
	Tue,  8 Apr 2025 12:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113817;
	bh=6ylfuBi72S+4scnb1ZhoaSwqPjKlsz9RDRB5S5aLv58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLm81HMNpfwNlYK+zrTeEy4+ryIAFjhayubw14NPaUk3TYQiRBBAJZi8lpKc7gu6F
	 jsF74zvhNb5L0gUjUE58tVqrV02S8Cx6bV50IXjt2CVqNjNljBzeW70qsxUwyy3s4e
	 4bS5S/N32JRpaOpZThD4BndbezoNbivUb5orQJcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/154] pinctrl: bcm281xx: Fix incorrect regmap max_registers value
Date: Tue,  8 Apr 2025 12:49:09 +0200
Message-ID: <20250408104815.557745416@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit 68283c1cb573143c0b7515e93206f3503616bc10 ]

The max_registers value does not take into consideration the stride;
currently, it's set to the number of the last pin, but this does not
accurately represent the final register.

Fix this by multiplying the current value by 4.

Fixes: 54b1aa5a5b16 ("ARM: pinctrl: Add Broadcom Capri pinctrl driver")
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Link: https://lore.kernel.org/20250207-bcm21664-pinctrl-v1-2-e7cfac9b2d3b@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm281xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
index bc3b232a727a5..3452005342ad6 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm281xx.c
@@ -981,7 +981,7 @@ static const struct regmap_config bcm281xx_pinctrl_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
-	.max_register = BCM281XX_PIN_VC_CAM3_SDA,
+	.max_register = BCM281XX_PIN_VC_CAM3_SDA * 4,
 };
 
 static int bcm281xx_pinctrl_get_groups_count(struct pinctrl_dev *pctldev)
-- 
2.39.5



