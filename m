Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7698318EDA;
	Tue, 16 Jun 2026 19:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636582; cv=none; b=IpT2wpl5zdTQtnk1zH4aqpdDMOkbA5wJfoUOI3j3sLOf2lxoxyfFiWO0Fxbcz8Gl/Y6/mWkw1aA0J805M3DsD5UnunqhDzUzVX4eiLHvbSTHMUz6vRDdxBSXELNZ/HH8BotSZf/Lc9ESXtzx2RCkwAM1wWlmqs5PUsSJaviY4Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636582; c=relaxed/simple;
	bh=1sZgTPsA8inun41xQ8lDe2N/okYjuODK1tjHgdJtPss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaqW7qUm0whCUcvjxiBNv5ONCkxDFvGGTDlbH+jaUl9xgYOioagmh6yp7luuCqh7L3JzB6Bre++WBCZPRUsP8H0ksTMKfqjQ4MIJR/SzjTqXXSJJRxUd3qTTHjsZnHrVzgMaCNSK31/1HCMpxra279LchDhVwIisLLBpO/rns4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPLmuq06; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPLmuq06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9078B1F000E9;
	Tue, 16 Jun 2026 19:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636576;
	bh=hQsfyTrtrJ8Irm+1hRa4tbpKX3QhuYrpofMFJanulOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPLmuq06HZmYxSTQ5M8EGlnCAgv843ybZ8uFc2TN2bMSZSQozJZ27LbyUrBuEZZXj
	 +UY+kN8v4QE9Pnu09Y2xtsOUNpfrRdFVvB2q9HTmVoGgOc5UKfWIMK6KbD6k/YPxUB
	 T0SfnHWuAFUQlHe2hDKVCfd45IuVODbUOygkIsfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/342] spi: topcliff-pch: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:22 +0530
Message-ID: <20260616145100.668150758@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 5d6f477d6fc0767c57c5e1e6f55a1662820eef87 ]

Make sure to deregister the controller before disabling and releasing
underlying resources like interrupts and DMA during driver unbind.

Fixes: e8b17b5b3f30 ("spi/topcliff: Add topcliff platform controller hub (PCH) spi bus driver")
Cc: stable@vger.kernel.org	# 2.6.37
Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-8-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed data->host to data->master and kept return 0 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-topcliff-pch.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1449,11 +1449,16 @@ static int pch_spi_pd_remove(struct plat
 		free_irq(board_dat->pdev->irq, data);
 	}
 
+	spi_controller_get(data->master);
+
+	spi_unregister_controller(data->master);
+
 	if (use_dma)
 		pch_free_dma_buf(board_dat, data);
 
 	pci_iounmap(board_dat->pdev, data->io_remap_addr);
-	spi_unregister_master(data->master);
+
+	spi_controller_put(data->master);
 
 	return 0;
 }


