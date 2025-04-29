Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD9322AE68;
	Tue, 29 Apr 2025 18:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950069; cv=none; b=sKysjbaNsRsKl3XDxYrgf5GUK6IkZGuXsSZXx+BIyoKR4PnS04aJmkxDzFgz1F10Wo8u4lpUOHl7W4Q0pWZlx9dEMgJGHxTJK8ZfmbBk7vUHMHg2XvzH8Yut4NyR4/67M+ODYxm1lMp6UwhlSJGNyS2KHLHwBuZ/VnEXhxZOD4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950069; c=relaxed/simple;
	bh=bOkFb9H0aKWhniY//yVxLL5DTlPQ8nKmd0cq42JfwCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Up9Q6+9HCJC9BC7wBssyhl7OQ7PEPo5sIeW579wAUUZm/bZ4aLP8Ol0uQ1hdSoty2RuunYCyh9txd8tRK4OVMmCledc0rePm05xiawYcokKhMTtnzwE1k6YT4jJEReN+FKZ52Tkx38pWBdrhlWuq7ar2FOdg41wcmMU+40rASNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlGWlGy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlGWlGy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088AAC4CEE3;
	Tue, 29 Apr 2025 18:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950068;
	bh=bOkFb9H0aKWhniY//yVxLL5DTlPQ8nKmd0cq42JfwCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlGWlGy0aHXb75gShMpWNRl6TwBVgqN3hWO3FRYhcAbIrsVOW33XQlCYrwA3snC/K
	 NkkSLE/IRnNJID21ELBDDEmu5B/Tuu+oWZ0ulyGP+4ZqQ7jtDa9JPkD1/FPOehAjZL
	 KtN7xcD5MiwLFLdPzyiu0ruaHoZk2qxqtq8AFW2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/167] spi: tegra210-quad: add rate limiting and simplify timeout error message
Date: Tue, 29 Apr 2025 18:44:14 +0200
Message-ID: <20250429161057.633965782@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 21f4314e66ed8d40b2ee24185d1a06a07a512eb1 ]

On malfunctioning hardware, timeout error messages can appear thousands
of times, creating unnecessary system pressure and log bloat. This patch
makes two improvements:

1. Replace dev_err() with dev_err_ratelimited() to prevent log flooding
   when hardware errors persist
2. Remove the redundant timeout value parameter from the error message,
   as 'ret' is always zero in this error path

These changes reduce logging overhead while maintaining necessary error
reporting for debugging purposes.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20250401-tegra-v2-2-126c293ec047@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 97f3a4d3c31a9..442d42130ec87 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1111,8 +1111,8 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 					QSPI_DMA_TIMEOUT);
 
 			if (WARN_ON_ONCE(ret == 0)) {
-				dev_err(tqspi->dev, "QSPI Transfer failed with timeout: %d\n",
-					ret);
+				dev_err_ratelimited(tqspi->dev,
+						    "QSPI Transfer failed with timeout\n");
 				if (tqspi->is_curr_dma_xfer &&
 				    (tqspi->cur_direction & DATA_DIR_TX))
 					dmaengine_terminate_all
-- 
2.39.5



