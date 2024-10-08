Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A8B1DF72C;
	Tue,  8 Oct 2024 13:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393663; cv=none; b=UML+ZVSjU5tBb0Mz10k5lnIPgPSHAyN1VJ0ZAU/BBqvQQIcZ4HOM9DjOj2mSpefypysvrJyNKl3su9oC41bjGwO8A1N5Znc8inPxQXNKYwiwNTSNX5c3VQYm+xrcFfRVxP19oyOU7id2jXM04Wk5g7zi1ACd1nMQSjvBdfnJ6So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393663; c=relaxed/simple;
	bh=r4Oa5cEz01RTf39Dw3GAXQ3rhZdASrYJZ36VUYFrQoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=em7Pxd5ge86yEfqQ5ym5B6qpBwAFZgsEg1bozIsDsIJv1di0/QOLfuClip3FzujyvVqg0V/XIXsuaZL/qqS614x9Cb2LD1yR6QUh7ShAld+nLh3gmsXWJ3ON0sH1ZHRNRwjCebQtkTxhGeFPRvOfkci2BVQIUXbmfzp1wWVSIEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfaAUm+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfaAUm+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E38BC4CECD;
	Tue,  8 Oct 2024 13:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393662;
	bh=r4Oa5cEz01RTf39Dw3GAXQ3rhZdASrYJZ36VUYFrQoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfaAUm+NeFsvVH4m5ejpg7m9Qe8wRcS2Ax4dg1ZAtDcqqZVhScNVTDiX6I0fEa1Zm
	 PqGJS8TsEBPLCtZEaDHmHwHBfB8uiYyBBjbBuuFqPQYelJxV3M8nD+i6+Sa5F3Omym
	 R+AhQW9dwfr78t370fk8DADJCVAJH+6kt7XvSnCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 218/386] spi: bcm63xx: Fix missing pm_runtime_disable()
Date: Tue,  8 Oct 2024 14:07:43 +0200
Message-ID: <20241008115637.985713301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 265697288ec2160ca84707565d6641d46f69b0ff upstream.

The pm_runtime_disable() is missing in the remove function, fix it
by using devm_pm_runtime_enable(), so the pm_runtime_disable() in
the probe error path can also be removed.

Fixes: 2d13f2ff6073 ("spi: bcm63xx-spi: fix pm_runtime")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20240819123349.4020472-3-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -584,13 +584,15 @@ static int bcm63xx_spi_probe(struct plat
 
 	bcm_spi_writeb(bs, SPI_INTR_CLEAR_ALL, SPI_INT_STATUS);
 
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		goto out_clk_disable;
 
 	/* register and we are done */
 	ret = devm_spi_register_controller(dev, host);
 	if (ret) {
 		dev_err(dev, "spi register failed\n");
-		goto out_pm_disable;
+		goto out_clk_disable;
 	}
 
 	dev_info(dev, "at %pr (irq %d, FIFOs size %d)\n",
@@ -598,8 +600,6 @@ static int bcm63xx_spi_probe(struct plat
 
 	return 0;
 
-out_pm_disable:
-	pm_runtime_disable(&pdev->dev);
 out_clk_disable:
 	clk_disable_unprepare(clk);
 out_err:


