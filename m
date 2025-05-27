Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5134427FD61;
	Tue, 27 May 2025 16:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364601; cv=none; b=LqobUDC7uJ5e0q0URoQW3cSvfIRdLQhWrw3N99tbn1hvJGY2rpQ/BDgrYGc7qrwc3aq23x6ODjcTt7msT1J/WBSha7T1fdJSl2vDmLES0RAxD1KR6nHCqYoVqB+vWaLAezUZ6+n0KXo+IIQd4H6pwPO8e09qf1hNqBY5SL0E5g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364601; c=relaxed/simple;
	bh=eFA+52L/vzNKsLosllhZKcCOfubx7m61c8WC9p0n7G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmPpEPZLqIlS5Pw72oBlf2Ycg2mdNjAm24SIaSz52jtD0w0job8qCx8VHI+uhMKudJ5DAJhvYAWlrhlL9IS2dcwivhegZuycTRZCWBq/Yu4N7DdqYZOzYC4Gbt9XzOG0xyKEb28AhqE4QNBMEiQddPYbc4UAfaBcX/3k6edxEvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2nb4ImX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2nb4ImX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559BDC4CEE9;
	Tue, 27 May 2025 16:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364598;
	bh=eFA+52L/vzNKsLosllhZKcCOfubx7m61c8WC9p0n7G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2nb4ImXNO58b2tsHTzXaVnW27t25vqhuJCqXVkpA0WYHRHvc5MKcEvvxp9z8PHls
	 D28i7tCBJyjHZAPXfIf15IYE8Qr7Eo5S4hHBvqAqPVjYQpyTqNSW3rGE6ToLRXD87x
	 M+TX/Gq8PtNDpPqjqoXV42P9Q4QGsevbG/JZcajo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <quan.zhou@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/626] wifi: mt76: mt7925: fix fails to enter low power mode in suspend state
Date: Tue, 27 May 2025 18:19:59 +0200
Message-ID: <20250527162449.350348931@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5b14bf434df36..2396e1795fe17 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3287,6 +3287,9 @@ int mt7925_mcu_fill_message(struct mt76_dev *mdev, struct sk_buff *skb,
 		else
 			uni_txd->option = MCU_CMD_UNI_EXT_ACK;
 
+		if (cmd == MCU_UNI_CMD(HIF_CTRL))
+			uni_txd->option &= ~MCU_CMD_ACK;
+
 		goto exit;
 	}
 
-- 
2.39.5



