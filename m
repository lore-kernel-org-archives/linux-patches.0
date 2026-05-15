Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06CD3F6C48;
	Fri, 15 May 2026 16:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862069; cv=none; b=eRTvdV80iY1xp6peqjPWmoZKMf6nr0iXRrwqIYbDWJxZ5pr9IKZdhGGNqDQ/tjNDDIy12U22fcbuAAyNI4CoX5r8W42sZcu76VNS+bKpbNsqAp1fZBIw4kf//T6ZQmmMglDR52tr6a/Tx6ryOUZYgKA5/jk5TghFuUh7exPWc0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862069; c=relaxed/simple;
	bh=KvTgLFdwDXAm1QOHkZ8OB573HeWkNMuHrhvyYYvudfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAcW2wrJr2pDF5EV8AX2mOvMZkFdDy1wvhZsEHO4xTRnApF6cfSZab8NF3KdRX8f1xhyoDrqIcN6rKRAY9R/rQwdBLkQNxu3tLPHl09wxlaR+xUzboIBZFs6Gg3xkP4FDQsCaIHI1gG9X+R0czAELPhz2TNs53vK0K5m86M6AFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7512uMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7512uMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DDDC2BCB0;
	Fri, 15 May 2026 16:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862069;
	bh=KvTgLFdwDXAm1QOHkZ8OB573HeWkNMuHrhvyYYvudfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7512uMkaErPhaQqoSlW5QbXVlaR19tHsf6fZPkhzgD2tPY4WHi+2vOBeKB+kM139
	 fEHjRjmy4C51D9V9Jx926kES8gPPg7iDyhc+LkHsr90qllmua4jg1vb5hLyU23zyxQ
	 80VTDhlyNleK9sFe2sKhJ2SF3TvKs03Pa/kkLQNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 095/188] spi: cadence: fix unclocked access on unbind
Date: Fri, 15 May 2026 17:48:32 +0200
Message-ID: <20260515154659.389838936@linuxfoundation.org>
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

commit 5b1689a41f02955c5361944f748a4812a6ff9307 upstream.

Make sure that the controller is runtime resumed before disabling it
during driver unbind to avoid unclocked register access and unbalanced
clock disable.

Also restore the autosuspend setting.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: d36ccd9f7ea4 ("spi: cadence: Runtime pm adaptation")
Cc: stable@vger.kernel.org	# 4.7
Cc: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Link: https://sashiko.dev/#/patchset/20260414134319.978196-1-johan%40kernel.org?part=1
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421123615.1533617-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -697,16 +697,23 @@ static void cdns_spi_remove(struct platf
 {
 	struct spi_controller *ctlr = platform_get_drvdata(pdev);
 	struct cdns_spi *xspi = spi_controller_get_devdata(ctlr);
+	int ret = 0;
+
+	if (!spi_controller_is_target(ctlr))
+		ret = pm_runtime_get_sync(&pdev->dev);
 
 	spi_controller_get(ctlr);
 
 	spi_unregister_controller(ctlr);
 
-	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
+	if (ret >= 0)
+		cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
 	if (!spi_controller_is_target(ctlr)) {
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_set_suspended(&pdev->dev);
+		pm_runtime_put_noidle(&pdev->dev);
+		pm_runtime_dont_use_autosuspend(&pdev->dev);
 	}
 
 	spi_controller_put(ctlr);


