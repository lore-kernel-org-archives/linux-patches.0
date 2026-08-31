Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADD750AC32;
	Mon, 31 Aug 2026 13:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183757; cv=none; b=mbTbfQidp/QNmfGDBtkU/sgGZXax2Ea1JWG9pvt2EXlY08QyVkS1/KvowtBCQrqObSl5jd0GxvhGdiPzR99rgTRX/4+KRsfcmMsKA7EaWdYiuDypdpXk5gY0ZCozs22J5q7LRhrRnQ7PTxGLjYRPxFPNzPwuemqyBPgKikw+TVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183757; c=relaxed/simple;
	bh=VYiS/9weUNdxvaZHkmZJ+FaKBvkevmfQFpuMo73+ddI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iDahyNuQZC0+eeIb0oSPlZBLzc46qD2fvufQmvnuX4oSojUxRE0hfIaZQDYuls2UFpa7dfveFPr1d/SoDffAknMzjXUS6E/jWULciSh7gH8OT4YCCb9VyahJ2CSIFm5HcW5Myt9a+oZl2BkcLVcI/QFlLXgE/BPb15dWLY3QkCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GejhTPgm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GejhTPgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1F31F00A3F;
	Mon, 31 Aug 2026 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183755;
	bh=eMTcQ78YEYMX9oBfrUPiD4PBlKFL2mfSnRPkNhN8AMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GejhTPgmqnEilJq2L4/CREgqPKq36v1THaZJWDCZxEnLDI0Asl8pwQfp9wFDE+IlH
	 HgwIpBT/2TILHK9KdL9Czii2eRVKSbj57AjM34ktXD4LJEQYs3Oz0tleHWjqfavKq7
	 HjQQRwVfkBoGt79DE+jT4iRNZLniRoObT7eIjPoD1db/6Uci7hF7WT3rbZj1Z6dttF
	 30ZEwmZzIlKTpCGWHWYGYKFjeAkz9o15Rl53jCVMBDXn1fqUjIwEDie+78r/BzYBMW
	 vNwNIikf2/beQPJCJ25YhPj6ktiJnvVzGemrcq8uvOQuz7CJP7BbVtZtT/CYr/fHcR
	 9Kq/xGV/hZ7GA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Corentin Labbe <clabbe@baylibre.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: ralink: RT2X00: init EEPROM properly
Date: Mon, 31 Aug 2026 09:25:12 -0400
Message-ID: <20260831133314.4125787-284-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background `git log -S "PCI_EEPROM_QUIRK_EXTRA_READ_CYCLE"` search
finished, but this shallow 6.18.44 checkout only surfaced merge commits
— not the original introducing change.

From external history, that quirk came in **7738a7a** (`misc: eeprom:
eeprom_93cx6: Add quirk for extra read clock cycle`, Oct 2024). That
lines up with the regression: rt2x00 PCI drivers never zero-initialized
the new `quirks` field, so EEPROM reads could be corrupted and RF
chipset detection could fail.

The backport analysis stands: **YES** for this 6.18.y tree.

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

