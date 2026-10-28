Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208963;
	b=nnpqwl3mFPSgg2SZKpfKOSOi+1bQQ1xPHRKIXpSHhnJWIX+K/xiDqjXM6Sq+xU3SK7Hz
	 Qrbb3JT20Si20LeL9/hO9HQXJYadtQ0qW4nggu8DJRWhvqcrTcHTIBWQHI4jqDXFVjV3e
	 Pvaj9490f010V4OJA5z+DQf5XMJDt17teulz/KHN0cYJZ0XE0GNX48FR84qufjLCojC60
	 pZOGfDDHINBInZ69WVjJTUH2lnjG+0nKv8vmGvxBBQMVJHKJQKQCxRe2xrHiIXyFp0fIr
	 fazNsXIjzu3sfQLcw2iSX4/wqYqSNaQ62Bqftp6yk73KwxR4onVu1/8ZX6jRR75Tblg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x7hbXx0zf4qoFqponGtXLtMvdVNaR+JVFSlOZD13xCc=;
	b=u+k7papxD3DxMX4z7AJ6jfCCLJLfpaN0ForBj0oClhD9h78SiiTPVXN3kiPp+y+frxgv
	 7GEoK3mWgyWLVhiDuw/DPfgqC0PmcOWi02iTAsUxGLbjCID35vum56/l0sX4SeT8FYRs9
	 aYk37c4t1dj8CnwrAN96he/2fJKr5e56alMc6gKz7Ye+uO9pplrAsfCKkVkQ2piBM4I0U
	 apv1fWcQcsrEiO9aOI0bbAswBbCNR8dGtFvkvI+pSFbjou4wbEvGu6kOFw5Ta3TYKomC9
	 GE0bKBTZdVX8PB5XUIDsYVU7jehVCjwa2Ux3VcDw+W6fNO1pHZqyQ6x793y9osWXNAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hotDwKRC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C9B606A322;
	Wed, 28 Oct 2026 17:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hotDwKRC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEBB1F01825;
	Wed, 28 Oct 2026 17:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208962;
	bh=x7hbXx0zf4qoFqponGtXLtMvdVNaR+JVFSlOZD13xCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hotDwKRC67/bJ3iYzBMK/mpNusGaNkP8FjZ01211zbBqYj8H9VRWWAzXBJBkeOeeN
	 n5IfostBSWdgFDZiAFxC2rZRCONHqkBfJ88+Yg4TkO1Y1R3OD781Lo63r//EPCJ44o
	 lfH1xeC87yFq94QKjz811QBMR+xhKB5lsnSwT68w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 304/516] wifi: mac80211: keep paired old chanctx alive
Date: Wed, 28 Oct 2026 17:57:36 +0100
Message-ID: <20261028170010.691670674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted link-based chanctx handling to the older vif-based API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5639a71257e41..0d0bb18a77e79 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -846,6 +846,7 @@ void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_chanctx *ctx = sdata->reserved_chanctx;
+	struct ieee80211_chanctx *old_ctx = NULL;
 
 	lockdep_assert_held(&sdata->local->chanctx_mtx);
 
@@ -860,6 +861,7 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 			if (WARN_ON(!ctx->replace_ctx))
 				return -EINVAL;
 
+			old_ctx = ctx->replace_ctx;
 			WARN_ON(ctx->replace_ctx->replace_state !=
 			        IEEE80211_CHANCTX_WILL_BE_REPLACED);
 			WARN_ON(ctx->replace_ctx->replace_ctx != ctx);
@@ -870,6 +872,10 @@ int ieee80211_vif_unreserve_chanctx(struct ieee80211_sub_if_data *sdata)
 
 			list_del_rcu(&ctx->list);
 			kfree_rcu(ctx, rcu_head);
+
+			if (ieee80211_chanctx_refcount(sdata->local,
+						       old_ctx) == 0)
+				ieee80211_free_chanctx(sdata->local, old_ctx);
 		} else {
 			ieee80211_free_chanctx(sdata->local, ctx);
 		}
@@ -1078,7 +1084,9 @@ ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 
 	ieee80211_check_fast_xmit_iface(sdata);
 
-	if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, old_ctx) == 0 &&
+	    !(old_ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED &&
+	      old_ctx->replace_ctx))
 		ieee80211_free_chanctx(local, old_ctx);
 
 	if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
@@ -1555,7 +1563,9 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
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



