Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3446312C47A;
	Tue, 30 Apr 2024 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474593; cv=none; b=sThawNnGF6rkwi5fFoDiVtbnePaphYg+fhVmGC02k224ssTYYCatx73nmL+7/pTi3NC09pU5jqCEFi8JZgNwcgHrdqVMQL5Xc5o1c2hHiwzvq9krTPlPhpyGGnm3swD5CrG8tfkrMQuPe+2y6tFKFmNdjf+eZ2t//gQ4m0V4+oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474593; c=relaxed/simple;
	bh=g0rlQPCbkVxxGuGgax7lRSpOgchJeigNWPmFSqIN4m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jf5uG9vRt375N88BoRRJbJbwbmGYEQOFMd1zSXjqwvtam39GXOPWeUfPD11+p+3YH0d/+dJ6uOnbv5KMRNkja64YpqMVGtYGY1mMHNM8If/+omdjQSM12zPDoNE6MBnSxeTme6cOAFH6SCvxAbog/yNG6stJMqsdDEzVdHM1jfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqqovvwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqqovvwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F452C4AF1A;
	Tue, 30 Apr 2024 10:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474593;
	bh=g0rlQPCbkVxxGuGgax7lRSpOgchJeigNWPmFSqIN4m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqqovvwzglIkg6EacbPs3byBi7q5xlPCCQeiwHcliOkpTxm/jia/0weyVzLX/ItME
	 1UrhgqzoYoLhukjfoEzyH8qw/SqKhy8fqpazQ3zCRwC7IZvX4j9wV6YEYxIvAKHfxq
	 RD8QDDRbyBxQyEptyArceYbvcf1ZqmHCzgGcOUYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 203/228] soundwire: amd: fix for wake interrupt handling for clockstop mode
Date: Tue, 30 Apr 2024 12:39:41 +0200
Message-ID: <20240430103109.659285249@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 63dc588e7af1392576071a1841298198c9cddee3 ]

When SoundWire Wake interrupt is enabled along with SoundWire Wake
enable register, SoundWire wake interrupt will be reported
when SoundWire manager is in D3 state and ACP is in D3 state.

When SoundWire Wake interrupt is reported, it will invoke runtime
resume of the SoundWire manager device.

In case of system level suspend, for ClockStop Mode SoundWire Wake
interrupt should be disabled.
It should be enabled only for runtime suspend scenario.
Change wake interrupt enable/disable sequence for ClockStop Mode in
system level suspend and runtime suspend sceanrio.

Fixes: 9cf1efc5ed2d ("soundwire: amd: add pm_prepare callback and pm ops support")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20240327063143.2266464-2-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 15 +++++++++++++++
 drivers/soundwire/amd_manager.h |  3 ++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index f54bb4dd2d101..42028ace063a4 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -148,6 +148,19 @@ static void amd_sdw_set_frameshape(struct amd_sdw_manager *amd_manager)
 	writel(frame_size, amd_manager->mmio + ACP_SW_FRAMESIZE);
 }
 
+static void amd_sdw_wake_enable(struct amd_sdw_manager *amd_manager, bool enable)
+{
+	u32 wake_ctrl;
+
+	wake_ctrl = readl(amd_manager->mmio + ACP_SW_STATE_CHANGE_STATUS_MASK_8TO11);
+	if (enable)
+		wake_ctrl |= AMD_SDW_WAKE_INTR_MASK;
+	else
+		wake_ctrl &= ~AMD_SDW_WAKE_INTR_MASK;
+
+	writel(wake_ctrl, amd_manager->mmio + ACP_SW_STATE_CHANGE_STATUS_MASK_8TO11);
+}
+
 static void amd_sdw_ctl_word_prep(u32 *lower_word, u32 *upper_word, struct sdw_msg *msg,
 				  int cmd_offset)
 {
@@ -1122,6 +1135,7 @@ static int __maybe_unused amd_suspend(struct device *dev)
 	}
 
 	if (amd_manager->power_mode_mask & AMD_SDW_CLK_STOP_MODE) {
+		amd_sdw_wake_enable(amd_manager, false);
 		return amd_sdw_clock_stop(amd_manager);
 	} else if (amd_manager->power_mode_mask & AMD_SDW_POWER_OFF_MODE) {
 		/*
@@ -1148,6 +1162,7 @@ static int __maybe_unused amd_suspend_runtime(struct device *dev)
 		return 0;
 	}
 	if (amd_manager->power_mode_mask & AMD_SDW_CLK_STOP_MODE) {
+		amd_sdw_wake_enable(amd_manager, true);
 		return amd_sdw_clock_stop(amd_manager);
 	} else if (amd_manager->power_mode_mask & AMD_SDW_POWER_OFF_MODE) {
 		ret = amd_sdw_clock_stop(amd_manager);
diff --git a/drivers/soundwire/amd_manager.h b/drivers/soundwire/amd_manager.h
index 5f040151a259b..6dcc7a449346e 100644
--- a/drivers/soundwire/amd_manager.h
+++ b/drivers/soundwire/amd_manager.h
@@ -152,7 +152,7 @@
 #define AMD_SDW0_EXT_INTR_MASK		0x200000
 #define AMD_SDW1_EXT_INTR_MASK		4
 #define AMD_SDW_IRQ_MASK_0TO7		0x77777777
-#define AMD_SDW_IRQ_MASK_8TO11		0x000d7777
+#define AMD_SDW_IRQ_MASK_8TO11		0x000c7777
 #define AMD_SDW_IRQ_ERROR_MASK		0xff
 #define AMD_SDW_MAX_FREQ_NUM		1
 #define AMD_SDW0_MAX_TX_PORTS		3
@@ -190,6 +190,7 @@
 #define AMD_SDW_CLK_RESUME_REQ				2
 #define AMD_SDW_CLK_RESUME_DONE				3
 #define AMD_SDW_WAKE_STAT_MASK				BIT(16)
+#define AMD_SDW_WAKE_INTR_MASK				BIT(16)
 
 static u32 amd_sdw_freq_tbl[AMD_SDW_MAX_FREQ_NUM] = {
 	AMD_SDW_DEFAULT_CLK_FREQ,
-- 
2.43.0



