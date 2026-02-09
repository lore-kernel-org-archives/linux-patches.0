Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2317922156C;
	Mon,  9 Feb 2026 14:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648305; cv=none; b=Mqk0ortMd2SC7AXQwim4hCj6pCiyarU3qHl9vq6z1sj2hvI6N4ygD+oy4zubTsIVxQYxUTEXIhF2pCPlts6MC7Y8X0rY/Ds5bIJXVvUtga+cjvJ9HIFoQj7XLgx+sy4juOgJKOs0XKmds5apXyQUhOxAshgpAcVA/UnYvXOsX84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648305; c=relaxed/simple;
	bh=aTSG0ZSMUwhcKpNL0HMQ32XZJ/q2Hn8V5tEw9BzSwyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qhh+u9sUcs1aiGpAkYbJyFOnq9/nJ2Vl+lfRclZxAL2iEXbbUzZJK7D2uH23Hz/4KA0rztFseb6NWWrlZb065frhOMSr5YHHjNLUdHS/bWQQccpFwH8sAh6dIry2vvC/ZjFyqhqEuTwjUEzw2ovSiZohl+aO+jaWABrtM4F7tEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKlWt277; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKlWt277"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAE6C116C6;
	Mon,  9 Feb 2026 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648305;
	bh=aTSG0ZSMUwhcKpNL0HMQ32XZJ/q2Hn8V5tEw9BzSwyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKlWt277Ox9KZH/xX0ARyBpu6FVjDaY51etUEgx5oi/gAyTQleJIaNn66oPmZvQM8
	 sGTsxt9tUEAd3iFfZm0VqcvygjUqqpmx7KGFOnstv+r8d4fO+LKcK9RsODYPLFWvrp
	 QjI//mdP+rtpMFWg3XCJXQR6M5ju7ek17JS/Qsjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 66/69] spi: tegra210-quad: Protect curr_xfer in tegra_qspi_combined_seq_xfer
Date: Mon,  9 Feb 2026 15:24:34 +0100
Message-ID: <20260209142304.300808186@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d3d3e698bffa1..a06609a43c7f1 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1063,6 +1063,7 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 	u32 address_value = 0;
 	u32 cmd_config = 0, addr_config = 0;
 	u8 cmd_value = 0, val = 0;
+	unsigned long flags;
 
 	/* Enable Combined sequence mode */
 	val = tegra_qspi_readl(tqspi, QSPI_GLOBAL_CONFIG);
@@ -1169,13 +1170,17 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
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



