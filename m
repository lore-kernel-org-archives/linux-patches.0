Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9442C8F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E8BC433C7;
	Sun, 16 Jul 2023 20:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539055;
	bh=qqEW4Ie0rogmYXJ3S37u/qRsLYimIeT20YAJR/6ieaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXe6F7ZzMgHdqh043obIMOZl19stIDCuWCsr+opzrh2W+SMfwhTFYX2GfH2G5WDHh
	 iXnfcIHcbLPwpenfBHjR9fjFte1rJq7MKURXCy3EHyoVCxrqgirB9gRFgoassU0RLN
	 AOtqwGqgmrwtnAukgHwpijyXdJzB6fkYZr7med5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 672/800] Bluetooth: fix invalid-bdaddr quirk for non-persistent setup
Date: Sun, 16 Jul 2023 21:48:45 +0200
Message-ID: <20230716195004.732733197@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 0cb7365850bacb8c2a9975cae672d65714d8daa1 ]

Devices that lack persistent storage for the device address can indicate
this by setting the HCI_QUIRK_INVALID_BDADDR which causes the controller
to be marked as unconfigured until user space has set a valid address.

Once configured, the device address must be set on every setup for
controllers with HCI_QUIRK_NON_PERSISTENT_SETUP to avoid marking the
controller as unconfigured and requiring the address to be set again.

Fixes: 740011cfe948 ("Bluetooth: Add new quirk for non-persistent setup settings")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 804cde43b4e02..b5b1b610df335 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -4626,23 +4626,17 @@ static int hci_dev_setup_sync(struct hci_dev *hdev)
 	invalid_bdaddr = test_bit(HCI_QUIRK_INVALID_BDADDR, &hdev->quirks);
 
 	if (!ret) {
-		if (test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks)) {
-			if (!bacmp(&hdev->public_addr, BDADDR_ANY))
-				hci_dev_get_bd_addr_from_property(hdev);
-
-			if (bacmp(&hdev->public_addr, BDADDR_ANY) &&
-			    hdev->set_bdaddr) {
-				ret = hdev->set_bdaddr(hdev,
-						       &hdev->public_addr);
-
-				/* If setting of the BD_ADDR from the device
-				 * property succeeds, then treat the address
-				 * as valid even if the invalid BD_ADDR
-				 * quirk indicates otherwise.
-				 */
-				if (!ret)
-					invalid_bdaddr = false;
-			}
+		if (test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks) &&
+		    !bacmp(&hdev->public_addr, BDADDR_ANY))
+			hci_dev_get_bd_addr_from_property(hdev);
+
+		if ((invalid_bdaddr ||
+		     test_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks)) &&
+		    bacmp(&hdev->public_addr, BDADDR_ANY) &&
+		    hdev->set_bdaddr) {
+			ret = hdev->set_bdaddr(hdev, &hdev->public_addr);
+			if (!ret)
+				invalid_bdaddr = false;
 		}
 	}
 
-- 
2.39.2



