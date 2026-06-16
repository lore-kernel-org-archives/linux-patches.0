Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AF93D8902;
	Tue, 16 Jun 2026 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634757; cv=none; b=HAKp+ioC7lRMWX6blyawcg7RBc2XzRdFt7y4ESN11kRJtTIA1tsvVIpjscfyPDool8YHBAYLon4aP6JD2R3WZqs+/6caWVosv4q/DS9SVPBp12QaVHU4sS4H4ql1tqvwdCduXpZt5bjmv9iygIV/djg/srbyZmiSr1VsK6IVjhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634757; c=relaxed/simple;
	bh=02KnEV0O/JiVz02hknLgHyfPWIeiJYFKjdieR7KnKGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WekixfUh8fgM08SPIs7Q/orR/p+EcVXlGZxijaqH8GTto6UVlRq0S8za7aP+LC7ZQkMtlFlRniNJrcchehcrpAmTAYbkMdNOFlSxvXhBu32+hv6uCcP/ECkYZCJTqr/kOcwRnLC/ETyCifoy2KsiWlZz6toICfHHLeiT50Izn6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+Gy3BYq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+Gy3BYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5F61F000E9;
	Tue, 16 Jun 2026 18:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634752;
	bh=+Z0+Aov8CQg+8Fc0pkXxJ0k1/jq8Pn+uxIbBFx/fgFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+Gy3BYqtYGBP4P20ogulblqzMBQX3uXQVJyPUuXhQIYm55tHiJsYBTM+AcnscqtJ
	 YolJTjFF2ph34KWRjs2E3r2X3GS4dZ+6QOSJTDOT0XAUUEKjUCGfH2DppBI+CEAVdf
	 ddDJXtzD9AerLL9Qad7cJCpszUk1jMb9xusR/Jso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masayuki Ohtake <masa-korg@dsn.okisemi.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 323/411] spi: topcliff-pch: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:21 +0530
Message-ID: <20260616145118.324999322@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ renamed spi_controller_*(data->host) calls to spi_master_*(data->master) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-topcliff-pch.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1450,11 +1450,16 @@ static void pch_spi_pd_remove(struct pla
 		free_irq(board_dat->pdev->irq, data);
 	}
 
+	spi_master_get(data->master);
+
+	spi_unregister_master(data->master);
+
 	if (use_dma)
 		pch_free_dma_buf(board_dat, data);
 
 	pci_iounmap(board_dat->pdev, data->io_remap_addr);
-	spi_unregister_master(data->master);
+
+	spi_master_put(data->master);
 }
 #ifdef CONFIG_PM
 static int pch_spi_pd_suspend(struct platform_device *pd_dev,


