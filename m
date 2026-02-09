Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D52A37AA71;
	Mon,  9 Feb 2026 14:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648059; cv=none; b=V3xymX70mI1C/q5DYmOKkVaZdKMjb7sRr/8fFEZYpZJojaxRVJsarhf3oMLdxxAMKevgpb5a6QxSGITi6u0Jp30GsOHxAirie4DrtZxfHswnIlpNLBj14QLzy0rJQiCPmxCEmQ3ke+1rjDubSzmO/JnvI9lXU7TzX6CukDN/rfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648059; c=relaxed/simple;
	bh=f9RKWNBbLTWcrKXmGuEk+EvfXYVYKjebmrXXHb76o6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNpVeJkTnleDQMeyKeDyOackuw0TQv3KTwfaY/rKIAfKHg8fBVBK1Px0DBxL/F+HwD+e9LLbjne8mKocmsK4YWEw/lCzE1B09tn+s9uM5hFvRtJ6cYlzqzBoA/SscoO4dXlw9fflL8a1jC1+mZMWR35VBuwQ09tZqvKC7vPWtj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2GfA1i9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2GfA1i9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FECC116C6;
	Mon,  9 Feb 2026 14:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648059;
	bh=f9RKWNBbLTWcrKXmGuEk+EvfXYVYKjebmrXXHb76o6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2GfA1i9N5C8Dptl66qauzIkPVSht+PiWfrQ08+ljIWd8IPZ+KR1VQ8nMwpnreGql
	 73poecgz02+PWzYi2B3gJbNOVOnxQgSVo71W5q1H7vE+N06LJXZ9fRAiJ6UdMAwOov
	 F6wBecCJukkRXxfdSB1BZX8XXdHVPU0wE1wzfvdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/113] spi: tegra210-quad: Protect curr_xfer in tegra_qspi_combined_seq_xfer
Date: Mon,  9 Feb 2026 15:24:18 +0100
Message-ID: <20260209142314.088534941@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit bf4528ab28e2bf112c3a2cdef44fd13f007781cd ]

The curr_xfer field is read by the IRQ handler without holding the lock
to check if a transfer is in progress. When clearing curr_xfer in the
combined sequence transfer loop, protect it with the spinlock to prevent
a race with the interrupt handler.

Protect the curr_xfer clearing at the exit path of
tegra_qspi_combined_seq_xfer() with the spinlock to prevent a race
with the interrupt handler that reads this field.

Without this protection, the IRQ handler could read a partially updated
curr_xfer value, leading to NULL pointer dereference or use-after-free.

Fixes: b4e002d8a7ce ("spi: tegra210-quad: Fix timeout handling")
Signed-off-by: Breno Leitao <leitao@debian.org>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260126-tegra_xfer-v2-4-6d2115e4f387@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 0c25d9c303bba..28552a8f27c14 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1064,6 +1064,7 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 	u32 address_value = 0;
 	u32 cmd_config = 0, addr_config = 0;
 	u8 cmd_value = 0, val = 0;
+	unsigned long flags;
 
 	/* Enable Combined sequence mode */
 	val = tegra_qspi_readl(tqspi, QSPI_GLOBAL_CONFIG);
@@ -1176,13 +1177,17 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 			tegra_qspi_transfer_end(spi);
 			spi_transfer_delay_exec(xfer);
 		}
+		spin_lock_irqsave(&tqspi->lock, flags);
 		tqspi->curr_xfer = NULL;
+		spin_unlock_irqrestore(&tqspi->lock, flags);
 		transfer_phase++;
 	}
 	ret = 0;
 
 exit:
+	spin_lock_irqsave(&tqspi->lock, flags);
 	tqspi->curr_xfer = NULL;
+	spin_unlock_irqrestore(&tqspi->lock, flags);
 	msg->status = ret;
 
 	return ret;
-- 
2.51.0



