Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB394C040C;
	Fri, 15 May 2026 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862534; cv=none; b=hv0mUnTNu/MiWgYYytoObx1MO3C1xZP0h6fqmwx7eeqWYOvSWhXLazZCua3hr4Utw6ZINLIzPu6M3YBTN/CM1JxkcZCQp/v9y7Eqvbu9K7/UpRq6bApuDcav3SsQvTjwA6QoVI3ddCxHaXXBRd8Wv3R0G3MUBOYXw8kN7K1vy38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862534; c=relaxed/simple;
	bh=o+s5BxD2oTEcHXUQQ+K7DaUZru8rwnVldworQS4LyFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVR7Qt4N2VDwJT3+/q/tpwgkK0D3OcewWRebS2Feof8Nqx6cuIQ3VAqk7kpJjgCqc6CWHdbrPDQKSs7u+GppFGjy6opszKk0U6oFdTaTXVP0/R4iknraexGUZuwA5L8QE240jkvpd96/fg27/IA4jNEnkFiAAYedKpij7RKNVx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmR/Ayb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmR/Ayb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85BEC2BCB0;
	Fri, 15 May 2026 16:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862534;
	bh=o+s5BxD2oTEcHXUQQ+K7DaUZru8rwnVldworQS4LyFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmR/Ayb6ISmlGeaEbUJ1TKsv8Z732NIq4nKsEe23K/eLEp7UVmQKW+o+pa2ewV25+
	 CO7dBE0HJxfJH5NTw7zMp78It3GsOIt5ldP3JUWadXdNikw64OkQGy+HMW8ehCIUk0
	 M75wYVD3y/Yz5OU7gpEsdbuMmf6WsHmpZQoz45FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 083/201] spi: mxs: fix controller deregistration
Date: Fri, 15 May 2026 17:48:21 +0200
Message-ID: <20260515154700.328526046@linuxfoundation.org>
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

commit 8b0d0011af20fb547aa67a1cefbf320992fd5e92 upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 33e195acf268 ("spi: mxs: use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mxs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mxs.c
+++ b/drivers/spi/spi-mxs.c
@@ -619,7 +619,7 @@ static int mxs_spi_probe(struct platform
 	if (ret)
 		goto out_pm_runtime_put;
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "Cannot register SPI host, %d\n", ret);
 		goto out_pm_runtime_put;
@@ -650,11 +650,17 @@ static void mxs_spi_remove(struct platfo
 	spi = spi_controller_get_devdata(host);
 	ssp = &spi->ssp;
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		mxs_spi_runtime_suspend(&pdev->dev);
 
 	dma_release_channel(ssp->dmach);
+
+	spi_controller_put(host);
 }
 
 static struct platform_driver mxs_spi_driver = {


