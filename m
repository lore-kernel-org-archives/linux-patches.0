Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1EC397D1E;
	Tue, 16 Dec 2025 12:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888351; cv=none; b=Hkbp+WeM5lzxJdCNtWCs2DceNfzzSUVFQEGKjlWifAMyNVQ4sKTDzlUF3h4NYMv1Vr7Fv1mA3UKWDtrTi5UtBT/59DsI8RgdmHuGev4+ed/a+oLnD19pzPCdIL729q6jukKg2mghXatuKGfLzhQvrwOJQh2RNM6zM0lTESoQb9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888351; c=relaxed/simple;
	bh=9Q9auBIEw5wY3auuzomLqeKoHjuoFgWrCnyeE+tBpWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKoEMewHQXKQO33H2v+ET85f6XfjXPS2LAFQfYw5gpQj1PGqUVlXA4YN6XrUL0QSzelbUTcQVdp8x4oEC90bJ4t2zb0D0O1XsFTLES4PKrdsi6kaTuZmNPFPb0H4hBFSOQ2ldf8GjUgJ6Vs97apYP32INjnEFSlqypir8II9SYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iB3Qfj2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iB3Qfj2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0688AC4CEF1;
	Tue, 16 Dec 2025 12:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888351;
	bh=9Q9auBIEw5wY3auuzomLqeKoHjuoFgWrCnyeE+tBpWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iB3Qfj2KQHybnSnU3D1NRiD3mjlB4di/zuGWnVoFVGV2Edbw7e6KBtZgd3iYPLVUs
	 XJ5C/X31WVq1W32WEZmrvyLlruQU/VbgOZpokuvjzqgbduyXW26vUWbI4VHqdazbZy
	 mZD0i5luFG4mspn1SwAemonrRsCg1ya3UzMMiIT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 508/614] net: dsa: b53: b53_arl_read{,25}(): use the entry for comparision
Date: Tue, 16 Dec 2025 12:14:35 +0100
Message-ID: <20251216111419.775893816@linuxfoundation.org>
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

[ Upstream commit a6e4fd38bf2f2e2363b61c27f4e6c49b14e4bb07 ]

Align the b53_arl_read{,25}() functions by consistently using the
parsed arl entry instead of parsing the raw registers again.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251107080749.26936-2-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8e46aacea426 ("net: dsa: b53: use same ARL search result offset for BCM5325/65")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a09ed32dccc07..4d8de90fb4ab8 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1830,7 +1830,7 @@ static int b53_arl_rw_op(struct b53_device *dev, unsigned int op)
 	return b53_arl_op_wait(dev);
 }
 
-static int b53_arl_read(struct b53_device *dev, u64 mac,
+static int b53_arl_read(struct b53_device *dev, const u8 *mac,
 			u16 vid, struct b53_arl_entry *ent, u8 *idx)
 {
 	DECLARE_BITMAP(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);
@@ -1854,14 +1854,13 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 			   B53_ARLTBL_DATA_ENTRY(i), &fwd_entry);
 		b53_arl_to_entry(ent, mac_vid, fwd_entry);
 
-		if (!(fwd_entry & ARLTBL_VALID)) {
+		if (!ent->is_valid) {
 			set_bit(i, free_bins);
 			continue;
 		}
-		if ((mac_vid & ARLTBL_MAC_MASK) != mac)
+		if (!ether_addr_equal(ent->mac, mac))
 			continue;
-		if (dev->vlan_enabled &&
-		    ((mac_vid >> ARLTBL_VID_S) & ARLTBL_VID_MASK) != vid)
+		if (dev->vlan_enabled && ent->vid != vid)
 			continue;
 		*idx = i;
 		return 0;
@@ -1871,7 +1870,7 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 	return *idx >= dev->num_arl_bins ? -ENOSPC : -ENOENT;
 }
 
-static int b53_arl_read_25(struct b53_device *dev, u64 mac,
+static int b53_arl_read_25(struct b53_device *dev, const u8 *mac,
 			   u16 vid, struct b53_arl_entry *ent, u8 *idx)
 {
 	DECLARE_BITMAP(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);
@@ -1893,14 +1892,13 @@ static int b53_arl_read_25(struct b53_device *dev, u64 mac,
 
 		b53_arl_to_entry_25(ent, mac_vid);
 
-		if (!(mac_vid & ARLTBL_VALID_25)) {
+		if (!ent->is_valid) {
 			set_bit(i, free_bins);
 			continue;
 		}
-		if ((mac_vid & ARLTBL_MAC_MASK) != mac)
+		if (!ether_addr_equal(ent->mac, mac))
 			continue;
-		if (dev->vlan_enabled &&
-		    ((mac_vid >> ARLTBL_VID_S_65) & ARLTBL_VID_MASK_25) != vid)
+		if (dev->vlan_enabled && ent->vid != vid)
 			continue;
 		*idx = i;
 		return 0;
@@ -1937,9 +1935,9 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 		return ret;
 
 	if (is5325(dev) || is5365(dev))
-		ret = b53_arl_read_25(dev, mac, vid, &ent, &idx);
+		ret = b53_arl_read_25(dev, addr, vid, &ent, &idx);
 	else
-		ret = b53_arl_read(dev, mac, vid, &ent, &idx);
+		ret = b53_arl_read(dev, addr, vid, &ent, &idx);
 
 	/* If this is a read, just finish now */
 	if (op)
-- 
2.51.0



