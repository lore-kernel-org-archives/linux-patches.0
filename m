Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE58E29D267;
	Fri, 15 May 2026 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862018; cv=none; b=ExfEoPuD+Ja7cVEv4OvjH9Zg+hoSSrNsST5wQ1gGk9nSHLf98x/YxI7UTpF1ZmNj1yha6iTLk/lpPZoC0WH75rvvRIfnApOADEnpnwBK4VMIvs+qAhQ4PhxUvTUibegRNe5ENkJcPMmKLOpqeT4nwT7ypv0RWm0f98kQA1Pbw1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862018; c=relaxed/simple;
	bh=kDkt3fNikKGlZ6rc1+pJF5ZFTue9hV3LgN6h93wr2qY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yd9dBx0cXLSp9VspBOMojQWB8ikhXWQe/7JKGNhY68Mf9zWCRdQCOWPdx8EL15CpdLX0qUvKTneaqpEHfxvbbAIg5u4XT59MO3aUML+AKVOg2SzFCMS4E2MLTlq56J/yORmxpEKbPFSZmEdaZA/9CjFi11wygEq8jtMVNQPZrto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7k3st8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7k3st8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4FBC2BCB0;
	Fri, 15 May 2026 16:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862017;
	bh=kDkt3fNikKGlZ6rc1+pJF5ZFTue9hV3LgN6h93wr2qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7k3st8ME8MHA5Zx7b1DKyLjDD9KapYVmQjyoYgdjVCoQukGPp8RVLmxYMoWdAecN
	 AhDQbfooqrrwbWHV2wZh3ctqIOc2CBmnLvZTiqIiEfRRe5R2l4dalETvnyXfj2FOyI
	 9ydDQkmQZsUN2RDI7rL83RDk2peT3ncJ9ORjcnNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomer Maimon <tmaimon77@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 077/188] spi: npcm-pspi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:14 +0200
Message-ID: <20260515154658.990643662@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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


