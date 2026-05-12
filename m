Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF1650276;
	Tue, 12 May 2026 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609159; cv=none; b=QaYsMY7zRgSighbwTdedobkaiwlYjub/HhiQmmr7A0DZVQ0htr63clIM9WRT4mD5NthFHRqhrDi0c3rpmCN0XpPVYFrNkAalPyQNhwy8j85JPkj+XBJM6dTDTrj9Kv41h7w8e2NH9YAenKk/pxbTnZZOxoh2wBT6ycCnWueD+h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609159; c=relaxed/simple;
	bh=8/uVstAO2fdEbASuoSm4U5EaDcohvgSKpgrX8qBMT3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8a8f1YovrgGoLakPLayzzF2wkfa1MXJrj9vVNOeGS2phvZCr92wF14fNE/gOqNzUnJJMHGwdMVaXYaOXGM/P9NuXJz1VJ7cTVtqGpecjC5KmXoDo1MeUgpOx7unenokG/koXpn5Gsc0pKaVX9Gr+GA1ZYqNUf0hRh3DmTtS/BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzex9wa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzex9wa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41E5C2BCC7;
	Tue, 12 May 2026 18:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609159;
	bh=8/uVstAO2fdEbASuoSm4U5EaDcohvgSKpgrX8qBMT3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzex9wa3N4ewtYUXMagHJVvhsBuMH9SMWvznFB7pxb64EUCl6CxAEdcetvs6KemLE
	 TimqGCNEMMrHpyYnstMu+Lhd0F277L0E8YQCraDXbnJFbQx8hlg2HXHog1IGS4+r/j
	 SIZ5TmQGV6hFZENZDs80vw6yNPwhPpgEABD7Q/Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 088/307] spi: tegra20-sflash: fix controller deregistration
Date: Tue, 12 May 2026 19:38:03 +0200
Message-ID: <20260512173941.984814164@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

commit ad7310e983327f939dd6c4e801eab13238992572 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: f12f7318c44a ("spi: tegra20-sflash: use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-23-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra20-sflash.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -505,7 +505,7 @@ static int tegra_sflash_probe(struct pla
 	tegra_sflash_writel(tsd, tsd->def_command_reg, SPI_COMMAND);
 	pm_runtime_put(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to host err %d\n", ret);
 		goto exit_pm_disable;
@@ -528,11 +528,17 @@ static void tegra_sflash_remove(struct p
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct tegra_sflash_data	*tsd = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	free_irq(tsd->irq, tsd);
 
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		tegra_sflash_runtime_suspend(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM_SLEEP


