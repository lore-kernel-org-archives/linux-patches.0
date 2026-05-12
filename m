Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB88D23E356;
	Tue, 12 May 2026 18:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609115; cv=none; b=DlFWL0rqAAEpDT3ZfrD1JMivzNMkc0bhUO28jj9OQuOXuraQXsFqhxbv+IKiLbjgFo4PeslDT3kqU/3V5gAwGw8E/IRSDjxM4UzZ1mbWD2KaQuIcKWRPbiSc33mnx/td1K5iLA9a7789JTl03j7w9SOp6/LsbDUxoHOMnKjfz1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609115; c=relaxed/simple;
	bh=GpdP+1nGh7zwt8EQfob2PNfbzwuHFNkF4Uo5Xf3ri6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knlTXlofY6lqoO/ks8Tn74i/5xpp9PdB8dAZ1FwKK2cN73Veo27ccJuuLBQ1lU7971qEltUsli7DKXEgC8f1l3tNB9ZQG+vf0tIo6J50EGwiKij+KYWnvN8Lrsi9x5qeqq83jB7m7HHvNEPzDIgbAk1UtAdBWOgaImJ6swaj+/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ia8maYpL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ia8maYpL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24599C2BCC7;
	Tue, 12 May 2026 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609115;
	bh=GpdP+1nGh7zwt8EQfob2PNfbzwuHFNkF4Uo5Xf3ri6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ia8maYpLA/6c3eqgpZlUZ53+FC9xl/8Ap+mm1t/uOhufMcDRAiE0ZRW6xkYGkU0BN
	 E5CQxjM4/JQ3JzIhWV3kCWIplx1RvFeG05+AftCC01x5/ihNICi97d+Fd0rzoFI50c
	 p/fbU51MEedXzR3DqyieI1+AluzNlxbTpdAGCM1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.0 029/307] wifi: mac80211: use safe list iteration in radar detect work
Date: Tue, 12 May 2026 19:37:04 +0200
Message-ID: <20260512173940.740284721@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

commit ac8eb3e18f41e2cc8492cc1d358bcb786c850270 upstream.

The call to ieee80211_dfs_cac_cancel can cause the iterated chanctx to
be freed and removed from the list. Guard against this to avoid a
slab-use-after-free error.

Cc: stable@vger.kernel.org
Fixes: bca8bc0399ac ("wifi: mac80211: handle ieee80211_radar_detected() for MLO")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://patch.msgid.link/20260505151539.236d63a1b736.I35dbb9e96a2d4a480be208770fdd99ba3b817b79@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3623,11 +3623,11 @@ void ieee80211_dfs_radar_detected_work(s
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, radar_detected_work);
 	struct cfg80211_chan_def chandef;
-	struct ieee80211_chanctx *ctx;
+	struct ieee80211_chanctx *ctx, *tmp;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	list_for_each_entry(ctx, &local->chanctx_list, list) {
+	list_for_each_entry_safe(ctx, tmp, &local->chanctx_list, list) {
 		if (ctx->replace_state == IEEE80211_CHANCTX_REPLACES_OTHER)
 			continue;
 


