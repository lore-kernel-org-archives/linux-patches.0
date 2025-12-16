Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B34132AAB3;
	Tue, 16 Dec 2025 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886411; cv=none; b=Tv0DhaEl3zNqLT9RilV6gThskw/c/HZhyuOhp1kzyfTjUqfo/4XuqhFKKTIUnQSzf84iY6/1Y/sgww8xx7h0Ypf0bA/oirW2Bd2SXfFzRqaYo4yK0fgaxY7Kl3csI/IT1ea6K2lF/e9oLMZ4CFHLZCYP9PsqC7zBI8wEUjNH1us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886411; c=relaxed/simple;
	bh=VfFt1rNNgX17Dn+Q1OyrMzDU4B0t3VHAUTOa0WmsuQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+LsFC9Y04u6w8bFIGBN2EqQKUWlvBFxm1+xhOUM7YXPeHses0Dy4BKsaNkCxzW5CuY5QksF1iT/ZenhFfdroN7qh3iAYvPHhP7TBDmcniMHQbQLtaYleYDuTR28c8yeTV+KbGjOpKJaRsijsKgiVGV+ZvKfmppwJHqf+kDi0dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYalGsI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYalGsI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CDDC4CEF1;
	Tue, 16 Dec 2025 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886411;
	bh=VfFt1rNNgX17Dn+Q1OyrMzDU4B0t3VHAUTOa0WmsuQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYalGsI/RDkXvpyn/G2GnhiO7DRr/BMTTQ5PkfRlO0nZ/K9rkJPROGTsrQA4Syef+
	 FxjfV6d2xeAm/X47JEw94bC8Ag4fWO3hqkID7nbV4N7yGCOtHNZCYiUUSevVHWvMyR
	 OZsJa+bVJOgQii4eJY/i8OQh/mP0JCCFgI0Dnmp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 421/507] net: dsa: b53: fix BCM5325/65 ARL entry multicast port masks
Date: Tue, 16 Dec 2025 12:14:22 +0100
Message-ID: <20251216111400.713138810@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 3b08863469aa6028ac7c3120966f4e2f6051cf6b ]

We currently use the mask 0xf for writing and reading b53_entry::port,
but this is only correct for unicast ARL entries. Multicast ARL entries
use a bitmask, and 0xf is not enough space for ports > 3, which includes
the CPU port.

So extend the mask accordingly to also fit port 4 (bit 4) and MII (bit
5). According to the datasheet the multicast port mask is [60:48],
making it 12 bit wide, but bits 60-55 are reserved anyway, and collide
with the priority field at [60:59], so I am not sure if this is valid.
Therefore leave it at the actual used range, [53:48].

The ARL search result register differs a bit, and there the mask is only
[52:48], so only spanning the user ports. The MII port bit is
contained in the Search Result Extension register. So create a separate
search result parse function that properly handles this.

Fixes: c45655386e53 ("net: dsa: b53: add support for FDB operations on 5325/5365")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20251128080625.27181-6-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c |  4 +++-
 drivers/net/dsa/b53/b53_priv.h   | 25 +++++++++++++++++++++----
 drivers/net/dsa/b53/b53_regs.h   |  8 +++++++-
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index db1ed8c9c536e..5544e8e9c6446 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2099,10 +2099,12 @@ static void b53_arl_search_read_25(struct b53_device *dev, u8 idx,
 				   struct b53_arl_entry *ent)
 {
 	u64 mac_vid;
+	u8 ext;
 
+	b53_read8(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSLT_EXT_25, &ext);
 	b53_read64(dev, B53_ARLIO_PAGE, B53_ARL_SRCH_RSTL_0_MACVID_25,
 		   &mac_vid);
-	b53_arl_to_entry_25(ent, mac_vid);
+	b53_arl_search_to_entry_25(ent, mac_vid, ext);
 }
 
 static void b53_arl_search_read_89(struct b53_device *dev, u8 idx,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index ae2c615c088ed..f4afbfcc345e6 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -348,8 +348,8 @@ static inline void b53_arl_to_entry_25(struct b53_arl_entry *ent,
 	ent->is_age = !!(mac_vid & ARLTBL_AGE_25);
 	ent->is_static = !!(mac_vid & ARLTBL_STATIC_25);
 	u64_to_ether_addr(mac_vid, ent->mac);
-	ent->port = (mac_vid >> ARLTBL_DATA_PORT_ID_S_25) &
-		     ARLTBL_DATA_PORT_ID_MASK_25;
+	ent->port = (mac_vid & ARLTBL_DATA_PORT_ID_MASK_25) >>
+		     ARLTBL_DATA_PORT_ID_S_25;
 	if (is_unicast_ether_addr(ent->mac) && ent->port == B53_CPU_PORT)
 		ent->port = B53_CPU_PORT_25;
 	ent->vid = (mac_vid >> ARLTBL_VID_S_65) & ARLTBL_VID_MASK_25;
@@ -388,8 +388,8 @@ static inline void b53_arl_from_entry_25(u64 *mac_vid,
 	if (is_unicast_ether_addr(ent->mac) && ent->port == B53_CPU_PORT_25)
 		*mac_vid |= (u64)B53_CPU_PORT << ARLTBL_DATA_PORT_ID_S_25;
 	else
-		*mac_vid |= (u64)(ent->port & ARLTBL_DATA_PORT_ID_MASK_25) <<
-				  ARLTBL_DATA_PORT_ID_S_25;
+		*mac_vid |= ((u64)ent->port << ARLTBL_DATA_PORT_ID_S_25) &
+			    ARLTBL_DATA_PORT_ID_MASK_25;
 	*mac_vid |= (u64)(ent->vid & ARLTBL_VID_MASK_25) <<
 			  ARLTBL_VID_S_65;
 	if (ent->is_valid)
@@ -414,6 +414,23 @@ static inline void b53_arl_from_entry_89(u64 *mac_vid, u32 *fwd_entry,
 		*fwd_entry |= ARLTBL_AGE_89;
 }
 
+static inline void b53_arl_search_to_entry_25(struct b53_arl_entry *ent,
+					      u64 mac_vid, u8 ext)
+{
+	memset(ent, 0, sizeof(*ent));
+	ent->is_valid = !!(mac_vid & ARLTBL_VALID_25);
+	ent->is_age = !!(mac_vid & ARLTBL_AGE_25);
+	ent->is_static = !!(mac_vid & ARLTBL_STATIC_25);
+	u64_to_ether_addr(mac_vid, ent->mac);
+	ent->vid = (mac_vid >> ARLTBL_VID_S_65) & ARLTBL_VID_MASK_25;
+	ent->port = (mac_vid & ARL_SRCH_RSLT_PORT_ID_MASK_25) >>
+		    ARL_SRCH_RSLT_PORT_ID_S_25;
+	if (is_multicast_ether_addr(ent->mac) && (ext & ARL_SRCH_RSLT_EXT_MC_MII))
+		ent->port |= BIT(B53_CPU_PORT_25);
+	else if (!is_multicast_ether_addr(ent->mac) && ent->port == B53_CPU_PORT)
+		ent->port = B53_CPU_PORT_25;
+}
+
 static inline void b53_arl_search_to_entry_63xx(struct b53_arl_entry *ent,
 						u64 mac_vid, u16 fwd_entry)
 {
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index fcedd5fb00337..e0379e70900b7 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -328,7 +328,7 @@
 #define   ARLTBL_VID_MASK_25		0xff
 #define   ARLTBL_VID_MASK		0xfff
 #define   ARLTBL_DATA_PORT_ID_S_25	48
-#define   ARLTBL_DATA_PORT_ID_MASK_25	0xf
+#define   ARLTBL_DATA_PORT_ID_MASK_25	GENMASK_ULL(53, 48)
 #define   ARLTBL_VID_S_65		53
 #define   ARLTBL_AGE_25			BIT_ULL(61)
 #define   ARLTBL_STATIC_25		BIT_ULL(62)
@@ -374,6 +374,12 @@
 
 /* Single register search result on 5325/5365 */
 #define B53_ARL_SRCH_RSTL_0_MACVID_25	0x24
+#define   ARL_SRCH_RSLT_PORT_ID_S_25	48
+#define   ARL_SRCH_RSLT_PORT_ID_MASK_25	GENMASK_ULL(52, 48)
+
+/* BCM5325/5365 Search result extend register (8 bit) */
+#define B53_ARL_SRCH_RSLT_EXT_25	0x2c
+#define   ARL_SRCH_RSLT_EXT_MC_MII	BIT(2)
 
 /* ARL Search Data Result (32 bit) */
 #define B53_ARL_SRCH_RSTL_0		0x68
-- 
2.51.0



