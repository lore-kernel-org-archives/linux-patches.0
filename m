Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E414F32C929;
	Mon, 29 Dec 2025 16:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024937; cv=none; b=jcnX8yvW1C/ddonQL688CGz1ygCkf7LUZoiMpXcfW4tihWM9yC5yWWqDj1ePGrl7H57hKddtiqlmewJor4Y86aknxHaZ/ROdTlQ7b7x8+2m2E3F5ZCUpwePIT1KwcFK6B84JQ9ATKgccnAcf7h3oLWQRxSmm7ka1NmIbYciy+BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024937; c=relaxed/simple;
	bh=K9712T3Opmj9IvSENfSiP9as/mpODSPdqW4+zS/r1rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJ2LihBmfLnZ5IryoaYX/xOAgNJIWCcCVoMQseFWRHOfIZQhjpvqtFCBxoSU4oemssEtATgqyGXIgZIlnuWKDABa1ueMJ8gNHegIdIYz5ahsuUNDNZ0PnrYzx7nFSs4Pm8XxuBR3Ce4qHhYD0tWL6FTwHd22HP6C61/NDUU36TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bclRO69F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bclRO69F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F50CC116C6;
	Mon, 29 Dec 2025 16:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024936;
	bh=K9712T3Opmj9IvSENfSiP9as/mpODSPdqW4+zS/r1rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bclRO69FrMJdPA9yf4zQ2pNL4GC82P6uXgb4ZbndhZjeoxjdq4eNRJJmcEFgU7FYI
	 vQSmd9dPs8AbQ/T2wYc1AouJeVkHbtcv76nCctx4Yycp+CVCXLle0B3cEjfWM20dor
	 8KPzzT7j2feJrpvr6SWoyxuW6c7LBj6QPs9OCTSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	druth@chromium.org,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/430] wifi: mt76: mt792x: fix wifi init fail by setting MCU_RUNNING after CLC load
Date: Mon, 29 Dec 2025 17:07:19 +0100
Message-ID: <20251229160725.732320072@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit 066f417be5fd8c7fe581c5550206364735dad7a3 ]

Set the MT76_STATE_MCU_RUNNING bit only after mt7921_load_clc()
has successfully completed. Previously, the MCU_RUNNING state
was set before loading CLC, which could cause conflict between
chip mcu_init retry and mac_reset flow, result in chip init fail
and chip abnormal status. By moving the state set after CLC load,
firmware initialization becomes robust and resolves init fail issue.

Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Reviewed-by: druth@chromium.org
Link: https://patch.msgid.link/19ec8e4465142e774f17801025accd0ae2214092.1763465933.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 86bd33b916a9d..edc1df3c071e5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -646,10 +646,10 @@ int mt7921_run_firmware(struct mt792x_dev *dev)
 	if (err)
 		return err;
 
-	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
 	err = mt7921_load_clc(dev, mt792x_ram_name(dev));
 	if (err)
 		return err;
+	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
 
 	return mt7921_mcu_fw_log_2_host(dev, 1);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 8eda407e4135e..c12b71b71cfc7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1003,10 +1003,10 @@ int mt7925_run_firmware(struct mt792x_dev *dev)
 	if (err)
 		return err;
 
-	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
 	err = mt7925_load_clc(dev, mt792x_ram_name(dev));
 	if (err)
 		return err;
+	set_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
 
 	return mt7925_mcu_fw_log_2_host(dev, 1);
 }
-- 
2.51.0



