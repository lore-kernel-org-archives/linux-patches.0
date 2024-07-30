Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A3D1A6160;
	Tue, 30 Jul 2024 16:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356561; cv=none; b=SfqeflMJOLRlPOSD3ZivtcPIpnotUDehFz0pbIPt7wEOtjbtkxgLMcVQ6efQCVS+xqXjkhGhEnG1pwPh2xxePady2gEJNqo0yDLYRSpZnj3XMcvBgLaPoNvm6ADOGil6cCDsKDrVgQjBqHOh8DkziA8TooU5lfICczzYJ5ZnJtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356561; c=relaxed/simple;
	bh=XbMJ0MxT7FdxQtvBz0DkrJDuTIxou+DDNwk8Wxnv+kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VbHB/XoaGbCZxFYfpaAfzrOxKBcaW9rz/dBd8q680XKa/8IrDesR20YIVI5i6TIS6yJ1ZZOVrpG2Hr3dqcZ+b3BZ5EeBbLH6VddLpG0woaJ+BkhOsMuRu1NrEGNwvQBdjRz337gRdOr2j8i5wdE6QEtOBwgsdr/RI/4YDFk1bwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rY53HgZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rY53HgZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C38C32782;
	Tue, 30 Jul 2024 16:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356561;
	bh=XbMJ0MxT7FdxQtvBz0DkrJDuTIxou+DDNwk8Wxnv+kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rY53HgZEGRUcrs4ZAUnMaIt/u9vlEpGigX83lXa0Kpzj+pl6jGvKgJEH30oSafquX
	 3X07+wbKgLlkGV5CsOcSxU55euL+OY5o5+NVVIiP6I3p7VwzYsUB2A31UExaEaJMAC
	 gx+YRBUBdA2rGWz/+qyPSBLp0+ZxYELwt1nxaFMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 162/809] wifi: mac80211: cancel TTLM teardown work earlier
Date: Tue, 30 Jul 2024 17:40:38 +0200
Message-ID: <20240730151731.001152185@linuxfoundation.org>
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

[ Upstream commit 3567bd6dcd1467d2ad0f597be94114c6f9c62680 ]

It shouldn't be possible to run this after disconnecting, so
cancel the work earlier.

Fixes: a17a58ad2ff2 ("wifi: mac80211: add support for tearing down negotiated TTLM")
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240506211034.096a10ccebec.I5584a21c27eb9b3e87b9e26380b627114b32ccba@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 72e38e42f6da0..0a9949bbd7576 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3294,6 +3294,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
 				  &sdata->u.mgd.ml_reconf_work);
 
+	wiphy_work_cancel(sdata->local->hw.wiphy,
+			  &ifmgd->teardown_ttlm_work);
+
 	ieee80211_vif_set_links(sdata, 0, 0);
 
 	ifmgd->mcast_seq_last = IEEE80211_SN_MODULO;
@@ -8709,8 +8712,6 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 			  &ifmgd->beacon_connection_loss_work);
 	wiphy_work_cancel(sdata->local->hw.wiphy,
 			  &ifmgd->csa_connection_drop_work);
-	wiphy_work_cancel(sdata->local->hw.wiphy,
-			  &ifmgd->teardown_ttlm_work);
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
 				  &ifmgd->tdls_peer_del_work);
 	wiphy_delayed_work_cancel(sdata->local->hw.wiphy, &ifmgd->ttlm_work);
-- 
2.43.0



