Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7730F12D755;
	Tue, 30 Apr 2024 11:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475733; cv=none; b=UkGNmzM7zFuQF1ki6TmgD6dk2h5KkHY9KK4bynveYV7mAxaSQ9CZloWoNPmaF/cdIyDqQFw7htplegMKoqpJlLrPmHbEQlWjQZ/qg2JtUK69/mOrPKT7F7LIPHoL3gFLeiyrsvNTW2DeY2oRCHAgoNdqfwt4SBS+sEaSCbkXl2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475733; c=relaxed/simple;
	bh=rU3r815yod2YWXObHgCFacKZa8a0Kuiv0gPzVR0nDsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyz+cXuNKHiqxpOeBgvMlYReIb+B2j1vpu65uqYVVjLT7DPwGnlAAla6JdH3UFzRjpRw5lZcS/IsEN8u+7iROIyuS3gQaynJORvpMGUkDADutTkNi6fkvDjYCzBc1FpjEGgkBjpB1r92P7Smq3V7GQNXg2f/mNnEGXRNlmd9ixA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2aqBQ0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2aqBQ0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEFBC2BBFC;
	Tue, 30 Apr 2024 11:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475733;
	bh=rU3r815yod2YWXObHgCFacKZa8a0Kuiv0gPzVR0nDsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2aqBQ0+5IImtu8HrI6WaSXkw0Xyl1/sStKxQg8a4QJxAJut0K6PrybFYqgi+j0L2
	 fqEgekPQT/ZF9afr8M8/5Ku4yvAzXpWEUtFFosmFBAEJeQU9TqoNyaaB5JZagOZQAo
	 /sfSf2+Y8b8Ky+sWlbRxq1FxsN09JvYTG1ON99fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/186] soundwire: amd: fix for wake interrupt handling for clockstop mode
Date: Tue, 30 Apr 2024 12:40:13 +0200
Message-ID: <20240430103102.707096134@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a3b1f4e6f0f90..79173ab540a6b 100644
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



