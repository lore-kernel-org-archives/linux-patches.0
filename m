Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC033326D73;
	Mon, 18 Aug 2025 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525597; cv=none; b=CN6q89KQmJibtXI8pMkEV+zbIbaNvKgHgqCkDo7mHupA5BlUy0Llr8mEqqLIeE1IdcPR6PJfNv5kmHngIW3g0WtQVGu8xqhuBpscnUxdXIlhiA0w5EXKjQAHk1DP0jcrnjun4cNA+32d3eWPqqKhThVpZMlMnS41zJ325J9rrbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525597; c=relaxed/simple;
	bh=sLSfg0GIePL1Jv6P41vwC7PtmEpMWTF7km2HRWuSjng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQA3HgL3k/Ip0Q6nJncnnuVAUdMW30waCKP7IDbnwaGZxmwCgY9xGmqLpWZ6hxsUnjGqNsPlY/fFFvh1+qAbneXqUEHss7rneNyqm8Yybl88G3XDD9UYoaG6vI4TJzLjQ6Gl1sK91q/+hOpbayEhUM61ymV3W/nkyS+HKxmm1iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=detJ8GU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="detJ8GU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3733C113D0;
	Mon, 18 Aug 2025 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525597;
	bh=sLSfg0GIePL1Jv6P41vwC7PtmEpMWTF7km2HRWuSjng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=detJ8GU6QK6QJMMD7VHXALfjVRsfi4Kd4/ZakQZsTEcndd1uU6tRQgpHEf94a6O2f
	 JlYC7LTkOTg3fM4GAUbSyXc//NF2O8ieaQy2UBaVC5YvjtbWY1GNgruXQsDtRbpq9y
	 4cm074Bom6Cue4Bspi+dOwF0eqvIQAekAMUTImVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 279/570] wifi: mt76: mt7915: mcu: increase eeprom command timeout
Date: Mon, 18 Aug 2025 14:44:26 +0200
Message-ID: <20250818124516.597451296@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Bauer <mail@david-bauer.net>

[ Upstream commit efd31873cdb3e5580fb76eeded6314856f52b06e ]

Increase the timeout for MCU_EXT_CMD_EFUSE_BUFFER_MODE command.

Regular retries upon hardware-recovery have been observed. Increasing
the timeout slightly remedies this problem.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20250402004528.1036715-2-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 4c7f193a1158..c1cfdbc2fe84 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -208,6 +208,9 @@ mt7915_mcu_set_timeout(struct mt76_dev *mdev, int cmd)
 	case MCU_EXT_CMD_BSS_INFO_UPDATE:
 		mdev->mcu.timeout = 2 * HZ;
 		return;
+	case MCU_EXT_CMD_EFUSE_BUFFER_MODE:
+		mdev->mcu.timeout = 10 * HZ;
+		return;
 	default:
 		break;
 	}
-- 
2.39.5



