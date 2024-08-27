Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A32B1C8FA0;
	Tue, 27 Aug 2024 15:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771885; cv=none; b=ECNzKYQ1v9xitGh5CDdRD6SUTFuvGFYqtnm8s9k6cpjHoEj525KUA9iMCQU2J+nJGP7Rt1696FQ8j1o50VWbEinx8b5xGqvpp2NjOvcaGzQVscbNZrW2N96slDYu0kmXBb/MAbzlGpIr9XNWb+2AJczJNcLrB+pyW7YmTxdOKW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771885; c=relaxed/simple;
	bh=IcniGGX+BPHiaI6z2YDRqSOfTDc2mZdZswKHMMe7BVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrsneZAhSEYRKzcc506DhK/eJcdfbDDfoZPaCg0WLNCZTlFYdWLjQnfXGn1v/kPWp1HvHui4jxFAybmc2rOdANq+sc/sAjeKyPzyr4ks/Pq9+i7AmoRKF+I5G4FgDXZ8IkA8c34hY1SzKoQD4vxUWZTnpRxY/zqKQjiad/15OR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5zFxxT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5zFxxT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B02C61040;
	Tue, 27 Aug 2024 15:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771885;
	bh=IcniGGX+BPHiaI6z2YDRqSOfTDc2mZdZswKHMMe7BVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5zFxxT9i+WFednwFus8xe7Z4vrJgeZolAdrPEC82YW/XJ0P85noWTdt64D13ZVeN
	 yq+jD7ZVVquBoLzmX/YanL6nrE9UVYVesum4H/d1VW1ZdFuiRe/4nmOxBH4RLJIe2o
	 go3il+bOFOROZLQgEPH/3LgLcYJxKShHW2eGdcfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+25b3a0b24216651bc2af@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/321] wifi: mac80211: fix change_address deadlock during unregister
Date: Tue, 27 Aug 2024 16:35:58 +0200
Message-ID: <20240827143840.137096566@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 408ee5afc9ae7..6a9d81e9069c9 100644
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



