Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCCB1A5B9D;
	Tue, 15 Jul 2025 13:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586476; cv=none; b=r8K0sdEZxa8Y4OzzEKCzGB2T0rOjwPBo3ngi5zBSccoCOKp9TUiGDEVm3y8UfHAJp1pkPqD3oOhWPKMWYV81K8Bwv3mHHGztApLDq7kClKvh37Tj082iczhIufw++kFOgKZwrWGiJkI53irxRnG1In+hFRb9L8mzSH+n+xPQM+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586476; c=relaxed/simple;
	bh=jp5ThTBfaaR6s721SVyObbPRnv0ewuqjKthqILdvvXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvT2F5py38q+rGPGZjtdeOQsP/XYTT5tpXVuy4M3MDqvJrqz2dggM0bw9EAgjq/2eFiEXoewqULgnnv6z/nhz98KFvJd1zmqvoppn5wuJI9YumdHAfiTMT/b74n0khTKt+TxofU2/EZ0Qzml/UFpdDMotl42CitnK02cQbQXIxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Vc0bNZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Vc0bNZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AC8C4CEF1;
	Tue, 15 Jul 2025 13:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586475;
	bh=jp5ThTBfaaR6s721SVyObbPRnv0ewuqjKthqILdvvXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Vc0bNZ5iNaj0eGp9wGXEyLIBJ+fyymLL6hF15maCUqpbthCpNgZckHI+nfDWTzAz
	 B/sniwzamTumlVW7lbBnYyiD1JG6YD/Lebd5ClZlMruVMm/lezFNtyQt9+yLyrUVKU
	 OK/ccpazq++iuBQWPm+psKuksM7/VEBZktu94S7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/148] regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods
Date: Tue, 15 Jul 2025 15:13:22 +0200
Message-ID: <20250715130803.524303224@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

From: Manivannan Sadhasivam <mani@kernel.org>

[ Upstream commit c9764fd88bc744592b0604ccb6b6fc1a5f76b4e3 ]

drvdata::gpiods is supposed to hold an array of 'gpio_desc' pointers. But
the memory is allocated for only one pointer. This will lead to
out-of-bounds access later in the code if 'config::ngpios' is > 1. So
fix the code to allocate enough memory to hold 'config::ngpios' of GPIO
descriptors.

While at it, also move the check for memory allocation failure to be below
the allocation to make it more readable.

Cc: stable@vger.kernel.org # 5.0
Fixes: d6cd33ad7102 ("regulator: gpio: Convert to use descriptors")
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250703103549.16558-1-mani@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/gpio-regulator.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index e84fc9d724486..50fcb5fce11ac 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -253,8 +253,10 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	drvdata->gpiods = devm_kzalloc(dev, sizeof(struct gpio_desc *),
-				       GFP_KERNEL);
+	drvdata->gpiods = devm_kcalloc(dev, config->ngpios,
+				       sizeof(struct gpio_desc *), GFP_KERNEL);
+	if (!drvdata->gpiods)
+		return -ENOMEM;
 
 	if (config->input_supply) {
 		drvdata->desc.supply_name = devm_kstrdup(&pdev->dev,
@@ -267,8 +269,6 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (!drvdata->gpiods)
-		return -ENOMEM;
 	for (i = 0; i < config->ngpios; i++) {
 		drvdata->gpiods[i] = devm_gpiod_get_index(dev,
 							  NULL,
-- 
2.39.5



