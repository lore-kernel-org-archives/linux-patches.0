Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA5119E7F7;
	Sat, 12 Sep 2026 08:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201141; cv=none; b=kgZtPvzXYtMFfSErMwYGT1vrwSK4qdZtiY5ecC02gqLA09Y7CNcf3B/sR0c/sCorYeO57JEJikgAwvBtnSkg8gLTYmyoLp7FWG9o3tqPNTmmfSQJkfBTDfqapRj4qezadZdQV+nhXk7fY3LYpZy8/ayqVc0fXZPum/d/iAmR4uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201141; c=relaxed/simple;
	bh=XbqmQKM4d1+E2I2dUX2F/ftJkVYXw/XnOykUpQrNffA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueCTq0wJCAI5A3UyuUlcFXhdypeCLwLIs1wBNscrqaSheoHz1a3e86ZdrkkkvdoXkZ7B3ZTJ9wXm3HU+137IrI+jV+fk7u4EuUnYHHs65MYu4EqgJSGa1BxuBr7us3exLRFGmPj01Zl5PR40scB153HTkxUK7rugTm4KH8rOShM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynBmypLo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynBmypLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A201F000FF;
	Sat, 12 Sep 2026 08:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201140;
	bh=JPP0jRDm8rFVnQZAHotHvyypnWS2JTJsDLZNeVDl6YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ynBmypLoCgRIlJdDzCltTOEn6kJRsyYDWsLg7CtR1twmJa/SIuE34so3/kVeakDSY
	 8rdLpNahuzXpfOlFBaPCg8qF11EtYuV60kDXSagLfGLiB6aPbZiilIMlxYM4xzVNBh
	 YM0+IAXsTw5974+81ER2rFalzlemFdQS7gkRUEJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0935/1815] wifi: mt76: mt7996: skip key upload when adding an offchannel link
Date: Sat, 12 Sep 2026 08:44:45 +0200
Message-ID: <20260912065710.904395602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit ccb4bda277999959bc852480d8684b13b926e657 ]

No hw keys are ever uploaded for scanning/roc links and the link remove
path already skips the key iteration for them. The add path still runs
it, and since mt7996_set_hw_key() resolves the target through
mvif->link[link_id] rather than the offchannel link, starting a scan on
another band re-uploads the group keys of the link sharing the same
link_id, re-sending its BSS cipher info and, for BIGTK with beacon
protection on an AP link, toggling its beacons off and on.

Skip the key iteration for offchannel links, mirroring the remove path.

Fixes: 69d54ce7491d ("wifi: mt76: mt7996: switch to single multi-radio wiphy")
Link: https://patch.msgid.link/20260724124813.3961474-18-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 57afe4e81666c..c49c6f92efe2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -372,7 +372,8 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 				   CONN_STATE_PORT_SECURE, true);
 	rcu_assign_pointer(dev->mt76.wcid[idx], &msta_link->wcid);
 
-	ieee80211_iter_keys(mphy->hw, vif, mt7996_key_iter, &it);
+	if (!mlink->wcid->offchannel)
+		ieee80211_iter_keys(mphy->hw, vif, mt7996_key_iter, &it);
 
 	if (!mlink->wcid->offchannel) {
 		if (vif->txq &&
-- 
2.53.0



