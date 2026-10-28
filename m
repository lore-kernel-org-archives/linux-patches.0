Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211303;
	b=ajU3xGF2DSGEScGwPRjB6Nyxvzne9RjeFQjgYnDF6fotTZW9hDyNNTrPLmbUfU+aX4NX
	 9glWL/h02m65jEVSan2U86u0rujvUM2jDq3xtOZBnTB/8uWE/X71hxAT/L6geTqig0Tx4
	 HS8Y8fYKzbKppKrbY+tRg65TmICH+5qjMEUzOmUuZaV2k05b1W1d/4uziOC8UJMah0V6L
	 tQtqe3Ej8DMdZCd9IV95bNSR4mjY68q+f1gwWjBIM4Iqz7mCgfIUrtngCwkFDR+Hiuh6a
	 1aeqHjE40BsJs0bhAMQb2vYZHVqVteK7R75dOgmXyZ7g+kcYrHNCxbBHkX37o8nmaDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMagPv0kQSYTrcdS7M4uIrWFsUD/n3qLpK7rc+4Qmmc=;
	b=gCUy3Mku5B2p1gIwwDNc4F6JYM61sxpZHORelqQlWk1bbxhUi05UkBopWBMLfSgHkedX
	 HYyGCZt8f1vFGWgCzavhxXC/q4V0rlKqt9BTK5x/pdrg1PhUin2Jh44PkHjYgegKXPvm3
	 5/HpStN1ZDpYIFkGEL0margQ23I+zxplARpMh8dRic/wgoluvsghNee0EdTwl00kQfFfb
	 g5hxWPTiOpwFon+IEUfoWL+rgmmG/3qFttv8vj0bQ2/bVcLe/R76JZJRK1KmQNBEYwCP5
	 jCF552/Vt3AaELm+RM/HTMU/5nXMpKZRB2ZQ3w/TWZysOBvN6Vy6E8nZqfayA/qEs0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+T5oVhv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC037606A94F;
	Wed, 28 Oct 2026 18:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+T5oVhv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242B21F031E0;
	Wed, 28 Oct 2026 18:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211302;
	bh=EMagPv0kQSYTrcdS7M4uIrWFsUD/n3qLpK7rc+4Qmmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+T5oVhvlDGrB1GVlau1nUYanmN4/BxSpr4DBjyh0sdRyk4BGbilXM2BXzK2movBb
	 X8QaMPiYFx5g2n0sCzzCZl0I7MZMIa91d8IlFmsKFGYewsM3LGllQT/mg18xBhxhmJ
	 ssraGpH0PjGJUMwc2CA1vOH3PZRFNjNDwJt22Od0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 331/571] wifi: mac80211: keep paired old chanctx alive
Date: Wed, 28 Oct 2026 17:57:58 +0100
Message-ID: <20261028170015.860618418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 3412e9a800786d1dec4a58367db1cba275e7ef11 ]

An in-place replacement keeps reciprocal replace_ctx pointers between
the old WILL_BE_REPLACED chanctx and the new REPLACES_OTHER chanctx.
However, the early free paths only consider assigned and reserved link
users when deciding whether to free the old chanctx.

That lets the old chanctx be freed too early while the replacement
partner still points back to it, either when the last assigned link is
released or when that link successfully reassigns to another existing
context. Later unreserve and switch-finalization paths can then follow a
stale replace_ctx pointer.

Keep a paired old chanctx alive until the replacement pair has been torn
down. Apply the same check to both __ieee80211_link_release_channel()
and ieee80211_link_use_reserved_reassign(). If the replacement is later
abandoned, ieee80211_link_unreserve_chanctx() already tears down the
pairing before freeing the old chanctx once no users remain.

Fixes: 5bcae31d9cb1 ("mac80211: implement multi-vif in-place reservations")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Link: https://patch.msgid.link/b9b582b0db3814f641648b8886bb50f9d68f93ac.1785730815.git.zhilinz@nebusec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: adapted link-based channel handling to VIF-based functions and fields. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f32d8d07d6a30..84be216fcb7c2 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -940,6 +940,7 @@ void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_chanctx *ctx = sdata->reserved_chanctx;
+	struct ieee80211_chanctx *old_ctx = NULL;
 
 	lockdep_assert_held(&sdata->local->chanctx_mtx);
 
@@ -954,6 +955,7 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 			if (WARN_ON(!ctx->replace_ctx))
 				return -EINVAL;
 
+			old_ctx = ctx->replace_ctx;
 			WARN_ON(ctx->replace_ctx->replace_state !=
 			        IEEE80211_CHANCTX_WILL_BE_REPLACED);
 			WARN_ON(ctx->replace_ctx->replace_ctx != ctx);
@@ -964,6 +966,10 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 
 			list_del_rcu(&ctx->list);
 			kfree_rcu(ctx, rcu_head);
+
+			if (ieee80211_chanctx_refcount(sdata->local,
+						       old_ctx) == 0)
+				ieee80211_free_chanctx(sdata->local, old_ctx);
 		} else {
 			ieee80211_free_chanctx(sdata->local, ctx);
 		}
@@ -1177,7 +1183,9 @@ ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 
 	ieee80211_check_fast_xmit_iface(sdata);
 
-	if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, old_ctx) == 0 &&
+	    !(old_ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED &&
+	      old_ctx->replace_ctx))
 		ieee80211_free_chanctx(local, old_ctx);
 
 	ieee80211_recalc_chanctx_min_def(local, new_ctx);
@@ -1649,7 +1657,9 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 	}
 
 	ieee80211_assign_vif_chanctx(sdata, NULL);
-	if (ieee80211_chanctx_refcount(local, ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, ctx) == 0 &&
+	    !(ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED &&
+	      ctx->replace_ctx))
 		ieee80211_free_chanctx(local, ctx);
 
 	sdata->radar_required = false;
-- 
2.53.0



