Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF0C486B8C;
	Wed, 23 Sep 2026 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174283; cv=none; b=mcXeMgzkZNkthIFfX1IHtYY0GSix/BzTbRGMgZiF8BJEE/nyqep1vQM6H1eam+FvTAAPfk1zlnCZ5LKrWlT/kKWHWC85Auur9LKV1xbNMBA9NRJDylaPMvcNbXq1sKjYTwa/WYaQPSWRJdiVpKv6VELkO/y6sNi8W+ac5pq6N90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174283; c=relaxed/simple;
	bh=MpMirQuwLFPaza0wrakNUmVBRCRz8qhwzDIc6eRf44o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkLnbqhnruEY+Bi/rgHSGUFAYfvyFEEjdYdljCs31OT0H9PThBz2EK2tgywWbP7LXcDFySjLcIBmhdqLAitLbszHYbKh5tPMvueRe0ScW5xQVjIuaGwju1OFugfOY5QQ+VrBrIoosfXRBwt6FJXIf+fTzKthEtx4hhRkserhMAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmDafXFC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmDafXFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25DE1F000FF;
	Wed, 23 Sep 2026 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174282;
	bh=EF6AUFSy80KYKwi7XRdXZSbYV+nXYR4sFfwj24LEmDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmDafXFCs5hXea60OFos6ion3Al3qHvYOJbhdPiktD6BGIzBbMMsO52zPZjy2q6yB
	 OZceBLwu5knWyofi8nrx+gJFdZImpsgY+qMFiq1m/VOsI+xXJnNrIew6wrTWQdOvrV
	 2NN/Nj1gOBBw0j5ErjkbdG3rv9EoUrH6rR+BVvCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f1ba58d6b55abd13239e@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 064/398] wifi: mac80211: dont offload TC setup on AP_VLAN interfaces
Date: Wed, 23 Sep 2026 16:02:18 +0200
Message-ID: <20260923140645.090376117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index 499126317a914..82eff9e867c1f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -896,6 +896,9 @@ static int ieee80211_netdev_setup_tc(struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		return -EOPNOTSUPP;
+
 	return drv_net_setup_tc(local, sdata, dev, type, type_data);
 }
 
-- 
2.53.0



