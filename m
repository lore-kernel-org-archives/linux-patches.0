Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E0B221719;
	Tue, 29 Apr 2025 17:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946580; cv=none; b=TE8ox1wR4vaLlCcYF0q47NbzEWZpY0fG09TSRr7tP28/OQfknpErFjjzrMGkazndUn9kD5t9TcJUsqXdsOzP6BGOezelS9WiCL4xa51U+RD8NTTv3BcgSgeAZl9wSTMZNFXfX6khqjZ+BiDC/AJHqci1rp6YeSlZLOae4/dKTk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946580; c=relaxed/simple;
	bh=5gOaQtnGFt4VHW8VeHgSeWT/A95hHPxVWueUWBUt9HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R11b4nRMKlFvOhEGbhKle72YP+fmYUHcQ/2OUhRY2f11Ek2A1slzbnsbo/vfZnK5qrW3qTL2gkcmNjiTlckKjxE7JXTayivqoyLOuOSL15bqu7hZ45a8dazElAnBAQs9Z5mFPaRQB2Z9kOumlPYkYcXKxkODJfSYZUKYstLfy48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCrWIwCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCrWIwCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A4FC4CEE3;
	Tue, 29 Apr 2025 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946580;
	bh=5gOaQtnGFt4VHW8VeHgSeWT/A95hHPxVWueUWBUt9HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCrWIwCEfCEGayJnCzukJH+gE+yIMhfEfXhHVIJ2f5Ol5D1xwqtT4rRgG6ICbh/Ws
	 XMm6uGa9100Gxt8A1J99o/yD5zJNdUmXAeyGCe9ojVbwjoMmSppKy7xatJNaAfuM11
	 1sEGftnXoDB3DAVdgw/rBZMG3aoNbzfGz+HtYiHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 284/311] spi: tegra210-quad: use WARN_ON_ONCE instead of WARN_ON for timeouts
Date: Tue, 29 Apr 2025 18:42:01 +0200
Message-ID: <20250429161132.642434080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 41c721fc093938745d116c3a21326a0ee03bb491 ]

Some machines with tegra_qspi_combined_seq_xfer hardware issues generate
excessive kernel warnings, severely polluting the logs:

    dmesg | grep -i "WARNING:.*tegra_qspi_transfer_one_message" | wc -l
    94451

This patch replaces WARN_ON with WARN_ON_ONCE for timeout conditions to
reduce log spam. The subsequent error message still prints on each
occurrence, providing sufficient information about the failure, while
the stack trace is only needed once for debugging purposes.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20250401-tegra-v2-1-126c293ec047@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 08e49a8768943..2d320fbb8875f 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1117,7 +1117,7 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 					(&tqspi->xfer_completion,
 					QSPI_DMA_TIMEOUT);
 
-			if (WARN_ON(ret == 0)) {
+			if (WARN_ON_ONCE(ret == 0)) {
 				dev_err(tqspi->dev, "QSPI Transfer failed with timeout: %d\n",
 					ret);
 				if (tqspi->is_curr_dma_xfer &&
-- 
2.39.5



