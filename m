Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DBF39A113;
	Tue, 16 Dec 2025 12:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888381; cv=none; b=IhDo3p7ZfEYB8PHi4A0E0UwFCIXJj6dELzpXrDeOK7CkjYMacGSJ5zy6JBi5rEkaApkahp/7R4+j14utD0Abu86mY63yBn20jhacf5QatXcE3LodTo5c2erGVG+p3+R+plVI1pesUds2YfitZ3n+g9KvN07ciVtLsN/N6EWgGKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888381; c=relaxed/simple;
	bh=q3i3N2+qfk+5e5X4B+9zZ06UlF0Kx/0efDA8xl4VHJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djBHoZp1LY03cKDBbTI0b4cVW6aP5fs7wzEr5uikLPdrgfol5MqwKcKCgbYiD3MkwQ0lfhozYyyUfPi/XNktcF/h/eVw+IYXwdTOa+CWVZTcQF1I8lSxRBmg3hZDEdOtf+bn0W2L49EJCInG/KUmsZrx7DYiKCbGO23i9T/DcJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rw1q1Tzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rw1q1Tzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B819BC4CEF1;
	Tue, 16 Dec 2025 12:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888381;
	bh=q3i3N2+qfk+5e5X4B+9zZ06UlF0Kx/0efDA8xl4VHJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rw1q1TzcxtaSqJFA0hAHnOAtdHwlGovJRFvewUg8+mZHFmZEO9AAlxceBD4Y0RgR9
	 S21pV4UVuZm7SqWGXzYYDXlg7k6HF/FxV2juOvtogzFDalT3yFT08LIs0hvemnG2xF
	 aue+22s4gi5JMjoGYHR++GJWMxUSJorvk+y/TMM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 517/614] net: dsa: b53: add support for bcm63xx ARL entry format
Date: Tue, 16 Dec 2025 12:14:44 +0100
Message-ID: <20251216111420.100207133@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 2b3013ac03028a2364d8779719bb6bfbc0212435 ]

The ARL registers of BCM63XX embedded switches are somewhat unique. The
normal ARL table access registers have the same format as BCM5389, but
the ARL search registers differ:

* SRCH_CTL is at the same offset of BCM5389, but 16 bits wide. It does
  not have more fields, just needs to be accessed by a 16 bit read.
* SRCH_RSLT_MACVID and SRCH_RSLT are aligned to 32 bit, and have shifted
  offsets.
* SRCH_RSLT has a different format than the normal ARL data entry
  register.
* There is only one set of ENTRY_N registers, implying a 1 bin layout.

So add appropriate ops for bcm63xx and let it use it.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251107080749.26936-9-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 3b08863469aa ("net: dsa: b53: fix BCM5325/65 ARL entry multicast port masks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 44 +++++++++++++++++++++++++++-----
 drivers/net/dsa/b53/b53_priv.h   | 15 +++++++++++
 drivers/net/dsa/b53/b53_regs.h   |  9 +++++++
 3 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 68e9162087ab4..db1ed8c9c536e 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2042,12 +2042,20 @@ static void b53_read_arl_srch_ctl(struct b53_device *dev, u8 *val)
 
 	if (is5325(dev) || is5365(dev))
 		offset = B53_ARL_SRCH_CTL_25;
-	else if (dev->chip_id == BCM5389_DEVICE_ID || is5397_98(dev))
+	else if (dev->chip_id == BCM5389_DEVICE_ID || is5397_98(dev) ||
+		 is63xx(dev))
 		offset = B53_ARL_SRCH_CTL_89;
 	else
 		offset = B53_ARL_SRCH_CTL;
 
-	b53_read8(dev, B53_ARLIO_PAGE, offset, val);
+	if (is63xx(dev)) {
+		u16 val16;
+
+		b53_read16(dev, B53_ARLIO_PAGE, offset, &val16);
+		*val = val16 & 0xff;
+	} else {
+		b53_read8(dev, B53_ARLIO_PAGE, offset, val);
+	}
 }
 
 static void b53_write_arl_srch_ctl(struct b53_device *dev, u8 val)
@@ -2056,12 +2064,16 @@ static void b53_write_arl_srch_ctl(struct b53_device *dev, u8 val)
 
 	if (is5325(dev) || is5365(dev))
 		offset = B53_ARL_SRCH_CTL_25;
-	else if (dev->chip_id == BCM5389_DEVICE_ID || is5397_98(dev))
+	else if (dev->chip_id == BCM5389_DEVICE_ID || is5397_98(dev) ||
+		 is63xx(dev))
 		offset = B53_ARL_SRCH_CTL_89;
 	else
 		offset = B53_ARL_SRCH_CTL;
 
-	b53_write8(dev, B53_ARLIO_PAGE, offset, val);
+	if (is63xx(dev))
+		b53_write16(dev, B53_ARLIO_PAGE, offset, val);
+	else
+		b53_write8(dev, B53_ARLIO_PAGE, offset, val);
 }
 
 static int b53_arl_search_wait(struct b53_device *dev)
@@ -2105,6 +2117,18 @@ static void b53_arl_search_read_89(struct b53_device *dev, u8 idx,
 	b53_arl_to_entry_89(ent, mac_vid, fwd_entry);
 }
 
+static void b53_arl_search_read_63xx(struct b53_device *dev, u8 idx,
+				     struct b53_arl_entry *ent)
+{
+	u16 fwd_entry;
+	u64 mac_vid;
+
+	b53_read64(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSLT_MACVID_63XX,
+		   &mac_vid);
+	b53_read16(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSLT_63XX, &fwd_entry);
+	b53_arl_search_to_entry_63xx(ent, mac_vid, fwd_entry);
+}
+
 static void b53_arl_search_read_95(struct b53_device *dev, u8 idx,
 				   struct b53_arl_entry *ent)
 {
@@ -2695,6 +2719,12 @@ static const struct b53_arl_ops b53_arl_ops_89 = {
 	.arl_search_read = b53_arl_search_read_89,
 };
 
+static const struct b53_arl_ops b53_arl_ops_63xx = {
+	.arl_read_entry = b53_arl_read_entry_89,
+	.arl_write_entry = b53_arl_write_entry_89,
+	.arl_search_read = b53_arl_search_read_63xx,
+};
+
 static const struct b53_arl_ops b53_arl_ops_95 = {
 	.arl_read_entry = b53_arl_read_entry_95,
 	.arl_write_entry = b53_arl_write_entry_95,
@@ -2864,14 +2894,14 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.dev_name = "BCM63xx",
 		.vlans = 4096,
 		.enabled_ports = 0, /* pdata must provide them */
-		.arl_bins = 4,
-		.arl_buckets = 1024,
+		.arl_bins = 1,
+		.arl_buckets = 4096,
 		.imp_port = 8,
 		.vta_regs = B53_VTA_REGS_63XX,
 		.duplex_reg = B53_DUPLEX_STAT_63XX,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK_63XX,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE_63XX,
-		.arl_ops = &b53_arl_ops_95,
+		.arl_ops = &b53_arl_ops_63xx,
 	},
 	{
 		.chip_id = BCM53010_DEVICE_ID,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 80e7dd6169b47..ae2c615c088ed 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -414,6 +414,21 @@ static inline void b53_arl_from_entry_89(u64 *mac_vid, u32 *fwd_entry,
 		*fwd_entry |= ARLTBL_AGE_89;
 }
 
+static inline void b53_arl_search_to_entry_63xx(struct b53_arl_entry *ent,
+						u64 mac_vid, u16 fwd_entry)
+{
+	memset(ent, 0, sizeof(*ent));
+	u64_to_ether_addr(mac_vid, ent->mac);
+	ent->vid = mac_vid >> ARLTBL_VID_S;
+
+	ent->port = fwd_entry & ARL_SRST_PORT_ID_MASK_63XX;
+	ent->port >>= 1;
+
+	ent->is_age = !!(fwd_entry & ARL_SRST_AGE_63XX);
+	ent->is_static = !!(fwd_entry & ARL_SRST_STATIC_63XX);
+	ent->is_valid = 1;
+}
+
 static inline void b53_arl_read_entry(struct b53_device *dev,
 				      struct b53_arl_entry *ent, u8 idx)
 {
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index f2a3696d122fa..fcedd5fb00337 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -364,11 +364,13 @@
 #define B53_ARL_SRCH_ADDR_25		0x22
 #define B53_ARL_SRCH_ADDR_65		0x24
 #define B53_ARL_SRCH_ADDR_89		0x31
+#define B53_ARL_SRCH_ADDR_63XX		0x32
 #define  ARL_ADDR_MASK			GENMASK(14, 0)
 
 /* ARL Search MAC/VID Result (64 bit) */
 #define B53_ARL_SRCH_RSTL_0_MACVID	0x60
 #define B53_ARL_SRCH_RSLT_MACVID_89	0x33
+#define B53_ARL_SRCH_RSLT_MACVID_63XX	0x34
 
 /* Single register search result on 5325/5365 */
 #define B53_ARL_SRCH_RSTL_0_MACVID_25	0x24
@@ -382,6 +384,13 @@
 #define B53_ARL_SRCH_RSTL_MACVID(x)	(B53_ARL_SRCH_RSTL_0_MACVID + ((x) * 0x10))
 #define B53_ARL_SRCH_RSTL(x)		(B53_ARL_SRCH_RSTL_0 + ((x) * 0x10))
 
+/* 63XX ARL Search Data Result (16 bit) */
+#define B53_ARL_SRCH_RSLT_63XX		0x3c
+#define   ARL_SRST_PORT_ID_MASK_63XX	GENMASK(9, 1)
+#define   ARL_SRST_TC_MASK_63XX		GENMASK(13, 11)
+#define   ARL_SRST_AGE_63XX		BIT(14)
+#define   ARL_SRST_STATIC_63XX		BIT(15)
+
 /*************************************************************************
  * IEEE 802.1X Registers
  *************************************************************************/
-- 
2.51.0



