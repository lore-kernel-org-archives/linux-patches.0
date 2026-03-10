Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6A73803CD;
	Tue, 10 Mar 2026 11:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141913; cv=none; b=EBV8SeksttIL3d7kfeeyJJWZwrPBp3QcaPqjmIpZfGDd8jLbLFJjkOefS0Nx/r7rjHsXx8hU4Z9FiCnkuEoxAW5eKrz1ugf/CilABRhJJaFKwCv59GosjtPeMF/tCVJFXcRs70I9WO3eyMAYEgDA4iZrSnwvEFY7m+K11hJg468=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141913; c=relaxed/simple;
	bh=IyWDwr0YumqQypt5Xl2HqYQaca+Tw0R6OD7rBO0PYqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+Ydw2a47ZD+hjJ5kZt7VGh7W5uL0ktg0POxGtP97AxRQctLWtORfx7xcPUQTAu/mwAUxbxT2dX62/AqAbYlZPyXJSbTdJnWjjauwVAzpAXvcY3f8oLL6G3JJkHn6ViuuV2VteKrlB4AfE2y/Zse+Coe8WIp9PYCaN0OOjJSGoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3QwKTwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3QwKTwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99380C2BC86;
	Tue, 10 Mar 2026 11:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141913;
	bh=IyWDwr0YumqQypt5Xl2HqYQaca+Tw0R6OD7rBO0PYqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3QwKTwo4fy51YipCqlUNJiO7wKpZQC0YLcRHTKxxB+tYs8YzkQpiYubM+qxd0ct7
	 jJttgCHU6D/6FO2kik3O2W1VMXHpg5O/TmjHdteUGiV45+jmJa1uRt3j2k/QXl+6GZ
	 r0hOAg40sQnj88YPSU6wxehCpK/S/J9SOOyKg7pM8OF4BWKCh8CelWIKJghwlnEXbb
	 pLSyu91Dw5wuuIW1K/i+ziN/54mscMau38SNXSqtLrktAFDoazTw95B0uwzcAX0wt8
	 507aUO+txvVmHB9oBXfpSUMLqII8L/blReYwak3nWMNYS3R4EQT6QKA9/RsP3mRUMI
	 raUc8LXhYJ61w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/314] regulator: bq257xx: Fix device node reference leak in bq257xx_reg_dt_parse_gpio()
Date: Tue, 10 Mar 2026 07:14:55 -0400
Message-ID: <e332c527a2579850c439dd58eba70899872190e4.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 4baaddaa44af01cd4ce239493060738fd0881835 ]

In bq257xx_reg_dt_parse_gpio(), if fails to get subchild, it returns
without calling of_node_put(child), causing the device node reference
leak.

Fixes: 981dd162b635 ("regulator: bq257xx: Add bq257xx boost regulator driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260224-bq257-v1-1-8ebbc731c1c3@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/bq257xx-regulator.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/bq257xx-regulator.c b/drivers/regulator/bq257xx-regulator.c
index fc1ccede44688..dab8f1ab44503 100644
--- a/drivers/regulator/bq257xx-regulator.c
+++ b/drivers/regulator/bq257xx-regulator.c
@@ -115,11 +115,10 @@ static void bq257xx_reg_dt_parse_gpio(struct platform_device *pdev)
 		return;
 
 	subchild = of_get_child_by_name(child, pdata->desc.of_match);
+	of_node_put(child);
 	if (!subchild)
 		return;
 
-	of_node_put(child);
-
 	pdata->otg_en_gpio = devm_fwnode_gpiod_get_index(&pdev->dev,
 							 of_fwnode_handle(subchild),
 							 "enable", 0,
-- 
2.51.0

