Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEE0219A63;
	Tue, 29 Apr 2025 18:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950724; cv=none; b=b/EAn2cEcmqPNheFdrJ3le7++Wv1J+7znmyziSQc4572QzN0tumJfsGvcelE7wkRvpxikpO9+QX7G5feIJiYDdN6t+Sbb25+rWCs24TG0GYpzEkf8tazQ9zJxWx+dA/mX7ixjtS1/cs9SOpdYBU8KPy3hn7daukvOPaPy6eiHBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950724; c=relaxed/simple;
	bh=vE/heJSDltBI9TQwQxZ2Qf/eQrijNOE4vRjCrMs+lzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emIdjvQvau58hZtQKIsVJS5Cgh+X4+bFaVN087ItXNSpLgq1Oc67Z9GkkdtNlcTHJnTlyo2c22twSbEziKDxy3hD2LLQPxi8l7ZyBi7TLI6yecMLTlLX2eNNR15gKSKIetJ+RWqehiiUAkpBl2wom9bV7cJJyCWJ1Ax7UO49r+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3iy3iw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3iy3iw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143B4C4CEE3;
	Tue, 29 Apr 2025 18:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950724;
	bh=vE/heJSDltBI9TQwQxZ2Qf/eQrijNOE4vRjCrMs+lzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3iy3iw/PWN46AWet7mejLQczPE4SaJDuvDaIvbd3ly6tG3MM6Xv4UmaFk4/7qY0q
	 GXCd5ncri9V7457bIRRrmbePV0oPZy0vc8sdSQ1AnfxNjKggTpmAEz6nmI2gIHn7xo
	 E1qVNE8q3PzGgDyAlQwI5C60QSX7QqHJbyTLoaE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/204] spi: tegra210-quad: add rate limiting and simplify timeout error message
Date: Tue, 29 Apr 2025 18:44:32 +0200
Message-ID: <20250429161106.918921600@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2abb54f9a9ba4..e3c236025a7b3 100644
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



