Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCDA28135D;
	Thu, 27 Nov 2025 15:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255705; cv=none; b=ffKa041utC8BPtMD+jt1nejzqpdV4Lnt69nDOWfGP7kICpYWl5sM2qRLgDzhUbxYeVzMK+2RJlg9l+NaxUl6I9SHzsz3uHG0huGQE6Rayz57HLKXrasgmfekPHF8+tMFi66ywrGkQso4DxyBc5BZ07hGABD9mN32m1QgMp2mNpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255705; c=relaxed/simple;
	bh=0s0jiAVwInxowLL91RVOfwuc/fjmmk15Ti5gVYSB1/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qm53ljNI2qGaQZf6VhauMlzKtyd043FiWNVAC/vAq+EKYoGp2LlW7dKiVYc7Buk5zhiD0zRpfeimuzHSKg0eNK31cYJqSuWAu1rPXl+Of8EQLQnNkz/Ky75AX6APuhNdkKg7Cs1jnhkBslNUcZVyB1AYf1BMwVFdqR0rxM6iz74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DpEuPeg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpEuPeg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B0DC4CEF8;
	Thu, 27 Nov 2025 15:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255704;
	bh=0s0jiAVwInxowLL91RVOfwuc/fjmmk15Ti5gVYSB1/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpEuPeg9ZmowXODGn+5VQkX0rGEdRgxYzm8L3tMM758TfUPcNXprWm2T87Zba7kJL
	 t9f6BcZQovJtjpxgZnhMZO6nlDS4mH6vRvRapgLBssr+gwdZccJ583J4K5DSBlPd4C
	 h2I7D8XEOm8wzMz8cRDJQs0VeH3gEiP+FMiLkgoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 085/175] clk: sunxi-ng: sun55i-a523-r-ccu: Mark bus-r-dma as critical
Date: Thu, 27 Nov 2025 15:45:38 +0100
Message-ID: <20251127144046.069360676@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit 5888533c6011de319c5f23ae147f1f291ce81582 ]

The "bus-r-dma" clock in the A523's PRCM clock controller is also
referred to as "DMA_CLKEN_SW" or "DMA ADB400 gating". It is unclear how
this ties into the DMA controller MBUS clock gate; however if the clock
is not enabled, the DMA controller in the MCU block will fail to access
DRAM, even failing to retrieve the DMA descriptors.

Mark this clock as critical. This sort of mirrors what is done for the
main DMA controller's MBUS clock, which has a separate toggle that is
currently left out of the main clock controller driver.

Fixes: 8cea339cfb81 ("clk: sunxi-ng: add support for the A523/T527 PRCM CCU")
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20251020171059.2786070-6-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c b/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c
index c5b0d4a2e397e..0339c4af0fe5b 100644
--- a/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c
+++ b/drivers/clk/sunxi-ng/ccu-sun55i-a523-r.c
@@ -121,7 +121,7 @@ static SUNXI_CCU_GATE_HW(bus_r_ir_rx_clk, "bus-r-ir-rx",
 			 &r_apb0_clk.common.hw, 0x1cc, BIT(0), 0);
 
 static SUNXI_CCU_GATE_HW(bus_r_dma_clk, "bus-r-dma",
-			 &r_apb0_clk.common.hw, 0x1dc, BIT(0), 0);
+			 &r_apb0_clk.common.hw, 0x1dc, BIT(0), CLK_IS_CRITICAL);
 static SUNXI_CCU_GATE_HW(bus_r_rtc_clk, "bus-r-rtc",
 			 &r_apb0_clk.common.hw, 0x20c, BIT(0), 0);
 static SUNXI_CCU_GATE_HW(bus_r_cpucfg_clk, "bus-r-cpucfg",
-- 
2.51.0



