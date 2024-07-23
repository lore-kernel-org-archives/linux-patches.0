Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FBB13C3F5;
	Tue, 23 Jul 2024 18:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759837; cv=none; b=nOqdTeKwlsITMu14Ch51q8nQ7eRgA/Q2ByLSiswNZwvseXEAsbQ9a+sGtPec6ztlKijkSXY5imjgKzqudLTOjhwiVf4LZl8zkau1rIkKs3wbPwvH6yv8h9sPI6ruxOtWEqz1u+d3PrNf0hgwcmjJKz4nV9/1+qPhbfVAlzjMVTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759837; c=relaxed/simple;
	bh=+tKSPDXH+DVXgQENGWawK+Y1f76JU3UBqLUk8wCBoy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdxwLOimDJdP0qnUMPFF/yjEOPxJ55JMHuSv/XrY3GAluZjvOzTbsg9Q3oBQVHsG+Q4DTWCcIINSMx71O1+BmFP7Upole/xYI2+eQdGzL7A7Wu+DF6+11ThvK/tX3KLiAb8VcVEgEwJQLLpLSj265L/rqnqmeovL3uvJOk+4wYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+ZuBcWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+ZuBcWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A034BC4AF09;
	Tue, 23 Jul 2024 18:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759837;
	bh=+tKSPDXH+DVXgQENGWawK+Y1f76JU3UBqLUk8wCBoy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+ZuBcWAf/1YhjeKghlWDVzC0L82JPc0zCEvrtoZoh/BLZEkoRcEJRh3DoZIclMWu
	 ML0m4fd2yPewl+/h2LwgdtmtMPPW1xB2+95omcdIK+CVvntIjVgnhESHPA+z2AOwaG
	 zosQQryDPo18DCqxgSHwymZ129ECF/HfxvsuQ2rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de87c09cc7b964ea2e23@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 015/163] wifi: mac80211: apply mcast rate only if interface is up
Date: Tue, 23 Jul 2024 20:22:24 +0200
Message-ID: <20240723180144.059210416@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 51dc2d9dd6b84..d0feadfdb46e1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2954,8 +2954,9 @@ static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
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



