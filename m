Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BAE248BA6;
	Wed, 15 Jan 2025 10:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937724; cv=none; b=N++V3RhD1F6meohVeN10QkHZ3w+ivAtOADC+KOO4ntrdozF5wY1mbn5rkKc0N2Ncvo4qUotT0O/wANF9PXWaI02vkGlaFcRYE4dLzLV2AA39MzCgX+yLX+tvbfWmwain4zMMD5m/XjA3cOuLrBhXlL4eqhJjg/tsCNhIqUhYsmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937724; c=relaxed/simple;
	bh=ZkpkJrCaCPczV6Ur+TgaKPN3ouPQHIfKDUcI0L1zGjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHC/dgockzKlgw3xWcHM1CozoMAO5Ser+naDqtM4UNkM2ApS+kzqwuzv0RoGzEdcr6ci2kdjvhRBUmzxhT5ybpe7TfkjvA/rIvBT4RcFTLL4uYRvdrfTagkBONXPvEqz4+kJyXI0qSoAi92Nv6E1O61ZGyt9RKhIETeMdJKOFU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Oqrks39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Oqrks39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6F0C4CEE2;
	Wed, 15 Jan 2025 10:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937723;
	bh=ZkpkJrCaCPczV6Ur+TgaKPN3ouPQHIfKDUcI0L1zGjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Oqrks39FPpOjQ5dDwRls1EQXUtShJYNr4l0S+q01gQNaF1BdAYY5AoA/KD/Kzm+x
	 2Blmj+t2CHHad7j5s2w9TSqmO/TEht+0qLtTQX5S4x831NxWxvzx0PebATZ59nhwYX
	 o06HhfSC9Cau11KnkyQpO1/3bFzpnJOzxs7PVRiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/92] Bluetooth: hci_sync: Fix not setting Random Address when required
Date: Wed, 15 Jan 2025 11:36:40 +0100
Message-ID: <20250115103548.420275810@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c2994b008492db033d40bd767be1620229a3035e ]

This fixes errors such as the following when Own address type is set to
Random Address but it has not been programmed yet due to either be
advertising or connecting:

< HCI Command: LE Set Exte.. (0x08|0x0041) plen 13
        Own address type: Random (0x03)
        Filter policy: Ignore not in accept list (0x01)
        PHYs: 0x05
        Entry 0: LE 1M
          Type: Passive (0x00)
          Interval: 60.000 msec (0x0060)
          Window: 30.000 msec (0x0030)
        Entry 1: LE Coded
          Type: Passive (0x00)
          Interval: 180.000 msec (0x0120)
          Window: 90.000 msec (0x0090)
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Extended Scan Parameters (0x08|0x0041) ncmd 1
        Status: Success (0x00)
< HCI Command: LE Set Exten.. (0x08|0x0042) plen 6
        Extended scan: Enabled (0x01)
        Filter duplicates: Enabled (0x01)
        Duration: 0 msec (0x0000)
        Period: 0.00 sec (0x0000)
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Extended Scan Enable (0x08|0x0042) ncmd 1
        Status: Invalid HCI Command Parameters (0x12)

Fixes: c45074d68a9b ("Bluetooth: Fix not generating RPA when required")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index b7a7b2afaa04..c6108e68f5a9 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1006,9 +1006,9 @@ static bool adv_use_rpa(struct hci_dev *hdev, uint32_t flags)
 
 static int hci_set_random_addr_sync(struct hci_dev *hdev, bdaddr_t *rpa)
 {
-	/* If we're advertising or initiating an LE connection we can't
-	 * go ahead and change the random address at this time. This is
-	 * because the eventual initiator address used for the
+	/* If a random_addr has been set we're advertising or initiating an LE
+	 * connection we can't go ahead and change the random address at this
+	 * time. This is because the eventual initiator address used for the
 	 * subsequently created connection will be undefined (some
 	 * controllers use the new address and others the one we had
 	 * when the operation started).
@@ -1016,8 +1016,9 @@ static int hci_set_random_addr_sync(struct hci_dev *hdev, bdaddr_t *rpa)
 	 * In this kind of scenario skip the update and let the random
 	 * address be updated at the next cycle.
 	 */
-	if (hci_dev_test_flag(hdev, HCI_LE_ADV) ||
-	    hci_lookup_le_connect(hdev)) {
+	if (bacmp(&hdev->random_addr, BDADDR_ANY) &&
+	    (hci_dev_test_flag(hdev, HCI_LE_ADV) ||
+	    hci_lookup_le_connect(hdev))) {
 		bt_dev_dbg(hdev, "Deferring random address update");
 		hci_dev_set_flag(hdev, HCI_RPA_EXPIRED);
 		return 0;
-- 
2.39.5



