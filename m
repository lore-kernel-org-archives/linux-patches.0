Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E138183090;
	Sun,  1 Sep 2024 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207714; cv=none; b=niE5iIKGCU7ukk7PsXlU5+hsED7tDX6FG8EcUUtT9NEf3CBXF4nJkPmt4V1puglHwEjiys7OdlXALa0y0skZIFEH4ud/Hhn8o7XewjEtrzbnfdsrAisRZ2udXsYsIj8zS/HCZqCbYbzXePXgV6j8hiqhRCIVaE/HWOOXEXypBQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207714; c=relaxed/simple;
	bh=uCzjZbbqctetRMcepL6W8oC9JX1cyTPl2kvyCAxmdOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMDsaRmrV3MBnosqirnnzXAJ/q/cAhEmxM9nV0nsCbxNmMzIeo4vxfAAHGycnLY9yTKHp/yRpEqY5tEMqfqa+6Vtsc8vKqEydDs17QdByCNzmB2ITa3PTdiwjTii/sfpATT2dNOCZDBvXJbYeMS1WF1lb9KUkPQRTsJRryRhi6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1RlO40G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1RlO40G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3D5C4CEC3;
	Sun,  1 Sep 2024 16:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207714;
	bh=uCzjZbbqctetRMcepL6W8oC9JX1cyTPl2kvyCAxmdOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1RlO40GqTyBxmZ0/a/hETXKRfia2S1MpwEJh4xLpesURUm9wNoyxM5ZSwIyYzTzZ
	 mJSu9gNLV9p/EdY6pK1A/MgAc+TIuPvDn548RUw0xyJx+Nk2J07BonA1aPk1TAm6sY
	 BXbqQGhEtQfW9yRn/PwpXKDpEBWi94JoeJOIvNN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/98] Bluetooth: Make use of __check_timeout on hci_sched_le
Date: Sun,  1 Sep 2024 18:16:24 +0200
Message-ID: <20240901160805.737359832@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 1b1d29e5149990e44634b2e681de71effd463591 ]

This reuse __check_timeout on hci_sched_le following the same logic
used hci_sched_acl.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Stable-dep-of: 932021a11805 ("Bluetooth: hci_core: Fix LE quote calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_core.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 504f6aa4e95db..0221aa5785052 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -4116,15 +4116,10 @@ static void hci_sched_le(struct hci_dev *hdev)
 	if (!hci_conn_num(hdev, LE_LINK))
 		return;
 
-	if (!hci_dev_test_flag(hdev, HCI_UNCONFIGURED)) {
-		/* LE tx timeout must be longer than maximum
-		 * link supervision timeout (40.9 seconds) */
-		if (!hdev->le_cnt && hdev->le_pkts &&
-		    time_after(jiffies, hdev->le_last_tx + HZ * 45))
-			hci_link_tx_to(hdev, LE_LINK);
-	}
-
 	cnt = hdev->le_pkts ? hdev->le_cnt : hdev->acl_cnt;
+
+	__check_timeout(hdev, cnt);
+
 	tmp = cnt;
 	while (cnt && (chan = hci_chan_sent(hdev, LE_LINK, &quote))) {
 		u32 priority = (skb_peek(&chan->data_q))->priority;
-- 
2.43.0



