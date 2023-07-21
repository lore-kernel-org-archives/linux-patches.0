Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3664B200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56854C433C9;
	Fri, 21 Jul 2023 19:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966012;
	bh=eChpkFqjQpgHo+0kp79sDAgmC8+UC7KJ0eA+G6EKAcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkU0D3Uc//aZkp1dRkO5dOsUA55XNlqwIPpV8seOjY2RvXr67Iwh0f5vyEbGKYe26
	 d50XmVPzob6cQ+kg0678ijDQU6q210sRGfVKES/jkgJLc7uxmyaCLskqUbvoi6ML1v
	 dW5LWvIb58GtEWEz7dyrFS/7FnsabAAWJEGfdi1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/532] drm/radeon: fix possible division-by-zero errors
Date: Fri, 21 Jul 2023 18:01:10 +0200
Message-ID: <20230721160623.404765356@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit 1becc57cd1a905e2aa0e1eca60d2a37744525c4a ]

Function rv740_get_decoded_reference_divider() may return 0 due to
unpredictable reference divider value calculated in
radeon_atom_get_clock_dividers(). This will lead to
division-by-zero error once that value is used as a divider
in calculating 'clk_s'.
While unlikely, this issue should nonetheless be prevented so add a
sanity check for such cases by testing 'decoded_ref' value against 0.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

v2: minor coding style fixes (Alex)
In practice this should actually happen as the vbios should be
properly populated.

Fixes: 66229b200598 ("drm/radeon/kms: add dpm support for rv7xx (v4)")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/cypress_dpm.c | 8 ++++++--
 drivers/gpu/drm/radeon/ni_dpm.c      | 8 ++++++--
 drivers/gpu/drm/radeon/rv740_dpm.c   | 8 ++++++--
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cypress_dpm.c b/drivers/gpu/drm/radeon/cypress_dpm.c
index fdddbbaecbb74..72a0768df00f7 100644
--- a/drivers/gpu/drm/radeon/cypress_dpm.c
+++ b/drivers/gpu/drm/radeon/cypress_dpm.c
@@ -557,8 +557,12 @@ static int cypress_populate_mclk_value(struct radeon_device *rdev,
 						     ASIC_INTERNAL_MEMORY_SS, vco_freq)) {
 			u32 reference_clock = rdev->clock.mpll.reference_freq;
 			u32 decoded_ref = rv740_get_decoded_reference_divider(dividers.ref_div);
-			u32 clk_s = reference_clock * 5 / (decoded_ref * ss.rate);
-			u32 clk_v = ss.percentage *
+			u32 clk_s, clk_v;
+
+			if (!decoded_ref)
+				return -EINVAL;
+			clk_s = reference_clock * 5 / (decoded_ref * ss.rate);
+			clk_v = ss.percentage *
 				(0x4000 * dividers.whole_fb_div + 0x800 * dividers.frac_fb_div) / (clk_s * 625);
 
 			mpll_ss1 &= ~CLKV_MASK;
diff --git a/drivers/gpu/drm/radeon/ni_dpm.c b/drivers/gpu/drm/radeon/ni_dpm.c
index 672d2239293e0..3e1c1a392fb7b 100644
--- a/drivers/gpu/drm/radeon/ni_dpm.c
+++ b/drivers/gpu/drm/radeon/ni_dpm.c
@@ -2241,8 +2241,12 @@ static int ni_populate_mclk_value(struct radeon_device *rdev,
 						     ASIC_INTERNAL_MEMORY_SS, vco_freq)) {
 			u32 reference_clock = rdev->clock.mpll.reference_freq;
 			u32 decoded_ref = rv740_get_decoded_reference_divider(dividers.ref_div);
-			u32 clk_s = reference_clock * 5 / (decoded_ref * ss.rate);
-			u32 clk_v = ss.percentage *
+			u32 clk_s, clk_v;
+
+			if (!decoded_ref)
+				return -EINVAL;
+			clk_s = reference_clock * 5 / (decoded_ref * ss.rate);
+			clk_v = ss.percentage *
 				(0x4000 * dividers.whole_fb_div + 0x800 * dividers.frac_fb_div) / (clk_s * 625);
 
 			mpll_ss1 &= ~CLKV_MASK;
diff --git a/drivers/gpu/drm/radeon/rv740_dpm.c b/drivers/gpu/drm/radeon/rv740_dpm.c
index d57a3e1df8d63..4464fd21a3029 100644
--- a/drivers/gpu/drm/radeon/rv740_dpm.c
+++ b/drivers/gpu/drm/radeon/rv740_dpm.c
@@ -249,8 +249,12 @@ int rv740_populate_mclk_value(struct radeon_device *rdev,
 						     ASIC_INTERNAL_MEMORY_SS, vco_freq)) {
 			u32 reference_clock = rdev->clock.mpll.reference_freq;
 			u32 decoded_ref = rv740_get_decoded_reference_divider(dividers.ref_div);
-			u32 clk_s = reference_clock * 5 / (decoded_ref * ss.rate);
-			u32 clk_v = 0x40000 * ss.percentage *
+			u32 clk_s, clk_v;
+
+			if (!decoded_ref)
+				return -EINVAL;
+			clk_s = reference_clock * 5 / (decoded_ref * ss.rate);
+			clk_v = 0x40000 * ss.percentage *
 				(dividers.whole_fb_div + (dividers.frac_fb_div / 8)) / (clk_s * 10000);
 
 			mpll_ss1 &= ~CLKV_MASK;
-- 
2.39.2



