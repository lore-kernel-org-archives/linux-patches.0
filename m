Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF2DA32;
	Tue, 22 Jul 2025 13:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192417; cv=none; b=azJ9kLUkP8GCmxqudMrn7YyfmTKw6KZx8h23+FuDrnUuda9FTY7pnkgbtIgejEJOHfJDUU20ZI88qoOWQYIcFdVoC5zV05Uf2rAahivuyH93101qc+8bYCKE3Cmm45BXw1n9TxLxKMCADuJrQQMgxyIkEK0QumZv+BoBRR/wIxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192417; c=relaxed/simple;
	bh=ZCGPc4TjXOJmlK6YHn6Y9kBCVYlyV93b8V+eaQmfclc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qL0pS0Am+bhlumRGIuQBIDYnGJnWpAP89l5+sIIy91sqBNnjvSpZNpdoXLvW8hXfMH0/Hic+uVPfOkrFb2iegjTKoPFQeTDcb5uOh3GC0zk8sSAH4ezfpWnRpv1aQ/4nS5uVJmGCO83T3lDeVoD2oxxtiWMwLmB5OCRAtrORWA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGlhyu2p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGlhyu2p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008E3C4CEEB;
	Tue, 22 Jul 2025 13:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192417;
	bh=ZCGPc4TjXOJmlK6YHn6Y9kBCVYlyV93b8V+eaQmfclc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NGlhyu2pjZMX7wq1gf1qWgaYPRn8NgGSnf+QygkkY1BPrG/6pafJvsRG+H7lp1iKJ
	 mUhzxBS8fI/tFlwssqQi5M7I9PirPJoPF668dQ+syhgxd+XOuanf/RIL7VKb3rSsAy
	 gm+QUjSPTbARZjVtxqeRZ4jRlzFk0eUULXGY7p70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/111] soundwire: amd: fix for handling slave alerts after link is down
Date: Tue, 22 Jul 2025 15:44:34 +0200
Message-ID: <20250722134335.588948951@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 31b203ebbae0c..ce1c8e1372eed 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1135,9 +1135,11 @@ static int __maybe_unused amd_suspend(struct device *dev)
 	}
 
 	if (amd_manager->power_mode_mask & AMD_SDW_CLK_STOP_MODE) {
+		cancel_work_sync(&amd_manager->amd_sdw_work);
 		amd_sdw_wake_enable(amd_manager, false);
 		return amd_sdw_clock_stop(amd_manager);
 	} else if (amd_manager->power_mode_mask & AMD_SDW_POWER_OFF_MODE) {
+		cancel_work_sync(&amd_manager->amd_sdw_work);
 		amd_sdw_wake_enable(amd_manager, false);
 		/*
 		 * As per hardware programming sequence on AMD platforms,
-- 
2.39.5



