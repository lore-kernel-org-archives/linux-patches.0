Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514AE34C137;
	Tue, 16 Dec 2025 12:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887882; cv=none; b=nEunxuGfXI0gO6Ugejm7+JxrbongKudcHwpTCbbays7jzbAL+v1NmdpnllYSb2r/k09T5KKspY0X1osyJDX+ATw6YggJOJjCxVzCHty5iGYFLubHCyx4eUasIn5pRS4Yb1138UwOCwbxrEHAimAxdTbAyYsD0sOkK05oL5RnbPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887882; c=relaxed/simple;
	bh=oJfCecZVWlBXtgsGwR9B7V3EYG1gHVSkrmWMlK67utM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPW2UsKzhH4Am+rIFFmikaTsPv8YsCMHBuJatx9MnHzAl8JKQjN3edAzXOF6PPwYH5rK9OBaT3PcofhPVJ8z4awUwmixBja2d5te1pd7g8vqdS2pLj0hMR7zmgSijFasDgpMXpqs+wKetZO1HJa/PddCnKrIY/PXSP68vHax9bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ti87DJ//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ti87DJ//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CE6C4CEF5;
	Tue, 16 Dec 2025 12:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887882;
	bh=oJfCecZVWlBXtgsGwR9B7V3EYG1gHVSkrmWMlK67utM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ti87DJ///z1K/3l3JLyiNYIyvoHt1dGxtaQ7/4YSegfzegFx0MRsgw8a/yifwJBgd
	 O0z/AEvRIsebiree4ovi4Q6A1wA582B5DNetvXMU5Km6DxQhqTBlk+irjuwzqYeFx2
	 PelT0LiRIPHYTzzogd8tHRkAc5yAU5bCp3BJwYmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 366/614] regulator: pca9450: Fix error code in probe()
Date: Tue, 16 Dec 2025 12:12:13 +0100
Message-ID: <20251216111414.620587765@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 670500b41e543c5cb09eb9f7f0e4e26c5b5fdf7e ]

Return "PTR_ERR(pca9450->sd_vsel_gpio)" instead of "ret".  The "ret"
variable is success at this point.

Fixes: 3ce6f4f943dd ("regulator: pca9450: Fix control register for LDO5")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/aSBqnPoBrsNB1Ale@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 4be270f4d6c35..91b96dbab328b 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -1251,10 +1251,9 @@ static int pca9450_i2c_probe(struct i2c_client *i2c)
 	 * to this signal (if SION bit is set in IOMUX).
 	 */
 	pca9450->sd_vsel_gpio = gpiod_get_optional(&ldo5->dev, "sd-vsel", GPIOD_IN);
-	if (IS_ERR(pca9450->sd_vsel_gpio)) {
-		dev_err(&i2c->dev, "Failed to get SD_VSEL GPIO\n");
-		return ret;
-	}
+	if (IS_ERR(pca9450->sd_vsel_gpio))
+		return dev_err_probe(&i2c->dev, PTR_ERR(pca9450->sd_vsel_gpio),
+				     "Failed to get SD_VSEL GPIO\n");
 
 	pca9450->sd_vsel_fixed_low =
 		of_property_read_bool(ldo5->dev.of_node, "nxp,sd-vsel-fixed-low");
-- 
2.51.0



