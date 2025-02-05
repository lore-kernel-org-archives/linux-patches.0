Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C5F151988;
	Wed,  5 Feb 2025 14:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766152; cv=none; b=Tihs7lL9mJmgLJGtVALc3grMkhnOmTrWSfdZO+aHrycWQjC4gGLl+R+T+C3jQn4mbm9grG892iNcdmwlo5CqHnzWBxN7NkCHCDmt/wPlK4AyS2tagWbl6bsXmbNIMaDmBom+I3zyGaTm5I5S2yXG9iFTG+rlbvcWxscxZNgPNGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766152; c=relaxed/simple;
	bh=FnKI1L94WnQ4Lz7BHpsXOPvFisuPp2Cp5GU+/or8VuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GfqmRvAUK4wz/ON8MDrYnGJXpDubzu2Vi8Fpwvk4mRhrr05PujXWCcLEiVjFalcb4cD3FgxxMS//hjdjaJrhMc8yNEmCt9Rdzl+kCZmJeGau+u/irBYNlxbJQhkMOr5CAcPE3dreEzoR9Y9iAzmNxKMWSChxNzaH2kB9CZGVWxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmssQ8Su; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmssQ8Su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38F6C4CED1;
	Wed,  5 Feb 2025 14:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766152;
	bh=FnKI1L94WnQ4Lz7BHpsXOPvFisuPp2Cp5GU+/or8VuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmssQ8SuByrNiOIt9C9gQ+AZd/fKhaaUcukCHHSd6Z33edbJzzBOViAskvlpKj4ch
	 4HUvjbwWjwrSW7DJqF1K/VAJEkfRb1JCr13bq73XDRyH8HLSTqTaW+4PKg8ysIb98i
	 G3LYrzctvKpdkcfVhffoSbB5WhalRJAFLjKpYgy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 247/623] pinctrl: samsung: Fix irq handling if an error occurs in exynos_irq_demux_eint16_31()
Date: Wed,  5 Feb 2025 14:39:49 +0100
Message-ID: <20250205134505.675051055@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f686a2b52e9d78cf401f1b7f446bf0c3a81ebcc0 ]

chained_irq_enter(() should be paired with a corresponding
chained_irq_exit().

Here, if clk_enable() fails, a early return occurs and chained_irq_exit()
is not called.

Add a new label and a goto for fix it.

Fixes: f9c744747973 ("pinctrl: samsung: support a bus clock")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/f148d823acfb3326a115bd49a0eed60f2345f909.1731844995.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/samsung/pinctrl-exynos.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
index b79c211c03749..ac6dc22b37c98 100644
--- a/drivers/pinctrl/samsung/pinctrl-exynos.c
+++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
@@ -636,7 +636,7 @@ static void exynos_irq_demux_eint16_31(struct irq_desc *desc)
 		if (clk_enable(b->drvdata->pclk)) {
 			dev_err(b->gpio_chip.parent,
 				"unable to enable clock for pending IRQs\n");
-			return;
+			goto out;
 		}
 	}
 
@@ -652,6 +652,7 @@ static void exynos_irq_demux_eint16_31(struct irq_desc *desc)
 	if (eintd->nr_banks)
 		clk_disable(eintd->banks[0]->drvdata->pclk);
 
+out:
 	chained_irq_exit(chip, desc);
 }
 
-- 
2.39.5



