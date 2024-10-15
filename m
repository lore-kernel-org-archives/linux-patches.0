Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C1019B3FF;
	Tue, 15 Oct 2024 11:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993467; cv=none; b=ug1aGfOJjH52b+JT4GQYexB/agqVMIxP5gsLuEc07URTm6ITovGWs3BbtN8s/HRvPl1ZVfuIKbf/qEN2iR2855nmD6K+0Y/hp1RE/e/A4f6coqjuu+vAbsA8eKMkQOf6GhLb0ecLyUobz0lDbCogkdespqEbOtPYI1yGMdufIg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993467; c=relaxed/simple;
	bh=7TmYMrmUhMbwTaEIxXNlEISjXW0zSVvY5kRVY9uyXWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYlQz2Dbc7qR9Jti/QGmsfb+beQRUOJvpG2VQzSVN3PzTxH09K1q/C9t6+xmPnCwLk5X+vdwBKwC3VVFjiinTtq2eC6nsnCp0SHeynJTaG44GLxucsuzj9W3Rq+R0oXSZkND6+y5gkbzSqblw/Mf9ZLaECpSEKKHrGVOzK3mwbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XFTp6ylY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XFTp6ylY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51170C4CEC6;
	Tue, 15 Oct 2024 11:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993466;
	bh=7TmYMrmUhMbwTaEIxXNlEISjXW0zSVvY5kRVY9uyXWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFTp6ylYK9RzhW3fNOuuSfbLJoRAlRfeheAHt1dkCMjBC4uT3DiX7hG8WlvA9/poi
	 uX0YJwwL1uaioEqLg0FOfZqP4t2t6ruAn3Z3Jo1CCDWqZm8sw/kLE3NX4yYCQ8kesy
	 v1B1QZe7n9Ck6iqokfjMT470aQ2nyRs6HnI4vtfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 389/691] net: stmmac: Disable automatic FCS/Pad stripping
Date: Tue, 15 Oct 2024 13:25:37 +0200
Message-ID: <20241015112455.780320774@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 929d43421ee526c5a3c4d6f7e2bb1b98b2cb1b1f ]

The stmmac has the possibility to automatically strip the padding/FCS for IEEE
802.3 type frames. This feature is enabled conditionally. Therefore, the stmmac
receive path has to have a determination logic whether the FCS has to be
stripped in software or not.

In fact, for DSA this ACS feature is disabled and the determination logic
doesn't check for it properly. For instance, when using DSA in combination with
an older stmmac (pre version 4), the FCS is not stripped by hardware or software
which is problematic.

So either add another check for DSA to the fast path or simply disable ACS
feature completely. The latter approach has been chosen, because most of the
time the FCS is stripped in software anyway and it removes conditionals from the
receive fast path.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/87v8q8jjgh.fsf@kurt/
Link: https://lore.kernel.org/r/20220905130155.193640-1-kurt@linutronix.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 4c1b56671b68 ("net: stmmac: dwmac4: extend timeout for VLAN Tag register busy bit check")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/dwmac100.h    |  2 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000.h   |  2 +-
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  |  9 -------
 .../ethernet/stmicro/stmmac/dwmac100_core.c   |  8 -------
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  1 -
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 24 ++++---------------
 6 files changed, 6 insertions(+), 40 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100.h b/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
index 35ab8d0bdce71..7ab791c8d355f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100.h
@@ -56,7 +56,7 @@
 #define MAC_CONTROL_TE		0x00000008	/* Transmitter Enable */
 #define MAC_CONTROL_RE		0x00000004	/* Receiver Enable */
 
-#define MAC_CORE_INIT (MAC_CONTROL_HBD | MAC_CONTROL_ASTP)
+#define MAC_CORE_INIT (MAC_CONTROL_HBD)
 
 /* MAC FLOW CTRL defines */
 #define MAC_FLOW_CTRL_PT_MASK	0xffff0000	/* Pause Time Mask */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
index 3c73453725f94..4296ddda8aaa6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000.h
@@ -126,7 +126,7 @@ enum inter_frame_gap {
 #define GMAC_CONTROL_TE		0x00000008	/* Transmitter Enable */
 #define GMAC_CONTROL_RE		0x00000004	/* Receiver Enable */
 
-#define GMAC_CORE_INIT (GMAC_CONTROL_JD | GMAC_CONTROL_PS | GMAC_CONTROL_ACS | \
+#define GMAC_CORE_INIT (GMAC_CONTROL_JD | GMAC_CONTROL_PS | \
 			GMAC_CONTROL_BE | GMAC_CONTROL_DCRS)
 
 /* GMAC Frame Filter defines */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
index 76edb9b726756..0e00dd83d027a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
@@ -15,7 +15,6 @@
 #include <linux/crc32.h>
 #include <linux/slab.h>
 #include <linux/ethtool.h>
-#include <net/dsa.h>
 #include <asm/io.h>
 #include "stmmac.h"
 #include "stmmac_pcs.h"
@@ -24,7 +23,6 @@
 static void dwmac1000_core_init(struct mac_device_info *hw,
 				struct net_device *dev)
 {
-	struct stmmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = hw->pcsr;
 	u32 value = readl(ioaddr + GMAC_CONTROL);
 	int mtu = dev->mtu;
@@ -32,13 +30,6 @@ static void dwmac1000_core_init(struct mac_device_info *hw,
 	/* Configure GMAC core */
 	value |= GMAC_CORE_INIT;
 
-	/* Clear ACS bit because Ethernet switch tagging formats such as
-	 * Broadcom tags can look like invalid LLC/SNAP packets and cause the
-	 * hardware to truncate packets on reception.
-	 */
-	if (netdev_uses_dsa(dev) || !priv->plat->enh_desc)
-		value &= ~GMAC_CONTROL_ACS;
-
 	if (mtu > 1500)
 		value |= GMAC_CONTROL_2K;
 	if (mtu > 2000)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
index 75071a7d551a8..a6e8d7bd95886 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac100_core.c
@@ -15,7 +15,6 @@
 *******************************************************************************/
 
 #include <linux/crc32.h>
-#include <net/dsa.h>
 #include <asm/io.h>
 #include "stmmac.h"
 #include "dwmac100.h"
@@ -28,13 +27,6 @@ static void dwmac100_core_init(struct mac_device_info *hw,
 
 	value |= MAC_CORE_INIT;
 
-	/* Clear ASTP bit because Ethernet switch tagging formats such as
-	 * Broadcom tags can look like invalid LLC/SNAP packets and cause the
-	 * hardware to truncate packets on reception.
-	 */
-	if (netdev_uses_dsa(dev))
-		value &= ~MAC_CONTROL_ASTP;
-
 	writel(value, ioaddr + MAC_CONTROL);
 
 #ifdef STMMAC_VLAN_TAG_USED
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index e5c5a9c5389c3..687eb17e41c6e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/ethtool.h>
 #include <linux/io.h>
-#include <net/dsa.h>
 #include "stmmac.h"
 #include "stmmac_pcs.h"
 #include "dwmac4.h"
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 23c0355c13c18..b62d153f1676e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5045,16 +5045,8 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 		buf1_len = stmmac_rx_buf1_len(priv, p, status, len);
 		len += buf1_len;
 
-		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
-		 * Type frames (LLC/LLC-SNAP)
-		 *
-		 * llc_snap is never checked in GMAC >= 4, so this ACS
-		 * feature is always disabled and packets need to be
-		 * stripped manually.
-		 */
-		if (likely(!(status & rx_not_ls)) &&
-		    (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
-		     unlikely(status != llc_snap))) {
+		/* ACS is disabled; strip manually. */
+		if (likely(!(status & rx_not_ls))) {
 			buf1_len -= ETH_FCS_LEN;
 			len -= ETH_FCS_LEN;
 		}
@@ -5231,16 +5223,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		buf2_len = stmmac_rx_buf2_len(priv, p, status, len);
 		len += buf2_len;
 
-		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
-		 * Type frames (LLC/LLC-SNAP)
-		 *
-		 * llc_snap is never checked in GMAC >= 4, so this ACS
-		 * feature is always disabled and packets need to be
-		 * stripped manually.
-		 */
-		if (likely(!(status & rx_not_ls)) &&
-		    (likely(priv->synopsys_id >= DWMAC_CORE_4_00) ||
-		     unlikely(status != llc_snap))) {
+		/* ACS is disabled; strip manually. */
+		if (likely(!(status & rx_not_ls))) {
 			if (buf2_len) {
 				buf2_len -= ETH_FCS_LEN;
 				len -= ETH_FCS_LEN;
-- 
2.43.0



