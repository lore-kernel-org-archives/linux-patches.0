Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317E423FC41;
	Tue, 11 Nov 2025 00:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822767; cv=none; b=QI1TlDuJ3xRHHBOWh1vhpumsM9lh55KPFYBTQjMLQ9SwA5ki9ODHAvte56koszmS92jFoHSDGg2d38iw/mNHZdg3/8tMIjax6QcWCbVjgG0DbAjEGtJlXt6+ut4Wq4+NbIwTVbgrQkRIG4JJ4k6Ww2HKKpGd9MdkosYKx1+lwr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822767; c=relaxed/simple;
	bh=EN2SqQt/dN9tSjTgMfM1jjwEcw/ul7N8D45GQMEQfAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijBcmyJ2bAppGv8WEc3W+eykpqsOCnFUlP964rcIkUank7xgdsLmCPJZV3/oOF7TTWxdqoXFuAkQUOEekXpBOxhbZeIc1kvj2pz9e5/AAaRSqD7hFP/Kjhm6MFCLuofeer6cWXY0+kCZB5dgWGuDMQICel9y6Do7Uc0ckvLL9jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXIJBY2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXIJBY2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C042BC2BC86;
	Tue, 11 Nov 2025 00:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822767;
	bh=EN2SqQt/dN9tSjTgMfM1jjwEcw/ul7N8D45GQMEQfAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXIJBY2Rx2VC50n31avHTRbE+yI1lbo+syhFFhwVQsh7LkmQui/P1hC9BCH1nGRW+
	 K86Uv5/LrUiF3Ucwn3Qv273IGC1w349kwuvh1lY7R7c3Eb6aHo47t1dy5l8XPIYQvL
	 CVcccf3cRvKABe1p9KS+IZIlC5A1VOplEIuSqP5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 127/849] mmc: host: renesas_sdhi: Fix the actual clock
Date: Tue, 11 Nov 2025 09:34:57 +0900
Message-ID: <20251111004539.465616273@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 9c174e4dacee9fb2014a4ffc953d79a5707b77e4 ]

Wrong actual clock reported, if the SD clock division ratio is other
than 1:1(bits DIV[7:0] in SD_CLK_CTRL are set to 11111111).

On high speed mode, cat /sys/kernel/debug/mmc1/ios
Without the patch:
clock:          50000000 Hz
actual clock:   200000000 Hz

After the fix:
clock:          50000000 Hz
actual clock:   50000000 Hz

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://lore.kernel.org/r/20250629203859.170850-1-biju.das.jz@bp.renesas.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index fb8ca03f661d7..a41291a28e9bd 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -222,7 +222,11 @@ static void renesas_sdhi_set_clock(struct tmio_mmc_host *host,
 			clk &= ~0xff;
 	}
 
-	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clk & CLK_CTL_DIV_MASK);
+	clock = clk & CLK_CTL_DIV_MASK;
+	if (clock != 0xff)
+		host->mmc->actual_clock /= (1 << (ffs(clock) + 1));
+
+	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, clock);
 	if (!(host->pdata->flags & TMIO_MMC_MIN_RCAR2))
 		usleep_range(10000, 11000);
 
-- 
2.51.0



