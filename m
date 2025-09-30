Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A90217F55;
	Tue, 30 Sep 2025 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244726; cv=none; b=Eld9X/PEEiffD9EsrLWo93Zz3BYP9+iUMXWEmy4C+x64tId8wMlW2ayzCSDJJj4dI5It3Fntr0bD8SmHlvbRWlkECTBbj3l/S5Ks/nleB7NterONZxSWfLoiCBGrAkIPsK2u6vZR5XAxZ3QsdXO4LrN/E5TquWZ4gO57L5OfXfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244726; c=relaxed/simple;
	bh=twY2Ml5qcH1zHZetQNKUBn6XTyK71rgQnmHLY60Oh7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLZbVUWxDT+bvRqffzlmE14ND5S2GnfEgsWEnkOXBzXGher3n5aWemdhj80YxgJedkDOohW9KUTX9E0EKMT2HAumpMa1m73FkYp10mt8qZK2zLvqVFfDgIWc63zIsasAH3RsgM98twbaSs9ZlotlHTyq1J7LX77uZPRXOluMX14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CuUsCg2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CuUsCg2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44154C4CEF0;
	Tue, 30 Sep 2025 15:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244726;
	bh=twY2Ml5qcH1zHZetQNKUBn6XTyK71rgQnmHLY60Oh7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CuUsCg2i1fwOmr/d4n/oOSKm0eMXrXawPl7UmeVtMlOEVMri6ruQ73kE+PbUCn9lq
	 ZOB/F+7teIIug/u5xgu75pqgndr1quS+6hHKdM3rGEKN5hA4zHHTUs54H3kAg0mO3I
	 q8zXYSSXpxfcKbL+EoWXfaX7a48cJLM1lk1vHPx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Michael Walle <mwalle@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 088/143] gpio: regmap: fix memory leak of gpio_regmap structure
Date: Tue, 30 Sep 2025 16:46:52 +0200
Message-ID: <20250930143834.738981635@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 3bd44edd6c55828fd4e11cb0efce5b7160bfa2de ]

The gpio_regmap structure is leaked on the error path. Fix this by
jumping to the appropriate kfree instead of returning directly.

Fixes: db305161880a ("gpio: regmap: Allow ngpio to be read from the property")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Suggested-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Link: https://lore.kernel.org/r/20250922142427.3310221-7-ioana.ciornei@nxp.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-regmap.c b/drivers/gpio/gpio-regmap.c
index 87c4225784cfa..b3b84a404485e 100644
--- a/drivers/gpio/gpio-regmap.c
+++ b/drivers/gpio/gpio-regmap.c
@@ -274,7 +274,7 @@ struct gpio_regmap *gpio_regmap_register(const struct gpio_regmap_config *config
 	if (!chip->ngpio) {
 		ret = gpiochip_get_ngpios(chip, chip->parent);
 		if (ret)
-			return ERR_PTR(ret);
+			goto err_free_gpio;
 	}
 
 	/* if not set, assume there is only one register */
-- 
2.51.0



