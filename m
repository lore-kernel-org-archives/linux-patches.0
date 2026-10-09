Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA59046EF92;
	Fri,  9 Oct 2026 14:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557193; cv=none; b=gysUOejqySSg+yMOT/o37IXImg3nx+A1CvSBchNvZ8EmUVGQceBuzyv9fsQ9t1NbxVILcBbXPmupMIF1WjfGyUILDKFz0LHmIqK4dYmlL+j2p1VtJ/n51LS8hpenNx8HOo9mStC2Xqh5gKCxFXz/gjWS+ZdkKmpnB2Dd7/7/UQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557193; c=relaxed/simple;
	bh=1K/8BlcHiz6LhNuUqYD7Ip+16d7SEateNutLtOKykYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bFNJOZcLNK+es+TfezoRxqfo2Cgb6Qg0vXuSrVKFd7yijbYFLfeN9VXWv9OlK3QbMpdvnzXubsrIInuEnAxGH79nD/S+SAJ9z3lNuxvvSY4EpSVaEp2/VuMADtfqUk7OD/Zs/Z4Vc3McQ/Q6z4Zx3YGZSBx30f8Co2eu7XkgfXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/7pKhYe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/7pKhYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340EE1F000FF;
	Fri,  9 Oct 2026 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557192;
	bh=zcs/duF3hRTaxrvvYmbcYPqUNpGHWg/dkXprLsR0YBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/7pKhYeBO18vMee6TuZXgBEnnY6Mpaqnq/ASSkHIVVwMxB91ICY88qBvOsc+F/Vm
	 4zrImGCnSRd9qh0TfZ9DsEhAR9hq/xDjn9Fk6aUH1I6rQd69EY1qBbfwxzl7aMB1ra
	 llBE8lvFOAhrYxZ2FrXmY/2L1qBdjw/wS42AUz0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Pesaresi <andreapesaresi82@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 362/403] wifi: mac80211: set info->band for 802.3 encap offload frames
Date: Fri,  9 Oct 2026 16:12:03 +0200
Message-ID: <20261009141000.755772482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4659,6 +4659,7 @@ static void ieee80211_8023_xmit(struct i
 {
 	struct ieee80211_tx_info *info;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct tid_ampdu_tx *tid_tx = NULL;
 	struct sk_buff *seg, *next;
 	unsigned int skbs = 0, len = 0;
@@ -4708,6 +4709,16 @@ static void ieee80211_8023_xmit(struct i
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
 


