Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2B6398B68;
	Tue, 16 Dec 2025 12:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888354; cv=none; b=VOtnecPOOoeB9my0DW4Hgj6M996fOV2BXb0/O1EDmrk2YNt/nTD0+WfNRm2o+ZzHiL8oocvYLFiI7ohBuGXnRebzonrTbvMthJUHo7ZOO+ly1wPUnOD7uug5tP888jEWigmVEAErdea2rxiVNg+eFsI2J0ussUKNqQC0NnZkmW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888354; c=relaxed/simple;
	bh=+oj4QKzHVmt+RFWMddCaodgW14+KrbwIHdc6uIl2lzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbjfbnl6kgO9G1htuVD1NMWkTXn+rWrPu6Yoh453VgX4dc1b38NLb1ETSYN4efNWVrALZY736w4ZwHcgIMY35okALbsZzMn9oAJLzxh7srYA3ISRWLvE+2qbxrfjQfuBRNDfKcJTcfnQtwQ0+BldzHc0WXB+DAU7UQbJZaP/LRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dhEoyI3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dhEoyI3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10125C4CEF1;
	Tue, 16 Dec 2025 12:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888354;
	bh=+oj4QKzHVmt+RFWMddCaodgW14+KrbwIHdc6uIl2lzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhEoyI3hgGctIZoTkKxXMGSW9JpvXKk7S0t6ZilK+eY150Q3zJMRJ7NwtwDuzvGz0
	 fpWFd7FrF5EXTTWbyxgBoVQa0OojSEq5fgPeLBf5ipC1Y6ZiHAOwHsjhRMeXGnGAkB
	 MEORZ/PthEaqYzoysbZYdF+u0rDjKAlC3l50Z2vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 509/614] net: dsa: b53: move reading ARL entries into their own function
Date: Tue, 16 Dec 2025 12:14:36 +0100
Message-ID: <20251216111419.811549984@linuxfoundation.org>
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

[ Upstream commit 4a291fe7226736a465ddb3fa93c21fcef7162ec7 ]

Instead of duplicating the whole code iterating over all bins for
BCM5325, factor out reading and parsing the entry into its own
functions, and name it the modern one after the first chip with that ARL
format, (BCM53)95.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251107080749.26936-3-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8e46aacea426 ("net: dsa: b53: use same ARL search result offset for BCM5325/65")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 69 +++++++++++---------------------
 1 file changed, 23 insertions(+), 46 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 4d8de90fb4ab8..41dcd2d03230d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1830,48 +1830,30 @@ static int b53_arl_rw_op(struct b53_device *dev, unsigned int op)
 	return b53_arl_op_wait(dev);
 }
 
-static int b53_arl_read(struct b53_device *dev, const u8 *mac,
-			u16 vid, struct b53_arl_entry *ent, u8 *idx)
+static void b53_arl_read_entry_25(struct b53_device *dev,
+				  struct b53_arl_entry *ent, u8 idx)
 {
-	DECLARE_BITMAP(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);
-	unsigned int i;
-	int ret;
-
-	ret = b53_arl_op_wait(dev);
-	if (ret)
-		return ret;
-
-	bitmap_zero(free_bins, dev->num_arl_bins);
-
-	/* Read the bins */
-	for (i = 0; i < dev->num_arl_bins; i++) {
-		u64 mac_vid;
-		u32 fwd_entry;
+	u64 mac_vid;
 
-		b53_read64(dev, B53_ARLIO_PAGE,
-			   B53_ARLTBL_MAC_VID_ENTRY(i), &mac_vid);
-		b53_read32(dev, B53_ARLIO_PAGE,
-			   B53_ARLTBL_DATA_ENTRY(i), &fwd_entry);
-		b53_arl_to_entry(ent, mac_vid, fwd_entry);
+	b53_read64(dev, B53_ARLIO_PAGE, B53_ARLTBL_MAC_VID_ENTRY(idx),
+		   &mac_vid);
+	b53_arl_to_entry_25(ent, mac_vid);
+}
 
-		if (!ent->is_valid) {
-			set_bit(i, free_bins);
-			continue;
-		}
-		if (!ether_addr_equal(ent->mac, mac))
-			continue;
-		if (dev->vlan_enabled && ent->vid != vid)
-			continue;
-		*idx = i;
-		return 0;
-	}
+static void b53_arl_read_entry_95(struct b53_device *dev,
+				  struct b53_arl_entry *ent, u8 idx)
+{
+	u32 fwd_entry;
+	u64 mac_vid;
 
-	*idx = find_first_bit(free_bins, dev->num_arl_bins);
-	return *idx >= dev->num_arl_bins ? -ENOSPC : -ENOENT;
+	b53_read64(dev, B53_ARLIO_PAGE, B53_ARLTBL_MAC_VID_ENTRY(idx),
+		   &mac_vid);
+	b53_read32(dev, B53_ARLIO_PAGE, B53_ARLTBL_DATA_ENTRY(idx), &fwd_entry);
+	b53_arl_to_entry(ent, mac_vid, fwd_entry);
 }
 
-static int b53_arl_read_25(struct b53_device *dev, const u8 *mac,
-			   u16 vid, struct b53_arl_entry *ent, u8 *idx)
+static int b53_arl_read(struct b53_device *dev, const u8 *mac,
+			u16 vid, struct b53_arl_entry *ent, u8 *idx)
 {
 	DECLARE_BITMAP(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);
 	unsigned int i;
@@ -1885,12 +1867,10 @@ static int b53_arl_read_25(struct b53_device *dev, const u8 *mac,
 
 	/* Read the bins */
 	for (i = 0; i < dev->num_arl_bins; i++) {
-		u64 mac_vid;
-
-		b53_read64(dev, B53_ARLIO_PAGE,
-			   B53_ARLTBL_MAC_VID_ENTRY(i), &mac_vid);
-
-		b53_arl_to_entry_25(ent, mac_vid);
+		if (is5325(dev) || is5365(dev))
+			b53_arl_read_entry_25(dev, ent, i);
+		else
+			b53_arl_read_entry_95(dev, ent, i);
 
 		if (!ent->is_valid) {
 			set_bit(i, free_bins);
@@ -1934,10 +1914,7 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 	if (ret)
 		return ret;
 
-	if (is5325(dev) || is5365(dev))
-		ret = b53_arl_read_25(dev, addr, vid, &ent, &idx);
-	else
-		ret = b53_arl_read(dev, addr, vid, &ent, &idx);
+	ret = b53_arl_read(dev, addr, vid, &ent, &idx);
 
 	/* If this is a read, just finish now */
 	if (op)
-- 
2.51.0



