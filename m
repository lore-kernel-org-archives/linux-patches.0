Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620065;
	b=z5Ux9r1GsEK/LrXV/xCzKD+5gOJWOc0Kdr7pnoDk1Jf6Qv5nPQbz1mW9wCMz/OTZU33X
	 n+x9+uQQ/e+5HzuEfRpGhcdBleABAUrMZot+1OqB/uocyXpGN2BeuJGRuxbRg6w0GkmFr
	 vLM6nkz2wX1DxvkkJleV3snOqMiura+ksPjXJVAJixrKJNprEuiy31vkf3RtyjnSulw6H
	 KjddvdAzREDOOtmdsZYb++qf9li1IlJKl/7Xg064cN2cprM+DA3oC9FlUImoXqMhmsSFV
	 Tzbuno4fQQ7hLKrV02t9h/teML1Lxg37dVU45UIydkUAPTX4dYDx+Yf9OqkA70Re/nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JND5ebdwUDIYiqHezBcYpsf0KYBIIE9OBiC+G8myDQw=;
	b=rzQR9ZBAZAqcxTJI0LOI9a9UOk3i8f/4XaIV3E/0RxyawQw14sDazyj/7YkxSXosKt+X
	 lL7aDYBTtqJUiJnYlrUtzJKS6EU6WoE5r2SAllm/mFcrLBSRYmxtfSTGRARNvs6QaZo+4
	 7D7UrEBvr8WHafvurzleSCBWOUkF1UGooO7BKXHzfl+OTpjoIwCaitAtWq83P3oa7fO8n
	 VFe5TBmE3zP5baHnRO8bPBOjnxX0omL5zoNsxUItEMLagV0Jz25E8zX2nNbjj6wO81Bu7
	 hBHqWLKJz2TCDaPcN2+KlR9n5sGVe19rVLQ4LAWPi/JOv+KvnwanGKKCd+C2tE0xNvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xPj/4jKC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F428606A321;
	Wed, 25 Nov 2026 15:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xPj/4jKC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251AD1F000D2;
	Wed, 25 Nov 2026 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620064;
	bh=JND5ebdwUDIYiqHezBcYpsf0KYBIIE9OBiC+G8myDQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xPj/4jKCK72ANLiBTuAYEya9PFG0Y0kheiA9nS9kwfamcy3q2Mniig88XI9g6JBbq
	 +2zVFYdNNLJLOUL9XscjeIKEkm7RN/j/EEHpSg2osSUbKpW5Vci79wb6ctZXLlsSvj
	 LQNsCxay9M7pTSsBBgr5XOFHyH3j8BMq+E9RQC2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0798/1005] wifi: mac80211: fix use-after-free when MLO link setup is rolled back
Date: Wed, 25 Nov 2026 15:35:36 +0100
Message-ID: <20261125143840.429413730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit a155ef2ef79531c139244289c5b8f15c05d16a0e upstream.

Rolling back an MLO link addition can free link containers while RCU
readers still hold pointers to them. ieee80211_vif_update_links()
publishes new links before checking for duplicate addresses and calling
drv_change_vif_links(). If either fails, it restores the old pointers
and frees the new containers without waiting for readers.

During a non-MLO to MLO transition, the published link 0 replaces the
deflink, so existing link 0 users can acquire the new container. Readers
such as ieee80211_csa_finish() and
ieee80211_obss_color_collision_notify() can also queue work embedded in
the link. If they queue after ieee80211_link_stop() cancels that work,
it remains queued when the container is freed.

Wait for RCU readers after restoring the old pointers and before
stopping the new links, so their work is queued before it is cancelled.

Fixes: d3e2439b0f33 ("wifi: mac80211: fix link manipulation")
Cc: stable@vger.kernel.org # 7.2.x
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261026152654.80697-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/link.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -400,6 +400,8 @@ static int ieee80211_vif_update_links(st
 		memcpy(sdata->link, old_data, sizeof(old_data));
 		memcpy(sdata->vif.link_conf, old, sizeof(old));
 		ieee80211_set_vif_links_bitmaps(sdata, old_links, dormant_links);
+		/* drain RCU readers before cancelling work they may queue */
+		synchronize_rcu();
 		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {
 			ieee80211_link_debugfs_remove(&links[link_id]->data);
 			ieee80211_link_stop(&links[link_id]->data);


