Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A16A24FBFF;
	Mon, 23 Jun 2025 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685726; cv=none; b=C69h/h8f5gJ3pZLLwW6HWB3cG6SMXaUvulPUzKuLt7vlMtj6+N9lG4dh2/EZivUjjrVyzMc2uhgWV4mLJH8yqOpXr1N9xEoZetr1Ol/UCdzGk6OFpq8BDIiums5ww+1e8o11DkgmtU3S+UHrblt1XgdgKQMpXXGgP10OXmDe+qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685726; c=relaxed/simple;
	bh=VRc/3doPS0iazIW9RsX0AsVE/oZyZyLBRCb9PmwUGNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilQidkfKmKWTURyMdmQzN/mIuUqq/n2wuPYZBpMOZ0eDyHcu195SRGEbxBijsRP1INo0AJjqFU6G1CVk3MBaQAG+/KC3y0kMGrZMfn40k9YihwX5BEq7URLqRp8OcBM0SwhcuCzq2u9ltBGgKSrxch6CnsDIpRWGObxjM+9tmnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m04k4mEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m04k4mEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C7CC4CEEA;
	Mon, 23 Jun 2025 13:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685726;
	bh=VRc/3doPS0iazIW9RsX0AsVE/oZyZyLBRCb9PmwUGNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m04k4mEj+6cPKdqMBvtyGtIEhZj7m0XPjMyn0JbHaDlDs8/pzRImlcdkqDRYM+cuC
	 8PFR0Ien+/RQk93PZ0LsZ1Fav6y1BM2KDN2s0uHKLrFRi6eJSVFdv6BQ1Sw2vjGXLl
	 y6XlLpnafDeZ30+CQ7+S0Q1tw6l/KO/DYZ+sd2xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/508] spi: tegra210-quad: Fix X1_X2_X4 encoding and support x4 transfers
Date: Mon, 23 Jun 2025 15:01:12 +0200
Message-ID: <20250623130645.917218000@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Vishwaroop A <va@nvidia.com>

[ Upstream commit dcb06c638a1174008a985849fa30fc0da7d08904 ]

This patch corrects the QSPI_COMMAND_X1_X2_X4 and QSPI_ADDRESS_X1_X2_X4
macros to properly encode the bus width for x1, x2, and x4 transfers.
Although these macros were previously incorrect, they were not being
used in the driver, so no functionality was affected.

The patch updates tegra_qspi_cmd_config() and tegra_qspi_addr_config()
function calls to use the actual bus width from the transfer, instead of
hardcoding it to 0 (which implied x1 mode). This change enables proper
support for x1, x2, and x4 data transfers by correctly configuring the
interface width for commands and addresses.

These modifications improve the QSPI driver's flexibility and prepare it
for future use cases that may require different bus widths for commands
and addresses.

Fixes: 1b8342cc4a38 ("spi: tegra210-quad: combined sequence mode")
Signed-off-by: Vishwaroop A <va@nvidia.com>
Link: https://patch.msgid.link/20250416110606.2737315-2-va@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 442d42130ec87..b84dc830c4333 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -135,7 +135,7 @@
 #define QSPI_COMMAND_VALUE_SET(X)		(((x) & 0xFF) << 0)
 
 #define QSPI_CMB_SEQ_CMD_CFG			0x1a0
-#define QSPI_COMMAND_X1_X2_X4(x)		(((x) & 0x3) << 13)
+#define QSPI_COMMAND_X1_X2_X4(x)		((((x) >> 1) & 0x3) << 13)
 #define QSPI_COMMAND_X1_X2_X4_MASK		(0x03 << 13)
 #define QSPI_COMMAND_SDR_DDR			BIT(12)
 #define QSPI_COMMAND_SIZE_SET(x)		(((x) & 0xFF) << 0)
@@ -147,7 +147,7 @@
 #define QSPI_ADDRESS_VALUE_SET(X)		(((x) & 0xFFFF) << 0)
 
 #define QSPI_CMB_SEQ_ADDR_CFG			0x1ac
-#define QSPI_ADDRESS_X1_X2_X4(x)		(((x) & 0x3) << 13)
+#define QSPI_ADDRESS_X1_X2_X4(x)		((((x) >> 1) & 0x3) << 13)
 #define QSPI_ADDRESS_X1_X2_X4_MASK		(0x03 << 13)
 #define QSPI_ADDRESS_SDR_DDR			BIT(12)
 #define QSPI_ADDRESS_SIZE_SET(x)		(((x) & 0xFF) << 0)
@@ -1035,10 +1035,6 @@ static u32 tegra_qspi_addr_config(bool is_ddr, u8 bus_width, u8 len)
 {
 	u32 addr_config = 0;
 
-	/* Extract Address configuration and value */
-	is_ddr = 0; //Only SDR mode supported
-	bus_width = 0; //X1 mode
-
 	if (is_ddr)
 		addr_config |= QSPI_ADDRESS_SDR_DDR;
 	else
@@ -1072,13 +1068,13 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 		switch (transfer_phase) {
 		case CMD_TRANSFER:
 			/* X1 SDR mode */
-			cmd_config = tegra_qspi_cmd_config(false, 0,
+			cmd_config = tegra_qspi_cmd_config(false, xfer->tx_nbits,
 							   xfer->len);
 			cmd_value = *((const u8 *)(xfer->tx_buf));
 			break;
 		case ADDR_TRANSFER:
 			/* X1 SDR mode */
-			addr_config = tegra_qspi_addr_config(false, 0,
+			addr_config = tegra_qspi_addr_config(false, xfer->tx_nbits,
 							     xfer->len);
 			address_value = *((const u32 *)(xfer->tx_buf));
 			break;
-- 
2.39.5



