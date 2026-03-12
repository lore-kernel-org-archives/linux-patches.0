Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683F6373BE0;
	Thu, 12 Mar 2026 20:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347123; cv=none; b=TlQutcWfnN5uueGp7jQg3BhobnyYAt5RpyySVcjH2N3Pq+TtIfrW63kgaIuIstXEKG4hWkIeryDAE7yDGKskQdFtxHj/LwvphaCNbDc2O1tjze9284zbKM5ekYmfoHappT6x2s/TecJcNA+4zYdZ7rJvlCCmhMHMm+4jPUsQj/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347123; c=relaxed/simple;
	bh=2UCXfw3GWOKvy6Bklj3L4DDKnF10cxloWxO5sEC2pD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivgcM68nRUpYphFnXL9xOcdpd2WxnD/Aa6VCRJ5pztvOX4pMKn3WSSeCe7LOKowzctwU0NabjW2HFMxzsfL8vlx9d4Jcx5/Qyhbg38pVUjwBL0qKxiclHjxLvBFNYAAAlMfVWc5Syz1cAGndmVRt0cwQmAwuUmr2Xn0Pp+LINjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFm/wF62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFm/wF62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1361C4CEF7;
	Thu, 12 Mar 2026 20:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347123;
	bh=2UCXfw3GWOKvy6Bklj3L4DDKnF10cxloWxO5sEC2pD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFm/wF621DeVh2enicZWgHytRAMc9keTepYlybwVLSg0Sx1v/hRhwRGiPPD/ysnmy
	 bxj59oDvFj3tC0addwupgrleZjG3fptjlOyKxAu6rvdwhs/UDE4Xy7gFmYakml6FfZ
	 iP358Z1JUEDWre34SXOQi6F0kXvkMPjtmDMSlR7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/265] wifi: mt76: Fix possible oob access in mt76_connac2_mac_write_txwi_80211()
Date: Thu, 12 Mar 2026 21:09:56 +0100
Message-ID: <20260312201025.870677216@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 4e10a730d1b511ff49723371ed6d694dd1b2c785 ]

Check frame length before accessing the mgmt fields in
mt76_connac2_mac_write_txwi_80211 in order to avoid a possible oob
access.

Fixes: 577dbc6c656d ("mt76: mt7915: enable offloading of sequence number assignment")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260226-mt76-addba-req-oob-access-v1-3-b0f6d1ad4850@kernel.org
[fix check to also cover mgmt->u.action.u.addba_req.capab,
correct Fixes tag]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index a3db65254e37f..268f414f0a023 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -396,6 +396,7 @@ mt76_connac2_mac_write_txwi_80211(struct mt76_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 + 1 + 2 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ) {
 		u16 capab = le16_to_cpu(mgmt->u.action.u.addba_req.capab);
-- 
2.51.0



