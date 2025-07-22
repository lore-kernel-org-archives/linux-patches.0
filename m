Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220B81A2C25;
	Tue, 22 Jul 2025 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192973; cv=none; b=eTNmZo68hNPXmE3ZiX1ERKROnJ/rmE2dnXRyGwmECVfxXdpHwb7DhfIvW2q/Q8ZKLTxoEJGt7dYUI6J6OStWuoc7vTjJCvBAGLbuR2nd23JzOo8Mlxs7kdsEVh0fUPW2QTvATUhYx6qLYCHTVwV/H6gLCzUCX85X14pD/e91a8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192973; c=relaxed/simple;
	bh=W7rk+gUIjxwK6z0G+yzYxGoUVuqSH1futDcfRQIta+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMVSSJ2luyRa4Of/phalUFsC1npXrbt9TDWfGW99E86LGqOuowTND1PH3T5L6wDVOSM6j2lF8MJ8SqXkD3n9t7JxOI+RLIM5SM1cIL8szgTfJa87mhlMGg1HgYtFfv9k+heNPBqFEWBaJPDqaR27jng9rdJae+CIAQu+JDQGMNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlFBw3oB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlFBw3oB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83105C4CEEB;
	Tue, 22 Jul 2025 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192973;
	bh=W7rk+gUIjxwK6z0G+yzYxGoUVuqSH1futDcfRQIta+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlFBw3oB+BT3TevhhoONImG419+X+du9H18pulBB9fcjRUBaLItpawSBDIkVRyCXs
	 hBuOCc7yGu2uKmL5pK2qxNFwCOup///Q9lbTL0C7BFgJkAr2zAYXUwOK4ZPnPqCkm8
	 WC3Wi49cDy/HDeMWgTJ8euu364i2x2NyWe/XIK4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Gasbarroni <alex.gasbarroni@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 114/158] Bluetooth: hci_sync: fix connectable extended advertising when using static random address
Date: Tue, 22 Jul 2025 15:44:58 +0200
Message-ID: <20250722134345.005435839@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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
index bc01135e43f3e..bbd809414b2f2 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6789,8 +6789,8 @@ int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
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



