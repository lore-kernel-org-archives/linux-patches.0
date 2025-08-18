Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA64212DDA1;
	Mon, 18 Aug 2025 13:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522063; cv=none; b=oNjdt3esLWkWHgUxBvg/BfeQ6UMwxJP9Aza6zScmGEhXudC/PxynLeOzAT/iQSI5fqsnXJxeB4GU37voQbC5Fi+XeLGcxTynuN42sr5RVTAtGmU9sKXspWAjI7rZ/yKkq0BZPihRg/BmCVF2flhkn59XwBFGdrlKfSkFmtL8B38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522063; c=relaxed/simple;
	bh=ruZrxXIayvxCQCB1fF3o79W4HjCNE2+KZhv2B+ei/4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6VKnN/OctsurncaUsiRWby/Ho3GV8mWPXGV2D+lXaFn+xSF7VQaDKTYUq5O7wtGdvGBp8wLGMXLqdDSrs22jbFf338yK1mgEMvOg+TNqhycqG7lR4GRiE7xSVnOrLyb1RR1PcMlRVtxq4BJu83Ii6ibVYGSUVLgDPSQ5uGDqPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nr/IcxA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nr/IcxA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83B8C4CEEB;
	Mon, 18 Aug 2025 13:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522063;
	bh=ruZrxXIayvxCQCB1fF3o79W4HjCNE2+KZhv2B+ei/4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nr/IcxA1EP4+yQ7fj2+Zzf0fvlRikjYzDdygrmhGTjT//OaiWiDkZg0+fARPMVIX/
	 1aEupqbo7dR5iEoMEdqOk77VW0k/0SFUdg8apVuvbtm6IDT/aibgQjmD3EzeT+D8QY
	 gzGpZgmMl+J4myCqQnm7jXSiEcc/pMR3FzUjG+RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/444] wifi: mac80211: dont complete management TX on SAE commit
Date: Mon, 18 Aug 2025 14:43:49 +0200
Message-ID: <20250818124456.473187652@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8e7094160206..155421671fff 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4269,6 +4269,8 @@ struct ieee80211_prep_tx_info {
  * @mgd_complete_tx: Notify the driver that the response frame for a previously
  *	transmitted frame announced with @mgd_prepare_tx was received, the data
  *	is filled similarly to @mgd_prepare_tx though the duration is not used.
+ *	Note that this isn't always called for each mgd_prepare_tx() call, for
+ *	example for SAE the 'confirm' messages can be on the air in any order.
  *
  * @mgd_protect_tdls_discover: Protect a TDLS discovery session. After sending
  *	a TDLS discovery-request, we expect a reply to arrive on the AP's
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1bcd4eef73e6..5a9a84a0cc35 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4292,6 +4292,7 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_prep_tx_info info = {
 		.subtype = IEEE80211_STYPE_AUTH,
 	};
+	bool sae_need_confirm = false;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
@@ -4337,6 +4338,8 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 				jiffies + IEEE80211_AUTH_WAIT_SAE_RETRY;
 			ifmgd->auth_data->timeout_started = true;
 			run_again(sdata, ifmgd->auth_data->timeout);
+			if (auth_transaction == 1)
+				sae_need_confirm = true;
 			goto notify_driver;
 		}
 
@@ -4379,6 +4382,9 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	     ifmgd->auth_data->expected_transaction == 2)) {
 		if (!ieee80211_mark_sta_auth(sdata))
 			return; /* ignore frame -- wait for timeout */
+	} else if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
+		   auth_transaction == 1) {
+		sae_need_confirm = true;
 	} else if (ifmgd->auth_data->algorithm == WLAN_AUTH_SAE &&
 		   auth_transaction == 2) {
 		sdata_info(sdata, "SAE peer confirmed\n");
@@ -4387,7 +4393,8 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 
 	cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 notify_driver:
-	drv_mgd_complete_tx(sdata->local, sdata, &info);
+	if (!sae_need_confirm)
+		drv_mgd_complete_tx(sdata->local, sdata, &info);
 }
 
 #define case_WLAN(type) \
-- 
2.39.5



