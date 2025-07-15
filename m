Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B2D2ECD30;
	Tue, 15 Jul 2025 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587695; cv=none; b=RRQtVRfW9nvQaksb6sJsA1bxuRpRpxKyctcGuybyPhCZQyDE5ZUHK6ggyP5HRKxRVVoZlLzy5CIJ9RE8LqAYWxOSbIA3OihuE3H1q9wEY1C4ruC04RQnfAl44HnKqCADiSGh2DLOpgmOVy49klk4hTNKHbQ0P14BFGmF/6bVOjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587695; c=relaxed/simple;
	bh=5vC8KAJ6Es23ZyrtqjXf95ZdPdrWVopYs/xEArOrUMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9VuhUmJpwZZgdUYiQEN/8LSLp8zk96K3+akr4U5u2tZus5HtIR/+p7kHQQENhRJh4j6/Ke1hVDhoH+1OM4HPRbwDnhIqgWqiewrnKUZNHWST5wCC4lCxuhpb1j+7FMLTsZxfJMyoCaZ4dfmHmqwE/P7/FlyEQDyE7S5vXXvimI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRFbYFWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRFbYFWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B146AC4CEE3;
	Tue, 15 Jul 2025 13:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587695;
	bh=5vC8KAJ6Es23ZyrtqjXf95ZdPdrWVopYs/xEArOrUMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRFbYFWEXlLD8A+LkwdLHGyjLoRuztLw70fRwg8Q7np6+pxy5gVM7lXF3SRs88wgQ
	 LqAz8oYKsSDakXTkjZkEPfJYXWQBwXXH7rKOEcr4o3AISiGe5sqUVk6TyOazUaSCpU
	 3j6IHvHG8D/RUKkxZtlMTV9MtOjYx0CH6AMj414s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/208] regulator: gpio: Fix the out-of-bounds access to drvdata::gpiods
Date: Tue, 15 Jul 2025 15:13:38 +0200
Message-ID: <20250715130815.315568603@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/regulator/gpio-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 5927d4f3eabd7..de07b16b34f8e 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -257,8 +257,8 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	drvdata->gpiods = devm_kzalloc(dev, sizeof(struct gpio_desc *),
-				       GFP_KERNEL);
+	drvdata->gpiods = devm_kcalloc(dev, config->ngpios,
+				       sizeof(struct gpio_desc *), GFP_KERNEL);
 	if (!drvdata->gpiods)
 		return -ENOMEM;
 	for (i = 0; i < config->ngpios; i++) {
-- 
2.39.5



