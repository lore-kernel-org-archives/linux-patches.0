Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C84839FCDC;
	Sat, 12 Sep 2026 08:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201227; cv=none; b=kHcvbzLvgvexAsWSvU5DZYEolRpgxZhUO1WSHKpsBWOIHVLBAjReOODKko8X5qi86x5IJBveuouvaiJtEWz/G5gCmcDIcOs/G9k07ULnQ8SmofzzHayQ/Vt95nuL5B50bOc/uNR4q1FZZmnb3MfvvmG7DrKP4JZ9uySICDHwRas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201227; c=relaxed/simple;
	bh=7m8OFr2l4h+gTuVmFn4TwWKwl8HPZDKBBSgdEIw30OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yx7Ffj9CxOMNeJbHfKNb90mXjvfiZcs/g62b5tNvSOsu5vGubKteevHiJS+gdt94ZXQZ494ht6cO986cntVgchX++V2H8xHjD+AoKwAU7gVSj7fEBm/Q9ilJamMJOPSBLlUhL99kyJVlyUvLRRUMnZfB3DmFpLyX9ITzk9iS6eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGtIwPnH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGtIwPnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A90341F000FF;
	Sat, 12 Sep 2026 08:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201225;
	bh=0C7yb2/AbFGGSs0tOAQfLA8MMbwKH9sdiD46yE47FgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGtIwPnHvwMoWnCGjJxzHnVAJe2G2lPBM882niCT+87cbY5yr15RmJznaCEb6bn7p
	 P2muQoPpbjwZxzv3SNs0w97122YaeobWIyIBxYMuY4zKO869YgJdgXfEx15/S4GkJ4
	 NAA9qH/4X7IoCvi+kZTPm07ff1y7oonK1e3hhxXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0951/1815] wifi: mt76: reject out-of-range link ids in mt76_vif_link()
Date: Sat, 12 Sep 2026 08:45:01 +0200
Message-ID: <20260912065711.291356734@linuxfoundation.org>
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
index 640061276d762..476578e2fbf0c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -2128,6 +2128,9 @@ mt76_vif_link(struct mt76_dev *dev, struct ieee80211_vif *vif, int link_id)
 	if (!link_id)
 		return mlink;
 
+	if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+		return NULL;
+
 	return mt76_dereference(mvif->link[link_id], dev);
 }
 
-- 
2.53.0



