Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E83535207D;
	Tue, 26 Aug 2025 14:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217664; cv=none; b=g7ABtFhZqdVO7tfBVecz046ponWuS6e6GlQx91hUtMnvEia8uYd7H62naWAHgJ7xReGCRGBMtinu4jPUdTa8WCb0LGwwCPwUnePQ4XOMCt/n+/7OI/raCZ0JCcPRbRCul8dlX/RUECJpXLFeu8YM7WQzsGnochJrF005s8FWwUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217664; c=relaxed/simple;
	bh=5qx+J+JAKtUjY2mXmngTnaJQlACFDv8EBBMegVOp1jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6IxOXZtOgpsdHjgYu2YJbHgN8ra8+3hiijUyd1sqdhvgmfvSt+nIjdVdQejg16UyvLgoob4noTzq1lO8E1laOgGVzFUQwp3aLWLBnFGmpNz+FJtCKv2RBGkK9zIISA5psRB3Y6CjTuhrD+XjB6AOqbRgV8nBLQthR5Fg1hGXJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgzwS6cK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgzwS6cK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958FAC4CEF1;
	Tue, 26 Aug 2025 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217663;
	bh=5qx+J+JAKtUjY2mXmngTnaJQlACFDv8EBBMegVOp1jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgzwS6cKzlmyiZIO19TMihLDXW4z8S1s4r3N8iLk5mT5jI6ewyvPLOqICLKnwHTHZ
	 BKtArDUju3b/ILZWlr2+powVm41FeTINl4ZMWa3NU+O3vkqfgpR2LaemF80MwGu6+e
	 U+4mqlJNQX5++JpHIzzq60jtMuNhpC4iP/uDSb64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 228/523] gpio: wcd934x: check the return value of regmap_update_bits()
Date: Tue, 26 Aug 2025 13:07:18 +0200
Message-ID: <20250826110930.080638295@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit ff0f0d7c6587e38c308be9905e36f86e98fb9c1f ]

regmap_update_bits() can fail so check its return value in
wcd_gpio_direction_output() for consistency with the rest of the code
and propagate any errors.

Link: https://lore.kernel.org/r/20250709-gpiochip-set-rv-gpio-remaining-v1-2-b8950f69618d@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-wcd934x.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-wcd934x.c b/drivers/gpio/gpio-wcd934x.c
index 97e6caedf1f3..c00968ce7a56 100644
--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -45,9 +45,12 @@ static int wcd_gpio_direction_output(struct gpio_chip *chip, unsigned int pin,
 				     int val)
 {
 	struct wcd_gpio_data *data = gpiochip_get_data(chip);
+	int ret;
 
-	regmap_update_bits(data->map, WCD_REG_DIR_CTL_OFFSET,
-			   WCD_PIN_MASK(pin), WCD_PIN_MASK(pin));
+	ret = regmap_update_bits(data->map, WCD_REG_DIR_CTL_OFFSET,
+				 WCD_PIN_MASK(pin), WCD_PIN_MASK(pin));
+	if (ret)
+		return ret;
 
 	return regmap_update_bits(data->map, WCD_REG_VAL_CTL_OFFSET,
 				  WCD_PIN_MASK(pin),
-- 
2.39.5



