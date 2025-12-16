Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEE6348458;
	Tue, 16 Dec 2025 11:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886352; cv=none; b=E4zIDLfRHhPV8YqOjoVz+SotxjVMcxZxSHfXZ3UzaIo+J7nqvQpwYuG0BMGrS8uAnJg4kBZ0EYVG0l53NlqIX5EufaO+Y0i/QNb4+FJXqeujcgnns/mJr1VBJDCejoFYjPtsr39z3OyF5yVYq7btd/GHIk0cj5yjqx9851K0IGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886352; c=relaxed/simple;
	bh=vhiYeegG8QwmsqcJhjd3wBF0Pa1jggvZ1OIcSomIVO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGu+6lyI8/7eSJPTQzt3n5Re3IKMYfBiUkPffbI7tVCQDFlheMdIcMynFxR4Hii1r4p+s2uqFqhfD3jUuzCsUqS9wqu357TnTrbfF8gUO4jt9DDu+nQM/IOS8WCmhZ/YKGrTKv6BWsiz1l+WirKiBYGfUPArYrSvWd5XB+q6JzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KvhmkWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KvhmkWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380F0C4CEF1;
	Tue, 16 Dec 2025 11:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886351;
	bh=vhiYeegG8QwmsqcJhjd3wBF0Pa1jggvZ1OIcSomIVO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KvhmkWhZ296aWFbRHfst0jLTFkAIu+a4pphlC7wj/qJlUBhdBhM06g0OfvLJEapU
	 o9I38H4eMBYdofz4J+zgVSvbcfMiePb0jAOZCIMY+Xo/rcne1HoFWs3c4sulHh+/Vp
	 cJi8lm7kxAkYrqaO2vRDVRMzw7M8pkaeFvEAYoYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 411/507] net: dsa: b53: b53_arl_read{,25}(): use the entry for comparision
Date: Tue, 16 Dec 2025 12:14:12 +0100
Message-ID: <20251216111400.353100781@linuxfoundation.org>
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



