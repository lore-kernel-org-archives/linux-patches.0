Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905413EDE55;
	Tue, 12 May 2026 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609151; cv=none; b=HCgo9aJSWa6oakFjzAMcQnMjyRipHJT06G8X2WMaVtp90ozOLjlC8sW9hQ1sE2SKXgCEen1fnOqKQmgnUh9mc7CKAKyshaPslbbdwhrVu8JjODkUlY2WJPW5qIZlLMaLBLDgZkGOl3BLx2OniMZv8nsd36CqcWboLHbn2ifxc/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609151; c=relaxed/simple;
	bh=MWSCQdNYzkNyJaCOQiZK0hJs0A8w/1wbczPIvQfqT9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6UMswfArLDbCwE03i7cqF9Lqe3qf501yWiKuyG+oul9OXPBvXvtjEeaTkENFVe0cnrR3wuxV7Y9wgieJc68B4Nrn0CFwBpHw5C3+NCdXQAbSDd+7uJ2z/t1qF+BgZSWjJoK8wzHHwDKCZd2Jfa5VZKTTRVy7mxrtKkMy2wUF/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzEc8Nzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzEc8Nzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F15C2BCB0;
	Tue, 12 May 2026 18:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609151;
	bh=MWSCQdNYzkNyJaCOQiZK0hJs0A8w/1wbczPIvQfqT9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzEc8Nziqwih1bk/6WyTFPHJ2tkdQSIzfRkCqU8bUCZTWuPS0NrdM/YGd4YfB49Z4
	 TuOtLWIyETQI4XS5VTmNwnPRhfBO9iFpDb8iHLrlJhTTF00NhtjmvzCHz/xTpgXn7m
	 8rVzrc08EbHoQ1a8+K9a5+4uovVG08dCnYl0TSEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 086/307] spi: tegra114: fix controller deregistration
Date: Tue, 12 May 2026 19:38:01 +0200
Message-ID: <20260512173941.938473578@linuxfoundation.org>
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

commit 9c9c27ff2058142d8f800de3186d6864184958de upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 5c8096439600 ("spi: tegra114: use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.13
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-22-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra114.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -1415,7 +1415,7 @@ static int tegra_spi_probe(struct platfo
 		goto exit_pm_disable;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can not register to host err %d\n", ret);
 		goto exit_free_irq;
@@ -1441,6 +1441,10 @@ static void tegra_spi_remove(struct plat
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct tegra_spi_data	*tspi = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	free_irq(tspi->irq, tspi);
 
 	if (tspi->tx_dma_chan)
@@ -1452,6 +1456,8 @@ static void tegra_spi_remove(struct plat
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		tegra_spi_runtime_suspend(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM_SLEEP


