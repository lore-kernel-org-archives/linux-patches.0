Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CD61DE8A0;
	Tue,  8 Oct 2024 13:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393183; cv=none; b=VcTtLhIWNzVLh0D7iMS4s0HO/KV/6CYjQmyiYlcBC8ExLjzMbdv2A2biYe0FhdMvHk1bWoKP2ueSIXvuEnwi4sUGqKfII5JKVZsVraFveDNzsRN1Po8OxTw764Pp1uvERXSfGmVBxtwEJdjk9SEnhGoZoawWLW8xGfFIERy7zMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393183; c=relaxed/simple;
	bh=S9QkYLLq9OrlNWFhEXnLmthxDvhP/5CxAWQzIkCkoxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqKTn6dODhamddjB7PwZe621V9zVU4UxqVEhmo9uKPnO39OOpbhZ1gfxD8uLVDrTXGqvmFQbN6Uq8FS9enhrZmgf5WJEjZ+GESt6mlCF7HQhF8VAZ/HwIbabrdkNkpW3/vawHKS50amu8/0mdDNwUz6eWGiXwG8UGUEuc+R7jLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWDS/S3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWDS/S3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F57C4CECC;
	Tue,  8 Oct 2024 13:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393183;
	bh=S9QkYLLq9OrlNWFhEXnLmthxDvhP/5CxAWQzIkCkoxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWDS/S3hK9iFItuIeRssafEgYA6eHw34EAGPM7WdrNHX42QOfR4FvaYqoerO+QL9V
	 upmlMM8VCJQJyRLeS7q3i015Mbdwzw6Urg/eG6yIBGKtIKTfRCwuwAZu28tyvvPBvx
	 tvMm+/IQgz1zhGtyA9WNDKg7R1v5tz5U/3eI5Y1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hilda Wu <hildawu@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/386] Bluetooth: btrtl: Set msft ext address filter quirk for RTL8852B
Date: Tue,  8 Oct 2024 14:05:22 +0200
Message-ID: <20241008115632.492051227@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 277d039ecbb42..1e7c1f9db9e4b 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -1285,6 +1285,7 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
 			btrealtek_set_flag(hdev, REALTEK_ALT6_CONTINUOUS_TX_CHIP);
 
 		if (btrtl_dev->project_id == CHIP_ID_8852A ||
+		    btrtl_dev->project_id == CHIP_ID_8852B ||
 		    btrtl_dev->project_id == CHIP_ID_8852C)
 			set_bit(HCI_QUIRK_USE_MSFT_EXT_ADDRESS_FILTER, &hdev->quirks);
 
-- 
2.43.0



