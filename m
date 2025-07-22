Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2886D2EAB69;
	Tue, 22 Jul 2025 14:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193465; cv=none; b=sd67SQmw0Zi+XzUJi3cbA6DBsgeVfAtyYrvgCgH7TCuANmQE2IBNDjoHLglb4nw/MkzD/vxW3qlZ0inA4BQ0pJLSQsm+S319sgzrxhc6ZkFXdNR1Mizj2nX5kB+m6oKED3roZR6ctJBnIkgRefR7oEhPi3gEiI65dgR34j54ZzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193465; c=relaxed/simple;
	bh=oGdS6YxQbf8Bdvs7OMbNdY9s9hKyMooMvBAhS8ZnRKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcyFZ3iar3k32MtRzv2hxonrnuM6R6pq2Y166N8cj9S4/vblwkaJ5YHfOrUxXWBifI3oqqaxdsBHwn3vWivHmG+YWCz49cw/Ej4zhdMOhDLMOkI+f8k2MOfEzfb19/ePXQ89OvGw8jgkVocarRRQMLBGkJN5A3/ozgxrc2ABVBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4D0Zpu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4D0Zpu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B13EC4CEEB;
	Tue, 22 Jul 2025 14:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193465;
	bh=oGdS6YxQbf8Bdvs7OMbNdY9s9hKyMooMvBAhS8ZnRKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4D0Zpu2wkxTBTAquopE3N646C6VwOTlFqeJO+hGZ4dkPWM238O6abJi+DD1smgLD
	 75ZOp9O3g/bAEAgTQyc5Kp2b/o05LGo5wZIN9FW6ScgZW9O4nN83xyyTiWEvA8znbn
	 TRymv7Doe3UjBUt1WFCiV2fbMX7QiArZo+60XsGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 099/187] soundwire: amd: fix for handling slave alerts after link is down
Date: Tue, 22 Jul 2025 15:44:29 +0200
Message-ID: <20250722134349.465280713@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 86a4371b76976158be875dc654ceee35c574b27b ]

Sometimes, its observed that during system level suspend callback
execution, after link is down, handling pending slave status workqueue
results in mipi register access failures as shown below.

soundwire sdw-master-0-0: trf on Slave 1 failed:-110 read addr 0 count 1
rt722-sdca sdw:0:0:025d:0722:01: SDW_DP0_INT recheck read failed:-110
rt722-sdca sdw:0:0:025d:0722:01: Slave 1 alert handling failed: -110
amd_sdw_manager amd_sdw_manager.0: SDW0 cmd response timeout occurred
amd_sdw_manager amd_sdw_manager.0: command timeout for Slave 1
soundwire sdw-master-0-0: trf on Slave 1 failed:-110 write addr 5c count 1
amd_sdw_manager amd_sdw_manager.0: SDW0 previous cmd status clear failed
amd_sdw_manager amd_sdw_manager.0: command timeout for Slave 1
soundwire sdw-master-0-0: trf on Slave 1 failed:-110 write addr 5d count 1
amd_sdw_manager amd_sdw_manager.0: SDW0 previous cmd status clear failed
amd_sdw_manager amd_sdw_manager.0: command timeout for Slave 1

Cancel the pending slave status workqueue prior to initiating clock stop
sequence during suspend callback execution for both the power modes.

Fixes: 9cf1efc5ed2d ("soundwire: amd: add pm_prepare callback and pm ops support")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250530054447.1645807-2-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index a12c68b93b1c3..a9a57cb6257cc 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1209,6 +1209,7 @@ static int __maybe_unused amd_suspend(struct device *dev)
 	}
 
 	if (amd_manager->power_mode_mask & AMD_SDW_CLK_STOP_MODE) {
+		cancel_work_sync(&amd_manager->amd_sdw_work);
 		amd_sdw_wake_enable(amd_manager, false);
 		if (amd_manager->acp_rev >= ACP70_PCI_REV_ID) {
 			ret = amd_sdw_host_wake_enable(amd_manager, false);
@@ -1219,6 +1220,7 @@ static int __maybe_unused amd_suspend(struct device *dev)
 		if (ret)
 			return ret;
 	} else if (amd_manager->power_mode_mask & AMD_SDW_POWER_OFF_MODE) {
+		cancel_work_sync(&amd_manager->amd_sdw_work);
 		amd_sdw_wake_enable(amd_manager, false);
 		if (amd_manager->acp_rev >= ACP70_PCI_REV_ID) {
 			ret = amd_sdw_host_wake_enable(amd_manager, false);
-- 
2.39.5



