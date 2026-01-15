Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8083D349D;
	Thu, 15 Jan 2026 17:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499972; cv=none; b=nWHDoy+oqC2499HWH1Ayskl5Z4CgQUZNrzIWgo4f8C6w/LVJoSMMl+wAf0PWHP8rD6sYxUlQKMHxJameSu8KxBrk4+hlDFNLbHspIGPS/HGeIK4bBBiWO+HXBxQ7nodAZH3kH8tyOe+8R0Kkp14w0fNsqaorely4T3YftTc4NlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499972; c=relaxed/simple;
	bh=Ys6f8NEPzO93FkeNYNyskmK+FT7saQRao6VBNQJEIWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3LBgw1V9P1enbXA1GS4uh0KONvxElyGX26cgrU3D55M62Igmw+cKGPRmeyOnrqszVy77a1vWw/x0p81QgvWAoJ0inesT0O7RqwcJBuiR1438F5v/RPRLL4RlIt1AA3E8S4RvDjIFLM5AflFXF8CUZ9zxHkEYZ55uiSBn5t0Kvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0FUVJUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0FUVJUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBAD0C16AAE;
	Thu, 15 Jan 2026 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499972;
	bh=Ys6f8NEPzO93FkeNYNyskmK+FT7saQRao6VBNQJEIWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0FUVJUvvWNRNiQZ5VE8UaXLKUV5pDA+P+Cp8QcVHE/IqeBILb/J8rK6nNSXKHieT
	 ye5FhyJsaLzwwCTpmE2pdeCi68aX52764taALWU6hX2w4CQmOMJvRkpYDqJP0D2i8z
	 a9dHZc4QPm38kXmeve+Q6xL6MQKm8Py3KaMDeGKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 381/451] ASoC: stm32: sai: Use the devm_clk_get_optional() helper
Date: Thu, 15 Jan 2026 17:49:42 +0100
Message-ID: <20260115164244.704972557@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1487,12 +1487,9 @@ static int stm32_sai_sub_parse_of(struct
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


