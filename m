Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AB91EE02F;
	Tue, 30 Sep 2025 15:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244589; cv=none; b=Ktbyn4dhAgWCJfCFu0odUwnKp1DESm9dM+1ajmBTFHbpJuOF6SizXHapjaZUMh+cb4QNG80s0TZbSnzyRzoT6SjpZLxJP344kFik2+cLHmFM7v8PMqixcgRyTOF+zZLpJY/cQf+h9ioM6UdkW98vNaafzaUIIymavAojvhdAA7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244589; c=relaxed/simple;
	bh=78eZ4mxdgmehVafubClEtVhhhlrTeTYx9cHUZWP98Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6NNVeC6SaNjQq6NZg+k9Nj9y0D5KrsoBkk28/2QhnfLMtV0KJqoFootKZjwNXeI1+wYD01Ovq7lvnueaCk4jP+9jUDhRcRwbdKbOdQWA0VBl1ABicfRalFJpfcZMjYyof0rB8gtyKxFQvBTDlDBLr0bNDgyQ3S8Ret6UudVMs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZt29UJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZt29UJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A1FC4CEF0;
	Tue, 30 Sep 2025 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244589;
	bh=78eZ4mxdgmehVafubClEtVhhhlrTeTYx9cHUZWP98Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZt29UJfQMYbni657XZBjynBNYbnWDQ38hSr6Zr6NKQ45F2QWA3e70NE6wWb9YKLg
	 Ru5kkUEIzvQbC1HaFGrlLgInoN6GyYzC/jqk+HGcKOmIe/FfLOTOy1JdUcqaNVtmUz
	 D2E3HMXug1IAIhX5Ilh4KmT6yMIb0OCt84Yotc10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 022/143] drm/panfrost: Commonize Mediatek power domain array definitions
Date: Tue, 30 Sep 2025 16:45:46 +0200
Message-ID: <20250930143832.126827981@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit bd77b870eb190c9cf5d9b7208625513e99e5be2d ]

In the panfrost driver, the platform data of several Mediatek SoC
declares and uses several different power domains arrays according to
GPU core number present in the SoC:
- mediatek_mt8186_pm_domains (2 cores)
- mediatek_mt8183_pm_domains (3 cores)
- mediatek_mt8192_pm_domains (5 cores)

As they all are fixed arrays, starting with the same entries and the
platform data also has a power domains array length field
(num_pm_domains), they can be replaced by a single array, containing
all entries, if the num_pm_domains field of the platform data is also
set to the matching core number.

So, create a generic power domain array (mediatek_pm_domains) and use
it in the mt8183(b), mt8186, mt8188 and mt8192 platform data instead.

Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250509-mt8370-enable-gpu-v6-3-2833888cb1d3@collabora.com
Stable-dep-of: 81645377c231 ("drm/panfrost: Add support for Mali on the MT8370 SoC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 27 +++++++++++--------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 7b899a9b2120c..21b28bef84015 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -789,6 +789,8 @@ static const struct panfrost_compatible amlogic_data = {
 	.vendor_quirk = panfrost_gpu_amlogic_quirk,
 };
 
+static const char * const mediatek_pm_domains[] = { "core0", "core1", "core2",
+						    "core3", "core4" };
 /*
  * The old data with two power supplies for MT8183 is here only to
  * keep retro-compatibility with older devicetrees, as DVFS will
@@ -798,48 +800,43 @@ static const struct panfrost_compatible amlogic_data = {
  * coupled regulators instead.
  */
 static const char * const legacy_supplies[] = { "mali", "sram", NULL };
-static const char * const mediatek_mt8183_pm_domains[] = { "core0", "core1", "core2" };
 static const struct panfrost_compatible mediatek_mt8183_data = {
 	.num_supplies = ARRAY_SIZE(legacy_supplies) - 1,
 	.supply_names = legacy_supplies,
-	.num_pm_domains = ARRAY_SIZE(mediatek_mt8183_pm_domains),
-	.pm_domain_names = mediatek_mt8183_pm_domains,
+	.num_pm_domains = 3,
+	.pm_domain_names = mediatek_pm_domains,
 };
 
 static const struct panfrost_compatible mediatek_mt8183_b_data = {
 	.num_supplies = ARRAY_SIZE(default_supplies) - 1,
 	.supply_names = default_supplies,
-	.num_pm_domains = ARRAY_SIZE(mediatek_mt8183_pm_domains),
-	.pm_domain_names = mediatek_mt8183_pm_domains,
+	.num_pm_domains = 3,
+	.pm_domain_names = mediatek_pm_domains,
 	.pm_features = BIT(GPU_PM_CLK_DIS) | BIT(GPU_PM_VREG_OFF),
 };
 
-static const char * const mediatek_mt8186_pm_domains[] = { "core0", "core1" };
 static const struct panfrost_compatible mediatek_mt8186_data = {
 	.num_supplies = ARRAY_SIZE(default_supplies) - 1,
 	.supply_names = default_supplies,
-	.num_pm_domains = ARRAY_SIZE(mediatek_mt8186_pm_domains),
-	.pm_domain_names = mediatek_mt8186_pm_domains,
+	.num_pm_domains = 2,
+	.pm_domain_names = mediatek_pm_domains,
 	.pm_features = BIT(GPU_PM_CLK_DIS) | BIT(GPU_PM_VREG_OFF),
 };
 
-/* MT8188 uses the same power domains and power supplies as MT8183 */
 static const struct panfrost_compatible mediatek_mt8188_data = {
 	.num_supplies = ARRAY_SIZE(default_supplies) - 1,
 	.supply_names = default_supplies,
-	.num_pm_domains = ARRAY_SIZE(mediatek_mt8183_pm_domains),
-	.pm_domain_names = mediatek_mt8183_pm_domains,
+	.num_pm_domains = 3,
+	.pm_domain_names = mediatek_pm_domains,
 	.pm_features = BIT(GPU_PM_CLK_DIS) | BIT(GPU_PM_VREG_OFF),
 	.gpu_quirks = BIT(GPU_QUIRK_FORCE_AARCH64_PGTABLE),
 };
 
-static const char * const mediatek_mt8192_pm_domains[] = { "core0", "core1", "core2",
-							   "core3", "core4" };
 static const struct panfrost_compatible mediatek_mt8192_data = {
 	.num_supplies = ARRAY_SIZE(default_supplies) - 1,
 	.supply_names = default_supplies,
-	.num_pm_domains = ARRAY_SIZE(mediatek_mt8192_pm_domains),
-	.pm_domain_names = mediatek_mt8192_pm_domains,
+	.num_pm_domains = 5,
+	.pm_domain_names = mediatek_pm_domains,
 	.pm_features = BIT(GPU_PM_CLK_DIS) | BIT(GPU_PM_VREG_OFF),
 	.gpu_quirks = BIT(GPU_QUIRK_FORCE_AARCH64_PGTABLE),
 };
-- 
2.51.0



