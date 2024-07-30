Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE38E1A6161;
	Tue, 30 Jul 2024 16:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356551; cv=none; b=tRKqicCDS+ot5Qv7RUHkSzZtClLpd3+kuTThSEKQVzggOufxH97aDs/QdRaPQ+BdDlwnSWYzbSBO5NYkaYh2f9RzI//WD44nT9GkaAaBHW4UgGTsC12hxBitzQCoTxI5LVhjdaYOF/hhxi5KHOvCf2BoqMBDzVnObbNC4J1eHV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356551; c=relaxed/simple;
	bh=6aXKSVCmi/odxqDI5rWCYMvVop61gQ2EVo8w/7+g3kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQRIAbnV/6x0X6HLcFmrAHHoqgk2ybGBaSvSLfIgb3BM5c8t6xee/P9IUFfqKZxVfSDHlY1apbHLcCL8KjCBM/fr8d86H4lFlJ0tuOvAzo9I+iICxtdUQvP+jo8KWugGh1hlg6HHWYmSm/PnvkgH2giEORqH2Dx+OESddpma34A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mb/Nlh1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mb/Nlh1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C27C32782;
	Tue, 30 Jul 2024 16:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356550;
	bh=6aXKSVCmi/odxqDI5rWCYMvVop61gQ2EVo8w/7+g3kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mb/Nlh1pA9aztZvvFFRTz9XNlKHqSfDOjM38e6WkZtGlUe0Pab7LWSrbgTjWLmJQk
	 S0koFkfVSSsDoesL9TSLlNsZKqfZ3sydB7dI9N/6/nUO9MqQptskd0A7NDff0ja9rt
	 Bz4BGzd3Y96Zkf1xFtA/PfJDlN92RRqvN0jkLpSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 161/809] wifi: mac80211: cancel multi-link reconf work on disconnect
Date: Tue, 30 Jul 2024 17:40:37 +0200
Message-ID: <20240730151730.961909069@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 53b739fd46462dc40fd18390d76f2ee05c18ea3a ]

This work shouldn't run after we're disconnecting. Cancel it earlier
(and then don't cancel it in stop later.)

Fixes: 8eb8dd2ffbbb ("wifi: mac80211: Support link removal using Reconfiguration ML element")
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240506211034.ac754794279f.Ib9fbb1dab50c6b67f6de9be09a6c452ce89bbd50@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index edac1578d425c..72e38e42f6da0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3289,6 +3289,11 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
 				  &ifmgd->neg_ttlm_timeout_work);
+
+	sdata->u.mgd.removed_links = 0;
+	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
+				  &sdata->u.mgd.ml_reconf_work);
+
 	ieee80211_vif_set_links(sdata, 0, 0);
 
 	ifmgd->mcast_seq_last = IEEE80211_SN_MODULO;
@@ -8708,8 +8713,6 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 			  &ifmgd->teardown_ttlm_work);
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
 				  &ifmgd->tdls_peer_del_work);
-	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
-				  &ifmgd->ml_reconf_work);
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy, &ifmgd->ttlm_work);
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
 				  &ifmgd->neg_ttlm_timeout_work);
-- 
2.43.0



