Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC041875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27606C433D2;
	Wed, 28 Dec 2022 15:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243015;
	bh=2O9/80TZi91Ai0SyGAgdDIbqpeZq11OA7HCa76Urnxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppCC3RDb+vWc/JM1WZy/+hKbJf5U2u4wJAkFHzn/1cfv2NTMz+xcp0kT+/0Q2LoFb
	 s2ZkGnsx2s2FOkTBVaXBUcS7xFd2eUuKHDExBWqgmPHAiK++igm8eqhQftTXLu6q1C
	 epPmg0k1xdUaz4gMi8OdpaHXb9YnCXjhUaWFmhI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 671/731] mmc: renesas_sdhi: better reset from HS400 mode
Date: Wed, 28 Dec 2022 15:42:58 +0100
Message-Id: <20221228144315.934933474@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 0da69dd2155019ed4c444ede0e79ce7a4a6af627 ]

Up to now, HS400 adjustment mode was only disabled on soft reset when a
calibration table was in use. It is safer, though, to disable it as soon
as the instance has an adjustment related quirk set, i.e. bad taps or a
calibration table.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20221120113457.42010-3-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/renesas_sdhi_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index f443debbcb98..12921fba4f52 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -520,7 +520,7 @@ static void renesas_sdhi_reset_hs400_mode(struct tmio_mmc_host *host,
 			 SH_MOBILE_SDHI_SCC_TMPPORT2_HS400OSEL) &
 			sd_scc_read32(host, priv, SH_MOBILE_SDHI_SCC_TMPPORT2));
 
-	if (priv->adjust_hs400_calib_table)
+	if (priv->quirks && (priv->quirks->hs400_calib_table || priv->quirks->hs400_bad_taps))
 		renesas_sdhi_adjust_hs400_mode_disable(host);
 
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, CLK_CTL_SCLKEN |
-- 
2.35.1



