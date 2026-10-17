Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E869D29BDB5;
	Sat, 17 Oct 2026 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255729; cv=none; b=rfLDWgKN6ZvwuuDU44tRfqAM8ypHM7lqhZy7f6gKUoGQbZ2DmHy9taUlWYg9n6ZkAPB8RPFhv464qk4t1Oh/fouJ+sDuCEJXzIPdvRJwqS8XJt+TwXkMP/vem2J2m70wm9a193WHD0smWfltjaFfaECqyMoTmvMtY8aUYCBgu0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255729; c=relaxed/simple;
	bh=pBTogoMCC8J22QJR/i0Sy+OsMrLDoIStH3Y6F0pWzZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5qMH3JYxHTXqaxLt9a+Ed/6BKRMaMaYCfyHsfGDwEogGMw805Q4nnPpe/KJBamgw1ojWsTjlsJPXvtdYqfm8FXi9i7+y1N4az2KHOJQmxdd9CQZAjnEQDP1LTbFrU3yfq26odaoZfag3Ev/wgXLZPPxL+mazliFMiJjuXdh+BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZsA+nfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZsA+nfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779491F000C4;
	Sat, 17 Oct 2026 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255728;
	bh=5ixqVOuKXNilv++Q+RSSZ8WooMy9K31npA1mPNrKsLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZsA+nfHrTSlv6nIurZ4u68PPouEqz33tWW5/DQY5JQlI01krIu9FSt05naxZEHU/
	 aPOnYwIuAXFSs65eKSALDgOZ10KJig73wsOpNwA/bKIDXSzzBpATtzDtaSX04mSpi3
	 T2zO9y0L7lryg2KnZeTOiPmci3nZCQPYTCK8Ky4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentina Fernandez <valentina.fernandezalanis@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 842/869] spi: microchip-core-qspi: stop checking viability of op->max_freq in supports_op callback
Date: Sat, 17 Oct 2026 18:01:23 +0200
Message-ID: <20261017160058.458633943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 89e7353f522f5cf70cb48c01ce2dcdcb275b8022 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-microchip-core-qspi.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/spi/spi-microchip-core-qspi.c b/drivers/spi/spi-microchip-core-qspi.c
index bc5e4e4e558a0..2b5271fa870bf 100644
--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -486,10 +486,6 @@ static int mchp_coreqspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *o
 
 static bool mchp_coreqspi_supports_op(struct spi_mem *mem, const struct spi_mem_op *op)
 {
-	struct mchp_coreqspi *qspi = spi_controller_get_devdata(mem->spi->controller);
-	unsigned long clk_hz;
-	u32 baud_rate_val;
-
 	if (!spi_mem_default_supports_op(mem, op))
 		return false;
 
@@ -512,14 +508,6 @@ static bool mchp_coreqspi_supports_op(struct spi_mem *mem, const struct spi_mem_
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
 
-- 
2.53.0



