Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1C8378D84;
	Mon,  9 Feb 2026 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648308; cv=none; b=HEZHSzeMfTvkOAIHe9hU08y8hKJ2YPz/dU9phEfJx2T+z1o5+syiCU+oe4IWFFaFNDog9FjaLQpoB2V4HL0XehQIoVPXnpGkk6SYY0ZIy5DJqHn5qQYAzHWOYVqSs7F7++93qeMqPqzc9/snwHIrgjQF8DmLixp4KZOw7N2KgkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648308; c=relaxed/simple;
	bh=sS2FdwlHhl8aFK3DQkVgVqVtPZu2Pxd+LfUhkDV8uKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaEMLHqzp3b9tb/u+VIEEvy+LC6rVz91BMXwgsOJNa0eMNiOEHjSEOMAQc2qnYDhSiK4394BBPaYj9aXVXTmtVztK1YbEGc3SvAMXe0xHh9HE+ObJaHhJ7A+XSnf1fClfVDRNUhj2EzSwYo+MOULu1+ljINxReyRWerJ2k3b18Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pk2amYIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pk2amYIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D39C116C6;
	Mon,  9 Feb 2026 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648308;
	bh=sS2FdwlHhl8aFK3DQkVgVqVtPZu2Pxd+LfUhkDV8uKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pk2amYIMXnMW6k5PoGQWEvb1xSvM4uegmSWx/kIJp+JYALFFhpyCiuvCKAKkhLhac
	 JqfTLegvAKz2Pa5NCOulc6Xc8qh5SFGrzFwB83slsWzID3xPFglyBouMJHW4JXAuHW
	 7M7MHv5AK2JYjAwst1ays8wC3spU9yD12PSCJBR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 67/69] spi: tegra210-quad: Protect curr_xfer clearing in tegra_qspi_non_combined_seq_xfer
Date: Mon,  9 Feb 2026 15:24:35 +0100
Message-ID: <20260209142304.336762061@linuxfoundation.org>
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

[ Upstream commit 6d7723e8161f3c3f14125557e19dd080e9d882be ]

Protect the curr_xfer clearing in tegra_qspi_non_combined_seq_xfer()
with the spinlock to prevent a race with the interrupt handler that
reads this field to check if a transfer is in progress.

Fixes: b4e002d8a7ce ("spi: tegra210-quad: Fix timeout handling")
Signed-off-by: Breno Leitao <leitao@debian.org>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260126-tegra_xfer-v2-5-6d2115e4f387@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index a06609a43c7f1..022cc0ebee77c 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1193,6 +1193,7 @@ static int tegra_qspi_non_combined_seq_xfer(struct tegra_qspi *tqspi,
 	struct spi_transfer *transfer;
 	bool is_first_msg = true;
 	int ret = 0, val = 0;
+	unsigned long flags;
 
 	msg->status = 0;
 	msg->actual_length = 0;
@@ -1262,7 +1263,9 @@ static int tegra_qspi_non_combined_seq_xfer(struct tegra_qspi *tqspi,
 		msg->actual_length += xfer->len + dummy_bytes;
 
 complete_xfer:
+		spin_lock_irqsave(&tqspi->lock, flags);
 		tqspi->curr_xfer = NULL;
+		spin_unlock_irqrestore(&tqspi->lock, flags);
 
 		if (ret < 0) {
 			tegra_qspi_transfer_end(spi);
-- 
2.51.0



