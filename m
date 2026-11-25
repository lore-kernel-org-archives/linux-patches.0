Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623322;
	b=K4Zd6VP5eYLZZImnisla8G50ZTLwjlxaAeUZp0D21a+S0JzNpHyVkPjF4Pz0+z8vDzZJ
	 IGwdFakcCXli+LAJK3fXQRLSTc6rJBgjwd/Lo0/2PLkq0lYMKg40ofYy7V/FjIB01bn28
	 Gc3bELpWRQiJ67nJqqXI9mQthuCW0Q5mPGWkfVbhpe/rw32tcexUnwAdBV7kbjY95ZsPM
	 60cFUFBafenv/Qa11GKHQelZCXr9QqM88JqTXdmo8uoO+50Y+GvRjawr0RNHOmkWDeclP
	 LMo6DxD46d/SExDH7evwNpgdXlFeSM/7mv1aXtzPAH8eqohz5BeTCHqa1AuRSRg2+Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kwuF0eprlx/FEX9IkMdh+7CJaBb/O2pnQKsVu/7c/a8=;
	b=oBg0RFwdkeKfQXNijUTCNZx8NqHOFCiw4zmw7b0XjA7UvHBjPE6ks30CU3gqgQMam9QA
	 wc0CBg+piTFDQysaK+aqDaQ91Jz/0ZKseK5XffY0zQvIiPa0iQZ5OwY6byt092+ev42dY
	 cFRkx4c4BMQBhGM4mhJzpHKmClZcpSC/q3ucO8ECDPrf/KfOJPwzHTOrrYSRz17iB4lgV
	 EQsOEMJxYBGjs5SSNc/qmA0KNfiHO84e/7u9/srqw0vnzHNdfH7mxUbi9rvI2DgtFvagy
	 BPmy1zmrDlQPtF5dkzzkeNijIkXkVVFKfrRYw9cFLv4jH0Jk8bgGKk1w9nI9QucOk+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5X449wr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9655606A323;
	Wed, 25 Nov 2026 16:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5X449wr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B921F000E6;
	Wed, 25 Nov 2026 16:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623322;
	bh=kwuF0eprlx/FEX9IkMdh+7CJaBb/O2pnQKsVu/7c/a8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5X449wr1z48gIqRJJWxCO4O0i9ofuSZyYYKB1q8B9dseNtyALoQ4QTtyq0x86790
	 vjXlztOZ28MNBym7ZeHp9p0IwarH6ApVt9R1cjXaRwivbfxK7xUX4JgIEjaINuh4py
	 F/zSRvNu13nGwTvxWb3VBE9VxYOfAcJ2ymFS/4lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 820/990] wifi: mac80211: restore dormant links when link updates fail
Date: Wed, 25 Nov 2026 15:36:27 +0100
Message-ID: <20261125143841.246895372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit bb22f3b2d8f8a2f883944f24678cf84e18b162e8 upstream.

A failed MLO link update can leave the interface with the requested
dormant-links bitmap instead of its previous one. This can disable active
links or trigger a bitmap warning during rollback.

The error path restores the old valid-links bitmap but passes the new
dormant_links argument to ieee80211_set_vif_links_bitmaps().

Save the old dormant bitmap before changing link state and use it when
restoring the old configuration.

LLM assistance was used to find the bug and review.

Fixes: 6d543b34dbcf ("wifi: mac80211: Support disabled links during association")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142123.13072-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/link.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -284,6 +284,7 @@ static int ieee80211_vif_update_links(st
 {
 	u16 old_links = sdata->vif.valid_links;
 	u16 old_active = sdata->vif.active_links;
+	u16 old_dormant = sdata->vif.dormant_links;
 	unsigned long add = new_links & ~old_links;
 	unsigned long rem = old_links & ~new_links;
 	unsigned long sta_rem = rem;
@@ -390,7 +391,7 @@ static int ieee80211_vif_update_links(st
 		/* restore config */
 		memcpy(sdata->link, old_data, sizeof(old_data));
 		memcpy(sdata->vif.link_conf, old, sizeof(old));
-		ieee80211_set_vif_links_bitmaps(sdata, old_links, dormant_links);
+		ieee80211_set_vif_links_bitmaps(sdata, old_links, old_dormant);
 		/* drain RCU readers before cancelling work they may queue */
 		synchronize_rcu();
 		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {


