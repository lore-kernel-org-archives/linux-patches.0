Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF01D14C5B0;
	Tue, 23 Jul 2024 18:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759441; cv=none; b=udUHynhMF/Uu+qs7uvBDC8eemAl/fToTazB7eEeDcn2UMXA5ZU7gw/V5mFEWOgdBgXOda/zVO6vJphUN6xAQ/+PGZTRwJbTu3Z4UNQU+oL/e9df8AAk+S/Z1t94WpSOlJbZNNpgTOX8yHBSpN/WCoJ9InPA6wX6HX7q5YjKWZmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759441; c=relaxed/simple;
	bh=Nedcz0RiOzowIdUZuJkfKmd+DFUcEc/f5D2FISmPGZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoxZy41+l5UCN+D9mci/i0fT6RQk5CFAK/MFWVf4+4mSlouQB4H3ZnCZlEapws9fNJlbdCOGAEP3AzKhDZ46H2tUQcYjgbGsPF4xlpXn2dEGV1djF2iNQoPlgNsyumBO8ctH17bAnUbkembrXlhtVKbC4A1j3+Zvq71kLLcCBXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJk6f9o2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJk6f9o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA47C4AF0A;
	Tue, 23 Jul 2024 18:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759441;
	bh=Nedcz0RiOzowIdUZuJkfKmd+DFUcEc/f5D2FISmPGZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJk6f9o2sVg8XPATAJnMjbHk3/eoSt/h4GiQr554iBMIglugVfj+hEs6FeyUwthld
	 yfiZ6ABUmmluPullU/xJlbCmJcvOmFgNjxxHdWTpJyyeLhjJwgfE5tPouP6hIZZql0
	 +rOJxLv/N4ULHgRgtP3xnMCY4XCm9D6o2StK4BkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de87c09cc7b964ea2e23@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/129] wifi: mac80211: apply mcast rate only if interface is up
Date: Tue, 23 Jul 2024 20:22:40 +0200
Message-ID: <20240723180405.256952806@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 505f1d6ccd16c..f3fc0be9d8eac 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2953,8 +2953,9 @@ static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
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



