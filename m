Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0BA39734B;
	Fri, 15 May 2026 16:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862565; cv=none; b=nHQfFh2L7kWymgLyyMWDRDJ968VGG0RP6CXiE2gx3xX11qTqfgD/VrG7QB0hOMmGqpBs4DF3wsSp7coW6kZVdO5K253OwtzOBItM6ZcBIirU94OCkobexk/u7SDnPqaFMTZhDFxV3aBKJwChrGkyviOK2lmLSKLY6U/PcDd/mpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862565; c=relaxed/simple;
	bh=8GHkuWxvbcEsZuRjQz/jxRZ7mQ8C304BVEWvIb2akZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVPaLuX4YZDi6hRPM1zwvyI52ItzVvne1GPN3JQ7pSMgoNmDJ5syBzqFJGo0iPT7Vc3geuIL9wjYFXziolWwIp1ujpg+erYy1imgSdBMcc5B2VSq11FttDbFq6u45GAQGAuQN1M/APpxuKfJRuv0j2qFP4Mw4l2H/IjtQVuNuTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2XnX6Vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2XnX6Vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD260C2BCB0;
	Fri, 15 May 2026 16:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862565;
	bh=8GHkuWxvbcEsZuRjQz/jxRZ7mQ8C304BVEWvIb2akZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2XnX6VxphPXzEhXOyMwE6d1nE3nf21xpDNrnMDE1j7QFjUq5cQGl0PSxgI3IRmI2
	 S4wGVJePBwrbYd2YvjMCPh+fRbau49ed+uFZ/rl3DyVGjP4N0mOdT4LeNfFIAbA3Ji
	 OlxcW9pfCtQ/+91rb5e8mEEOiV05RYgZi/PYK28Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 098/201] spi: npcm-pspi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:36 +0200
Message-ID: <20260515154700.657004185@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -413,7 +413,7 @@ static int npcm_pspi_probe(struct platfo
 	/* set to default clock rate */
 	npcm_pspi_set_baudrate(priv, NPCM_PSPI_DEFAULT_CLK);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto out_disable_clk;
 
@@ -434,8 +434,14 @@ static void npcm_pspi_remove(struct plat
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


