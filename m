Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B664A3B9DAE;
	Sat, 17 Oct 2026 17:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257037; cv=none; b=XP1PaiA8LB7nv1G/58U2x+8+PJXyMyDbXIB5gArNdOMmz6mo5L+oX1b5NHwV3qkOMqVTJ8R9ohSPiBRmDM0tTWsKAGoXy3JnwDx7BwUfI814lFCi8nsY/pFsVt00z01erMv/bKdk/mJPOdbnKNmHIU/5xJgPqB7ja9cut4R4yxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257037; c=relaxed/simple;
	bh=7iSdW4zxIGfMMsfhJp7O/AJ6MKMj3+Y9Zr7eYQGo4d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMd5QIpIyYsn2wLsoXxPdUQ1THoTs1GOwVmL6aZXruzKZd7zrdhO70Y2SF9oiP+62RPu154EhHk/WPF+YovO9dpIzEjx+RNQ/NH4wOzN+NwvS0leE2kkfikkneGOHXJPzBT6ctGtErAZfGtazZQFaJzcpcYJjbJ+G29JtuCeydw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiB3sbgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiB3sbgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1104C1F000C4;
	Sat, 17 Oct 2026 17:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257035;
	bh=AJtddBsN5na3K09c4OS4xHtF1qeHAgKswkMRmfUc5uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tiB3sbgwhecC1HcTgj85r0xsecBow16SCRVeztyxxgVFWMkFx2z6cUFfvxDO9L+hZ
	 CmLkxMVjLJJbIjWquwBvUF0nexDiob7Uh3qIWyZ+VPbj0DvuzDqQREHrrhTX8vlQhm
	 0vvRuCgPaWCsn3Tj3zlF0HmiYsjTP0qUe6oUznOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0429/1674] wifi: mac80211: keep paired old chanctx alive
Date: Sat, 17 Oct 2026 17:45:01 +0200
Message-ID: <20261017160442.138042452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Inlined the replacement-partner helper at both call sites. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 4a21e53afa72e..85875ed7536f8 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1067,6 +1067,7 @@ int ieee80211_link_unreserve_chanctx(struct ieee80211_link_data *link)
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_chanctx *ctx = link->reserved_chanctx;
+	struct ieee80211_chanctx *old_ctx = NULL;
 
 	lockdep_assert_held(&sdata->local->chanctx_mtx);
 
@@ -1081,6 +1082,7 @@ int ieee80211_link_unreserve_chanctx(struct ieee80211_link_data *link)
 			if (WARN_ON(!ctx->replace_ctx))
 				return -EINVAL;
 
+			old_ctx = ctx->replace_ctx;
 			WARN_ON(ctx->replace_ctx->replace_state !=
 			        IEEE80211_CHANCTX_WILL_BE_REPLACED);
 			WARN_ON(ctx->replace_ctx->replace_ctx != ctx);
@@ -1091,6 +1093,10 @@ int ieee80211_link_unreserve_chanctx(struct ieee80211_link_data *link)
 
 			list_del_rcu(&ctx->list);
 			kfree_rcu(ctx, rcu_head);
+
+			if (ieee80211_chanctx_refcount(sdata->local,
+						       old_ctx) == 0)
+				ieee80211_free_chanctx(sdata->local, old_ctx);
 		} else {
 			ieee80211_free_chanctx(sdata->local, ctx);
 		}
@@ -1322,7 +1328,9 @@ ieee80211_link_use_reserved_reassign(struct ieee80211_link_data *link)
 
 	ieee80211_check_fast_xmit_iface(sdata);
 
-	if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, old_ctx) == 0 &&
+	    !(old_ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED &&
+	      old_ctx->replace_ctx))
 		ieee80211_free_chanctx(local, old_ctx);
 
 	ieee80211_recalc_chanctx_min_def(local, new_ctx, NULL);
@@ -1802,7 +1810,9 @@ static void __ieee80211_link_release_channel(struct ieee80211_link_data *link)
 	}
 
 	ieee80211_assign_link_chanctx(link, NULL);
-	if (ieee80211_chanctx_refcount(local, ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, ctx) == 0 &&
+	    !(ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED &&
+	      ctx->replace_ctx))
 		ieee80211_free_chanctx(local, ctx);
 
 	link->radar_required = false;
-- 
2.53.0



