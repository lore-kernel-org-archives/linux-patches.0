Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35909371887;
	Sat, 12 Sep 2026 10:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209352; cv=none; b=MRXS6Pzl5tNlfJqNgf+dk9VJTKV1JmubZv8qaCOVZ8SWId8UzCcHAlXSD5d7PV2X8UvaBMEtGYtDVZhJt38/BwJ/WXtj+TUkasXZVWLWVlBxiDjIMU+NPN6cn6zGe73YLF9MB0qNs6vksqYor4jp4FEo8CMvbFETRNrx4Lru1Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209352; c=relaxed/simple;
	bh=AT9/y+ApkWjymNatw/lrDOKU214ssz/6KUpHSV/W3ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qW7LDqD/hTmAI4/HIEdh5bm0jdDsFOnK6O6gjfA0EwhfuqCMOgrJJ6nCZ5szGCYEos6++Kso3e8CFHp+1gnvCUP75kVWcfdaatua/t2Co8xyBvDIlKDq+nfRQNV4Z0x3rqJylhts8swzynjoRheWAu7nZxH6N/+VABVSkwmNfm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0bSAcco; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0bSAcco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1E41F000FF;
	Sat, 12 Sep 2026 10:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209351;
	bh=YuAXpDmFOvAEP73ZJ7E19f516+tPxG437gnOl4Nn4NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0bSAccoeJoOSCXGA7vv8nCiTa5XcvmAIv94rxWxXHJo9GQ0nN3tVfGTO/rUm9MCR
	 3/Bd8dpZz/8G1j6JB2x6sOj6s78h2uk16tv4MIMkyMJI58lZvVnIcATxXQqlpZ3rVj
	 RQdLg22LurwfPm1JXghWWU5Zr26Kxhq7qJJO/5qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0803/1518] wifi: mt76: reject out-of-range link ids in mt76_vif_link()
Date: Sat, 12 Sep 2026 08:49:32 +0200
Message-ID: <20260912065641.598604815@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 9ba744a28c26eaa5cae930688a22e01888395308 ]

mt76_vif_link() indexes mvif->link[] without validating link_id, but
callers pass mvif->deflink_id / msta->deflink_id, which hold
IEEE80211_LINK_UNSPECIFIED (0xf) until the first link has been added.
Since IEEE80211_MLD_MAX_NUM_LINKS is 15, that reads one element past the
end of the array, aliasing mt76_vif_data.offchannel_link.

Reachable via mt7996_set_tsf()/mt7996_offset_tsf() and
mt7996_net_fill_forward_path(). Bounds check link_id and return NULL,
matching mt7996_sta_link() and mt7996_sta_link_protected().

Fixes: a9384b36a42a ("wifi: mt76: mt7996: rework set/get_tsf callabcks to support MLO")
Link: https://patch.msgid.link/20260801145334.1166751-9-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 03e53a6a23b31..5560787718599 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -2071,6 +2071,9 @@ mt76_vif_link(struct mt76_dev *dev, struct ieee80211_vif *vif, int link_id)
 	if (!link_id)
 		return mlink;
 
+	if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+		return NULL;
+
 	return mt76_dereference(mvif->link[link_id], dev);
 }
 
-- 
2.53.0



