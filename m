Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE7D35BDDE;
	Fri,  9 Jan 2026 12:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963018; cv=none; b=dtRu3RjrkN6i/LycIAJV2O5pxQH9s90XndPIqPPhLdYmnGj7O4TXP4j92Q4JiO2DicQwH0DLb50tbjsS5psXolpmIO4kP+P+eYCHV/6//jMmYvpBZ0xxEj4qqwoIesGqHx+AEN9cWP58V2zbgQ64cszii9m0OIe1+xj+wTQynj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963018; c=relaxed/simple;
	bh=xOMH+MhAXZoIE3AtxOEwybPx6bkFjSsrQHZ1tx4YAEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpXHzv+gV0+pm2AgjQOMa4Y0yrpoJL+2n7L62cAp3ve01AMM+1fNBDInzayRCtg/whV32/SHIZW2+PEtj0A8zYK4eTYyf01iTf2D/u0KrQQV/6wxF91rAKOUlb9CkONhg8j8ymaoOaWu8FgQCXXYaLIZt79Mz5sNEUqVLe46a9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/ClfOGk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/ClfOGk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31AEC4CEF1;
	Fri,  9 Jan 2026 12:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963018;
	bh=xOMH+MhAXZoIE3AtxOEwybPx6bkFjSsrQHZ1tx4YAEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/ClfOGkrxIZXSsKtpunn37UDQlmY0dWtEybNPtCEdQ2XT1GKxLZv+W2b+y08DpGA
	 1BkkMjh/M0IOxkk2uH07bQxyNv3ZL7SQIKYS+yLrcX+CIgi1JurWMp8nIh4Ga6/+s0
	 ir8C+gL9eBSMI4Bwyd+7BLkOQXigohhbF00YUR7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 569/634] ASoC: stm32: sai: Use the devm_clk_get_optional() helper
Date: Fri,  9 Jan 2026 12:44:07 +0100
Message-ID: <20260109112139.016149108@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 374628fb668e50b42fe81f2a63af616182415bcd ]

Use devm_clk_get_optional() instead of hand writing it.
This saves some LoC and improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/f7987f18dadf77bfa09969fd4c82d5a0f4e4e3b7.1684594838.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 312ec2f0d9d1 ("ASoC: stm32: sai: fix clk prepare imbalance on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/stm/stm32_sai_sub.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/sound/soc/stm/stm32_sai_sub.c
+++ b/sound/soc/stm/stm32_sai_sub.c
@@ -1485,12 +1485,9 @@ static int stm32_sai_sub_parse_of(struct
 		if (ret < 0)
 			return ret;
 	} else {
-		sai->sai_mclk = devm_clk_get(&pdev->dev, "MCLK");
-		if (IS_ERR(sai->sai_mclk)) {
-			if (PTR_ERR(sai->sai_mclk) != -ENOENT)
-				return PTR_ERR(sai->sai_mclk);
-			sai->sai_mclk = NULL;
-		}
+		sai->sai_mclk = devm_clk_get_optional(&pdev->dev, "MCLK");
+		if (IS_ERR(sai->sai_mclk))
+			return PTR_ERR(sai->sai_mclk);
 	}
 
 	return 0;


