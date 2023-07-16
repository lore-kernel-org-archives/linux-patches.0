Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3188F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:22:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A00C433C8;
	Sun, 16 Jul 2023 20:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538960;
	bh=t5dc8HQpTwI7tli9JanaKj+q2mIcDbz75/FufcyVGEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjRXrgQM7fitmAQ4RV8qfuVuWbslS/2XfDb3z/JBWWFkdXfJh8/y5t2klR8mVvnsR
	 AMUsJ7x+LVcGNoGPq0LQShrbrkEw9vrKcKThJZNIFq/Z1+Icfyvb09tj8C4kNjsyxV
	 0AyqPpgd5p9b3icdq/srqW6N6tjMnp5q6i58EsGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia-wei Chang <Jia-wei.Chang@mediatek.com>,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 638/800] cpufreq: mediatek: correct voltages for MT7622 and MT7623
Date: Sun, 16 Jul 2023 21:48:11 +0200
Message-ID: <20230716195003.933469914@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit f85534113f5ae90a52521cdb9e9977a43ee42626 ]

The MT6380 regulator typically used together with MT7622 does not
support the current maximum processor and SRAM voltage in the cpufreq
driver (1360000uV).
For MT7622 limit processor and SRAM supply voltages to 1350000uV to
avoid having the tracking algorithm request unsupported voltages from
the regulator.

On MT7623 there is no separate SRAM supply and the maximum voltage used
is 1300000uV. Create dedicated platform data for MT7623 to cover that
case as well.

Fixes: 0883426fd07e3 ("cpufreq: mediatek: Raise proc and sram max voltage for MT7622/7623")
Suggested-by: Jia-wei Chang <Jia-wei.Chang@mediatek.com>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/mediatek-cpufreq.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/mediatek-cpufreq.c b/drivers/cpufreq/mediatek-cpufreq.c
index 9a39a7ccfae96..fef68cb2b38f7 100644
--- a/drivers/cpufreq/mediatek-cpufreq.c
+++ b/drivers/cpufreq/mediatek-cpufreq.c
@@ -696,9 +696,16 @@ static const struct mtk_cpufreq_platform_data mt2701_platform_data = {
 static const struct mtk_cpufreq_platform_data mt7622_platform_data = {
 	.min_volt_shift = 100000,
 	.max_volt_shift = 200000,
-	.proc_max_volt = 1360000,
+	.proc_max_volt = 1350000,
 	.sram_min_volt = 0,
-	.sram_max_volt = 1360000,
+	.sram_max_volt = 1350000,
+	.ccifreq_supported = false,
+};
+
+static const struct mtk_cpufreq_platform_data mt7623_platform_data = {
+	.min_volt_shift = 100000,
+	.max_volt_shift = 200000,
+	.proc_max_volt = 1300000,
 	.ccifreq_supported = false,
 };
 
@@ -734,7 +741,7 @@ static const struct of_device_id mtk_cpufreq_machines[] __initconst = {
 	{ .compatible = "mediatek,mt2701", .data = &mt2701_platform_data },
 	{ .compatible = "mediatek,mt2712", .data = &mt2701_platform_data },
 	{ .compatible = "mediatek,mt7622", .data = &mt7622_platform_data },
-	{ .compatible = "mediatek,mt7623", .data = &mt7622_platform_data },
+	{ .compatible = "mediatek,mt7623", .data = &mt7623_platform_data },
 	{ .compatible = "mediatek,mt8167", .data = &mt8516_platform_data },
 	{ .compatible = "mediatek,mt817x", .data = &mt2701_platform_data },
 	{ .compatible = "mediatek,mt8173", .data = &mt2701_platform_data },
-- 
2.39.2



