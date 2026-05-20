Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B141CDFCA;
	Wed, 20 May 2026 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295583; cv=none; b=lkUAD6bKa9mwNhXCxom0ohCYhWsyr7HTqErf0/909Y86c/6qYVO32cRQl9o6PiOjmgHNR7uug1l05SXYj4/Ta8ahiHC5JtiwwrBpj7TuvBSogHppJWfDK6SlIj/Up0+8LpAPFUAHdVsh74Erb/w3IL8QUAZWsjmWLAOKn64AGmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295583; c=relaxed/simple;
	bh=afaziNe9Wa72upal9ggb14hheJ1mySysJo3SK/r5y6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dU7bLPdJVmm/KRAvFDovSFwhu2PQE8BSo8IgNOhm+q9IWFnVLnjdWw6yaIJqzs3gV39rX/tvtKH6Py0Q1a/lV6PllY+xd9p8gRB58cfj6e/H/8m6IiBmsMS+84PU2K+ZlbO+yCWaX1QItuq75bnUW6cWE6ZKxng7+Jj+jG8/mMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=orSQoc6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="orSQoc6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED5B1F00896;
	Wed, 20 May 2026 16:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295581;
	bh=hNfRVCRERKhxUhTU/5z4WqQAUMhQpQKXmUiTnwEntYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=orSQoc6peOr72Fhh7SiMZTjoSIYQg13d+tQ+gE1CgQozcqJZTKlhj4z+7PFLzNn5c
	 YOWxPUzmhQYWJTPGkMBsmO3yJHc2kU4D86B91nbSFKRjzIt9bWUEm3Amvcb169wVVl
	 wbLpwePt/cbcudQYBqc+G0eq9j9R4H2YKGr3ZAYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0433/1146] spi: rzv2h-rspi: Fix invalid SPR=0/BRDV=0 clock configuration
Date: Wed, 20 May 2026 18:11:23 +0200
Message-ID: <20260520162157.998816826@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 0335767dd8e7ade8a8e3028d08c4621515d47388 ]

The combination of SPR=0 and BRDV=0 results in the minimum division
ratio of 2, producing the maximum possible bit rate for a given clock
source. This combination is not supported in two cases:

- On RZ/G3E, RZ/G3L, RZ/V2H(P) and RZ/V2N, RSPI_n_TCLK is fixed at
  200MHz, which would yield 100Mbps. The next hardware manual update
  will explicitly state that since the maximum frequency of the
  RSPICKn clock signal is 50MHz, settings with N=0 and n=0 resulting
  in 100Mbps are prohibited.

- On RZ/T2H and RZ/N2H, when PCLK (125MHz) is used as the clock
  source, SPR=0 and BRDV=0 is explicitly listed as unsupported in
  the hardware manual (Table 36.7).

Skip the SPR=0/BRDV=0 combination in rzv2h_rspi_find_rate_fixed() to
prevent the driver from selecting an invalid clock configuration on the
affected SoCs.

Additionally, remove the now redundant RSPI_SPBR_SPR_PCLK_MIN define
which was previously set to 1 to work around the PCLK restriction, but
was overly broad as it incorrectly blocked valid combinations such as
SPR=0/BRDV=1 (31.25Mbps on PCLK=125MHz).

Fixes: 8b61c8919dff ("spi: Add driver for the RZ/V2H(P) RSPI IP")
Fixes: 1ce3e8adc7d0 ("spi: rzv2h-rspi: add support for using PCLK for transfer clock")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://patch.msgid.link/20260410080517.2405700-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rzv2h-rspi.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-rzv2h-rspi.c b/drivers/spi/spi-rzv2h-rspi.c
index 23f0e92ae208e..d6b9b558932dd 100644
--- a/drivers/spi/spi-rzv2h-rspi.c
+++ b/drivers/spi/spi-rzv2h-rspi.c
@@ -50,7 +50,6 @@
 
 /* Register SPBR */
 #define RSPI_SPBR_SPR_MIN	0
-#define RSPI_SPBR_SPR_PCLK_MIN	1
 #define RSPI_SPBR_SPR_MAX	255
 
 /* Register SPCMD */
@@ -533,6 +532,17 @@ static void rzv2h_rspi_find_rate_fixed(struct clk *clk, u32 hz,
 	for (brdv = RSPI_SPCMD_BRDV_MIN; brdv <= RSPI_SPCMD_BRDV_MAX; brdv++) {
 		spr = DIV_ROUND_UP(clk_rate, hz * (1 << (brdv + 1)));
 		spr--;
+		/*
+		 * Skip SPR=0 and BRDV=0 as it is not a valid combination:
+		 * - On RZ/G3E, RZ/G3L, RZ/V2H(P) and RZ/V2N, RSPI_n_TCLK is
+		 *   fixed at 200MHz and SPR=0 and BRDV=0 results in the maximum
+		 *   bit rate of 100Mbps which is prohibited.
+		 * - On RZ/T2H and RZ/N2H, when PCLK (125MHz) is used as
+		 *   the clock source, SPR=0 and BRDV=0 is explicitly listed
+		 *   as unsupported in the hardware manual (Table 36.7).
+		 */
+		if (!spr && !brdv)
+			continue;
 		if (spr >= spr_min && spr <= spr_max)
 			goto clock_found;
 	}
@@ -566,12 +576,8 @@ static u32 rzv2h_rspi_setup_clock(struct rzv2h_rspi_priv *rspi, u32 hz)
 	rspi->info->find_tclk_rate(rspi->tclk, hz, RSPI_SPBR_SPR_MIN,
 				   RSPI_SPBR_SPR_MAX, &best_clock);
 
-	/*
-	 * T2H and N2H can also use PCLK as a source, which is 125MHz, but not
-	 * when both SPR and BRDV are 0.
-	 */
 	if (best_clock.error && rspi->info->find_pclk_rate)
-		rspi->info->find_pclk_rate(rspi->pclk, hz, RSPI_SPBR_SPR_PCLK_MIN,
+		rspi->info->find_pclk_rate(rspi->pclk, hz, RSPI_SPBR_SPR_MIN,
 					   RSPI_SPBR_SPR_MAX, &best_clock);
 
 	if (!best_clock.clk_rate)
-- 
2.53.0



