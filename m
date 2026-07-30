Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247D04052DC;
	Thu, 30 Jul 2026 14:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423516; cv=none; b=XEIgooAKtv05/IF5jiRI8419zLHkywUZ6tAVm9HCKx5IDJ6vGV5S5pNCZkO5u2EAKTtlKFCUuj1v2tm474QQvT3ycBGoivuULfQaQ2vjs9jkZtA7STk2MtigwhC/nTLFY9mX5+F1gSZ8EI+9MU9sMnRxXga7FeNUl2TFV0gc+/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423516; c=relaxed/simple;
	bh=NAyxiTw9XjyA2ZuPQd8oNe9ePCfQhyjtMnVI+tX/IhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EsD6HosKlN6ArP4WAmHADNCl2h0nrAmEVkIeySgdJyYQ+fg9KVXHicb8K3YAQp9/edwg5qqwjoV7Iuva9QIdVFnwZz0cf3fyFRCphV1rPxXW2yoiHdkleVvjPbJLPl4A0IJnzVWmSeuq3RK+WFvnP4hfoGg+s6wvZjfNIdxAgMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMig2zsx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMig2zsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBEB1F000E9;
	Thu, 30 Jul 2026 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423515;
	bh=AZN/42f4ywc6FTeN3AIV2KpSjWNBN7hUq16+j/BFPLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMig2zsxS3agMrsyIK/cjlMHpr37kfrLhUL2rKfLySMD6eaAhaem4klyTCbIphw3D
	 9FEsrdSLHs48+Bc7FNIaJdQM+fBKJbE00v8yMW7FlqvqNKEY1EGT1JXvD8Fit8jelb
	 X0cS1MYvYx8zp6rq3P7nxax4ZaVXgvdwgEQ4de/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/675] wifi: mac80211: fix unsol_bcast_probe_resp double free on alloc failure
Date: Thu, 30 Jul 2026 16:06:39 +0200
Message-ID: <20260730141446.594400821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 1d067abcd37062426c59ec73dbc4e87a63f33fea ]

ieee80211_set_unsol_bcast_probe_resp() calls kfree_rcu() on the old
template before allocating the replacement. If the kzalloc() then fails,
it returns -ENOMEM while link->u.ap.unsol_bcast_probe_resp still points
at the object already queued for freeing. A later update or AP teardown
re-queues that same rcu_head; the second free is caught by KASAN when the
RCU sheaf is processed in softirq:

  BUG: KASAN: double-free in rcu_free_sheaf (mm/slub.c:5850)
  Free of addr ffff88800d06f300 by task exploit/145
   ...
   __rcu_free_sheaf_prepare (mm/slub.c:2634 mm/slub.c:2940)
   rcu_free_sheaf (mm/slub.c:5850)
   rcu_core (kernel/rcu/tree.c:2617 kernel/rcu/tree.c:2869)
   handle_softirqs (kernel/softirq.c:622)
  The buggy address belongs to the cache kmalloc-128 of size 128

Queue the old object for kfree_rcu() only after the new one is published,
matching ieee80211_set_probe_resp() and ieee80211_set_s1g_short_beacon().

Fixes: 3b1c256eb4ae ("wifi: mac80211: fixes in FILS discovery updates")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260621093532.884188-1-xmei5@asu.edu
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d32eacbb7517d7..001e4bb55b6199 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1157,8 +1157,6 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 	link_conf->unsol_bcast_probe_resp_interval = params->interval;
 
 	old = sdata_dereference(link->u.ap.unsol_bcast_probe_resp, sdata);
-	if (old)
-		kfree_rcu(old, rcu_head);
 
 	if (params->tmpl && params->tmpl_len) {
 		new = kzalloc(sizeof(*new) + params->tmpl_len, GFP_KERNEL);
@@ -1171,6 +1169,9 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 		RCU_INIT_POINTER(link->u.ap.unsol_bcast_probe_resp, NULL);
 	}
 
+	if (old)
+		kfree_rcu(old, rcu_head);
+
 	*changed |= BSS_CHANGED_UNSOL_BCAST_PROBE_RESP;
 	return 0;
 }
-- 
2.53.0



