Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B14A13B7BE;
	Tue, 27 Feb 2024 13:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040639; cv=none; b=BRbdrEmBp0BkDtpI94dyWVVmZZWx+pM3AF0NaGmoYmKUGAuq9oQ17zDrkGoh+aYgOIp1OD1WgZxZFLctLD+ww2peSxC/Cp3aI6TBAKCz0NF0uOQJcSxpdzQRYe7FSggsT/XqJy8GspYPYE9iuvgkrxE29ZfD4EDqb50obhm5xlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040639; c=relaxed/simple;
	bh=x+/+Uujl1W2NalL+iJ8OkWP7wJMdHBvl8dDeXO83xSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ypyf0tUjIk+f5NK15PiCYonPcsTFgCgpHu7m6HnAKdrC8oTQ4Dp4PBbEhtxSOrv2N2MorbjHBx5lOcKYJ5IV3E6wTFSJfSM4035FSmVHgr51QDJih4U63zqrRYTLRS3oya4UIQpa1TF9mFdUit8QN8R1hRez5WTwAGV73Wj2ZEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4NMGHY9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4NMGHY9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0EFC433F1;
	Tue, 27 Feb 2024 13:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040639;
	bh=x+/+Uujl1W2NalL+iJ8OkWP7wJMdHBvl8dDeXO83xSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4NMGHY9d8etAFPQwfp042yl0er4FZSwFEMDMF4a5trPXyeFDtC6B7dSohc3lyPNZ
	 x7StVpm8BpijqmTzlaLR+B6ITW9r2bOhRlrTcHlP8a8x5KVq8x9NrlwspMF/tYvBX2
	 BZojWG6ZA+NpI7TruWf4Kru+FQ6k0P6bGe3zzlhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 028/334] spi: cs42l43: Handle error from devm_pm_runtime_enable
Date: Tue, 27 Feb 2024 14:18:06 +0100
Message-ID: <20240227131631.505768719@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit f9f4b0c6425eb9ffd9bf62b8b8143e786b6ba695 ]

As it devm_pm_runtime_enable can fail due to memory allocations, it is
best to handle the error.

Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://msgid.link/r/20240124174101.2270249-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cs42l43.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cs42l43.c b/drivers/spi/spi-cs42l43.c
index d239fc5a49ccc..c1556b6529092 100644
--- a/drivers/spi/spi-cs42l43.c
+++ b/drivers/spi/spi-cs42l43.c
@@ -244,7 +244,10 @@ static int cs42l43_spi_probe(struct platform_device *pdev)
 	priv->ctlr->use_gpio_descriptors = true;
 	priv->ctlr->auto_runtime_pm = true;
 
-	devm_pm_runtime_enable(priv->dev);
+	ret = devm_pm_runtime_enable(priv->dev);
+	if (ret)
+		return ret;
+
 	pm_runtime_idle(priv->dev);
 
 	regmap_write(priv->regmap, CS42L43_TRAN_CONFIG6, CS42L43_FIFO_SIZE - 1);
-- 
2.43.0



