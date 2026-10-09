Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F284C6507;
	Fri,  9 Oct 2026 14:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557259; cv=none; b=Unuy2lgVMNx6L6xyr0LP7PeVOIpzPg580oOc0jByJ+eUIFplKcuQmCoVK8gxNO7Xmz0bAGd1jSW2hD/O9qTSFYdZLx23Yu2HJiVZI9irSBsuSfdN1APEZ4bwvbs2O1BVFjTwYMAc4I3Qrm0XuBiNuTR8n3lNNguK6M2bW8WOJqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557259; c=relaxed/simple;
	bh=R89lDY/lcoig8MhbY46wCWnveIQxkCEwD9Ropt5Jo6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1RPPCt5r4ZXu/vCEoZXuqjYAA6ImYIwTRLmymrcPHtdLcK7XSdK4axZ67WNZCKIcJcb+WBS8NPfoq+bo9/q5s8f0ag/n2H8VCQHjwbnE+thVjiCcbrWfx5YA0j9/0x0m0jOAciCDyj3DkVrlTlj/RZYwoO4fYPIVBuiZOk7n8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGvXsFEj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGvXsFEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9981F00899;
	Fri,  9 Oct 2026 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557258;
	bh=3ts8hD9su+jdhySq31SjmZt3bXxBMCfo0BElPvL9UjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGvXsFEjKBqlZ2SqHJCSuDFubfzOCA/Ie5LvlM5f0O3e4z0xNmE0q1CcQwhpmWrko
	 WLauOEzFzhc0i4+X5+9luO7eQkUbozI/VeohIe12dF4hn//SFu3nM08vg4yUa3XRJq
	 7vWYPDDA6hmGloSXUz339PAhuNeO3nhQwWEJz++g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 327/428] wifi: mac80211: count only matching reservations in reserved switch
Date: Fri,  9 Oct 2026 16:11:04 +0200
Message-ID: <20261009140953.318860119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 437f3727b4fd715266c296435c116288f82666fd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/chan.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1770,7 +1770,8 @@ out:
 }
 
 static bool
-ieee80211_link_has_in_place_reservation(struct ieee80211_link_data *link)
+ieee80211_link_has_in_place_reservation(struct ieee80211_link_data *link,
+					struct ieee80211_chanctx *ctx)
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_chanctx *old_ctx, *new_ctx;
@@ -1780,6 +1781,9 @@ ieee80211_link_has_in_place_reservation(
 	new_ctx = link->reserved_chanctx;
 	old_ctx = ieee80211_link_get_chanctx(link);
 
+	if (new_ctx != ctx)
+		return false;
+
 	if (!old_ctx)
 		return false;
 
@@ -1792,6 +1796,12 @@ ieee80211_link_has_in_place_reservation(
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
 
@@ -1821,7 +1831,8 @@ static int ieee80211_chsw_switch_vifs(st
 		}
 
 		for_each_chanctx_user_reserved(local, ctx, &iter) {
-			if (!ieee80211_link_has_in_place_reservation(iter.link))
+			if (!ieee80211_link_has_in_place_reservation(iter.link,
+								     ctx))
 				continue;
 
 			old_ctx = ieee80211_link_get_chanctx(iter.link);
@@ -1923,7 +1934,9 @@ static int ieee80211_vif_use_reserved_sw
 
 		for_each_chanctx_user_assigned(local, ctx->replace_ctx, &iter) {
 			n_assigned++;
-			if (iter.link && iter.link->reserved_chanctx) {
+			if (iter.link &&
+			    ieee80211_link_has_in_place_reservation(iter.link,
+								    ctx)) {
 				n_reserved++;
 				if (iter.link->reserved_ready)
 					n_ready++;
@@ -1948,7 +1961,8 @@ static int ieee80211_vif_use_reserved_sw
 use_reserved:
 		ctx->conf.radar_enabled = false;
 		for_each_chanctx_user_reserved(local, ctx, &iter) {
-			if (ieee80211_link_has_in_place_reservation(iter.link) &&
+			if (ieee80211_link_has_in_place_reservation(iter.link,
+								    ctx) &&
 			    !iter.link->reserved_ready)
 				return -EAGAIN;
 
@@ -1989,7 +2003,8 @@ use_reserved:
 		}
 
 		for_each_chanctx_user_reserved(local, ctx, &iter) {
-			if (!ieee80211_link_has_in_place_reservation(iter.link))
+			if (!ieee80211_link_has_in_place_reservation(iter.link,
+								     ctx))
 				continue;
 
 			ieee80211_chan_bw_change(local,
@@ -2038,7 +2053,7 @@ use_reserved:
 			struct ieee80211_bss_conf *link_conf = link->conf;
 			u64 changed = 0;
 
-			if (!ieee80211_link_has_in_place_reservation(link))
+			if (!ieee80211_link_has_in_place_reservation(link, ctx))
 				continue;
 
 			rcu_assign_pointer(link_conf->chanctx_conf,
@@ -2089,7 +2104,8 @@ use_reserved:
 		for_each_chanctx_user_reserved(local, ctx, &iter) {
 			struct ieee80211_link_data *link = iter.link;
 
-			if (WARN_ON(ieee80211_link_has_in_place_reservation(link)))
+			if (WARN_ON(ieee80211_link_has_in_place_reservation(link,
+									    ctx)))
 				continue;
 
 			if (!link->reserved_ready)


