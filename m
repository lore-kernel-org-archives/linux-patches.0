Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456D41DE8AD;
	Mon,  9 Feb 2026 14:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647531; cv=none; b=FIssGUPgA4bjz5kCJ5eg4H59bEVk0B3udloHCP0UixwMSi3xQVdEWIciIVlZgQmBqz6k8GnZ1pUL6gJU5w9gt4As2fzu12FOyTfirNSrlRLZe1H5DRCoK24FTSe1VwtFDR8oPrcX17LI1N5LzMUT2bfoekMR8LJBoC1cVdfPvho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647531; c=relaxed/simple;
	bh=QMo9yoC42RnsChsb7cvgQdxAMrxxpv9YKtofBSpH7D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jg+++yn8435h+QsPJwedhNV4MJofnE5MYKEnCNJys4Tp0jtNq9mCgLrI3r3UsS+bhfLBb1WErwG6fJpNjOVsyTAWu5pOudPp+iD2v4JC3lNPQ6U5WJTHw6jPSnV7+nmK24bfuxvbhAlPL7YY3USwouMA8Eva/4g5zu2nVh/C7iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERHiVYQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERHiVYQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82066C116C6;
	Mon,  9 Feb 2026 14:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647530;
	bh=QMo9yoC42RnsChsb7cvgQdxAMrxxpv9YKtofBSpH7D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERHiVYQA0ydr1Jr/ARpsf13+twhCS/LqqqGg5APb9WZjSNUJj2v5TOZFW3geavJ6d
	 UvMljB6555EZgPY/3TyGD+9/MNVnZDAXUXl3giPXGMISx12zb4rnqPlfWGuTnsqweE
	 R0LlsZPjWg3bSFOHrnsjKrGqUR3UfIT02G0wB/yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitrios Katsaros <patcherwork@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/175] ASoC: tlv320adcx140: Propagate error codes during probe
Date: Mon,  9 Feb 2026 15:22:46 +0100
Message-ID: <20260209142323.774269652@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Dimitrios Katsaros <patcherwork@gmail.com>

[ Upstream commit d89aad92cfd15edbd704746f44c98fe687f9366f ]

When scanning for the reset pin, we could get an -EPROBE_DEFER.
The driver would assume that no reset pin had been defined,
which would mean that the chip would never be powered.

Now we both respect any error we get from devm_gpiod_get_optional.
We also now properly report the missing GPIO definition when
'gpio_reset' is NULL.

Signed-off-by: Dimitrios Katsaros <patcherwork@gmail.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://patch.msgid.link/20260113-sound-soc-codecs-tvl320adcx140-v4-3-8f7ecec525c8@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adcx140.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 62d936c2838c9..1565727ca2f3d 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -1156,6 +1156,9 @@ static int adcx140_i2c_probe(struct i2c_client *i2c)
 	adcx140->gpio_reset = devm_gpiod_get_optional(adcx140->dev,
 						      "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(adcx140->gpio_reset))
+		return dev_err_probe(&i2c->dev, PTR_ERR(adcx140->gpio_reset),
+				     "Failed to get Reset GPIO\n");
+	if (!adcx140->gpio_reset)
 		dev_info(&i2c->dev, "Reset GPIO not defined\n");
 
 	adcx140->supply_areg = devm_regulator_get_optional(adcx140->dev,
-- 
2.51.0



