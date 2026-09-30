Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154BD3515DC;
	Wed, 30 Sep 2026 16:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785857; cv=none; b=tlPZ/ahBSjWzhQ02hWrzS8xPoIGywDn4mFPUn6PA11cbvL0rD6aNfYFxUrzYgI2D0SG6Cwc7T6k5O2Prz6yYC/Zc1cg0DTZihOyq+KvuiEQljVDFYTZwgRoEbvtzAzrqHscvIRP8HQd19IC4w9opCBDsGijsn868BEjdFlOJ460=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785857; c=relaxed/simple;
	bh=ZJ1BormSIf0ItkBm6RjtK4OeoF5vAMXWASsw1xjwGMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkNiqJ1FSvrG+dGJCAplOAspBDH59/FpDOvutIO2gRxLHjZ3I5SKFdlCMASL6D/fbG+rrHNyo9jTdCf9jzYgk5hRlx8ov7NosnBlKxWCc1/eG7bJreLKJAMasMylZ+FTSAYh6J5zljkDhkiiwyimyBK2a6LsdvvatBnN8P3tAfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AlFE3FpI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AlFE3FpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F45D1F000FF;
	Wed, 30 Sep 2026 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785856;
	bh=IlvWDj2/eB8thuSDmo9CRWwInKSFkKwzI1uCoSPd6ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AlFE3FpIUcNdiXxxXKZk7t+ngCZVyTXdjgKynwFu2333g0Rzxgkc9x7VGAgPsqhpe
	 ZXWafk4356ihkBa+RvhfNs/QjRCBfZ8gxrpoAHNxE5fwlh8/D54N+Q1BP2O2ycR9Qx
	 rMDZPzYMYuroLeygjtWWQcSzIqnMvcxJAgNUw+AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+63a84ea9c0f57d6133fa@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 639/982] wifi: mac80211: mesh: release the channel if start fails
Date: Wed, 30 Sep 2026 17:22:55 +0200
Message-ID: <20260930152430.492716742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit ae97fff6495a8764bc0ef281cfe5444f701e527f ]

ieee80211_join_mesh() acquires a channel context and then calls
ieee80211_start_mesh(), which can fail. In that case, the chanctx
isn't released then interface removal will attempt to unassign it
after it's removed from the driver, hitting:

  wlan0: Failed check-sdata-in-driver check, flags: 0x0
  WARNING: net/mac80211/driver-ops.c:366 at drv_unassign_vif_chanctx
   ieee80211_assign_link_chanctx
   __ieee80211_link_release_channel
   ieee80211_link_release_channel
   ieee80211_teardown_sdata
   unregister_netdevice_many_notify
   _cfg80211_unregister_wdev
   ieee80211_remove_interfaces
   ieee80211_unregister_hw
   mac80211_hwsim_del_radio
   hwsim_exit_net

Correctly release the channel on start failures.

Assisted-by: LLM
Reported-by: syzbot+63a84ea9c0f57d6133fa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=63a84ea9c0f57d6133fa
Fixes: 2b5e19677592 ("mac80211: cache mesh beacon")
Link: https://patch.msgid.link/20260908122838.201719-21-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0b425f97977be..b1c9d869305f9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2571,7 +2571,11 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 	if (err)
 		return err;
 
-	return ieee80211_start_mesh(sdata);
+	err = ieee80211_start_mesh(sdata);
+	if (err)
+		ieee80211_link_release_channel(&sdata->deflink);
+
+	return err;
 }
 
 static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
-- 
2.53.0



