Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7DD2DF6E9;
	Tue, 13 Oct 2026 12:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895232; cv=none; b=HekwT7ojgi9URDCyHyZr2BebkZXtApjwXiUa7cUTFEyjVjuOuII+MVo9LPF6qcUwNe/AkqsBL4z8qfusqT3uHwA12VKsDnWR1nJqtyzVaxJoV3gNUsIxkbfnQJeCDoA4XQwEuvCODMYgIHlhVU33PpIOCX8qK7Ep0bbIMBB93mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895232; c=relaxed/simple;
	bh=i37rZ0gJTZGQEV+p9t/6mh71kBau9WP6aZWKn3QWekk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXFXo5HBGuQoZykCvXJVQJGMPjJy0XxF2zgOOoxzxCIdQU4QvSUgmDieb3ZHPW5N05GRmhBLJJgvBtt0fGyR1WfbsCmiGEeRbxgVVQ9pJfQefK34J9aU0tpZ10oMWx9h8fL2xltlGAofvTMo1IvpLqPWckWZwoDsm61KnH7odQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3yB749X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3yB749X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914FF1F00893;
	Tue, 13 Oct 2026 12:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895231;
	bh=ScENEISnTe9kGT6Hnf77IE0z7wlunDy+bPY8OiL4gJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q3yB749XEAIRohdMuXtZDycFLJj0it/JEBENVPMn3mooiH20dMVy80GlXYScsupI+
	 txEPwXSqCKXhp7LTNvaQfbIVRQyPUb3t1GN1QOAVPJu3Ka7yOapa3vxZXZTgxPX/kR
	 fF7KiyyJeF2dKqQpizXeI89cCLg+nbd9+pxJzaTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 205/497] wifi: mac80211: keep paired old chanctx alive
Date: Tue, 13 Oct 2026 13:36:12 +0200
Message-ID: <20261013112912.757398810@linuxfoundation.org>
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

commit 3412e9a800786d1dec4a58367db1cba275e7ef11 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/chan.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -47,6 +47,13 @@ int ieee80211_chanctx_refcount(struct ie
 	       ieee80211_chanctx_num_reserved(local, ctx);
 }
 
+static bool
+ieee80211_chanctx_has_replace_partner(struct ieee80211_chanctx *ctx)
+{
+	return ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED &&
+	       ctx->replace_ctx;
+}
+
 static int ieee80211_num_chanctx(struct ieee80211_local *local, int radio_idx)
 {
 	struct ieee80211_chanctx *ctx;
@@ -1063,6 +1070,7 @@ int ieee80211_link_unreserve_chanctx(str
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_chanctx *ctx = link->reserved_chanctx;
+	struct ieee80211_chanctx *old_ctx = NULL;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
@@ -1077,6 +1085,7 @@ int ieee80211_link_unreserve_chanctx(str
 			if (WARN_ON(!ctx->replace_ctx))
 				return -EINVAL;
 
+			old_ctx = ctx->replace_ctx;
 			WARN_ON(ctx->replace_ctx->replace_state !=
 			        IEEE80211_CHANCTX_WILL_BE_REPLACED);
 			WARN_ON(ctx->replace_ctx->replace_ctx != ctx);
@@ -1087,6 +1096,11 @@ int ieee80211_link_unreserve_chanctx(str
 
 			list_del_rcu(&ctx->list);
 			kfree_rcu(ctx, rcu_head);
+
+			if (ieee80211_chanctx_refcount(sdata->local,
+						       old_ctx) == 0)
+				ieee80211_free_chanctx(sdata->local, old_ctx,
+						       false);
 		} else {
 			ieee80211_free_chanctx(sdata->local, ctx, false);
 		}
@@ -1360,7 +1374,8 @@ ieee80211_link_use_reserved_reassign(str
 
 	ieee80211_check_fast_xmit_iface(sdata);
 
-	if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, old_ctx) == 0 &&
+	    !ieee80211_chanctx_has_replace_partner(old_ctx))
 		ieee80211_free_chanctx(local, old_ctx, false);
 
 	ieee80211_recalc_chanctx_min_def(local, new_ctx, NULL, false);
@@ -1835,7 +1850,8 @@ void __ieee80211_link_release_channel(st
 	}
 
 	ieee80211_assign_link_chanctx(link, NULL, false);
-	if (ieee80211_chanctx_refcount(local, ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, ctx) == 0 &&
+	    !ieee80211_chanctx_has_replace_partner(ctx))
 		ieee80211_free_chanctx(local, ctx, skip_idle_recalc);
 
 	link->radar_required = false;


