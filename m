Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851CC79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABF1C433D2;
	Thu, 12 Jan 2023 14:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533173;
	bh=EZxh70upKmVdfl0+AlR0i4wB+kJ8+6/XUEIDBeWQNOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b0AnNa+1vae7ZcStKtrDd8XGgtWyuxwgr3sM2GjeU808Jj9K1apcVONyFgH7riWHO
	 cJ+w8T+QqHMQZ4wgpwCn/VXBdT16OUev2BKUAmrZXZl3OOYx1phOxMwtnOij8PeM4Y
	 mamX4XySRuTcl9CrC+hG5d4O+chj44SUelhd4YbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcus Folkesson <marcus.folkesson@gmail.com>,
	Jacky Bai <ping.bai@nxp.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 393/783] thermal/drivers/imx8mm_thermal: Validate temperature range
Date: Thu, 12 Jan 2023 14:51:49 +0100
Message-Id: <20230112135542.533891371@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit d37edc7370273306d8747097fafa62436c1cfe16 ]

Check against the upper temperature limit (125 degrees C) before
consider the temperature valid.

Fixes: 5eed800a6811 ("thermal: imx8mm: Add support for i.MX8MM thermal monitoring unit")
Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Link: https://lore.kernel.org/r/20221014073507.1594844-1-marcus.folkesson@gmail.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx8mm_thermal.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/imx8mm_thermal.c b/drivers/thermal/imx8mm_thermal.c
index 0f4cabd2a8c6..6be16e0598b6 100644
--- a/drivers/thermal/imx8mm_thermal.c
+++ b/drivers/thermal/imx8mm_thermal.c
@@ -65,8 +65,14 @@ static int imx8mm_tmu_get_temp(void *data, int *temp)
 	u32 val;
 
 	val = readl_relaxed(tmu->base + TRITSR) & TRITSR_TEMP0_VAL_MASK;
+
+	/*
+	 * Do not validate against the V bit (bit 31) due to errata
+	 * ERR051272: TMU: Bit 31 of registers TMU_TSCR/TMU_TRITSR/TMU_TRATSR invalid
+	 */
+
 	*temp = val * 1000;
-	if (*temp < VER1_TEMP_LOW_LIMIT)
+	if (*temp < VER1_TEMP_LOW_LIMIT || *temp > VER2_TEMP_HIGH_LIMIT)
 		return -EAGAIN;
 
 	return 0;
-- 
2.35.1



