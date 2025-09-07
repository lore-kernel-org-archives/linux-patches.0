Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFB94315A;
	Sun,  7 Sep 2025 20:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277787; cv=none; b=Cty5WYtOwzoA/iK7yKcCLIT+ZNNrDOJyuSxWAQcNNDy/Cm+cOdVtEpNukIFQNXU7Bz9Oa2fXSykTcG+2attsIcyWe7tQ+ZKBAqgVMuLLAC9SlWvCX/ii2KBHAq6kTTbao8ZOK00Msp5cpLrcTn7qyEEv4tEzi3790dZ7i3yHbO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277787; c=relaxed/simple;
	bh=ldyay+VKRnGPd0zILKcxYdCI+6Xchs3CMxIBm5kP/CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DARLW8XGN/bVkQdwjCO6pKgAU8vnuOl1uocDixlvkCGLx7JKTUJmdyuQuX1l2VfhAzxDiL1SaN6jc/zOh0we16enNorQeo6x5ZamU8FQVVpm9h5cjuxMDYjvHy7xu/OF1MWzGvkuz6EdM3siqDrrXL4XaNQAEmHQrIbv4le7fNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r1wGKxfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r1wGKxfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C72BC4CEF0;
	Sun,  7 Sep 2025 20:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277787;
	bh=ldyay+VKRnGPd0zILKcxYdCI+6Xchs3CMxIBm5kP/CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1wGKxfpvUkOBcog6QS9DWA9iG0cOtBeG5L6ICASOOLykRFVMDVt1hZQ4NvJkFq+G
	 QYted3IW/lLwE/DKKYGfUgpKFxgb0avUGunuE1/3j/KPAfpj7lgz+dVcEY6x5rcHt3
	 +T8JiYhIH8unMrmXVlFdPh+lVVhuUzlOwYLmCjtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.16 124/183] spi: microchip-core-qspi: stop checking viability of op->max_freq in supports_op callback
Date: Sun,  7 Sep 2025 21:59:11 +0200
Message-ID: <20250907195618.736898108@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

commit 89e7353f522f5cf70cb48c01ce2dcdcb275b8022 upstream.

In commit 13529647743d9 ("spi: microchip-core-qspi: Support per spi-mem
operation frequency switches") the logic for checking the viability of
op->max_freq in mchp_coreqspi_setup_clock() was copied into
mchp_coreqspi_supports_op(). Unfortunately, op->max_freq is not valid
when this function is called during probe but is instead zero.
Accordingly, baud_rate_val is calculated to be INT_MAX due to division
by zero, causing probe of the attached memory device to fail.

Seemingly spi-microchip-core-qspi was the only driver that had such a
modification made to its supports_op callback when the per_op_freq
capability was added, so just remove it to restore prior functionality.

CC: stable@vger.kernel.org
Reported-by: Valentina Fernandez <valentina.fernandezalanis@microchip.com>
Fixes: 13529647743d9 ("spi: microchip-core-qspi: Support per spi-mem operation frequency switches")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Message-ID: <20250825-during-ploy-939bdd068593@spud>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-microchip-core-qspi.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -458,10 +458,6 @@ error:
 
 static bool mchp_coreqspi_supports_op(struct spi_mem *mem, const struct spi_mem_op *op)
 {
-	struct mchp_coreqspi *qspi = spi_controller_get_devdata(mem->spi->controller);
-	unsigned long clk_hz;
-	u32 baud_rate_val;
-
 	if (!spi_mem_default_supports_op(mem, op))
 		return false;
 
@@ -484,14 +480,6 @@ static bool mchp_coreqspi_supports_op(st
 			return false;
 	}
 
-	clk_hz = clk_get_rate(qspi->clk);
-	if (!clk_hz)
-		return false;
-
-	baud_rate_val = DIV_ROUND_UP(clk_hz, 2 * op->max_freq);
-	if (baud_rate_val > MAX_DIVIDER || baud_rate_val < MIN_DIVIDER)
-		return false;
-
 	return true;
 }
 


