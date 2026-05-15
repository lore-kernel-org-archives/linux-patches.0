Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C18122FF22;
	Fri, 15 May 2026 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860330; cv=none; b=T1xQvemRdaHkgJTbDl4CwA5bC0K8u8DQ8praIJDJIXUyOZ91XuqxYozYhEOR8vYXQ0UmjOZ5M3pYYMvyiF8bu+zYxazU1hTlGBlzuWGQFhrAJy2wcdNEgDPqkeFq+27RAZ/9OeOphfuseoF0A+fH+i6tCRGTwye9yJny16/HmI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860330; c=relaxed/simple;
	bh=m4XrzqWZVbAx1mPVa35/IaqdWhDFxVhFZKHP6isTx9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAVue1zrQa44VoCVWjlfME5ajVvDHX6KYQhhUlhYh+jk4+vL3K0wQkSI9trKKEHu9zNuChVJ2p8cFHN7YRlmi4HSqJ/7m/Bmc8basdbl/UwoopEOciSoYZVxWyNhfgZ/ZvrRs8B4ycLCkmIqG1Chfd4lG6slDFFRTeIgwPGlPlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKJTQVhh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKJTQVhh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3984C2BCB0;
	Fri, 15 May 2026 15:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860330;
	bh=m4XrzqWZVbAx1mPVa35/IaqdWhDFxVhFZKHP6isTx9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKJTQVhhDzShL3ffoRok4SwgOVrHUSwgkSFmQF4UX0iRSB6FI5+G5XeGGDI35O/g5
	 D3UgynJOyJuQN/hjDy+rIwGT8aalqFV7LENNqfmEIdcxaZBh3DYVfOOfEVUs+t6SuW
	 vLOqblX5wjF2hy7ZtHy6I5fAKswiRc80Kfo7yflg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 046/144] spi: sh-hspi: fix controller deregistration
Date: Fri, 15 May 2026 17:47:52 +0200
Message-ID: <20260515154654.600998595@linuxfoundation.org>
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

commit e63982e6392e45a6ecd68d6c317a081cc8e70143 upstream.

Make sure to deregister the controller before releasing underlying
resources like clocks during driver unbind.

Fixes: 49e599b8595f ("spi: sh-hspi: control spi clock more correctly")
Cc: stable@vger.kernel.org	# 3.4
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-13-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sh-hspi.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-sh-hspi.c
+++ b/drivers/spi/spi-sh-hspi.c
@@ -258,9 +258,9 @@ static int hspi_probe(struct platform_de
 	ctlr->transfer_one_message = hspi_transfer_one_message;
 	ctlr->bits_per_word_mask = SPI_BPW_MASK(8);
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "devm_spi_register_controller error.\n");
+		dev_err(&pdev->dev, "failed to register controller\n");
 		goto error2;
 	}
 
@@ -280,9 +280,15 @@ static void hspi_remove(struct platform_
 {
 	struct hspi_priv *hspi = platform_get_drvdata(pdev);
 
+	spi_controller_get(hspi->ctlr);
+
+	spi_unregister_controller(hspi->ctlr);
+
 	pm_runtime_disable(&pdev->dev);
 
 	clk_put(hspi->clk);
+
+	spi_controller_put(hspi->ctlr);
 }
 
 static const struct of_device_id hspi_of_match[] = {


