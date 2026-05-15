Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C933E00B3;
	Fri, 15 May 2026 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862049; cv=none; b=Rrb72S1X6xlqj5LoIstlnqIJ4c+16iW4aX7NtDFChVoqQSW4sIie5IeE9rVZL69DPifMqZ46gnJdrxl6zuZw7aovY2qIhya+x3BqHizU6kC5HNjV7GoPZSBHWLDMSaadiTQHAkaXKIxIsuoVZokT+zEpsTm2SGc3Me/DdJaFa7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862049; c=relaxed/simple;
	bh=OgEj7DNexCbq58Q9TfIXid5roMadAR78Vz/86nR3MaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcKXQ9Crq3CbXBcTPrIGGZ5Em6Qy26FPHrhLyi3HmWg8MKcRoAcROrENhb6wXIciuMTU6R4vYj5P7PAfUgDJduVlmqEu2gdrHBNBPb82GH2RIcIbLoU8BoZQx5V4dRkqV+zJ8sIEEbxa9/mqtYwkLN/ol/e6hflGbvAsHMqnyGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGKE7S/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGKE7S/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F03C2BCB0;
	Fri, 15 May 2026 16:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862048;
	bh=OgEj7DNexCbq58Q9TfIXid5roMadAR78Vz/86nR3MaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGKE7S/OHkJyk/sRyiiFOZEu4eR2p3CIVP3fyBxtfWEreYF9nRTTHn98wGT16G7pF
	 tu1uLH8M5zHr+oqvzPMdDTXWH9lk0BhrWf0yWVGABwqYxNZLkyS7McibIDe1Y9y06e
	 1ztxTBW6CNYL7rVA1VpeeSbRp1wUZBimqaNtu+TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 088/188] spi: orion: fix controller deregistration
Date: Fri, 15 May 2026 17:48:25 +0200
Message-ID: <20260515154659.234930596@linuxfoundation.org>
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

commit 220f4f11104a7f83b71543ef0e48dde1da2bc5d3 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 60cadec9da7b ("spi: new orion_spi driver")
Cc: stable@vger.kernel.org	# 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-7-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-orion.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-orion.c
+++ b/drivers/spi/spi-orion.c
@@ -802,10 +802,15 @@ static void orion_spi_remove(struct plat
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct orion_spi *spi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_get_sync(&pdev->dev);
 	clk_disable_unprepare(spi->axi_clk);
 
-	spi_unregister_controller(host);
+	spi_controller_put(host);
+
 	pm_runtime_disable(&pdev->dev);
 }
 


