Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3229C46A5EE;
	Tue, 21 Jul 2026 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656475; cv=none; b=bL4wlqkYlb9usm2oWjuAupfzJDMvAd2wTtHcP+dFGJk8XyLgNCZm2MHVgN+OEMxBnipAutpN7FRt08+leCcD4qVd5BJZghuPUTOLPS5Y3cTOZylXmrBVsXeX/JYVv9QBBsIbgaSfBoDCWoTkYuZNFr0auqf1N0Pa4mFtHXxgirU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656475; c=relaxed/simple;
	bh=x01i+i3YgKAdaFnlclTfpPZ/o2aCHvBMHC0qcGl0UFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MISAG1PuPzLK0HE5RoOQoeJ476ftXMc2vrRtakJpmin1B8zBV3a/IUSfX4Cp4NpJgLUVNSA+SpLGPutmEPISs24F6XvDFf816JKU3K/WB7KOFVgpyEyIB3JxN4tySbMCFP6jhJ7UHl0Ooq5Pw1g42S6ecIEjf3FJvIPEb2U7kPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FnLqL/U3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FnLqL/U3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B351F000E9;
	Tue, 21 Jul 2026 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656474;
	bh=Kqv6VABzTrSEXKwGPY1K4KHpvhZuvmigvedIIajKIFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnLqL/U3UwSHIoA8KpGV4/B85X47d61GvtQeexpVfUreHimX48GBWhU0AtttquNJb
	 IeHBLGGuSwUfBNRSx7pt8wiz0oB+FHpucEDcv5FIzbEvR/wRfJcH0FjkuPb/QbqAA/
	 9+2xP0mDEYeK58GbhPTuZ7hpju+mdii0lCUpuIvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Gupta <rajat.gupta@oss.qualcomm.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0401/1611] wifi: mt76: use kfree_rcu for offchannel link in mt76_put_vif_phy_link
Date: Tue, 21 Jul 2026 17:08:37 +0200
Message-ID: <20260721152524.254910677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Rajat Gupta <rajat.gupta@oss.qualcomm.com>

[ Upstream commit 7fae097aa9a56c30febf539d72ef3773165d3aa3 ]

mt76_put_vif_phy_link() frees the offchannel mlink with plain kfree()
after rcu_assign_pointer(NULL). However, rcu_assign_pointer only prevents
future RCU readers from obtaining the pointer -- it does not wait for
existing readers that already hold it via rcu_dereference.

The TX datapath (e.g. mt7996_mac_write_txwi) dereferences mlink->wcid
and mlink->idx under rcu_read_lock. If a TX softirq obtained the pointer
via rcu_dereference just before the NULL assignment, it will dereference
freed memory after the kfree.

struct mt76_vif_link already contains an rcu_head field that is unused at
this free site -- a developer oversight, since the adjacent
kfree_rcu_mightsleep call for rx_sc in the same function shows the
pattern was understood.

Replace kfree(mlink) with kfree_rcu(mlink, rcu_head).

Fixes: a8f424c1287c ("wifi: mt76: add multi-radio remain_on_channel functions")
Signed-off-by: Rajat Gupta <rajat.gupta@oss.qualcomm.com>
Link: https://patch.msgid.link/20260507043531.492-1-rajat.gupta@oss.qualcomm.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index eccaee1fd434fe..6adaeaf63e46af 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -311,7 +311,7 @@ void mt76_put_vif_phy_link(struct mt76_phy *phy, struct ieee80211_vif *vif,
 
 	rcu_assign_pointer(mvif->offchannel_link, NULL);
 	dev->drv->vif_link_remove(phy, vif, &vif->bss_conf, mlink);
-	kfree(mlink);
+	kfree_rcu(mlink, rcu_head);
 }
 
 void mt76_roc_complete(struct mt76_phy *phy)
-- 
2.53.0



