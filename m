Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE9A431E4A;
	Sat, 12 Sep 2026 08:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202642; cv=none; b=H7JnKei6qq1fo3umfRRJ9eoduOg38aI8D4T1ND/i31RFiST+zS6Y16e5Y0nOw5D7eBHvUk5UFsiI3nkjtVbyHICu06cuLPu9iAPEx63l779wJAgXkDlUmeGioLgwr2s5yMQNdGtyPDdCGzNMFe9Sa390vhTxbc0hiTr6a1WjoSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202642; c=relaxed/simple;
	bh=sXAEZiXAYZhWo70iZofFxTi7eGM9iFybebvfhTJfozA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXMWpASz7c+Y2phZL/ZvetSL+0xhxxJbiFvUKzS0eFaXenuu0G+HiGLbB6VxPy/BAgG9YjhwakFKl6NMjfzPAUN0HrrPeb3UM1PwRxHW6OSNe7yDhvUknbtBrza+6cPP+zmzV+cbqGUieneqmUJa4B3uXm4/7ktxgQslLq0pgq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1uC3ZRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1uC3ZRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7741F000FF;
	Sat, 12 Sep 2026 08:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202638;
	bh=7BYIwF4OwRAunHZxoROw7OB1vWjyKoTfUNHPOI56jog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1uC3ZRQA0fC+9Cu1zcSS2vXOhgHlAtyXDCwWCLUPH/BnRlctTUSiXOdfNhvlGuKu
	 1lepJtCuXenoiPOsPhVQt1AhIyh7Sgcfx6qm6GjKGwofMkzpMImSDcLBHbF+YvhQw3
	 8oeLVjZV7i86ZtPgWvwYa4R55u9mgn/c/S/wvrqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1245/1815] pinctrl: airoha: add missed IRQ resource helpers
Date: Sat, 12 Sep 2026 08:49:55 +0200
Message-ID: <20260912065718.242417704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/pinctrl/airoha/pinctrl-airoha.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/airoha/pinctrl-airoha.c b/drivers/pinctrl/airoha/pinctrl-airoha.c
index 84fecba8fecc3..4bbf97fdc2926 100644
--- a/drivers/pinctrl/airoha/pinctrl-airoha.c
+++ b/drivers/pinctrl/airoha/pinctrl-airoha.c
@@ -2640,6 +2640,7 @@ static const struct irq_chip airoha_gpio_irq_chip = {
 	.irq_mask_ack = airoha_irq_mask,
 	.irq_set_type = airoha_irq_type,
 	.flags = IRQCHIP_SET_TYPE_MASKED | IRQCHIP_IMMUTABLE,
+	GPIOCHIP_IRQ_RESOURCE_HELPERS,
 };
 
 static int airoha_pinctrl_add_gpiochip(struct airoha_pinctrl *pinctrl,
-- 
2.53.0



