Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55463FF1CD;
	Fri, 15 May 2026 15:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860340; cv=none; b=BdhaezWtW5kAsockuojHROln2KpUfC1xqOGShLcdXVRc9YrDF+RdezNrzxNdGuWfGiiHy/jSCS61fMZ7ddydNBlAvAuvUKhmqJwJbFLeaxT5LRQk3XJz/JffMU7UlyV1tUFmm2t4SGICU5LIlcRDmE9xBikzOuA7WqjW7973NSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860340; c=relaxed/simple;
	bh=j8QEHKxbJAzgkYv4iUYU6yK61Cg4z8/UDAehdbJ8xuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wgq9BdW2F1ToJafaazEeqOLU6x5BlXP1iTjK3oOtMl2yhVmFBm24uq/DdPNCKqkaCiq3HdgnomS42Kxlfz9CSTfAUIZL4qed/cJb26OfOXMKf+JAU6gXX6+t/N5iy1B+3zmTNrN43yG9yJCn0d5GqpQft/cWPjCBjZ4oX9WnJa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p7+6OzUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p7+6OzUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3C2C2BCB0;
	Fri, 15 May 2026 15:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860340;
	bh=j8QEHKxbJAzgkYv4iUYU6yK61Cg4z8/UDAehdbJ8xuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7+6OzUQtZefiAx/IDnzQ4+nyxQZYZbIZzF8b/nA/HNbudNufEuTfNA7DurM2XTJF
	 Cn1ek9giE4YWDvqvSUVvVYsFiLN3Ts92hEdBUJd51BZc3x1Qc5kOJC3Es1Qr2NnIQZ
	 PaJJHt5U0ig8dUkc7tN8z4dOjhAwRCcd7IWQljPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 050/144] spi: npcm-pspi: fix controller deregistration
Date: Fri, 15 May 2026 17:47:56 +0200
Message-ID: <20260515154654.700571665@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ebd81199e00e107980bf8c4d2c747ae50158f797 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 2a22f1b30cee ("spi: npcm: add NPCM PSPI controller driver")
Cc: stable@vger.kernel.org	# 5.0
Cc: Tomer Maimon <tmaimon77@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-5-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-npcm-pspi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-npcm-pspi.c
+++ b/drivers/spi/spi-npcm-pspi.c
@@ -414,7 +414,7 @@ static int npcm_pspi_probe(struct platfo
 	/* set to default clock rate */
 	npcm_pspi_set_baudrate(priv, NPCM_PSPI_DEFAULT_CLK);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto out_disable_clk;
 
@@ -435,8 +435,14 @@ static void npcm_pspi_remove(struct plat
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct npcm_pspi *priv = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	npcm_pspi_reset_hw(priv);
 	clk_disable_unprepare(priv->clk);
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id npcm_pspi_match[] = {


