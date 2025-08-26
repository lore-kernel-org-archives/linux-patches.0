Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4872C3451A0;
	Tue, 26 Aug 2025 13:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216402; cv=none; b=rifGP1TsecjnQTfTwwlXPFs+nEo3RUJg4rsNTB7yqQpU5eC7thNVxNp1Qs5g6voZgldFaH0jqmSk3qavfPoe8prsiuiuR1wv0IXuE5dDZjUlnVO8Wrjl1KciJIp+aXjYK6xZwf3R1sFbAflXeadj6q+gEez8iUQpVzy/nKOXVJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216402; c=relaxed/simple;
	bh=bgz22AhpP7fBVcsTv+T9dXnwV19cg1mltLtYm/I7Cz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvn5TCkiQFv69sCRFfvua1tUH4kCobgyIkj/MxXgExCDadlyJJaMBLxXJnZK+Gi3L4ftEdu0EhfhDLiFBKfaJUL9ljgg824SsklbxXdCr1MnIbDqB481amVDUS+9Nju/iMxi3pF8h4C2LIlj/Yx7pXXRfgcpJrZ5dSLaxwo8+j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wa8SbdOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wa8SbdOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C982FC4CEF1;
	Tue, 26 Aug 2025 13:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216402;
	bh=bgz22AhpP7fBVcsTv+T9dXnwV19cg1mltLtYm/I7Cz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wa8SbdODtS7uUFuDireDiYElucdC4ht1IJScVzVvYQ+myl4QEwHmvZ//LkZRvsBEG
	 YOlwZt/1Y6FhdK9UTtTdax3ZVgBLrgKrcU9k3A7tWZFPFNHNnlrqSz7eJQfmGF89Lr
	 P/yba5JBQbLHuBApYEDkZNuhTr+ZsBRkLngXdtUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 354/644] wifi: mac80211: dont complete management TX on SAE commit
Date: Tue, 26 Aug 2025 13:07:25 +0200
Message-ID: <20250826110955.170591291@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6b04716cdcac37bdbacde34def08bc6fdb5fc4e2 ]

When SAE commit is sent and received in response, there's no
ordering for the SAE confirm messages. As such, don't call
drivers to stop listening on the channel when the confirm
message is still expected.

This fixes an issue if the local confirm is transmitted later
than the AP's confirm, for iwlwifi (and possibly mt76) the
AP's confirm would then get lost since the device isn't on
the channel at the time the AP transmit the confirm.

For iwlwifi at least, this also improves the overall timing
of the authentication handshake (by about 15ms according to
the report), likely since the session protection won't be
aborted and rescheduled.

Note that even before this, mgd_complete_tx() wasn't always
called for each call to mgd_prepare_tx() (e.g. in the case
of WEP key shared authentication), and the current drivers
that have the complete callback don't seem to mind. Document
this as well though.

Reported-by: Jan Hendrik Farr <kernel@jfarr.cc>
Closes: https://lore.kernel.org/all/aB30Ea2kRG24LINR@archlinux/
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250609213232.12691580e140.I3f1d3127acabcd58348a110ab11044213cf147d3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h | 2 ++
 net/mac80211/mlme.c    | 9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c713edfbe2b6..f101ef4a1fd6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3787,6 +3787,8 @@ struct ieee80211_prep_tx_info {
  * @mgd_complete_tx: Notify the driver that the response frame for a previously
  *	transmitted frame announced with @mgd_prepare_tx was received, the data
  *	is filled similarly to @mgd_prepare_tx though the duration is not used.
+ *	Note that this isn't always called for each mgd_prepare_tx() call, for
+ *	example for SAE the 'confirm' messages can be on the air in any order.
  *
  * @mgd_protect_tdls_discover: Protect a TDLS discovery session. After sending
  *	a TDLS discovery-request, we expect a reply to arrive on the AP's
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ae379bd9dccc..6e86a23c647d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2960,6 +2960,7 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_prep_tx_info info = {
 		.subtype = IEEE80211_STYPE_AUTH,
 	};
+	bool sae_need_confirm = false;
 
 	sdata_assert_lock(sdata);
 
@@ -3005,6 +3006,8 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 				jiffies + IEEE80211_AUTH_WAIT_SAE_RETRY;
 			ifmgd->auth_data->timeout_started = true;
 			run_again(sdata, ifmgd->auth_data->timeout);
+			if (auth_transaction == 1)
+				sae_need_confirm = true;
 			goto notify_driver;
 		}
 
@@ -3047,6 +3050,9 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	     ifmgd->auth_data->expected_transaction == 2)) {
 		if (!ieee80211_mark_sta_auth(sdata, bssid))
 			return; /* ignore frame -- wait for timeout */
+	} else if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
+		   auth_transaction == 1) {
+		sae_need_confirm = true;
 	} else if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
 		   auth_transaction == 2) {
 		sdata_info(sdata, "SAE peer confirmed\n");
@@ -3055,7 +3061,8 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 
 	cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 notify_driver:
-	drv_mgd_complete_tx(sdata->local, sdata, &info);
+	if (!sae_need_confirm)
+		drv_mgd_complete_tx(sdata->local, sdata, &info);
 }
 
 #define case_WLAN(type) \
-- 
2.39.5



