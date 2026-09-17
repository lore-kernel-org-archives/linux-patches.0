Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5202F4FD28A;
	Thu, 17 Sep 2026 17:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664800; cv=none; b=JT6Sk1C/sNqdmAt5M+Km4ZFgx4eRgNd9gEGydQjtqdxPqPpclb+ZvBsTrKrZGhE2UesIAFv0ha1VvUTO1g/GIYfEjofdf40hRGby9TRhS4rQkgNk9yG0CUOofiB5Jbds52l/ocO5EbYIv0bUsPqUrBQemz3Yqmt8cXb+ydn+/eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664800; c=relaxed/simple;
	bh=O2sewKvxeG83KziNAanIUgNOtjWZLisrZcq1zyI/2Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoKh7/RlfhenyIL6URc9wf2JP+L/H7bCHzLlHL+i6zxmfxEu/Hi9kQDpwzD8M5OwmmrY6Nd4+zKhL74u1aMGVIgRDhStznIFX07j71y10/zWpbElP0DYsooe0H5dBFWk5+dWvfeh9N6CS3bV/ZvLz2/ATB/WfxknYwdwAUxpaKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peCVbI5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peCVbI5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81C61F000FF;
	Thu, 17 Sep 2026 17:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664799;
	bh=/RxpixIj9ag33VYS1OM59nBmgTBejMm+wIpc2limEPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=peCVbI5TFI/NUiqgC4/qfv9f3D9Pg6TaTrUC3DckLmoNLYvjLuzfKx3QGbGx1QPaV
	 fuhqZY670Zkfrb2ZrPhaKADwxL4N7f5rI9midt+8JZE/s4Ax5yl0fEY+cTqGp7lzTD
	 QsTiHBgTF0gRyfYXB/bn44ph5ATt5mIlIjjGNjW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Corentin Labbe <clabbe@baylibre.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0492/1250] wifi: ralink: RT2X00: init EEPROM properly
Date: Thu, 17 Sep 2026 16:04:47 +0100
Message-ID: <20260917151605.300289244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 0a2581cbae9e442835f68d22044157db61cdf54d ]

I have an hostapd setup with a
01:00.0 Network controller: Ralink corp. RT2790 Wireless 802.11n 1T/2R PCIe

The setup work fine on 6.18.26-gentoo
It breaks on 6.18.33-gentoo (and still broken on 6.18.37)

I found an hint in dmesg:
On 6.18.26-gentoo I see:
May 31 15:48:45 trash01 kernel: ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0003 detected
On 6.18.33-gentoo I see:
May 31 15:22:57 trash01 kernel: ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0006 detected

The RF chipset seems badly detected.

The problem was the EEPROM which was badly initialized.
Probably the origin was in some PCI change but unfortunately I couldn't play
to bisect/reboot often the board with this card to do it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260703134932.3786771-1-clabbe@baylibre.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
index 42e21e9f303b2..15073b856adf9 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
@@ -1429,7 +1429,7 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
  */
 static int rt2400pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	u32 reg;
 	u16 word;
 	u8 *mac;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
index 36ddc5a69fa40..3536a0f311171 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
@@ -1555,7 +1555,7 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
  */
 static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	u32 reg;
 	u16 word;
 	u8 *mac;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
index 14c45aba836f2..853fd31d13629 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
@@ -108,7 +108,7 @@ static void rt2800pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
 
 static int rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
 {
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	u32 reg;
 
 	reg = rt2x00mmio_register_read(rt2x00dev, E2PROM_CSR);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
index d1cd5694e3c73..5dca2afb4b96c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
@@ -2298,7 +2298,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
  */
 static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
-	struct eeprom_93cx6 eeprom;
+	struct eeprom_93cx6 eeprom = {};
 	u32 reg;
 	u16 word;
 	u8 *mac;
-- 
2.53.0



