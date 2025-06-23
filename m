Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13386253F12;
	Mon, 23 Jun 2025 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685392; cv=none; b=LoBnN12oODbHO557/r7uCK89ysBJ4ZFKCmubEbrvYQfI8XLOR96EjQMG0AXc/2P+POwL6TaBGcQD37hEorkbGZn6+imAbfjjvomPGu8D3Ufmw4uUsKro6mo6U79UVN5CLyyjE3zTLrFnu0r8GEfGtgyy2hEk/AqqYxA9UwEt+4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685392; c=relaxed/simple;
	bh=mj/8/gEhMD0gcZPo9R25HpAi7kfcXTWUsWjZ520LIL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLPDOih59YlxB7dX6Czp8Uy7u64S6ihngA7moova61F5wdM09dkdTBepTIoYU7ALUjiK+NGFjWdF3gvACP+FnhYKGwetyNYUD9xgpwwhkKI49bzEku29o6h0zq/Q7ymmsVgxxE6jJ28d+R+Bfxpqgad4ent4n/kFhGaVsJdhEw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZqnHvFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZqnHvFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAA0C4CEEA;
	Mon, 23 Jun 2025 13:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685392;
	bh=mj/8/gEhMD0gcZPo9R25HpAi7kfcXTWUsWjZ520LIL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZqnHvFjaxmas3qDSEFBAHOjx6O5QExeJTGNkUSWxpmKIn7XmFgudnAUPbuxUuhHx
	 BXZT92r9jrEL12IK5/J+WZyZ999Ws2gXy/hCJTmGiiQurSxlpfZSLssJlEs1kSFSBa
	 hiAfcsSm/irjPY5Hq74qe6j7l/jb89xsTMmmTy/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/508] spi: tegra210-quad: modify chip select (CS) deactivation
Date: Mon, 23 Jun 2025 15:01:14 +0200
Message-ID: <20250623130645.964626630@linuxfoundation.org>
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
index d09e0b9ac18c4..f2a4743efcb47 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1152,16 +1152,16 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
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



