Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA7D2EAB97;
	Tue, 22 Jul 2025 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193581; cv=none; b=SVT4V+eC1dWIzU6fRNffD9OHXOy8xFZvegaPCeIkNIY2qjQIoI6Ym9nBmSoWg28jTIcvHf4lSgqb+zLxCA8mLCxyw6M8FsbfEmj5SF3e4mExtmlH9+GLpKcmxZC2jHXsVP2CJAIaSrFCZGuy+/1kCkFa00M8lpREDpMSlSiYAqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193581; c=relaxed/simple;
	bh=G/2hk7buAbeG53qZ6IjZuQPH/TstIGkepbgdZ2kaefw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vgip937mh0XC4VGDLV4ahRUzM+oV3OTFSzlrsaIsS/IuVBNBmSuxUgXtTdfV3zP0MYBQ1KD6WvdQDRk4X6yej0oG9KVHhEGTG946C2geqcjvaAsYwSlq1NkSarVyzf2ZIP22Z9pE0fF6Msn27W9kPjZfYYybp/uZ7YXSgZQBz/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjKWV/I+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjKWV/I+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C34C4CEEB;
	Tue, 22 Jul 2025 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193580;
	bh=G/2hk7buAbeG53qZ6IjZuQPH/TstIGkepbgdZ2kaefw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjKWV/I+JVk0nDY7QqRc7evVMOhlsjMPPcvoiF5/MeaF1eJAomTaUUvyt7Fcu5HAO
	 CKFNtCATHzJE1T5Hc7G1rOA2t9u7XaEdY9KZwqt6+gUF8eQfktHQSN1iVM+8ZJBPb0
	 V7LXrtpPqY9Ox5yR8J6BKRCY8jcdShPO/vMsxLzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Gasbarroni <alex.gasbarroni@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 134/187] Bluetooth: hci_sync: fix connectable extended advertising when using static random address
Date: Tue, 22 Jul 2025 15:45:04 +0200
Message-ID: <20250722134350.729062456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Gasbarroni <alex.gasbarroni@gmail.com>

[ Upstream commit d85edab911a4c1fcbe3f08336eff5c7feec567d0 ]

Currently, the connectable flag used by the setup of an extended
advertising instance drives whether we require privacy when trying to pass
a random address to the advertising parameters (Own Address).
If privacy is not required, then it automatically falls back to using the
controller's public address. This can cause problems when using controllers
that do not have a public address set, but instead use a static random
address.

e.g. Assume a BLE controller that does not have a public address set.
The controller upon powering is set with a random static address by default
by the kernel.

	< HCI Command: LE Set Random Address (0x08|0x0005) plen 6
        	Address: E4:AF:26:D8:3E:3A (Static)
	> HCI Event: Command Complete (0x0e) plen 4
	      LE Set Random Address (0x08|0x0005) ncmd 1
	        Status: Success (0x00)

Setting non-connectable extended advertisement parameters in bluetoothctl
mgmt

	add-ext-adv-params -r 0x801 -x 0x802 -P 2M -g 1

correctly sets Own address type as Random

	< HCI Command: LE Set Extended Advertising Parameters (0x08|0x0036)
	plen 25
		...
	    Own address type: Random (0x01)

Setting connectable extended advertisement parameters in bluetoothctl mgmt

	add-ext-adv-params -r 0x801 -x 0x802 -P 2M -g -c 1

mistakenly sets Own address type to Public (which causes to use Public
Address 00:00:00:00:00:00)

	< HCI Command: LE Set Extended Advertising Parameters (0x08|0x0036)
	plen 25
		...
	    Own address type: Public (0x00)

This causes either the controller to emit an Invalid Parameters error or to
mishandle the advertising.

This patch makes sure that we use the already set static random address
when requesting a connectable extended advertising when we don't require
privacy and our public address is not set (00:00:00:00:00:00).

Fixes: 3fe318ee72c5 ("Bluetooth: move hci_get_random_address() to hci_sync")
Signed-off-by: Alessandro Gasbarroni <alex.gasbarroni@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 3ac8d436e3e3a..5b3211e7530a5 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6801,8 +6801,8 @@ int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
 		return 0;
 	}
 
-	/* No privacy so use a public address. */
-	*own_addr_type = ADDR_LE_DEV_PUBLIC;
+	/* No privacy, use the current address */
+	hci_copy_identity_address(hdev, rand_addr, own_addr_type);
 
 	return 0;
 }
-- 
2.39.5



