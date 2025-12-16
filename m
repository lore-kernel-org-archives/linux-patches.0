Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E65A39A138;
	Tue, 16 Dec 2025 12:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888391; cv=none; b=IrB7ZEpENKmro0yYon0Zj46iVo2MT2W0brQPPnJOCYurwyL2BaCWzj6h82c3w3cIK1NuqwHF96F0HIULeY1UngBD3p50DosA2zM5mfIuY5AHggO94B5EB6iaIPqKyYul6t6ktC4YQkEO/caWRjzmyaw47vtiLBPaMk1ejtBg4Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888391; c=relaxed/simple;
	bh=2jkUi7f9THUx3gF4kVxs10KhInLBEDyaoD/UgIIrGb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTUI037iatghyLv+qFrGStGEyxS6oH/bxCSxEW6eysEOirH8quboP8UVmK3Hgl8oJ1dff1mIf7lmJxgv+uH7WalKU7hCWtN3KKbRq9vKzlJuAAVRSajDgF14RVqtQZ72rb/PYoY/OnU9TMMJRBrpt++oxuzXjGyXeUO58VN3BoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrRHcuRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrRHcuRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC50C4CEF1;
	Tue, 16 Dec 2025 12:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888391;
	bh=2jkUi7f9THUx3gF4kVxs10KhInLBEDyaoD/UgIIrGb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrRHcuROat52gj3SCQa7swHVFKwI5wP3IVL8FpiloTBqpUx8+EF92xOsnNfMa166k
	 49CnQ4uB5y+V4DLlysLq04OKS0tTGPB32EOwUAX8fV4s2d/QyBD1KsFAt0acma1udT
	 3qJk7ZAvUkXbjQSzs2lgthCreRYh88dpVgVB9i7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 519/614] net: dsa: b53: fix BCM5325/65 ARL entry VIDs
Date: Tue, 16 Dec 2025 12:14:46 +0100
Message-ID: <20251216111420.173445784@linuxfoundation.org>
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

[ Upstream commit d39514e6a2d14f57830d649e2bf03b49612c2f73 ]

BCM5325/65's ARL entry registers do not contain the VID, only the search
result register does. ARL entries have a separate VID entry register for
the index into the VLAN table.

So make ARL entry accessors use the VID entry registers instead, and
move the VLAN ID field definition to the search register definition.

Fixes: c45655386e53 ("net: dsa: b53: add support for FDB operations on 5325/5365")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251128080625.27181-7-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c |  9 +++++++--
 drivers/net/dsa/b53/b53_priv.h   | 12 ++++++------
 drivers/net/dsa/b53/b53_regs.h   |  7 +++++--
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 5544e8e9c6446..62cafced758e7 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1833,19 +1833,24 @@ static int b53_arl_rw_op(struct b53_device *dev, unsigned int op)
 static void b53_arl_read_entry_25(struct b53_device *dev,
 				  struct b53_arl_entry *ent, u8 idx)
 {
+	u8 vid_entry;
 	u64 mac_vid;
 
+	b53_read8(dev, B53_ARLIO_PAGE, B53_ARLTBL_VID_ENTRY_25(idx),
+		  &vid_entry);
 	b53_read64(dev, B53_ARLIO_PAGE, B53_ARLTBL_MAC_VID_ENTRY(idx),
 		   &mac_vid);
-	b53_arl_to_entry_25(ent, mac_vid);
+	b53_arl_to_entry_25(ent, mac_vid, vid_entry);
 }
 
 static void b53_arl_write_entry_25(struct b53_device *dev,
 				   const struct b53_arl_entry *ent, u8 idx)
 {
+	u8 vid_entry;
 	u64 mac_vid;
 
-	b53_arl_from_entry_25(&mac_vid, ent);
+	b53_arl_from_entry_25(&mac_vid, &vid_entry, ent);
+	b53_write8(dev, B53_ARLIO_PAGE, B53_ARLTBL_VID_ENTRY_25(idx), vid_entry);
 	b53_write64(dev, B53_ARLIO_PAGE, B53_ARLTBL_MAC_VID_ENTRY(idx),
 		    mac_vid);
 }
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index f4afbfcc345e6..bd6849e5bb939 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -341,7 +341,7 @@ static inline void b53_arl_to_entry(struct b53_arl_entry *ent,
 }
 
 static inline void b53_arl_to_entry_25(struct b53_arl_entry *ent,
-				       u64 mac_vid)
+				       u64 mac_vid, u8 vid_entry)
 {
 	memset(ent, 0, sizeof(*ent));
 	ent->is_valid = !!(mac_vid & ARLTBL_VALID_25);
@@ -352,7 +352,7 @@ static inline void b53_arl_to_entry_25(struct b53_arl_entry *ent,
 		     ARLTBL_DATA_PORT_ID_S_25;
 	if (is_unicast_ether_addr(ent->mac) && ent->port == B53_CPU_PORT)
 		ent->port = B53_CPU_PORT_25;
-	ent->vid = (mac_vid >> ARLTBL_VID_S_65) & ARLTBL_VID_MASK_25;
+	ent->vid = vid_entry;
 }
 
 static inline void b53_arl_to_entry_89(struct b53_arl_entry *ent,
@@ -381,7 +381,7 @@ static inline void b53_arl_from_entry(u64 *mac_vid, u32 *fwd_entry,
 		*fwd_entry |= ARLTBL_AGE;
 }
 
-static inline void b53_arl_from_entry_25(u64 *mac_vid,
+static inline void b53_arl_from_entry_25(u64 *mac_vid, u8 *vid_entry,
 					 const struct b53_arl_entry *ent)
 {
 	*mac_vid = ether_addr_to_u64(ent->mac);
@@ -390,14 +390,13 @@ static inline void b53_arl_from_entry_25(u64 *mac_vid,
 	else
 		*mac_vid |= ((u64)ent->port << ARLTBL_DATA_PORT_ID_S_25) &
 			    ARLTBL_DATA_PORT_ID_MASK_25;
-	*mac_vid |= (u64)(ent->vid & ARLTBL_VID_MASK_25) <<
-			  ARLTBL_VID_S_65;
 	if (ent->is_valid)
 		*mac_vid |= ARLTBL_VALID_25;
 	if (ent->is_static)
 		*mac_vid |= ARLTBL_STATIC_25;
 	if (ent->is_age)
 		*mac_vid |= ARLTBL_AGE_25;
+	*vid_entry = ent->vid;
 }
 
 static inline void b53_arl_from_entry_89(u64 *mac_vid, u32 *fwd_entry,
@@ -422,7 +421,8 @@ static inline void b53_arl_search_to_entry_25(struct b53_arl_entry *ent,
 	ent->is_age = !!(mac_vid & ARLTBL_AGE_25);
 	ent->is_static = !!(mac_vid & ARLTBL_STATIC_25);
 	u64_to_ether_addr(mac_vid, ent->mac);
-	ent->vid = (mac_vid >> ARLTBL_VID_S_65) & ARLTBL_VID_MASK_25;
+	ent->vid = (mac_vid & ARL_SRCH_RSLT_VID_MASK_25) >>
+		   ARL_SRCH_RSLT_VID_S_25;
 	ent->port = (mac_vid & ARL_SRCH_RSLT_PORT_ID_MASK_25) >>
 		    ARL_SRCH_RSLT_PORT_ID_S_25;
 	if (is_multicast_ether_addr(ent->mac) && (ext & ARL_SRCH_RSLT_EXT_MC_MII))
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index e0379e70900b7..b6fe7d207a2c1 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -325,11 +325,9 @@
 #define B53_ARLTBL_MAC_VID_ENTRY(n)	((0x10 * (n)) + 0x10)
 #define   ARLTBL_MAC_MASK		0xffffffffffffULL
 #define   ARLTBL_VID_S			48
-#define   ARLTBL_VID_MASK_25		0xff
 #define   ARLTBL_VID_MASK		0xfff
 #define   ARLTBL_DATA_PORT_ID_S_25	48
 #define   ARLTBL_DATA_PORT_ID_MASK_25	GENMASK_ULL(53, 48)
-#define   ARLTBL_VID_S_65		53
 #define   ARLTBL_AGE_25			BIT_ULL(61)
 #define   ARLTBL_STATIC_25		BIT_ULL(62)
 #define   ARLTBL_VALID_25		BIT_ULL(63)
@@ -349,6 +347,9 @@
 #define   ARLTBL_STATIC_89		BIT(14)
 #define   ARLTBL_VALID_89		BIT(15)
 
+/* BCM5325/BCM565 ARL Table VID Entry N Registers (8 bit) */
+#define B53_ARLTBL_VID_ENTRY_25(n)	((0x2 * (n)) + 0x30)
+
 /* Maximum number of bin entries in the ARL for all switches */
 #define B53_ARLTBL_MAX_BIN_ENTRIES	4
 
@@ -376,6 +377,8 @@
 #define B53_ARL_SRCH_RSTL_0_MACVID_25	0x24
 #define   ARL_SRCH_RSLT_PORT_ID_S_25	48
 #define   ARL_SRCH_RSLT_PORT_ID_MASK_25	GENMASK_ULL(52, 48)
+#define   ARL_SRCH_RSLT_VID_S_25	53
+#define   ARL_SRCH_RSLT_VID_MASK_25	GENMASK_ULL(60, 53)
 
 /* BCM5325/5365 Search result extend register (8 bit) */
 #define B53_ARL_SRCH_RSLT_EXT_25	0x2c
-- 
2.51.0



