Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E975534887C;
	Wed,  3 Dec 2025 16:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777647; cv=none; b=tnNA22aGUj4sEO9UkPzQUrZKH4Oqv3zGgqPArUV1Awlktb8VAFG8rR7rkHPz5X1ckXtIvrNz0lPG09VsES9QJoHLCEgGaSiyzTkfuuL44OJM6K6d/Uz4ss984NdNnFPQzXETO3RNGrtBH4uD2OeoLNYIHK+Z+XzwFYObrL9kap0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777647; c=relaxed/simple;
	bh=SMP98IaZvIpRnhh0FvzX5N50VMAxFUN8RJZfx2Jyx10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y21t/vN3EAAbjU5z0D4wOWLSOekDxWr1gmtiA3AIHmeFNXJGcPOtbbW2uKf8m88kIt3radr2D0j8NxX4h3Ggcoa0vZKf+Wmv76h5svMMoBpLnl9XnsQ6i/DIbnvPZC9oxYz8QqTvYFW/GcCZt6TyBfITR5z4Uoxl8FMRnzsRA20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFQqO1Co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFQqO1Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B22EC4CEF5;
	Wed,  3 Dec 2025 16:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777646;
	bh=SMP98IaZvIpRnhh0FvzX5N50VMAxFUN8RJZfx2Jyx10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFQqO1Co/ymzMzlunH9rSjuj/WBawJbjL6ELMI7UR6y8tiDcwsyEpr1ak5NMakC7q
	 29F+H24zOvscOKXyvVJcbveUn4JLH1AZOQcjcT7UtDzYKquiNU1pI+211p849WsdHK
	 mosd5o8d6OEzm9Ch7C6bHGPJI1xdXhoPaySXrNcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/392] mmc: host: renesas_sdhi: Fix the actual clock
Date: Wed,  3 Dec 2025 16:23:29 +0100
Message-ID: <20251203152416.285368150@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9ea9bc250543f..2b5dc342d30ab 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -193,7 +193,11 @@ static void renesas_sdhi_set_clock(struct tmio_mmc_host *host,
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



