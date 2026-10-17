Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C732D73A6;
	Sat, 17 Oct 2026 17:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257067; cv=none; b=WjYOi2VgVf0S2tYoFUgOoNnw5qjjHMmuZmJw2cQlVgG0ny9Eqe5/yOamFAcs0SzUvV1Q9Va03T6a8nQdaHSnbyVCCNTt2if6P7bm/iPtTYBqtDDd7VeFyeylJKQ2S8B4l3plHZvxB485iKoyUCJ1a7BIyziQlf9WcnKkhDFZVss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257067; c=relaxed/simple;
	bh=8cxjDedzLE9t6VoupKMXB/iyg7PeE4u0dxMFx+RLcJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oe/5KV32d8iUZO7L0XyP0HMchoIlCmeZ8R5dPepClSBRCLY3+8jsdweWjuw5sxrIY8kDfo7OHJjgqhnENaE6GSkOoN3RFt0JOWbGFjP7SYLEYeKLOCnnw46HEullQj0mc8PH+YE6Cuq1czP7oHP9go3WAH55yTfnRHjrmF1XniY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOfGPvmJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOfGPvmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8701F000C4;
	Sat, 17 Oct 2026 17:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257066;
	bh=ggjrSG2PLUs+2mDwj0XA1E5t0JqQK593R1zOAhOFH9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOfGPvmJzh2XKE5xMJPAkHEgHHiqZ2ehCzp9SHvL4w2ZuoXsoi3ZjVd5BcKiOxAoj
	 63v/oDONkVzsY9ufqAe7wOTIYDtwdaubLlsnFBI5HpjtIGsezAs381iFZ+P/gBtM/w
	 ZwWMHz4ZmobjJ6WZhMttoIGkXklldFj/AvbJnzNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Pesaresi <andreapesaresi82@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0442/1674] wifi: mac80211: set info->band for 802.3 encap offload frames
Date: Sat, 17 Oct 2026 17:45:14 +0200
Message-ID: <20261017160442.467663960@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 4febc02cd02f021f2b6d0768332be643ef14a12d ]

Unlike the 802.11 TX paths, ieee80211_8023_xmit() does not set
info->band from the channel context on non-MLD interfaces. It stays at
0, so ieee80211_get_tx_rates() uses the wrong band for these frames.

Set it the same way as ieee80211_build_hdr(): drop the frame if there is
no channel context, and leave the band at 0 on MLD interfaces.

Reported-by: Andrea Pesaresi <andreapesaresi82@gmail.com>
Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20260926120216.4054712-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 931acf3bb6da1..cc7507ffaf001 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4623,6 +4623,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_tx_info *info;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct tid_ampdu_tx *tid_tx = NULL;
 	struct sk_buff *seg, *next;
 	unsigned int skbs = 0, len = 0;
@@ -4672,6 +4673,16 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 		sdata = container_of(sdata->bss,
 				     struct ieee80211_sub_if_data, u.ap);
 
+	/* MLD transmissions must not rely on the band */
+	if (!ieee80211_vif_is_mld(&sdata->vif)) {
+		chanctx_conf = rcu_dereference(sdata->vif.bss_conf.chanctx_conf);
+		if (unlikely(!chanctx_conf)) {
+			kfree_skb_list(skb);
+			return;
+		}
+		info->band = chanctx_conf->def.chan->band;
+	}
+
 	info->flags |= IEEE80211_TX_CTL_HW_80211_ENCAP;
 	info->control.vif = &sdata->vif;
 
-- 
2.53.0



