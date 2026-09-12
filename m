Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65D5384232;
	Sat, 12 Sep 2026 10:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210405; cv=none; b=X/PyghwXlg9bBkVVrR4FHf7JnB77dbCTOQWxDuFWU6ItuUpKoscaLRiFTkfMBfspJDwd54G1k//cqyt3estVG//YhY8Ebczw3JQkRI99I/3FHU203ZTsF9Y/+lay6NmcngNVSbL3dUCEWsiOzsODJ8jttFOFW+hXH8hd24lSpwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210405; c=relaxed/simple;
	bh=Yrwl3i9PPMajrEKpO8/rd9hRUOdbY22IUh8RVBM0AqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0IWfgDO9wCW8opVIbKqbeqY5nc29cQdK6UlDFdUaxOiUEW31u3tsUjjRSKxGQ6uBYd6soYuTPBwUILGaqr+htjGXrHaohMLl9VNyATGjoP1cB6BlsUgQIri7WypcnSiGdNmwJ5Bu8kOWoZkQmA9/Fg/+GYfvE00A+VNcVeVOi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfyndSoF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfyndSoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD80F1F000FF;
	Sat, 12 Sep 2026 10:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210403;
	bh=wQTASG4rmJ4PcYvR4dkCLMCa+VkZKlDcs85mFUY6+Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfyndSoFKQlwfAmrXBtFQHd3rZKqsTTiBMgLPUWc0In98NH5IvBUKnsrfjjR66Toc
	 jb0XQONhjTDgq2+m1wsrAS+Hn0ymjqJpNW9RZ6FzxkCgVcYCyY76O+rlqcGaGoRHcH
	 dhk/Go70rejZdOXOTCGB3S9gwl7fk+IyuJye/uD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1020/1518] pinctrl: airoha: add missed IRQ resource helpers
Date: Sat, 12 Sep 2026 08:53:09 +0200
Message-ID: <20260912065646.525379822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit a02fa031b9520e46e98bff17e12b472eba770670 ]

Without hooking .irq_request_resources, gpiolib cannot set
GPIOD_FLAG_USED_AS_IRQ. This breaks pin direction locking and can allow
userspace or another driver to reconfigure an active IRQ pin as an output

Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 9465de3e148bb..2163532f9af01 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -2638,6 +2638,7 @@ static const struct irq_chip airoha_gpio_irq_chip = {
 	.irq_mask_ack = airoha_irq_mask,
 	.irq_set_type = airoha_irq_type,
 	.flags = IRQCHIP_SET_TYPE_MASKED | IRQCHIP_IMMUTABLE,
+	GPIOCHIP_IRQ_RESOURCE_HELPERS,
 };
 
 static int airoha_pinctrl_add_gpiochip(struct airoha_pinctrl *pinctrl,
-- 
2.53.0



