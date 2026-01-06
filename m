Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6729E3491F5;
	Tue,  6 Jan 2026 17:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719897; cv=none; b=Ynr1iVi6wk2OLXCAd6RkgHJM3gQZpBWJke0NWa5zQpHM1pfTRBIs6svB5PQDymlARHWFxehZHReZpXOEG9o5sCm8gxrE4rC4O/hAzy1kvNA76mWk0F6Y9zcdM2Z1jwQPM4f0DnMnfrg5BUYoPGZwYswZmW+FgAEOqlejhuo2n0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719897; c=relaxed/simple;
	bh=Z/l/CVk3mglW/kuSdO5S2izJxApvLzKxlbL1tJiKDkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMhPv5A17P/Qqcrm2jubYf+IDqmyPUnw5eMaRUlJTfuqHjHzASIKx8qatzYOc1fnYv1BZ7tPRH5O1aYufdyJT2Q/1xJPOkc1Ok9p5HKWyv0K2nIMDtwCouXxwDf+CxFWotJUfqs4vJ9t22mrIT1JZGHhsT7sXkv03AXXea3IH/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJ/37OsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJ/37OsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57A3C116C6;
	Tue,  6 Jan 2026 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719897;
	bh=Z/l/CVk3mglW/kuSdO5S2izJxApvLzKxlbL1tJiKDkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJ/37OsPwI5F008DRj4PcblqiTO6ICt3NTtyFCt0wkqZ2Ra9lReisx3WW3Q5yNRgi
	 X8tR0lecGlkQ6utPnbAI5uIbVAergkcXimxscKewUR8PDYf77MHZehIYudqptbRETb
	 hM+KdjrK7HHpzV9fXzF3s+OYcZHEY57umhihd/pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	druth@chromium.org,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/567] wifi: mt76: mt792x: fix wifi init fail by setting MCU_RUNNING after CLC load
Date: Tue,  6 Jan 2026 17:56:53 +0100
Message-ID: <20260106170452.493302835@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 02c1de8620a7f..8d3f3c8b1a889 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -637,10 +637,10 @@ int mt7921_run_firmware(struct mt792x_dev *dev)
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
index e42b4f0abbe7a..c42b3b376f77e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -958,10 +958,10 @@ int mt7925_run_firmware(struct mt792x_dev *dev)
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



