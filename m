Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FCD2BD02D;
	Sun,  1 Jun 2025 23:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820890; cv=none; b=N9QGj5hgPYBW+nsA6IEYgRxhXDImTlpGdM3T0NFgelspuUF4mVxvshqQ1YgYxqGqS40B40xF59fDcc1VS1qoRF0Cad5Py5hSG0pWfHhBHL/54kyZC7KPukJFD9kNBIP1sTgCzClXPvmNthHyS+5Ghn3v8UgrU3EayRZ+l5bVNro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820890; c=relaxed/simple;
	bh=eH2MRst08QJbT48Qk34cNF6GC/r5RUhxvxzGbHtXzXc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A1f8rJY5s0xQCbfeK/j8vblAU+PjolnOHLCwUM2Y8W5PzgO4c2lneumyYHcL/55YsTb44VoIU+Yn5yrUU+TatcqtIlUkW/Rpx0rYIJ3BtJx91DM25oa0h5XyonyAGC0tAQlgQptNske3Ni1VplzwpP2hWzmU4xsomS9sOGrRoLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqyuyfug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqyuyfug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4C6C4CEE7;
	Sun,  1 Jun 2025 23:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820890;
	bh=eH2MRst08QJbT48Qk34cNF6GC/r5RUhxvxzGbHtXzXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqyuyfugXAV8BEaLcA6jjDl/xSmDXi7RB6EhfVw805tpDzzWKxqxfpLomYL9UpRlj
	 eEzN1qdlZzr0DIbDy350KSuYGiVAZ/uWHOL4mgce2ZMYTo3PVdA5IXjq/GYEB1aIsB
	 7X425JHh68V7UfhWzCgYZjlP7P9AiKGQH4MVPKgXOysWqubC/Q3qwNdLMVzbGBrQ5/
	 UhQQGKyVuk33X6RFOrjFneAL6pnYO5n3/QLN1hnHtce03e2c8VOCp2CJ0M8YcV8V69
	 JuEvBA4kIbHCGuc0b/n34Vt9PqQcke0wTH5Q7EEFLHal9lm4pR0jWuU/S1ZmgNmTjp
	 rXC8opUjqxCiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ayushi Makhija <quic_amakhija@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	andrzej.hajda@intel.com,
	neil.armstrong@linaro.org,
	rfoss@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	lumag@kernel.org,
	dianders@chromium.org,
	wenst@chromium.org,
	xji@analogixsemi.com,
	robh@kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 17/93] drm/bridge: anx7625: change the gpiod_set_value API
Date: Sun,  1 Jun 2025 19:32:44 -0400
Message-Id: <20250601233402.3512823-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233402.3512823-1-sashal@kernel.org>
References: <20250601233402.3512823-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ayushi Makhija <quic_amakhija@quicinc.com>

[ Upstream commit 50935044e58e563cdcfd556d62f27bc8744dd64e ]

Use gpiod_set_value_cansleep() instead of gpiod_set_value()
to fix the below call trace in the boot log:

[    5.690534] Call trace:
[    5.690536]  gpiod_set_value+0x40/0xa4
[    5.690540]  anx7625_runtime_pm_resume+0xa0/0x324 [anx7625]
[    5.690545]  __rpm_callback+0x48/0x1d8
[    5.690549]  rpm_callback+0x6c/0x78

Certain GPIO controllers require access via message-based buses
such as I2C or SPI, which may cause the GPIOs to enter a sleep
state. Therefore, use the gpiod_set_value_cansleep().

Signed-off-by: Ayushi Makhija <quic_amakhija@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20250505094245.2660750-7-quic_amakhija@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees.
**Detailed Analysis:** **1. Bug Fix Nature:** The commit fixes a real
runtime issue that produces call traces in the boot log. The commit
message clearly shows a call trace stack: ``` [ 5.690534] Call trace: [
5.690536] gpiod_set_value+0x40/0xa4 [ 5.690540]
anx7625_runtime_pm_resume+0xa0/0x324 [anx7625] ``` This indicates users
are experiencing actual crashes or warnings when using this driver with
certain GPIO controllers. **2. Small, Contained Fix:** The code changes
are minimal and surgical - only 4 lines changed, replacing
`gpiod_set_value()` with `gpiod_set_value_cansleep()` in the
`anx7625_power_on()` and `anx7625_power_standby()` functions: - Line
1260: `gpiod_set_value(ctx->pdata.gpio_p_on, 1)` →
`gpiod_set_value_cansleep(ctx->pdata.gpio_p_on, 1)` - Line 1263:
`gpiod_set_value(ctx->pdata.gpio_reset, 1)` →
`gpiod_set_value_cansleep(ctx->pdata.gpio_reset, 1)` - Line 1283:
`gpiod_set_value(ctx->pdata.gpio_reset, 0)` →
`gpiod_set_value_cansleep(ctx->pdata.gpio_reset, 0)` - Line 1285:
`gpiod_set_value(ctx->pdata.gpio_p_on, 0)` →
`gpiod_set_value_cansleep(ctx->pdata.gpio_p_on, 0)` **3. Well-
Established Pattern:** Looking at the similar commits provided as
reference, this exact type of GPIO API fix is common and consistently
handles the same underlying issue. All 5 similar commits (marked as "NO"
for backport) show the same pattern of switching from
`gpiod_set_value()` to `gpiod_set_value_cansleep()` to handle GPIO
controllers on message-based buses (I2C/SPI). **4. Technical
Correctness:** The fix is technically sound. These functions are called
during power management operations (`anx7625_power_on()` and
`anx7625_power_standby()`) where sleeping is acceptable and expected.
The `_cansleep` variant is the correct API when GPIO controllers might
be accessed via slow buses like I2C or SPI. **5. Low Risk:** The change
has minimal risk of regression. The `gpiod_set_value_cansleep()`
function provides the same functionality as `gpiod_set_value()` but
allows sleeping, making it safe to use in contexts where the original
was used incorrectly. **6. Critical Subsystem Impact:** This affects the
DRM bridge subsystem and display functionality. Users with anx7625
bridge chips connected to I2C GPIO expanders would experience boot-time
call traces, which is a user-visible issue that should be fixed in
stable kernels. **7. Real Hardware Impact:** The commit specifically
mentions "Certain GPIO controllers require access via message-based
buses such as I2C or SPI" - this is a real hardware configuration that
users deploy, not an edge case. This commit meets all the criteria for
stable backporting: it fixes a user-visible bug, has minimal risk, is
contained to a single driver, and follows an established pattern for
this type of GPIO API fix.

 drivers/gpu/drm/bridge/analogix/anx7625.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 04b1d5c961ce5..5b19136531f80 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1257,10 +1257,10 @@ static void anx7625_power_on(struct anx7625_data *ctx)
 	usleep_range(11000, 12000);
 
 	/* Power on pin enable */
-	gpiod_set_value(ctx->pdata.gpio_p_on, 1);
+	gpiod_set_value_cansleep(ctx->pdata.gpio_p_on, 1);
 	usleep_range(10000, 11000);
 	/* Power reset pin enable */
-	gpiod_set_value(ctx->pdata.gpio_reset, 1);
+	gpiod_set_value_cansleep(ctx->pdata.gpio_reset, 1);
 	usleep_range(10000, 11000);
 
 	DRM_DEV_DEBUG_DRIVER(dev, "power on !\n");
@@ -1280,9 +1280,9 @@ static void anx7625_power_standby(struct anx7625_data *ctx)
 		return;
 	}
 
-	gpiod_set_value(ctx->pdata.gpio_reset, 0);
+	gpiod_set_value_cansleep(ctx->pdata.gpio_reset, 0);
 	usleep_range(1000, 1100);
-	gpiod_set_value(ctx->pdata.gpio_p_on, 0);
+	gpiod_set_value_cansleep(ctx->pdata.gpio_p_on, 0);
 	usleep_range(1000, 1100);
 
 	ret = regulator_bulk_disable(ARRAY_SIZE(ctx->pdata.supplies),
-- 
2.39.5

