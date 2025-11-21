Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7644234E74B;
	Fri, 21 Nov 2025 13:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732368; cv=none; b=TK+O/7d7yM40vkXjxc0x3BOGDeVUWTUpnalK7MFqUdrOWH5ZYKtu0JHBsoPabjbaYhI2Fhh/Gsp8iLLLDDH6H51ZN5pdL9fWehcLNXyIFSuxgzNM3TcMqQ7hoAC20/ie95Wm8x5LxNgHdz41J2TxzzWCnG9sffvVadSHne8KPuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732368; c=relaxed/simple;
	bh=Z29IqAwiAgh0c70zTxE771m3rDVEfBZ6lkWEW+tIzmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyHdPv4l5ibkLSZCZWlwD9kXR9FPI/YMlzZFlYoNSnlmwxn21QIPu9LJtiHS8sIKvGPLF2fsiH6oslpWFnjfbSNgy79ck9NbyA6Puh3poXwBthxeVDabcMPwCem8bjVkZyaIqNaf2rip53zyoy+30JdbGkzVzqQBHojHHoev9Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4DNFhN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4DNFhN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31001C4CEF1;
	Fri, 21 Nov 2025 13:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732367;
	bh=Z29IqAwiAgh0c70zTxE771m3rDVEfBZ6lkWEW+tIzmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U4DNFhN8Y4HNI+JuiSvihQ+NBAAZj+zhOabCYcLvJEky/jc2Mg0wA4olfwzJRhoUv
	 AnAIKLKxWbORCMLF2f2Y36b21qiIeELVUja/BO8iQPAmwbHHnRybxV6ehTSC3/FJRu
	 bLwX6CsWvZdN9SooV36JalDb2P0f/EKT578mKBTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/529] mmc: host: renesas_sdhi: Fix the actual clock
Date: Fri, 21 Nov 2025 14:06:02 +0100
Message-ID: <20251121130233.267541993@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 597b00e8c9539..cffacf4434b55 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -220,7 +220,11 @@ static void renesas_sdhi_set_clock(struct tmio_mmc_host *host,
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



