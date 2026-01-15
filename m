Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34122D0C79;
	Thu, 15 Jan 2026 17:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497841; cv=none; b=Xl68dcWmr40RWgaTnPkmTIX0KzitQiZhX9/C/PGm8WkHUUT0f57qDx5Cdt9RPCp4Sl0qNUUH2XdRvOa6mS/hmjRwmXu8uEzg33C4GOqhc5FopBHYYEFsHQStxgAgawxuQGPYg4X6uZ2josU1Xh2rt4SpMv1t7m1uqam2xkezWNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497841; c=relaxed/simple;
	bh=nXkkXYz5hyCGj9veLF7RFD8gRvDHpicHd/xRFGQMUJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1qMLhcUBoLo90ozin55q2XIguDccKKApWyblc0CLuoiaDuEZL1SzT64G0qg55a1NLNLHwAiOe/wFBjqOG4Hgf8dr7I3d2Safmv3m0qTvQZJ3Ny4ijjKYI3ZWHKTcz9d7sy9HT9BzfXoWTwLChgn2GNu/UxUhdy3e+4jM/ThTCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiGF5BYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiGF5BYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C781C116D0;
	Thu, 15 Jan 2026 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497841;
	bh=nXkkXYz5hyCGj9veLF7RFD8gRvDHpicHd/xRFGQMUJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiGF5BYGtg8OEeFZLnKekJXSOHPrQCIC+ELXErX6AlvE17ZCak/u46d+Dl6knDqq6
	 gzUMPGWFexXMAwxwQTXKYvLn4FY6pWdP4kADqgwdb0G3h6QtrYRoMlJx8Gedjp/KWa
	 YIsI90cWA0aSH7zMyrS6IiXv2DCEfQIJlMJI8E68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Yarlagadda <kyarlagadda@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 205/554] spi: tegra210-quad: Fix validate combined sequence
Date: Thu, 15 Jan 2026 17:44:31 +0100
Message-ID: <20260115164253.675466562@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

commit 047ee71ae4f412d8819e39e4b08c588fa299cfc2 upstream.

Check for non dma transfers that do not fit in FIFO has issue and skips
combined sequence for Tegra234 & Tegra241 which does not have GPCDMA.

Fixes: 1b8342cc4a38 ("spi: tegra210-quad: combined sequence mode")

Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/20230224164034.56933-1-kyarlagadda@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra210-quad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1290,7 +1290,7 @@ static bool tegra_qspi_validate_cmb_seq(
 	if (xfer->len > 4 || xfer->len < 3)
 		return false;
 	xfer = list_next_entry(xfer, transfer_list);
-	if (!tqspi->soc_data->has_dma || xfer->len > (QSPI_FIFO_DEPTH << 2))
+	if (!tqspi->soc_data->has_dma && xfer->len > (QSPI_FIFO_DEPTH << 2))
 		return false;
 
 	return true;


