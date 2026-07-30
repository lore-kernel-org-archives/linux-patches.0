Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1E544C4F8;
	Thu, 30 Jul 2026 15:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425408; cv=none; b=QwTqFwLfhX9y+TIKwuLRlugiWj30hunVhlR4GRYYO3V99JDQJ8YEVbQckJZp1YL5P211tK8goi3D3aeSAWfK7saA1kMcDZgaqgZhCvWDJrNhjLSd1yl3EsiJPmKSTLDWVrhm3YSTdOEiJJUDooybMPYi3JQO9V7V7fH8gKtUrA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425408; c=relaxed/simple;
	bh=DMW1blay+xjs83ko4Dy43tHcO0VZrH1cJPwASK1j9b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKA8+ucYO+2r1OWpzfJ3GoKA6GwUP5IPy+aSFg3veJ9psZ0T/Y7yT4QE5YazuNYvbcCrIbdjQQK4vcO0LWvPrZZwnlmVyO4W8MF4SUjmZ9NFcNk2Ru7MdEJLeY8XukKM5QOzZux073SQMO6XCjD5KyFBpCyawTb1xt2XjeLCGkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJojyrRj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJojyrRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BE41F000E9;
	Thu, 30 Jul 2026 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425403;
	bh=RvvEcdROgaHI8K1iJMBYdFm5HMk12bD5gkn42t8dHX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJojyrRjQrzd0bvktmp2B95AOJROl39GaisYtZwNFpEc+YcnghroRT+om8mFlonWD
	 pnsiZ7NzRePl1EYIIu8WFy4qfni0xNqdG80qx4MNufjsxZEF+qhgYuUYd5hE5Q8IvD
	 oVve6b2hxQlb1unEF1QHKUVCPJZLRZlO3Q0O6YAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/602] wifi: mac80211: fix unsol_bcast_probe_resp double free on alloc failure
Date: Thu, 30 Jul 2026 16:07:30 +0200
Message-ID: <20260730141437.222264566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 0abb687fd58d5c..981f316df9cd9e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1010,8 +1010,6 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 	link_conf->unsol_bcast_probe_resp_interval = params->interval;
 
 	old = sdata_dereference(link->u.ap.unsol_bcast_probe_resp, sdata);
-	if (old)
-		kfree_rcu(old, rcu_head);
 
 	if (params->tmpl && params->tmpl_len) {
 		new = kzalloc(sizeof(*new) + params->tmpl_len, GFP_KERNEL);
@@ -1024,6 +1022,9 @@ ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
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



