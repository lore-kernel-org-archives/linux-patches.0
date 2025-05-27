Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D9927D776;
	Tue, 27 May 2025 17:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366701; cv=none; b=ljl3BiUkiLNUuxgWZZCavxcV1AmzNMnhVX2s77B/IH3TMPyKN82uL6tU87tq/fphYuEy4oNzsFOKZU4hKYodw44QUUviY3QeDegtxXk11U7S84rv/uQp/gM8uv36lm1m25wl9Ykp4SpP+t6eY2TAhgmW6FLFIT8JYfC19YZSLKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366701; c=relaxed/simple;
	bh=WmaDJUpP37iFdU/g5c7wrs8u8kXHt9akwwsTX5lOPHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVBF3Y8ldIQdRs5z/TcwdomqTc7gVu9pHV+pqzlr37MjLV1zkWQcIi3fAQtMxJ7vdKcV2cJ3sS1xClkIPUNN9sIJqpqYWVwOVfel3NMf7oyTZSPrgMj0a8C0Qqd/vfCTDautO/52RGPAT9C8ihDtmdk6VIkKnpWX48N0oWxxjSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZ5FqHmn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZ5FqHmn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A5CC4CEE9;
	Tue, 27 May 2025 17:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366701;
	bh=WmaDJUpP37iFdU/g5c7wrs8u8kXHt9akwwsTX5lOPHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZ5FqHmnJHQ5LufnaZ6kG0qjQ6eZU8dzPljg7HZexbqrHT64ZyfxZ0M+1yphuGrfz
	 gEuuK5uMWTrlEFEnYGc7rXkddaLGlKEsg7NrUShK6zJ2GqwA1rF5GHN69qnG38li7W
	 8K2ogVnScKqPV5kIR6GKqmHIXxDuGqr8ZUXx8y5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 123/783] wifi: mt76: mt7925: fix fails to enter low power mode in suspend state
Date: Tue, 27 May 2025 18:18:40 +0200
Message-ID: <20250527162518.155649812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Zhou <quan.zhou@mediatek.com>

[ Upstream commit 2d5630b0c9466ac6549495828aa7dce7424a272a ]

The mt7925 sometimes fails to enter low power mode during suspend.
This is caused by the chip firmware sending an additional ACK event
to the host after processing the suspend command. Due to timing issues,
this event may not reach the host, causing the chip to get stuck.
To resolve this, the ACK flag in the suspend command is removed,
as it is not needed in the MT7925 architecture. This prevents the
firmware from sending the additional ACK event, ensuring the device
can reliably enter low power mode during suspend.

Signed-off-by: Quan Zhou <quan.zhou@mediatek.com>
Link: https://patch.msgid.link/d056938144a3a0336c3a4e3cec6f271899f32bf7.1736775666.git.quan.zhou@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 87b3a88038e3c..59fa812b30d35 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3294,6 +3294,9 @@ int mt7925_mcu_fill_message(struct mt76_dev *mdev, struct sk_buff *skb,
 		else
 			uni_txd->option = MCU_CMD_UNI_EXT_ACK;
 
+		if (cmd == MCU_UNI_CMD(HIF_CTRL))
+			uni_txd->option &= ~MCU_CMD_ACK;
+
 		goto exit;
 	}
 
-- 
2.39.5



