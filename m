Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5001DF24D;
	Tue,  8 Oct 2024 12:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391524; cv=none; b=mmqn0bV6hR16fH6A0NDPgkZb22XGQai+0PeieIzgIdn2fzit4ihBbfG29XgfJ+MM/9e9f18v9YN/gyhFGkukrd49Jah6IfNBZjT6vLljBSoJ9BCqd5Cq6N4X0F0gDE2jxU8zYgjNJxYb1isKxFQCfSgM82KBfJNTH0Jocq+YsyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391524; c=relaxed/simple;
	bh=BjaqsKie4HIbAMG2bV+QWP7Ca7PLfLG2iou0O0jhzFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drOGX33Re80+3y3WYM7pSUN+WAEdrC+hHwOjJc7GtOsdlDR9cgeX6m2XMvA8x1OkirwRtry1Fzw4JgHW/Wz2ApzIro06/xGJyql93snnIhxDeJJf+7AiV9hHyGWuwTgVpN1kRHzhTbkttr6Pm+wG4L9156ht+pkViC6n8meWly4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2YRgK6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2YRgK6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D354C4CECD;
	Tue,  8 Oct 2024 12:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391523;
	bh=BjaqsKie4HIbAMG2bV+QWP7Ca7PLfLG2iou0O0jhzFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2YRgK6BLQvXArcdIXO0d+Pfgs0eXYcZC91UTBkPv5L5OATII8EZCsUPxEagRdwtV
	 N4wGnoADCgQfnjZLZYsLaVjnGup8g6gjgrspnUgYV5rLn9ipRnvhe24qh95rpuBe+f
	 raVHq+YkaR8X/m5OK0f4u42wX8zFaPVvexNJgZFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hilda Wu <hildawu@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 109/558] Bluetooth: btrtl: Set msft ext address filter quirk for RTL8852B
Date: Tue,  8 Oct 2024 14:02:19 +0200
Message-ID: <20241008115706.655849403@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hilda Wu <hildawu@realtek.com>

[ Upstream commit 9a0570948c5def5c59e588dc0e009ed850a1f5a1 ]

For tracking multiple devices concurrently with a condition.
The patch enables the HCI_QUIRK_USE_MSFT_EXT_ADDRESS_FILTER quirk
on RTL8852B controller.

The quirk setting is based on commit 9e14606d8f38 ("Bluetooth: msft:
Extended monitor tracking by address filter")

With this setting, when a pattern monitor detects a device, this
feature issues an address monitor for tracking that device. Let the
original pattern monitor keep monitor new devices.

Signed-off-by: Hilda Wu <hildawu@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index fd7991ea76726..7cce4abc8a023 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1296,6 +1296,7 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
 			btrealtek_set_flag(hdev, REALTEK_ALT6_CONTINUOUS_TX_CHIP);
 
 		if (btrtl_dev->project_id == CHIP_ID_8852A ||
+		    btrtl_dev->project_id == CHIP_ID_8852B ||
 		    btrtl_dev->project_id == CHIP_ID_8852C)
 			set_bit(HCI_QUIRK_USE_MSFT_EXT_ADDRESS_FILTER, &hdev->quirks);
 
-- 
2.43.0



