Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E69E3438A8;
	Thu, 17 Sep 2026 16:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660972; cv=none; b=IUmWB2caAmY5XdLa7yC9uOtrTyYycUBF0xa56hXP35mF4ku65JGGLSeqQvhsozKlc8JhP5bcYAXE23VIAbRErzeo5VXitXEJ0UqlJW5ikAMWBpfogpy1pR4g9UmpzMdQDFdH25iU0Ra6VtQmPQ3NTakR2PztmlcpUohZ/28NK5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660972; c=relaxed/simple;
	bh=pKxBBe47Hba+q748Ds8/cg1F9EOVR2KDRqVjNOfLRkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGnoWMfnH0tkXiDgOYs5VOu8aYa2cuyWCZi2xNZA2IIpf81JtizYADhZXx47eI1IWXS47R/GeqDBbPiy+i3ia72FC/d2AgfW0aqyASDsZTj97UvXk1wEdnEgbryGaNQKIRyIHR5lLmYBuwKx2BpngaAZLRZDrqxqORRGsq2LctA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9sOd9LF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9sOd9LF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41BF1F00898;
	Thu, 17 Sep 2026 16:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660971;
	bh=yB1gHQTvCo5KU8WC1LLNw4kndHKwPsDB8DZVied12CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9sOd9LFnvmBDkytZ4jraGS6Rmwy1ATpUZqLe4futTbLFYPJTKEtjecUvTVpjqnDu
	 s6z+us5MzMtnmxsFviGxlR0sDeAtCC2jAnAIQKjRNeVn3Y9OCpgxXLgeotgwY8tGaf
	 bgoq0mS5AqYVvJJefcDjsHhIGYLgsUrI0gQO7EnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0032/1250] wifi: mac80211: use chandef in ieee80211_get_sta_bw()
Date: Thu, 17 Sep 2026 15:57:07 +0100
Message-ID: <20260917151552.802776021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e36b3322a41b7de0168ad6a37bdd1219cfe35077 ]

When getting the bandwidth the station uses in order to
calculate the channel context's min_def, pass the channel
for the link to _ieee80211_sta_cap_rx_bw() instead of using
ieee80211_sta_cap_rx_bw(), which looks it up.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260415144514.d2bdf106a39f.I6ae07289a272dd9e27118f9fa324a4865f994003@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index a6895b40d4322..8403b5248a953 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -235,11 +235,12 @@ ieee80211_find_reservation_chanctx(struct ieee80211_local *local,
 	return NULL;
 }
 
-static enum nl80211_chan_width ieee80211_get_sta_bw(struct sta_info *sta,
-						    unsigned int link_id)
+static enum nl80211_chan_width
+ieee80211_get_sta_bw(struct sta_info *sta, struct ieee80211_link_data *link)
 {
 	enum ieee80211_sta_rx_bandwidth width;
 	struct link_sta_info *link_sta;
+	int link_id = link->link_id;
 
 	link_sta = wiphy_dereference(sta->local->hw.wiphy, sta->link[link_id]);
 
@@ -254,7 +255,7 @@ static enum nl80211_chan_width ieee80211_get_sta_bw(struct sta_info *sta,
 	 * capabilities here. Calling it RX bandwidth capability is a bit
 	 * wrong though, since capabilities are in fact symmetric.
 	 */
-	width = ieee80211_sta_cap_rx_bw(link_sta);
+	width = _ieee80211_sta_cap_rx_bw(link_sta, &link->conf->chanreq.oper);
 
 	switch (width) {
 	case IEEE80211_STA_RX_BW_20:
@@ -289,7 +290,6 @@ static enum nl80211_chan_width
 ieee80211_get_max_required_bw(struct ieee80211_link_data *link)
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
-	unsigned int link_id = link->link_id;
 	enum nl80211_chan_width max_bw = NL80211_CHAN_WIDTH_20_NOHT;
 	struct sta_info *sta;
 
@@ -300,7 +300,7 @@ ieee80211_get_max_required_bw(struct ieee80211_link_data *link)
 		    !(sta->sdata->bss && sta->sdata->bss == sdata->bss))
 			continue;
 
-		max_bw = max(max_bw, ieee80211_get_sta_bw(sta, link_id));
+		max_bw = max(max_bw, ieee80211_get_sta_bw(sta, link));
 	}
 
 	return max_bw;
-- 
2.53.0



