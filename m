Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145591DF759;
	Tue,  8 Oct 2024 12:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390447; cv=none; b=KUCetaoosVWmxJ9KH2a+3DBXlI6Bo83KaBSJSfqlFMmbeXqCKVk85TcufvwB9ydCnmiIam1MELYFbNtj+2n67MWNRBkQ2RbgmPcFT7d1GbZkhbGh1oTxzR2IChL6f9pmqxu2h2N96olAyEH9XzXBoCjFAUaZoTNqs6Ofc/LSYOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390447; c=relaxed/simple;
	bh=QAp6zXhNeroWQGg/b8YBTVcRE8Ge+HmeNa69DgJtMh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEDzAZ+eWB5KVV5ry5xNRiEEOSNs7Uk6Uiks+WhuUulKVjSO9l3SQ9H9tuC+gCSG+UPqVShhCFKlThQpt9J/KMhFqm0qPHrK/0LDdH5d244FwvCZZXGqgSv4LYVErJpWzOZDwjALxhFU4V4tffisRR9tX5dwyLy8FZBNoOmPPDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6AIJCaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6AIJCaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487B3C4CEC7;
	Tue,  8 Oct 2024 12:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390446;
	bh=QAp6zXhNeroWQGg/b8YBTVcRE8Ge+HmeNa69DgJtMh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6AIJCaFgxB4TyNULrSNCh3RKAHzaGryCI+vBkHuyLtU36Rw7Iog2Ds3hdrwjOrSo
	 XbyzmXFOiAkCzJCpD9acbKMAIA7WaWNobBBK9NmlIFD8uCi/IbbqeuPANa+SKH1ROY
	 2w261btVO0iM7P03P+JTnvYCfaucIRqPEy/4lN3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 260/482] spi: spi-cadence: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue,  8 Oct 2024 14:05:23 +0200
Message-ID: <20241008115658.517144313@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index e5140532071d2..316da99f798c8 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -665,8 +665,8 @@ static int cdns_spi_probe(struct platform_device *pdev)
 
 clk_dis_all:
 	if (!spi_controller_is_target(ctlr)) {
-		pm_runtime_set_suspended(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
+		pm_runtime_set_suspended(&pdev->dev);
 	}
 remove_ctlr:
 	spi_controller_put(ctlr);
@@ -688,8 +688,8 @@ static void cdns_spi_remove(struct platform_device *pdev)
 
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	spi_unregister_controller(ctlr);
 }
-- 
2.43.0



