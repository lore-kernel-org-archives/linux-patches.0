Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270F51FBEA6;
	Sat, 12 Sep 2026 16:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230946; cv=none; b=sfgoCwD8QVxLBWeTrAT+nSBW10D3z1oGD+25sUBUYvpHVsI3giURVH8OspDaSe4qnOn8Md/nmrhfvSouUw5mHpAIGc1171dSqnpBdOS1Qci0NcDbOTf2o/e/dKcW+uRnyAyMMWDmuWPc2JLDF0LQeo5IzNGp3216BjHzcykPSF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230946; c=relaxed/simple;
	bh=igt8sIsqgvm4Ql6pMrwcnmftoL+PwHELMb+Bt6OPMKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zk50qi/hBc5+OxWd8uABokvGpcvT2B+cxd9+7Wrdmjht6MDc8o8SSxwRDq0tASsO1nlIiGiHe5CEv9J1JHT0vEHvPzZKZF4wtg8EF9E31DyTauANCRdd+KS1P4Rr8NtTqkRXsbx4NQfgf9DRX2t61zXwegOg8sJ+3w6VYX7V6rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ECsju+z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ECsju+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01ADE1F000FF;
	Sat, 12 Sep 2026 16:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230945;
	bh=cSUUG8kDqoyfKtAAZ1Q3/5jWJQ/iST6v62Zt2CeEmXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ECsju+z0Kdijqr9W4jCJNxI1rCV++QI2VW5Zb0jS6DnZeFVfcesn0y9P7gcFialS
	 PEHSmyEJ8yFPDgLTd74c/hdYd8l0JG57O9GnedLpQLC8L7Z8aspjQ5CAFUa6hrjn03
	 RQrxGM1rT/YHMO9tSYEk6x6AsDHP8biCh2Kg0hhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0898/1191] wifi: mac80211: skip default WMM setup for AP_VLAN links
Date: Sat, 12 Sep 2026 09:00:26 +0200
Message-ID: <20260912065608.405738767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 4d8cfff012aaa971d50b01823b1015c1073c3ff6 ]

AP_VLAN interfaces are never passed to the driver, so setting default WMM
parameters on their links trips the check-sdata-in-driver warning in
drv_conf_tx(), as well as in the BSS_CHANGED_QOS link info notification.
Skip it, matching the existing AP_VLAN handling in this function.

Fixes: 2259d14499d1 ("wifi: mac80211: set default WMM parameters on all links")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20260804082608.2011433-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/link.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index cd84e7f3b742e..abca9d627cfc2 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -230,7 +230,8 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		link = links[link_id];
 		ieee80211_link_init(sdata, link_id, &link->data, &link->conf);
 		ieee80211_link_setup(&link->data);
-		ieee80211_set_wmm_default(&link->data, true, non_sta);
+		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+			ieee80211_set_wmm_default(&link->data, true, non_sta);
 	}
 
 	if (new_links == 0)
-- 
2.53.0



