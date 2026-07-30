Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA29F443318;
	Thu, 30 Jul 2026 14:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421296; cv=none; b=T7D/zd6cfaK4kK5DgZvBnT86mD72yRSZjj84ozS1nxd9tA7ZJKVNornLCkFLhl4IAOcLbKh5ZgUr8RzigZ0V2IyohKIPntOHVKpf4K9h7iAi8uFX9ZLyTmnokB4KeCttxIqULnTvrwDMo8PiNcbGtXV/EmwSS0lFbK9Xpo7ypzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421296; c=relaxed/simple;
	bh=+NsQvlU+ZsGgcd66i9gCbOp0Wpx1SBQWI5o2qDfxbk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEW3qQ8ZzuZqFE/OF9VZ/D0nJEGm+zR29YQMo3Rzjv3e07h0eayNY5fpq9G2IgwBo9g0nspKNkOv8SyANGCXJ7iLqh9xfTuEjiaCoItbaij2uWohCOxmX/8wJ2PSkHeHa7rI8zwZzKJDRedLT7afK2Kh4lmtbd3dmH7YdxrlwVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11pW9x8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11pW9x8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B231F00A3A;
	Thu, 30 Jul 2026 14:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421290;
	bh=1fqdDEfMGX4QF39soodREoQV8t/d5A3919D5T2NGVI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11pW9x8YPe25RSKBu98zvcqvQtcccgvOnIC+lN7TrX9mJQ1stX5VcZPXeoZajlILm
	 CZ1cI3pq71aoMMfbp5zB9CbBQhEtstKVZ8lycCSJhN1z6uu1Wvstf7INb90jSVWB/u
	 kSLXfxCWziaduAnR7mWSGj3nX1gwkb3cibHQiCG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 054/744] wifi: mac80211: fix unsol_bcast_probe_resp double free on alloc failure
Date: Thu, 30 Jul 2026 16:05:27 +0200
Message-ID: <20260730141445.425996344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index f9ee9947a94d66..e926bced6a313d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1178,8 +1178,6 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 	link_conf->unsol_bcast_probe_resp_interval = params->interval;
 
 	old = sdata_dereference(link->u.ap.unsol_bcast_probe_resp, sdata);
-	if (old)
-		kfree_rcu(old, rcu_head);
 
 	if (params->tmpl && params->tmpl_len) {
 		new = kzalloc(sizeof(*new) + params->tmpl_len, GFP_KERNEL);
@@ -1192,6 +1190,9 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
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



