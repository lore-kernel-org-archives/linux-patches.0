Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4DF3F9D2;
	Fri, 21 Nov 2025 13:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732019; cv=none; b=EHfwSFFvjewpzK8ouuCNP2wwVp0FP8vx48vuZGieppIywGXKN9LWArXRLzR9DM4YjLLfChP6J4HWBZkJb0RqHuUNUiun01nT9BcihUxc+yRfEoLZTS7OIo8FHkohVdkYCeFMO+DWloDPx2Tg+vA2qrShOSF67svj0z8WFEcU2Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732019; c=relaxed/simple;
	bh=Bv5H8DorArVFYXK9uI1EN+6fg7mRP6Cn+404Ckt6mPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=coS7TOf06oeatiGhkQfQrMgp/N/11q0tIkaWp2/XcVJZaM79XX2ku8lSfZkKJrwz9dImgb+5CzkLEgdTxwQQ6VjvJYdZ6c1k2fDn+cNVRNLQCK/QrxMBgLu+1/aMuYvq2V0Yu5WB7AebmDpwH4ieD0MILpcP3cSRWQGrb/VEW18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yngRpxql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yngRpxql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F009BC4CEF1;
	Fri, 21 Nov 2025 13:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732019;
	bh=Bv5H8DorArVFYXK9uI1EN+6fg7mRP6Cn+404Ckt6mPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yngRpxqlJMkIUUWOYP3g6PakRRVyxghAxqjB/OCTUpYQUNp9K3N1LabtQPj8z1V6k
	 Q+6qoyRws9t2nSae8skCC46vabsXgDN6RbEJAFCvZ9Mpjtll1ZRbyxZFWXkere8rvu
	 bXId+b6c7ANIXxx4J7IXsZF2hXgcV1aS9pNSuxXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 128/185] mmc: dw_mmc-rockchip: Fix wrong internal phase calculate
Date: Fri, 21 Nov 2025 14:12:35 +0100
Message-ID: <20251121130148.495567940@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 739f04f4a46237536aff07ff223c231da53ed8ce upstream.

ciu clock is 2 times of io clock, but the sample clk used is
derived from io clock provided to the card. So we should use
io clock to calculate the phase.

Fixes: 59903441f5e4 ("mmc: dw_mmc-rockchip: Add internal phase support")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/dw_mmc-rockchip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/dw_mmc-rockchip.c
+++ b/drivers/mmc/host/dw_mmc-rockchip.c
@@ -43,7 +43,7 @@ struct dw_mci_rockchip_priv_data {
  */
 static int rockchip_mmc_get_internal_phase(struct dw_mci *host, bool sample)
 {
-	unsigned long rate = clk_get_rate(host->ciu_clk);
+	unsigned long rate = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
 	u32 raw_value;
 	u16 degrees;
 	u32 delay_num = 0;
@@ -86,7 +86,7 @@ static int rockchip_mmc_get_phase(struct
 
 static int rockchip_mmc_set_internal_phase(struct dw_mci *host, bool sample, int degrees)
 {
-	unsigned long rate = clk_get_rate(host->ciu_clk);
+	unsigned long rate = clk_get_rate(host->ciu_clk) / RK3288_CLKGEN_DIV;
 	u8 nineties, remainder;
 	u8 delay_num;
 	u32 raw_value;


