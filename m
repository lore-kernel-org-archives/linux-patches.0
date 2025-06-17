Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842BA2DE1F3;
	Tue, 17 Jun 2025 15:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175223; cv=none; b=jbWdleSVrFy7WYJsHEAGBAaHKx2eCxMmg4ledXQyjAQRUMUjv0tGtRTWx8JrYntf9XeNmWB1I2pbwQpZ5qs58WiSzUyXc6rjAT7+5N4CQ+mrQ69niYl/YfEdmAcb4/glQiUjKq28bEe6Aehzd7fsnWKdL2Zn210/S3LbxwkaGHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175223; c=relaxed/simple;
	bh=08GkDYlem1NQ/B0Ob6dynxDTBaDMrRBJ9X1HyJWUQ1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyJM3MIUigCRgO7Z2BQcbwitosh7y0PRmZTJuT1unebKd8Kg69Cr7nlApAyhBhUd05tt1LNMCK5wtcHBBafaWRbhGG3s/LuQinh0uSmzEe87Hu1ZvfGdjPWkkEJCQsJYA9NqpUtD1VSKfQCDA2JIkmPZbiyEJyriu4253FckSOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNla00NL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNla00NL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C015BC4CEE7;
	Tue, 17 Jun 2025 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175223;
	bh=08GkDYlem1NQ/B0Ob6dynxDTBaDMrRBJ9X1HyJWUQ1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNla00NLJA2+F9/MGIqWKNjBJ7hXGkrAWQNQZ223SgPx9VzNWO3AD+4pPqjENegJf
	 yrVac8dGqUyh/Tjm9NMJZqjtC4HPAjZnOnFhxFKHWfahE1CYFsepVXASsDCStrNWjR
	 qH8mqdTimfohr/S6Ihg3D389Cq2EU02zO0TRjGIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 064/780] spi: tegra210-quad: modify chip select (CS) deactivation
Date: Tue, 17 Jun 2025 17:16:12 +0200
Message-ID: <20250617152454.105761761@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishwaroop A <va@nvidia.com>

[ Upstream commit d8966b65413390d1b5b706886987caac05fbe024 ]

Modify the chip select (CS) deactivation and inter-transfer delay
execution only during the DATA_TRANSFER phase when the cs_change
flag is not set. This ensures proper CS handling and timing between
transfers while eliminating redundant operations.

Fixes: 1b8342cc4a38 ("spi: tegra210-quad: combined sequence mode")
Signed-off-by: Vishwaroop A <va@nvidia.com>
Link: https://patch.msgid.link/20250416110606.2737315-4-va@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index b2872853d6ed8..665c06e1473be 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1159,16 +1159,16 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 				ret = -EIO;
 				goto exit;
 			}
-			if (!xfer->cs_change) {
-				tegra_qspi_transfer_end(spi);
-				spi_transfer_delay_exec(xfer);
-			}
 			break;
 		default:
 			ret = -EINVAL;
 			goto exit;
 		}
 		msg->actual_length += xfer->len;
+		if (!xfer->cs_change && transfer_phase == DATA_TRANSFER) {
+			tegra_qspi_transfer_end(spi);
+			spi_transfer_delay_exec(xfer);
+		}
 		transfer_phase++;
 	}
 	ret = 0;
-- 
2.39.5



