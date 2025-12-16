Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CA9345CAB;
	Tue, 16 Dec 2025 11:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886092; cv=none; b=INIgli7gTzMSZbIBOIs1xKAjloQACyKZNraoAQEq1tbwNoTcf9B9GFF2eVS9OXu97/xWTVd19dIJ/kc6eIpIhDlF+yPEWGRMSm31ihBl1cZJaqmFh93L+3b3juqD07b6XKhCvEQlPCIKuS3Fds9CC4Gi8cYVEwbsMx5Bn8YaKQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886092; c=relaxed/simple;
	bh=+IPoJbWpHFDJCtW/DtCNwLlwTYLUynfPL91LrRe2vm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWPPOYbsnQtQO4EGVbo9Gnk0gVjIIQuMyVib8iMxUhMYrk3WV4wTVu73Z2fvdJaPf9FQQ3SfcDjlKGV4MbPZyQTKt7UmKpKkuHyFeAVf16Ye2Dvzu1dA0j8DcKnHSO6gd/G9cCoo+07fHyqurqBiekgpQcjipGSZyDn9qKLtwTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8LeH2iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8LeH2iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A051C4CEF1;
	Tue, 16 Dec 2025 11:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886092;
	bh=+IPoJbWpHFDJCtW/DtCNwLlwTYLUynfPL91LrRe2vm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8LeH2iytm51FvJBQltS+cx3O2+sOcATQMdk1UCdi2/5283B/tH83Ipw0jZenVLys
	 ihHZYjXgaDT/BymFsn0w1naFc/NdTvP82Es2wIxjCYRuw7KWPsXSjk75GFKnV+qDTJ
	 pipeVyDNWKdJOcaYFn/5sVfP2RMr4uy7abtg7VFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 335/507] wifi: mt76: mt7996: skip deflink accounting for offchannel links
Date: Tue, 16 Dec 2025 12:12:56 +0100
Message-ID: <20251216111357.600657756@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 4fe823b9ee0317b04ddc6d9e00fea892498aa0f2 ]

Do not take into account offchannel links for deflink accounting.

Fixes: a3316d2fc669f ("wifi: mt76: mt7996: set vif default link_id adding/removing vif links")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Tested-by: Ben Greear <greearb@candelatech.com>
Link: https://patch.msgid.link/20251114-mt76-fix-missing-mtx-v1-4-259ebf11f654@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 04b1d5f871376..1bd0214a01b0e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -372,7 +372,8 @@ int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 
 	ieee80211_iter_keys(mphy->hw, vif, mt7996_key_iter, NULL);
 
-	if (mvif->mt76.deflink_id == IEEE80211_LINK_UNSPECIFIED)
+	if (!mlink->wcid->offchannel &&
+	    mvif->mt76.deflink_id == IEEE80211_LINK_UNSPECIFIED)
 		mvif->mt76.deflink_id = link_conf->link_id;
 
 	return 0;
@@ -397,7 +398,8 @@ void mt7996_vif_link_remove(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 
 	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
 
-	if (mvif->mt76.deflink_id == link_conf->link_id) {
+	if (!mlink->wcid->offchannel &&
+	    mvif->mt76.deflink_id == link_conf->link_id) {
 		struct ieee80211_bss_conf *iter;
 		unsigned int link_id;
 
-- 
2.51.0



