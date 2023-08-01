Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603671FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D13C433C7;
	Tue,  1 Aug 2023 09:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883016;
	bh=EpNFu8Jlt3/GZAud0zqcsX1eGCKySFG8ZTlQ2RO55iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfrwr9MN65/VHkc9oAC60kp8m9mNr914ycJrSCwOd4ecS1tuRQj8BBzeimqviMdJ8
	 eHcATN2Bn/OSCt9zY/jjWNYxfeC8SSsminAyXNNkqwJAgOgJmCrZe1vIRcBgvwo/aU
	 zlBcC8FN+Y5MElebMp0QuIM3S48M7jAZWDm3K4CM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Mikityanskiy <maxtram95@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 084/239] platform/x86: msi-laptop: Fix rfkill out-of-sync on MSI Wind U100
Date: Tue,  1 Aug 2023 11:19:08 +0200
Message-ID: <20230801091928.777855887@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Mikityanskiy <maxtram95@gmail.com>

[ Upstream commit ad084a6d99bc182bf109c190c808e2ea073ec57b ]

Only the HW rfkill state is toggled on laptops with quirks->ec_read_only
(so far only MSI Wind U90/U100). There are, however, a few issues with
the implementation:

1. The initial HW state is always unblocked, regardless of the actual
   state on boot, because msi_init_rfkill only sets the SW state,
   regardless of ec_read_only.

2. The initial SW state corresponds to the actual state on boot, but it
   can't be changed afterwards, because set_device_state returns
   -EOPNOTSUPP. It confuses the userspace, making Wi-Fi and/or Bluetooth
   unusable if it was blocked on boot, and breaking the airplane mode if
   the rfkill was unblocked on boot.

Address the above issues by properly initializing the HW state on
ec_read_only laptops and by allowing the userspace to toggle the SW
state. Don't set the SW state ourselves and let the userspace fully
control it. Toggling the SW state is a no-op, however, it allows the
userspace to properly toggle the airplane mode. The actual SW radio
disablement is handled by the corresponding rtl818x_pci and btusb
drivers that have their own rfkills.

Tested on MSI Wind U100 Plus, BIOS ver 1.0G, EC ver 130.

Fixes: 0816392b97d4 ("msi-laptop: merge quirk tables to one")
Fixes: 0de6575ad0a8 ("msi-laptop: Add MSI Wind U90/U100 support")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Link: https://lore.kernel.org/r/20230721145423.161057-1-maxtram95@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-laptop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index 6b18ec543ac3a..f4c6c36e05a52 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -208,7 +208,7 @@ static ssize_t set_device_state(const char *buf, size_t count, u8 mask)
 		return -EINVAL;
 
 	if (quirks->ec_read_only)
-		return -EOPNOTSUPP;
+		return 0;
 
 	/* read current device state */
 	result = ec_read(MSI_STANDARD_EC_COMMAND_ADDRESS, &rdata);
@@ -838,15 +838,15 @@ static bool msi_laptop_i8042_filter(unsigned char data, unsigned char str,
 static void msi_init_rfkill(struct work_struct *ignored)
 {
 	if (rfk_wlan) {
-		rfkill_set_sw_state(rfk_wlan, !wlan_s);
+		msi_rfkill_set_state(rfk_wlan, !wlan_s);
 		rfkill_wlan_set(NULL, !wlan_s);
 	}
 	if (rfk_bluetooth) {
-		rfkill_set_sw_state(rfk_bluetooth, !bluetooth_s);
+		msi_rfkill_set_state(rfk_bluetooth, !bluetooth_s);
 		rfkill_bluetooth_set(NULL, !bluetooth_s);
 	}
 	if (rfk_threeg) {
-		rfkill_set_sw_state(rfk_threeg, !threeg_s);
+		msi_rfkill_set_state(rfk_threeg, !threeg_s);
 		rfkill_threeg_set(NULL, !threeg_s);
 	}
 }
-- 
2.39.2



