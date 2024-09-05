Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5E114A08E;
	Thu,  5 Sep 2024 09:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529751; cv=none; b=l2BeCBnTchKbGW/uAbemiJPK7lDzk4NJ7fFnHNGawgvKpIEtZJxbuxgUneGOPfbRNKf8So+pbCAuoZ3P9MBxVEF/MF0qR+Q/mqB1UMRXpZikxP/WlLuAY8BQ+z35em9GkVxUt2DLKCty5RUDe3aBU+tWs04CDFQLEFjDFYmkrIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529751; c=relaxed/simple;
	bh=hFYSbozBNqQzIhcAxWnrNfE/9b7eX30okN1KCw+2n+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nc93W5LVvt87Bv8S3v5LX+DWpk1JhD1ioPlFPISKy0VEC/vhryuMUDpeSW4+0VBeYFpO+rjc5w5Ajg//YAg6fi4QFFp9nL/VOraH2+LCseNJi0JUa+fTWYOamWSRptlj2mjNYIRmDFJPAbe+6knWfuuxWj6iMroDYHC5kW8GgqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0NeauvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0NeauvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3302C4CEC3;
	Thu,  5 Sep 2024 09:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529751;
	bh=hFYSbozBNqQzIhcAxWnrNfE/9b7eX30okN1KCw+2n+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0NeauvL/Lg7Kx+c/3zW9Bh0LMCKPmqWch3j4wpXkpBzYgnS9vKBjEAQZQ7XgMXlt
	 MBbXM5RQRjAfk9dbXeSO1Ksbv3dPlZHf8JY1cUZUqnHAyHMov4V50evDFyfqebt/BO
	 QYmiRWWDZNMVxlycAtWT3/ROqxbqgjhfvzILe5pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 124/184] wifi: mac80211: check ieee80211_bss_info_change_notify() against MLD
Date: Thu,  5 Sep 2024 11:40:37 +0200
Message-ID: <20240905093737.068884196@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

[ Upstream commit a0ca76e5b7d550fcd74753d5fdaaf23f1a9bfdb4 ]

It's not valid to call ieee80211_bss_info_change_notify() with
an sdata that's an MLD, remove the FIXME comment (it's not true)
and add a warning.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240523121140.97a589b13d24.I61988788d81fb3cf97a490dfd3167f67a141d1fd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7ba329ebdda9..e44b2a26354b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -337,6 +337,8 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 
 	might_sleep();
 
+	WARN_ON_ONCE(ieee80211_vif_is_mld(&sdata->vif));
+
 	if (!changed || sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		return;
 
@@ -369,7 +371,6 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 	if (changed & ~BSS_CHANGED_VIF_CFG_FLAGS) {
 		u64 ch = changed & ~BSS_CHANGED_VIF_CFG_FLAGS;
 
-		/* FIXME: should be for each link */
 		trace_drv_link_info_changed(local, sdata, &sdata->vif.bss_conf,
 					    changed);
 		if (local->ops->link_info_changed)
-- 
2.43.0



