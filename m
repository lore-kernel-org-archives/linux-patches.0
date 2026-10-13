Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386A54EFFCF;
	Tue, 13 Oct 2026 12:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895571; cv=none; b=gG5ZCoI6LSjuiLqR3ZPoV9+BuQKXPNpfmC+DGbfrRwkhwgqQqjDaHS9gVfmlQi4mSws60PAkR0/Q7RTgFDPBcTu4G/h+nqwtoPky1MHdUfFJRvcfc+Q839VQzYIs3NjrIK5jXARUIeiKkG5pVd75x+Q8F0J3mGgwulJC/AyZhkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895571; c=relaxed/simple;
	bh=D379gCYFGj2xm0Bq07hxrtfgWMWPQgC4QGJZ+KgaFTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbV4VNgXaviMel2+TuRHJBlqlAZpLXNjwURm5bHAFCBPsIu6JRhNhbAhY1MMbc+fRMf9xwC+iHTaxUnc/4fg+jq8eJ8vfqx/5jfltCGRyvuQbIWbse90Pxuo1Zn5XclbYXX4Y8x3txCScDLBryPDU4khtZZUS5FGN3CEC33kv8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1NKu5xa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1NKu5xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FAE1F000FF;
	Tue, 13 Oct 2026 12:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895570;
	bh=Y2nNEMALZql58NNZyFJc8m51sqhEqh2uhrKyrqbNx7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1NKu5xa3Ag0Xxwy1VWmyrw3z5sdzAEhRm9D/PRTxJ+jmsjv08qDUSyVT/xjWVK7X
	 gJBVzv+mq0dSGaKZnZLy0ycaUZs7TyxYQDW5mNfp7OKk2m+nPAEiRQaTQG7uKoLSaW
	 PUA1PxHStrN8J3jHDSZcgJDAJJ00gubIBlzqQjtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/497] wifi: mac80211: count only matching reservations in reserved switch
Date: Tue, 13 Oct 2026 13:38:04 +0200
Message-ID: <20261013112915.427389442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 437f3727b4fd715266c296435c116288f82666fd ]

ieee80211_vif_use_reserved_switch() validates a replacement by counting
assigned links on ctx->replace_ctx and treating reservations too
broadly. A link can still be assigned to the old channel context while
holding a reservation that belongs to a different replacement
operation.

That can make the current replacement appear complete too early. If
another link finalizes first, the function can free the
WILL_BE_REPLACED chanctx while the unmatched link and driver still use
it, leading to a use-after-free in later beacon generation.

Require an in-place reservation to point at the current replacement
context, and require the reserved and assigned contexts to be the
matching replacement pair, before counting or moving the link.

Fixes: 5bcae31d9cb1 ("mac80211: implement multi-vif in-place reservations")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Link: https://patch.msgid.link/4b6c4b8648ab1920c38a40be32c0b1a2797b4ac6.1785726007.git.zhilinz@nebusec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: adapted iter.link-based channel-context iteration to direct link-list traversal. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index b156f12daacbb..aea060719a1ea 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1441,7 +1441,8 @@ ieee80211_link_use_reserved_assign(struct ieee80211_link_data *link)
 }
 
 static bool
-ieee80211_link_has_in_place_reservation(struct ieee80211_link_data *link)
+ieee80211_link_has_in_place_reservation(struct ieee80211_link_data *link,
+					struct ieee80211_chanctx *ctx)
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_chanctx *old_ctx, *new_ctx;
@@ -1451,6 +1452,9 @@ ieee80211_link_has_in_place_reservation(struct ieee80211_link_data *link)
 	new_ctx = link->reserved_chanctx;
 	old_ctx = ieee80211_link_get_chanctx(link);
 
+	if (new_ctx != ctx)
+		return false;
+
 	if (!old_ctx)
 		return false;
 
@@ -1463,6 +1467,12 @@ ieee80211_link_has_in_place_reservation(struct ieee80211_link_data *link)
 	if (new_ctx->replace_state != IEEE80211_CHANCTX_REPLACES_OTHER)
 		return false;
 
+	if (new_ctx->replace_ctx != old_ctx)
+		return false;
+
+	if (old_ctx->replace_ctx != new_ctx)
+		return false;
+
 	return true;
 }
 
@@ -1492,7 +1502,7 @@ static int ieee80211_chsw_switch_vifs(struct ieee80211_local *local,
 
 		list_for_each_entry(link, &ctx->reserved_links,
 				    reserved_chanctx_list) {
-			if (!ieee80211_link_has_in_place_reservation(link))
+			if (!ieee80211_link_has_in_place_reservation(link, ctx))
 				continue;
 
 			old_ctx = ieee80211_link_get_chanctx(link);
@@ -1595,7 +1605,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		list_for_each_entry(link, &ctx->replace_ctx->assigned_links,
 				    assigned_chanctx_list) {
 			n_assigned++;
-			if (link->reserved_chanctx) {
+			if (ieee80211_link_has_in_place_reservation(link, ctx)) {
 				n_reserved++;
 				if (link->reserved_ready)
 					n_ready++;
@@ -1616,7 +1626,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		ctx->conf.radar_enabled = false;
 		list_for_each_entry(link, &ctx->reserved_links,
 				    reserved_chanctx_list) {
-			if (ieee80211_link_has_in_place_reservation(link) &&
+			if (ieee80211_link_has_in_place_reservation(link, ctx) &&
 			    !link->reserved_ready)
 				return -EAGAIN;
 
@@ -1658,7 +1668,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 
 		list_for_each_entry(link, &ctx->reserved_links,
 				    reserved_chanctx_list) {
-			if (!ieee80211_link_has_in_place_reservation(link))
+			if (!ieee80211_link_has_in_place_reservation(link, ctx))
 				continue;
 
 			ieee80211_chan_bw_change(local,
@@ -1707,7 +1717,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 			struct ieee80211_bss_conf *link_conf = link->conf;
 			u64 changed = 0;
 
-			if (!ieee80211_link_has_in_place_reservation(link))
+			if (!ieee80211_link_has_in_place_reservation(link, ctx))
 				continue;
 
 			rcu_assign_pointer(link_conf->chanctx_conf,
@@ -1761,7 +1771,8 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		 */
 		list_for_each_entry_safe(link, link_tmp, &ctx->reserved_links,
 					 reserved_chanctx_list) {
-			if (WARN_ON(ieee80211_link_has_in_place_reservation(link)))
+			if (WARN_ON(ieee80211_link_has_in_place_reservation(link,
+									    ctx)))
 				continue;
 
 			if (WARN_ON(link->reserved_chanctx != ctx))
-- 
2.53.0



