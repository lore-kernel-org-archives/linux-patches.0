Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C376A3B42E7;
	Wed, 30 Sep 2026 19:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796149; cv=none; b=h468LGPCPjbMNiru5JMuKNbJl+OUrpq9b/TdKP1gDaOtAX8Da57li961G/0pvbqXJQikJRLo/CKFlNztFOc3J9k6ujYdo9ZsjkLFqbfIY0BjJD1p2rRHSGXk5oHwmRzARY33c5zPjobd4CasuvVKMIorPgoOmPVLxVh0iY+bpd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796149; c=relaxed/simple;
	bh=4hzJwXdwysPEuThTfKnILVgbyHxrivg+ZwjGF6FhMfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU/xN7y/jaPyvRFTpbrl50cvfzTXK9NZ9Yzsw9lfNvsR/W4uzB+xGmjH230DGel4/FxsASK+QM/ugrCVUdlUGLE4Fi2CRhmLFibg5KkuepbhIuDCU6FD/N5oFqq5Uz7fXv5ArvdYrTl4MDL6Wn2VbJb4zsbEn9Q5/oSjlQsiU0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTRIqstE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTRIqstE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98981F000FF;
	Wed, 30 Sep 2026 19:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796148;
	bh=rQK/cboRB7gtOSdnzmff7R0wvvOQ1za28LQM3QBh9Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTRIqstEydA7ECKXvpJR0laKEkTkHX80H6ZARyNlzGhkxCcMZ3bZpchun6eFTuH4S
	 DjR3+tJIsHvEsLrA5DiaTxFTElwjz5y+FDCgMf538+9XOnT0DfZnkfaznPU+HMU8aT
	 mAfNdb9bQ+dBKgZzEkLlPfW/5trSsJXA9YAszpyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0756/1193] wifi: mac80211: dont offload TC setup on AP_VLAN interfaces
Date: Wed, 30 Sep 2026 17:24:00 +0200
Message-ID: <20260930152451.048996384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 362bd5bce29ed0f6fd3d39a7065567777d70606e ]

AP_VLAN interfaces are purely virtual, so don't try to offload
TC setup to drivers. We can't really use the AP interface either
since we may not know it all the time, and it could technically
even change.

Just reject the TC offload so things get done in software.

Assisted-by: LLM
Fixes: 61587f1556fe ("wifi: mac80211: add support for letting drivers register tc offload support")
Reported-by: syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f1ba58d6b55abd13239e
Link: https://patch.msgid.link/20260904165722.726cc076cecb.Iccfd88b13635425e850ce031376eb60a4ce5f4f8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d4a554d6d5de5..583d257f593c2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -876,6 +876,9 @@ static int ieee80211_netdev_setup_tc(struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		return -EOPNOTSUPP;
+
 	return drv_net_setup_tc(local, sdata, dev, type, type_data);
 }
 
-- 
2.53.0



