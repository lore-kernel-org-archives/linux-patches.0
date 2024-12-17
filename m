Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC491F76CE;
	Tue, 17 Dec 2024 17:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456122; cv=none; b=gwe1Y/TpJtv6SRw3vzAZkaQIJA+8OBxK2MejxI5QjaEHaUzR+vP2qNVWRdN6E5e9K6YWFBKZ4LeRCE0l1HDB7L6sL9fydIaw3w57etFa5Yk0gOCXMkFHcz3KUzd5KY+fpUgmD6XGOhsJd29j90P/J7Q1u+kBBTDUBidJkxyMUqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456122; c=relaxed/simple;
	bh=6Z/TGMzipaeVOlElqV69XfSs8bllmuuVu+Vs1zHrAf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJupIlz+oLRmoHrHayJPG6ugDkO95zd0Uk/Z2d6/w7gOahgURxtFp3Oq1MhhovaTcsOLmGdX1tIXRFGxSgvA01o5zDbRDrFveR24dgXQz32W6dQPxgJ9N/pqekK2vlS3b51ynG4tmVTjGEZOJq24+CoAxPSE+1De2BsRe8//NaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izussGfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izussGfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A4BC4CEDE;
	Tue, 17 Dec 2024 17:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456122;
	bh=6Z/TGMzipaeVOlElqV69XfSs8bllmuuVu+Vs1zHrAf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izussGfsWt3LSoD2/cFgGy+nPoZ6Ag2hpk5x/5RK0BlfvZE0/dGzRM+iRFb+wN5iK
	 iBkF91AncPZpHBDu1t+SfvEc+xiHqXLaPhRKfYH7/+bG5uOlvXWYhS6aEUvq2wBOhX
	 zR0f9G5gvAUE6kzksy6k1cZQWNo+5e+0qIbp3FjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/109] wifi: mac80211: clean up ret in sta_link_apply_parameters()
Date: Tue, 17 Dec 2024 18:07:21 +0100
Message-ID: <20241217170534.923654230@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

[ Upstream commit 642508a42f74d7467aae7c56dff3016db64a25bd ]

There's no need to have the always-zero ret variable in
the function scope, move it into the inner scope only.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240605135233.eb7a24632d98.I72d7fe1da89d4b89bcfd0f5fb9057e3e69355cfe@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 819e0f1e58e0 ("wifi: mac80211: fix station NSS capability initialization order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fe4469af3cc9..f9395cd80051 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1795,7 +1795,6 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 				     struct sta_info *sta, bool new_link,
 				     struct link_station_parameters *params)
 {
-	int ret = 0;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u32 link_id = params->link_id < 0 ? 0 : params->link_id;
@@ -1837,6 +1836,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 	}
 
 	if (params->txpwr_set) {
+		int ret;
+
 		link_sta->pub->txpwr.type = params->txpwr.type;
 		if (params->txpwr.type == NL80211_TX_POWER_LIMITED)
 			link_sta->pub->txpwr.power = params->txpwr.power;
@@ -1889,7 +1890,7 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 
 	ieee80211_sta_init_nss(link_sta);
 
-	return ret;
+	return 0;
 }
 
 static int sta_apply_parameters(struct ieee80211_local *local,
-- 
2.39.5



