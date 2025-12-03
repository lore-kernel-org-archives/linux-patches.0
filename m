Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB9415ADB4;
	Wed,  3 Dec 2025 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764775972; cv=none; b=BsSkcZMNuLWlqHpyy5LONmUXNP1z28gbC6486nIzRFxsbjelVvByX+XuhxpJaUjU9+yl7wv0Bk+vD97Yl1lgV7UPISvOjHNDH7ui6/W853t5xmnFC9W/tcb1h+eJGwS8DiTJqcb67lRtJO3P7VusdwYzz2e4nPh2lm66EepdDGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764775972; c=relaxed/simple;
	bh=4AMXrnsypvifbJEePw1o8p5VC8FnOxH6wigU5VSIzmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsuIYri8fhmRzaQZjUrFEnhANIVhFIKaVXA2kZtVaf5CRmpH0RwK9/ZRXu3HTi5dgXutwxy59Cm9J+CxiQEUpIF9LXI8Ia8GnZmEAGhCCJl8EGFkky8COjM9IQVkQywNP0yiLsjI/pZGLp96Figae+O/Cw6go6VrwwtV6lvF5QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPdcBTXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPdcBTXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AC8C4CEF5;
	Wed,  3 Dec 2025 15:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764775972;
	bh=4AMXrnsypvifbJEePw1o8p5VC8FnOxH6wigU5VSIzmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPdcBTXOGNeq9H2JaDIgJ8OBxfeht31m16rSH6IAxkRS9Dno9qfANVS6miU+dcWyx
	 WB5eYHR1/RPxeKVRqK/YY0jDKcK/op9XKiWL5FHwIOWLdZs8/o9KBMlAOTXlLDJhVA
	 0aHKRkv3Vw87DbipwrrY1HJOu/xHM1HTk5cRPb1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/300] mmc: host: renesas_sdhi: Fix the actual clock
Date: Wed,  3 Dec 2025 16:24:07 +0100
Message-ID: <20251203152402.208719437@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a15b44ca87d35..c0acb309e3243 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -183,7 +183,11 @@ static void renesas_sdhi_set_clock(struct tmio_mmc_host *host,
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



