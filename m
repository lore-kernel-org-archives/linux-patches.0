Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96AF1917E3;
	Tue, 29 Apr 2025 17:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948381; cv=none; b=nJU0oK1eIoFUD2AQA465pPBhYnDRyinZkvIaj9BNiejWInzPzrzvnWW+kMS2m7lqxl8GQkOqPxzPGlKAdSV/AG94Ug+3dOmCCeyhcFWR3E7SAo0FLy70zFSF/AY+TAy4f2JS9hLrIaiAd+vmU6qqqBBk9Q9JgYx0mSNkiqZiHfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948381; c=relaxed/simple;
	bh=toTTXEzBzSCn2O1XvAXqggUGG+DBpueM3gmoJaG/DIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9dp5qswAOMUpZZcRC8V+H3cpqLNpUqg7DZ3IMOyumb6Zj0U5B8R3S3CwvjWlNfgIvJ/kRhvByNv0O2qeyz/+d3sNjQqW7N4pldHPBLcY4MF2nCAweGsDIUk6qVOeqQo+pj/+R941LquUhYzulasS4M8sLwAUaZXlCjZc1SgsaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0AC4LNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0AC4LNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5C3C4CEE3;
	Tue, 29 Apr 2025 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948381;
	bh=toTTXEzBzSCn2O1XvAXqggUGG+DBpueM3gmoJaG/DIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0AC4LNLgrMkElGtbtJtpC+oGj0XuaVngjSTrY6Sm6foh8OE1hJLoXXMAOZO84sje
	 9ZNwD9EMudHqXGUdr7NIqGuBC1QgBqM9BKXZ6S/eX2nHB7kLxiHPX8afWcZHIJ9aig
	 FEIsV+cbTArou1ju9Vrxgpx0v+pUn5uCTg/NdqUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/280] spi: tegra210-quad: add rate limiting and simplify timeout error message
Date: Tue, 29 Apr 2025 18:43:02 +0200
Message-ID: <20250429161124.987086433@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 94dc4cbc40e15..2d48ad844fb80 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1118,8 +1118,8 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
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



