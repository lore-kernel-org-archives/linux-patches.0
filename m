Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631303002B3;
	Sat, 12 Sep 2026 10:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209247; cv=none; b=gFelR4TxFadJJYI+y7oRFaSg6ZAg8raRK3//QT4wDzhscgq/VvLPPg/rn2fUhK7y1Bi5xU5x2ruRYV5CAgYVKSMIAPiOwWUmD4t1x7IX3TSA+XGqogh4v6fessqhQ3XuQJzAf+n95XuRDExFnrKw8HhN9Gjp2+mIIp2M4g/xqFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209247; c=relaxed/simple;
	bh=eYaTdsASISQeeZVVwwrlRYkxPNF6Cwh4TLHjh8uSWlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZHcTz3HJkpKuC+nB80B86cwRc2AasTUs27FNRuzH1JynyYAuhdb6pajGfdUiIAICkUQqirjHj5vvQNFJn21a/n8885C7PMuYgfiz3JOfdcGnQsfRPQYScd1AOQCv2zMt8dMJDeFZyUWj4XxnSMjIc6FPvV2sLut978cGrCjyDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2W23NuO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2W23NuO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0374C1F0089A;
	Sat, 12 Sep 2026 10:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209246;
	bh=WpcaMST4oZHJgocxr1kciR4ajIIdHFJE7XYZRgOuGpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2W23NuOSTRXPwD2xLs8uvAePosI40wUnzXfFdsy9Uvtm97Z8wl+J4x3fLqpY2Gym
	 oRbRNFvVoilkWZoOPwEJ+rzPA7nJ87PCALi5K6G6qUrzGUdxbvZFsJUL7mN+bJ/PAB
	 8z3yC1q37bxxDnh6EEUzN2aXS3aUZaQK8JI+9LXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0739/1518] wifi: mt76: mt7996: support fixed rate for link station
Date: Sat, 12 Sep 2026 08:48:28 +0200
Message-ID: <20260912065640.151881161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit feb06d4556203cd27cf3fa31147d43f28f329653 ]

Introduce mt7996_link_sta_add_debugfs() to extend fixed rate support for
MLO link station.

Co-developed-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20251106064203.1000505-4-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: ce35ecffc96e ("wifi: mt76: mt7996: fix MLD ID in MAC TXD and HIF TXP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt7996/debugfs.c   | 72 +++++++++++--------
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  1 +
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  3 +
 3 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
index 0ab827f52fd7d..0526fa1c26ad2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
@@ -953,16 +953,34 @@ bool mt7996_debugfs_rx_log(struct mt7996_dev *dev, const void *data, int len)
 #ifdef CONFIG_MAC80211_DEBUGFS
 /** per-station debugfs **/
 
-static ssize_t mt7996_sta_fixed_rate_set(struct file *file,
-					 const char __user *user_buf,
-					 size_t count, loff_t *ppos)
+static int
+mt7996_queues_show(struct seq_file *s, void *data)
+{
+	struct ieee80211_sta *sta = s->private;
+
+	mt7996_sta_hw_queue_read(s, sta);
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(mt7996_queues);
+
+void mt7996_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    struct ieee80211_sta *sta, struct dentry *dir)
+{
+	debugfs_create_file("hw-queues", 0400, dir, sta, &mt7996_queues_fops);
+}
+
+static ssize_t mt7996_link_sta_fixed_rate_set(struct file *file,
+					      const char __user *user_buf,
+					      size_t count, loff_t *ppos)
 {
 #define SHORT_PREAMBLE 0
 #define LONG_PREAMBLE 1
-	struct ieee80211_sta *sta = file->private_data;
-	struct mt7996_sta *msta = (struct mt7996_sta *)sta->drv_priv;
+	struct ieee80211_link_sta *link_sta = file->private_data;
+	struct mt7996_sta *msta = (struct mt7996_sta *)link_sta->sta->drv_priv;
 	struct mt7996_dev *dev = msta->vif->deflink.phy->dev;
-	struct mt7996_sta_link *msta_link = &msta->deflink;
+	struct mt7996_sta_link *msta_link;
 	struct ra_rate phy = {};
 	char buf[100];
 	int ret;
@@ -981,12 +999,13 @@ static ssize_t mt7996_sta_fixed_rate_set(struct file *file,
 
 	/* mode - cck: 0, ofdm: 1, ht: 2, gf: 3, vht: 4, he_su: 8, he_er: 9 EHT: 15
 	 * bw - bw20: 0, bw40: 1, bw80: 2, bw160: 3, BW320: 4
-	 * nss - vht: 1~4, he: 1~4, eht: 1~4, others: ignore
 	 * mcs - cck: 0~4, ofdm: 0~7, ht: 0~32, vht: 0~9, he_su: 0~11, he_er: 0~2, eht: 0~13
+	 * nss - vht: 1~4, he: 1~4, eht: 1~4, others: ignore
 	 * gi - (ht/vht) lgi: 0, sgi: 1; (he) 0.8us: 0, 1.6us: 1, 3.2us: 2
 	 * preamble - short: 1, long: 0
-	 * ldpc - off: 0, on: 1
 	 * stbc - off: 0, on: 1
+	 * ldpc - off: 0, on: 1
+	 * spe - off: 0, on: 1
 	 * ltf - 1xltf: 0, 2xltf: 1, 4xltf: 2
 	 */
 	if (sscanf(buf, "%hhu %hhu %hhu %hhu %hu %hhu %hhu %hhu %hhu %hu",
@@ -994,9 +1013,16 @@ static ssize_t mt7996_sta_fixed_rate_set(struct file *file,
 		   &phy.preamble, &phy.stbc, &phy.ldpc, &phy.spe, &ltf) != 10) {
 		dev_warn(dev->mt76.dev,
 			 "format: Mode BW MCS NSS GI Preamble STBC LDPC SPE ltf\n");
-		goto out;
+		return -EINVAL;
 	}
 
+	mutex_lock(&dev->mt76.mutex);
+
+	msta_link = mt76_dereference(msta->link[link_sta->link_id], &dev->mt76);
+	if (!msta_link) {
+		ret = -EINVAL;
+		goto out;
+	}
 	phy.wlan_idx = cpu_to_le16(msta_link->wcid.idx);
 	phy.gi = cpu_to_le16(gi);
 	phy.ltf = cpu_to_le16(ltf);
@@ -1005,36 +1031,26 @@ static ssize_t mt7996_sta_fixed_rate_set(struct file *file,
 
 	ret = mt7996_mcu_set_fixed_rate_ctrl(dev, &phy, 0);
 	if (ret)
-		return -EFAULT;
+		goto out;
 
+	ret = count;
 out:
-	return count;
+	mutex_unlock(&dev->mt76.mutex);
+	return ret;
 }
 
 static const struct file_operations fops_fixed_rate = {
-	.write = mt7996_sta_fixed_rate_set,
+	.write = mt7996_link_sta_fixed_rate_set,
 	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
 };
 
-static int
-mt7996_queues_show(struct seq_file *s, void *data)
-{
-	struct ieee80211_sta *sta = s->private;
-
-	mt7996_sta_hw_queue_read(s, sta);
-
-	return 0;
-}
-
-DEFINE_SHOW_ATTRIBUTE(mt7996_queues);
-
-void mt7996_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			    struct ieee80211_sta *sta, struct dentry *dir)
+void mt7996_link_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+				 struct ieee80211_link_sta *link_sta,
+				 struct dentry *dir)
 {
-	debugfs_create_file("fixed_rate", 0600, dir, sta, &fops_fixed_rate);
-	debugfs_create_file("hw-queues", 0400, dir, sta, &mt7996_queues_fops);
+	debugfs_create_file("fixed_rate", 0600, dir, link_sta, &fops_fixed_rate);
 }
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 20da0c10669a9..fd4e9112cccc5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -2371,6 +2371,7 @@ const struct ieee80211_ops mt7996_ops = {
 	.twt_teardown_request = mt7996_twt_teardown_request,
 #ifdef CONFIG_MAC80211_DEBUGFS
 	.sta_add_debugfs = mt7996_sta_add_debugfs,
+	.link_sta_add_debugfs = mt7996_link_sta_add_debugfs,
 #endif
 	.set_radar_background = mt7996_set_radar_background,
 #ifdef CONFIG_NET_MEDIATEK_SOC_WED
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index b8ffa42c5a1da..9f46d39e1e2cf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -867,6 +867,9 @@ int mt7996_mcu_cp_support(struct mt7996_dev *dev, u8 mode);
 #ifdef CONFIG_MAC80211_DEBUGFS
 void mt7996_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			    struct ieee80211_sta *sta, struct dentry *dir);
+void mt7996_link_sta_add_debugfs(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+				 struct ieee80211_link_sta *link_sta,
+				 struct dentry *dir);
 #endif
 int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 			 bool hif2, int *irq);
-- 
2.53.0



