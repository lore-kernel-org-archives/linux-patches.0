Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF231DEFE3;
	Tue,  8 Oct 2024 12:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392099; cv=none; b=nCX5fqcO1VyJtH3T1Xr8nGC0UhqOH01oFbcIZ+XqNYUHx3IuBW0LGHcofpw5NkDm27lXDMKdvKsLnX6zuutHK53J2yuVjrQh+38ZwZaIeMn0IXkz1lcHVyrZAeH1EKP9j7ypd9Xh8oyGJm5TDiw6lFVJ/NK8XetbXFLI1KKobAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392099; c=relaxed/simple;
	bh=IRG3ssFy0TJXhS0ozhXbr17q8H3/FOjITmC6kbSOjTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIB5aZ2XUUriwa0KO1teduDRKwSy4yRmddNpFHuW1zkZzSVJiruNYpLpcVQ8IQoOdJx4FoDPqHCwARXnDkNS4rcziWE3Qojx/NwLvi8BLSK/uBLpGaJVlXkyp9A5LpFP/6eSD7Aq2U/7tfoW6999AnpFTX98MAMVfenPqPEvrQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPFHpDqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPFHpDqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8D3C4AF0D;
	Tue,  8 Oct 2024 12:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392099;
	bh=IRG3ssFy0TJXhS0ozhXbr17q8H3/FOjITmC6kbSOjTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zPFHpDqK9ojJWrgPg5qqNPaf6C7gAn6aWE5Q838OsWIiWW0/7yUOWRfxUJCB2BooP
	 RXO7JzUj1iuoM3NbPegG2zrlsafMBP792YKIRDEqDkrAVNu7VhaV7aqNjPuBDBbQAp
	 DF75fM6T8v2KAjVr24A4qRVlpjxSukj8SCiMGWxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 316/558] spi: spi-cadence: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue,  8 Oct 2024 14:05:46 +0200
Message-ID: <20241008115714.744541097@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 67d4a70faa662df07451e83db1546d3ca0695e08 ]

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Fixes: d36ccd9f7ea4 ("spi: cadence: Runtime pm adaptation")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240923040015.3009329-3-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index e07e081de5ea4..087e748d9cc95 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -678,8 +678,8 @@ static int cdns_spi_probe(struct platform_device *pdev)
 
 clk_dis_all:
 	if (!spi_controller_is_target(ctlr)) {
-		pm_runtime_set_suspended(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
+		pm_runtime_set_suspended(&pdev->dev);
 	}
 remove_ctlr:
 	spi_controller_put(ctlr);
@@ -701,8 +701,8 @@ static void cdns_spi_remove(struct platform_device *pdev)
 
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	spi_unregister_controller(ctlr);
 }
-- 
2.43.0



