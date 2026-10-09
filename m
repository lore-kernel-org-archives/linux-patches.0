Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A07B3D9DDB;
	Fri,  9 Oct 2026 14:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557188; cv=none; b=cLpLtBYflaFm4fjtd+dwdTK6BS7NYicy7o+dZtSk5nSZ+iy5dz3FdFN+Zh6ttg/qObhJYKlSWZ7f4GRJ31HXelUl1p5CKtEBG7WtnHB1N+MJlhAWCL4T7vfTH+FNXgUr/+DIhHkY008Vmq/FGRoVtCAYbrsSuQWoXVrYbmyvlaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557188; c=relaxed/simple;
	bh=E2OeaQ/bQDbnWDU2IqYxvhheVL90O2QIC5AlKtTi95Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qf611xtVvLyOI37lGkoAeUiHBX9kgYh75oWp1cE0EgocKUQ11sbX2qqUL7eK9Q6x5bW8acFHw4U/Xl6bNLchttWpG7601nH7lFrT2MzMHHFEHAGJtp9tt4g0uZIJOruVQdAw9ikj+UqqPaczo97TzxiAFYF4ABhqKgSf3JWDrQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPfh3EMo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPfh3EMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D39A1F000FF;
	Fri,  9 Oct 2026 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557187;
	bh=SH/NmHmMT2EW0/0X+v1uHOWkgIrx2O9rIoOmX497TLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPfh3EMoYZX3TOGB5EYU4YpUXfylHqgPxuQEHZdrLIwkgT4W1S932PBUrsri9lwKO
	 Nmr53DWvNRY67aM3Uk1PKqwmWVJHUQd1b8RnkQaqg667VknU9djvuUJO3Ib7mDkzH7
	 QTe2Ie+s95jmh+7R8aG+1boQHE05OE8zEVUdprtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 361/403] wifi: mac80211: Add sta pointer sanity check in ieee80211_8023_xmit()
Date: Fri,  9 Oct 2026 16:12:02 +0200
Message-ID: <20261009141000.729962686@linuxfoundation.org>
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

From: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>

[ Upstream commit 303f11fda2fa4c6f7aa86b8fa54aaee5e1ef181b ]

Currently ieee80211_8023_xmit() accesses the sta pointer without any
sanity check, assuming that only unicast packets for an authorized
station are processed. But the sta pointer could become NULL when
a framework to support 802.3 offload for the multicast packets is
added in the follow-up patches. Add the valid sta pointer sanity
check to avoid the invalid pointer access.

This aligns with some of the subordinate functions called by
ieee80211_8023_xmit() that already NULL-check 'sta' such as
ieee80211_select_queue() and ieee80211_aggr_check().

Signed-off-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
Link: https://patch.msgid.link/20260604162403.1563729-2-tamizh.raja@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 4febc02cd02f ("wifi: mac80211: set info->band for 802.3 encap offload frames")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4659,7 +4659,7 @@ static void ieee80211_8023_xmit(struct i
 {
 	struct ieee80211_tx_info *info;
 	struct ieee80211_local *local = sdata->local;
-	struct tid_ampdu_tx *tid_tx;
+	struct tid_ampdu_tx *tid_tx = NULL;
 	struct sk_buff *seg, *next;
 	unsigned int skbs = 0, len = 0;
 	u16 queue;
@@ -4679,7 +4679,9 @@ static void ieee80211_8023_xmit(struct i
 	ieee80211_aggr_check(sdata, sta, skb);
 
 	tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
-	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
+
+	if (sta)
+		tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
 	if (tid_tx) {
 		if (!test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
 			/* fall back to non-offload slow path */
@@ -4727,8 +4729,11 @@ static void ieee80211_8023_xmit(struct i
 	}
 
 	dev_sw_netstats_tx_add(dev, skbs, len);
-	sta->deflink.tx_stats.packets[queue] += skbs;
-	sta->deflink.tx_stats.bytes[queue] += len;
+
+	if (sta) {
+		sta->deflink.tx_stats.packets[queue] += skbs;
+		sta->deflink.tx_stats.bytes[queue] += len;
+	}
 
 	ieee80211_tpt_led_trig_tx(local, len);
 


