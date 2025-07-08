Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A9121773D;
	Tue,  8 Jul 2025 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992686; cv=none; b=G2csP4eaHb/h4dhtXzwPVdCrC3sak6AlNQV6px11s3z4Sv0ZcI5Z3jOTdwHLWZKbh52bRo3dKJ6iEUQugdNwK9KTR9k7QuyttJ+sfKoa95HaQbiDdT3HKNgMJMoGyc1egnTWZzwo/txVZIxagwgtUyqNNXnqvgnAoAgikn4iKdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992686; c=relaxed/simple;
	bh=depyVtMYbvkdeenP13s0d15Vm2BUEsMgz4PG5ZYdtoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qv+21DV30NEmJpcfmLHnKxDhjvNd+cCxbun0BGFwnA0c1GwQqkC6xhtsioGMW2lwCKhVpU2a1KVP3N87etMBC9jY/hcBBiF8MUbUW59FV9iM1OuOFv/MFBvBPAllATyF17LvKDk6KKoWwffi8BctyYsieeldGE3aCwdVevVbuOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRzWX3jx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRzWX3jx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11631C4CEED;
	Tue,  8 Jul 2025 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992686;
	bh=depyVtMYbvkdeenP13s0d15Vm2BUEsMgz4PG5ZYdtoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRzWX3jxDzkr4PkrNLdUMZYPBCo/22FiH7Pg0k2BzGdCliOoBGkCVX/ROde+ZUZWP
	 HlN3/C93Q+qmQ3L4+vpsFB51Dl2jpNaOGMjshIV8v+9AWKVhCBP+cvCJ1TgEpP7G3z
	 /ruFt5A8DKgwNfI0jm9mR5FIzVoBhhFFGfbPZ+Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.li@amlogic.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/232] Bluetooth: Prevent unintended pause by checking if advertising is active
Date: Tue,  8 Jul 2025 18:20:42 +0200
Message-ID: <20250708162242.669897037@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Yang Li <yang.li@amlogic.com>

[ Upstream commit 1f029b4e30a602db33dedee5ac676e9236ad193c ]

When PA Create Sync is enabled, advertising resumes unexpectedly.
Therefore, it's necessary to check whether advertising is currently
active before attempting to pause it.

  < HCI Command: LE Add Device To... (0x08|0x0011) plen 7  #1345 [hci0] 48.306205
  		Address type: Random (0x01)
  		Address: 4F:84:84:5F:88:17 (Resolvable)
  		Identity type: Random (0x01)
  		Identity: FC:5B:8C:F7:5D:FB (Static)
  < HCI Command: LE Set Address Re.. (0x08|0x002d) plen 1  #1347 [hci0] 48.308023
  		Address resolution: Enabled (0x01)
  ...
  < HCI Command: LE Set Extended A.. (0x08|0x0039) plen 6  #1349 [hci0] 48.309650
  		Extended advertising: Enabled (0x01)
  		Number of sets: 1 (0x01)
  		Entry 0
  		Handle: 0x01
  		Duration: 0 ms (0x00)
  		Max ext adv events: 0
  ...
  < HCI Command: LE Periodic Adve.. (0x08|0x0044) plen 14  #1355 [hci0] 48.314575
  		Options: 0x0000
  		Use advertising SID, Advertiser Address Type and address
  		Reporting initially enabled
  		SID: 0x02
  		Adv address type: Random (0x01)
  		Adv address: 4F:84:84:5F:88:17 (Resolvable)
  		Identity type: Random (0x01)
  		Identity: FC:5B:8C:F7:5D:FB (Static)
  		Skip: 0x0000
  		Sync timeout: 20000 msec (0x07d0)
  		Sync CTE type: 0x0000

Fixes: ad383c2c65a5 ("Bluetooth: hci_sync: Enable advertising when LL privacy is enabled")
Signed-off-by: Yang Li <yang.li@amlogic.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 50cc60ac6242e..79d1a6ed08b29 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2531,6 +2531,10 @@ static int hci_pause_advertising_sync(struct hci_dev *hdev)
 	int err;
 	int old_state;
 
+	/* If controller is not advertising we are done. */
+	if (!hci_dev_test_flag(hdev, HCI_LE_ADV))
+		return 0;
+
 	/* If already been paused there is nothing to do. */
 	if (hdev->advertising_paused)
 		return 0;
-- 
2.39.5



