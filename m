Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ADE3AA518;
	Mon, 23 Mar 2026 14:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277946; cv=none; b=UiTQW7FERG5KvzWQIPPMwdL7LQcxlpyk6n5qHmdDEJBMKcbiG86U2YitFkg46mpcIgi60gemRZlWyha/yTpELayOAPaR4lBRNEg2vzWC6+yNkUShA4dCUc3EnZHU2/jX0rC6gBehSwU9nFmczS8nr1xI5ixJSknEP/it8eAKqu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277946; c=relaxed/simple;
	bh=2y0tK+EJ8QAc82RhX0hcE+Qoc7e3tUbB/tPEtHtnMzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E30Mb+v/X7BWDdkKCASZ1CcGXo1VYpRkNJgsacmP5HGLupbtva2/yQnxoidyCLT4rDGz7rLSnYYgFNmqak39Xt5Ay488eanTyXbudyTGcQ/0DZED32nQF4z1ZIYD+xLHnl3xwPOU5COp7b8NOg3CeQdvqTaFc3Nd1a+x0OLP4Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7fXRB/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7fXRB/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627A5C4CEF7;
	Mon, 23 Mar 2026 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277945;
	bh=2y0tK+EJ8QAc82RhX0hcE+Qoc7e3tUbB/tPEtHtnMzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7fXRB/IFevfJX8iNCUyF6t+1u8JvyzAthzcU3MMt0D5NUXq+bmgdacJuNe+BAdQN
	 xdHcXHd3dJ2XjUqqNTyGKRmdOo/Pwefimb5OsqBcAue1YZsboVRBNYlqPXJwyGwjPm
	 Zt0ThL8bT+bPSznGi18VM7R7AROIT7UOJTxuHOck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/567] wifi: mt76: mt7996: Fix possible oob access in mt7996_mac_write_txwi_80211()
Date: Mon, 23 Mar 2026 14:41:13 +0100
Message-ID: <20260323134537.617615797@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 60862846308627e9e15546bb647a00de44deb27b ]

Check frame length before accessing the mgmt fields in
mt7996_mac_write_txwi_80211 in order to avoid a possible oob access.

Fixes: 98686cd21624c ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260226-mt76-addba-req-oob-access-v1-1-b0f6d1ad4850@kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 8fa16f95e6a7b..3dd503b363ce0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -784,6 +784,7 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 	u32 val;
 
 	if (ieee80211_is_action(fc) &&
+	    skb->len >= IEEE80211_MIN_ACTION_SIZE + 1 &&
 	    mgmt->u.action.category == WLAN_CATEGORY_BACK &&
 	    mgmt->u.action.u.addba_req.action_code == WLAN_ACTION_ADDBA_REQ)
 		tid = MT_TX_ADDBA;
-- 
2.51.0



