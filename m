Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CBE1BA868;
	Thu, 15 Aug 2024 14:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730988; cv=none; b=TboO8Tes7KbwRVUvxx6vnVjpytT3gys02zz7Lrv0fJTaip5mOOtoG9T4ONWlSM5CCFYT+u/xYsBJVWWw5cTTCtSjSer+dSBUens+stqAsDr+uQfnw8/vtAb7IuhTN8a4lzVY58GShK6OVWO62AtTPwOwh2GcTzUSJ9XZdU2es00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730988; c=relaxed/simple;
	bh=IJV4OzBsGWmswCn/fhrJdKR+FrsgpSKvRY9DKjPkJB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPe2mfyDd2C5PBklfLrQbuIUsrIUz0mrLMEM2H1Kwqf4WWakuIfwW+09GOjs6Khy9PncIQceOCHuhEfIm0sPofvTpoSPueNMFTcvgcHOS2HTTzM836AR1NChtLex3/vb87PL4piiItes/FYqPliG8glkQX3Dl3FAVvi/HiJUCiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NHE3aSTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NHE3aSTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A876FC32786;
	Thu, 15 Aug 2024 14:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730988;
	bh=IJV4OzBsGWmswCn/fhrJdKR+FrsgpSKvRY9DKjPkJB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NHE3aSTkRfI2f3rQAVJE7QoTguC5BwhPcekNwzZ8B5CUFEIC6pqNfCxum/KtN6RZU
	 9O5HI+v8cNSvNQrABjVG68CUhaSq1OwUyTS+ZSwH+EKys0uD9/WaVeILyU5kumefnV
	 ZCh8r58rhGqMBF/xhWGrOVyoNAg71L8yJ0M07skI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+25b3a0b24216651bc2af@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/67] wifi: mac80211: fix change_address deadlock during unregister
Date: Thu, 15 Aug 2024 15:25:38 +0200
Message-ID: <20240815131839.261722363@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

[ Upstream commit 74a7c93f45abba538914a65dd2ef2ea7cf7150e2 ]

When using e.g. bonding, and doing a sequence such as

 # iw wlan0 set type __ap
 # ip link add name bond1 type bond
 # ip link set wlan0 master bond1
 # iw wlan0 interface del

we deadlock, since the wlan0 interface removal will cause
bonding to reset the MAC address of wlan0.

The locking would be somewhat difficult to fix, but since
this only happens during removal, we can simply ignore the
MAC address change at this time.

Reported-by: syzbot+25b3a0b24216651bc2af@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20231012123447.9f9d7fd1f237.Ic3a5ef4391b670941a69cec5592aefc79d9c2890@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 9ac5252c3da00..52b048807feae 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -300,6 +300,14 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
 	struct ieee80211_local *local = sdata->local;
 	int ret;
 
+	/*
+	 * This happens during unregistration if there's a bond device
+	 * active (maybe other cases?) and we must get removed from it.
+	 * But we really don't care anymore if it's not registered now.
+	 */
+	if (!dev->ieee80211_ptr->registered)
+		return 0;
+
 	wiphy_lock(local->hw.wiphy);
 	ret = _ieee80211_change_mac(sdata, addr);
 	wiphy_unlock(local->hw.wiphy);
-- 
2.43.0



