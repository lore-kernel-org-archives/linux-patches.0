Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629B62E8E0F;
	Tue, 22 Jul 2025 13:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192243; cv=none; b=rCMLjYetvPOrhdM5SsyKjfOFGyPrnQ+YzpKj8dT3Fpm6DLmTrxfXkYv6eT6ZOAo1EBYIHbLi36FDK+niOZbc7VO6vxZjWUHzYeSga573X1bPgkMHkuyKMs7M83xYfIpPeXimfJUu30xHaUEHzYQZRCYD4HG9eoFtNHaTYSSpXEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192243; c=relaxed/simple;
	bh=DhMJpvnVG3tWuAy0S76HFv1032GnYyAd2CIYHwSVTmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9e71UDmzw6nigLbCdTibfEHvKpo56fKgky/injuOFNd8eeFIoOpg7WBscTeBiz8khzi1HJroJ+8k4VQk6vCCOf6S3zsWXqgPNkvexHfo+Pq8Bc9JEd9hhB5PAr8ufkuwuwndS7EtX0RDYCE5sCn59B64W6lgq6DEjxHZfrcHhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhbDSnV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhbDSnV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5F3C4CEEB;
	Tue, 22 Jul 2025 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192243;
	bh=DhMJpvnVG3tWuAy0S76HFv1032GnYyAd2CIYHwSVTmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhbDSnV9SjUGdPViIddM3dfq/VAKIQHE5i/Gsq3SPLulRkT64cb+KfEOoyfFzbm9d
	 Y2FQtmJVvnqFsSZis0FPRrc9Irh9gmFxMED9v3jP1SJ9NWsXxEdWLaitdQnlrYHDUV
	 4zYp6el+7hziW7n+NlIw14FIejzI4HJVsvalMRrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Gasbarroni <alex.gasbarroni@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 53/79] Bluetooth: hci_sync: fix connectable extended advertising when using static random address
Date: Tue, 22 Jul 2025 15:44:49 +0200
Message-ID: <20250722134330.328274464@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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
index 7d22b2b02745a..27d1209da0df9 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -6508,8 +6508,8 @@ int hci_get_random_address(struct hci_dev *hdev, bool require_privacy,
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



