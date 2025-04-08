Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A27263C83;
	Tue,  8 Apr 2025 11:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113500; cv=none; b=K3Nzow37exA1QTzvl96pnI+/msxZkX5CUyqorhCtA11cMUae+dtpqR1RG9FeR/E8B0zrEL7pjHpRu9VjNLRzGXIsVP6JmBDWAC6Vq/4kNfpadkMJETicXvOS74E0naaEqrzS7czKCWvo1FxSi75MVTXm8/pjiOy0dZYZx3qCl8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113500; c=relaxed/simple;
	bh=3rZG/bPSuAZ75HAArvjJnKqYihqvVkttjbYQei3Ryhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1/cPuJR39W5Cl1MxrJNPck7GWhQDR4ybyYg+kqALFU9wfS2OXQUoEYH8XJ9KKb2GOXpsPvC/r0vCmpY6ndVYydNsFuzHatrLtZ7nRQbM5hIEdbzajNouMNhPQM1yTamjPBSMyl6ZATjIuhm8BEoslLrHY3Usz9sWM2bGQJcrcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOaLELY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOaLELY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0C0C4CEE5;
	Tue,  8 Apr 2025 11:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113500;
	bh=3rZG/bPSuAZ75HAArvjJnKqYihqvVkttjbYQei3Ryhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOaLELY4CgdFvVHBUcicFuF3DxLwsIqaTVQxxJbP3RkCuGTXm5uP0Qk9rThZ65yOL
	 qEIxLRt9Ax/1swsEdXpoQylibtcap2ropa8wc3s5lQn8aF6wECm25gNA3Ne/HVvF92
	 fvNgHFkmVefBK2MsrvTckc0K9EPSFZ+cozfLVIk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 181/268] wifi: mac80211: flush the station before moving it to UN-AUTHORIZED state
Date: Tue,  8 Apr 2025 12:49:52 +0200
Message-ID: <20250408104833.428527700@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 43e04077170799d0e6289f3e928f727e401b3d79 ]

We first want to flush the station to make sure we no longer have any
frames being Tx by the station before the station is moved to
un-authorized state. Failing to do that will lead to races: a frame may
be sent after the station's state has been changed.

Since the API clearly states that the driver can't fail the sta_state()
transition down the list of state, we can easily flush the station
first, and only then call the driver's sta_state().

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250306123626.450bc40e8b04.I636ba96843c77f13309c15c9fd6eb0c5a52a7976@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5d71e8d084c45..64cf5589989bb 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2023 Intel Corporation
+ * Copyright (C) 2018-2024 Intel Corporation
  */
 
 #include <linux/module.h>
@@ -1321,9 +1321,13 @@ static int _sta_info_move_state(struct sta_info *sta,
 		sta->sta.addr, new_state);
 
 	/* notify the driver before the actual changes so it can
-	 * fail the transition
+	 * fail the transition if the state is increasing.
+	 * The driver is required not to fail when the transition
+	 * is decreasing the state, so first, do all the preparation
+	 * work and only then, notify the driver.
 	 */
-	if (test_sta_flag(sta, WLAN_STA_INSERTED)) {
+	if (new_state > sta->sta_state &&
+	    test_sta_flag(sta, WLAN_STA_INSERTED)) {
 		int err = drv_sta_state(sta->local, sta->sdata, sta,
 					sta->sta_state, new_state);
 		if (err)
@@ -1399,6 +1403,16 @@ static int _sta_info_move_state(struct sta_info *sta,
 		break;
 	}
 
+	if (new_state < sta->sta_state &&
+	    test_sta_flag(sta, WLAN_STA_INSERTED)) {
+		int err = drv_sta_state(sta->local, sta->sdata, sta,
+					sta->sta_state, new_state);
+
+		WARN_ONCE(err,
+			  "Driver is not allowed to fail if the sta_state is transitioning down the list: %d\n",
+			  err);
+	}
+
 	sta->sta_state = new_state;
 
 	return 0;
-- 
2.39.5



