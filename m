Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26776156F37;
	Tue, 23 Jul 2024 18:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759149; cv=none; b=gwCSl763L/8OatSNBX+sPOhNuwYUoS7l2mt5pRlLZM3Gnw7EokeXXNBM1eRBbFcCDHRvgAeHYWwFR8DwSdtpuZDQ1DmrgTeZ13U/NtgE9spQeOyXbfbAt00NLma/4+PjAYyfZPHIDQx5HTv6oiTU6sHbuTZL2+3+cxJwZlJy1H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759149; c=relaxed/simple;
	bh=Dyynr/zrwPY+G+agNMizkLzg3KQDFIGX3GhgCwKZ2Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8YOmxpzUc5tdZnx3ZLIxoCbHHiIMelF/OVQkYCv+xAc+07We2WbraQYRrftHLmmET7ha80cVzx78Ya2K01q0VhjZk9QAsgkPRpUdefQWObxPk8dhrmdoMKnwbMWhgu+Zl1JT4RDm5TAwXZ3n7YdmLDsGjJ67BAXHRufykbnbuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PypYa6uz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PypYa6uz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1366C4AF0B;
	Tue, 23 Jul 2024 18:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759149;
	bh=Dyynr/zrwPY+G+agNMizkLzg3KQDFIGX3GhgCwKZ2Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PypYa6uz2ejrQZt3CwWsaycSXqtT/ZSWjdCZ+HaI88yPzWa0LbisRsCR3WdUx43X/
	 hUtVqi7VmHDvSMhVreNMIpXztvV3MzZ9njaALL3b3DQ/oWaT7PO98L3XrfbJqT7qt1
	 g4zjVDgsthmJu9Z1aWFetZT5U9qR0dgQkbWNEjmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de87c09cc7b964ea2e23@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/105] wifi: mac80211: apply mcast rate only if interface is up
Date: Tue, 23 Jul 2024 20:22:56 +0200
Message-ID: <20240723180403.658148693@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 02c665f048a439c0d58cc45334c94634bd7c18e6 ]

If the interface isn't enabled, don't apply multicast
rate changes immediately.

Reported-by: syzbot+de87c09cc7b964ea2e23@syzkaller.appspotmail.com
Link: https://msgid.link/20240515133410.d6cffe5756cc.I47b624a317e62bdb4609ff7fa79403c0c444d32d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1e57027da2913..2c60fc165801c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2838,8 +2838,9 @@ static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(sdata->vif.bss_conf.mcast_rate, rate,
 	       sizeof(int) * NUM_NL80211_BANDS);
 
-	ieee80211_link_info_change_notify(sdata, &sdata->deflink,
-					  BSS_CHANGED_MCAST_RATE);
+	if (ieee80211_sdata_running(sdata))
+		ieee80211_link_info_change_notify(sdata, &sdata->deflink,
+						  BSS_CHANGED_MCAST_RATE);
 
 	return 0;
 }
-- 
2.43.0



