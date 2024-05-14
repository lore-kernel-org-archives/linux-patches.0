Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875EB12E1DC;
	Tue, 14 May 2024 11:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686697; cv=none; b=jlI6EO2JRPGxaZExYeUzTfC7WBvseSsnAnFJ/SpQIP4KoJHEzgmR6y1zP0Grk4B2Nu6QBIuiHZCv1knB1scLxNkSLLXXoieT+kO8C9YOkWcnpEvRAguz70eqhV7KewPgbxrCjJQ8ifp89XEbJ1AKI5EWE+0r8R3dcoIGFVFxyog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686697; c=relaxed/simple;
	bh=rKlTy7KMoAXhL7PRSEy0H80MqIaBq+4JLy6eW+YLoDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7r3YTadaffvLDh77lqxislPjFTjCrBeMiWBT+9OQ0DBHNwTqXgLajQHPbdpDRXPKax6SwjWFO5k168aEhpy3BSnBETi/yzF0hD62alu7KCjE6c+hBOqZLEZgiCxfUH+O/1192keYb+vkSKR6dZOKExMvk6ye5c+4j9anTIdq/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giU3uUed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giU3uUed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B766EC2BD10;
	Tue, 14 May 2024 11:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686697;
	bh=rKlTy7KMoAXhL7PRSEy0H80MqIaBq+4JLy6eW+YLoDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giU3uUedUgyuyxZ7dj8TalCRGdcJL+RCmS1abLLiBGW3TSSYCHXcEiUr91fvxyrLG
	 0fjHxoMZTkPjqupLA8ajzHz7bUV4s5W+q9F1n0rOfnGrQFBPwtBI0z11twvEqQOACq
	 VIZbWG1qvAWb0TxwJKoG9QbzZb3jkOeB+KVJfsis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 228/236] spi: microchip-core-qspi: fix setting spi bus clock rate
Date: Tue, 14 May 2024 12:19:50 +0200
Message-ID: <20240514101029.013661174@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Conor Dooley <conor.dooley@microchip.com>

commit ef13561d2b163ac0ae6befa53bca58a26dc3320b upstream.

Before ORing the new clock rate with the control register value read
from the hardware, the existing clock rate needs to be masked off as
otherwise the existing value will interfere with the new one.

CC: stable@vger.kernel.org
Fixes: 8596124c4c1b ("spi: microchip-core-qspi: Add support for microchip fpga qspi controllers")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20240508-fox-unpiloted-b97e1535627b@spud
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-microchip-core-qspi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-microchip-core-qspi.c b/drivers/spi/spi-microchip-core-qspi.c
index 03d125a71fd9..09f16471c537 100644
--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -283,6 +283,7 @@ static int mchp_coreqspi_setup_clock(struct mchp_coreqspi *qspi, struct spi_devi
 	}
 
 	control = readl_relaxed(qspi->regs + REG_CONTROL);
+	control &= ~CONTROL_CLKRATE_MASK;
 	control |= baud_rate_val << CONTROL_CLKRATE_SHIFT;
 	writel_relaxed(control, qspi->regs + REG_CONTROL);
 	control = readl_relaxed(qspi->regs + REG_CONTROL);
-- 
2.45.0



