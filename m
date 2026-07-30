Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8583A6B7F;
	Thu, 30 Jul 2026 14:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421298; cv=none; b=P2AnPKXihrQmq3lMf0OR+wfzobpWtIFrjVGS9Wht0zcVr0phaEc1jbqHyAmFTkJweGZDu9BeBu6kz/vH2YP7TRfYhYj6GWLmvaBhNy+ZuzwM83P26ir28g26E6LCAGsYRfb3pS+hCPiNdRHrAlm+hqPL7H54YMUfBTUvdXjgsB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421298; c=relaxed/simple;
	bh=bbi8vJj9re4tOV+L4T75WNdLw/MYXvao6yKNVtGd0M8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WU+OReEuHWmKVVQu7zB/RN7B/cYGiYi7pOalimlB5MxB8tx13kqwmPIlf2hiRLAsFoR3bm1vBbGvTTyNfM0whWX7en9hJgUzKT5b75Vhfg78luGeGV8vSuMFBXXhvXjXhffPfkbCESAMSIQ8PqiAc3KAslZbhMzHb6c47heOpxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ViZsJZuw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ViZsJZuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D441F000E9;
	Thu, 30 Jul 2026 14:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421293;
	bh=9tnkHgMz+YvF4vEUtl9xRcR6knd1kh7wP/qmixfCO/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ViZsJZuwjIcWgVReo2IBhFKYyX6aQfAQfIeNqrmlOFdT3/4Mi5F0LrZgJ1DJyy6A1
	 5XBEa+AKMUiYm3viWSsTlbRYyJRdw0DNwGbCX1Cb6YwU+Zvov1lONfqIZ7CKKweOtO
	 24Dx5dbaSTIOR1lsn1590+cfOSbSD598BRu9w7/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 055/744] wifi: mac80211: fix fils_discovery double free on alloc failure
Date: Thu, 30 Jul 2026 16:05:28 +0200
Message-ID: <20260730141445.446924085@linuxfoundation.org>
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

[ Upstream commit 286e52a799fa158bdbd77da1426c4d93f9a6e7ad ]

ieee80211_set_fils_discovery() calls kfree_rcu() on the old template
before allocating the replacement. If the kzalloc() then fails, it
returns -ENOMEM while link->u.ap.fils_discovery still points at the
object already queued for freeing. A later update or AP teardown
(ieee80211_stop_ap()) re-queues that same rcu_head; the second free is
caught by KASAN when the RCU sheaf is processed in softirq:

  BUG: KASAN: double-free in rcu_free_sheaf (mm/slub.c:5850)
  Free of addr ffff88800c065280 by task swapper/0/0
   ...
   __rcu_free_sheaf_prepare (mm/slub.c:2634 mm/slub.c:2940)
   rcu_free_sheaf (mm/slub.c:5850)
   rcu_core (kernel/rcu/tree.c:2617 kernel/rcu/tree.c:2869)
   handle_softirqs (kernel/softirq.c:622)
  The buggy address belongs to the cache kmalloc-96 of size 96

Queue the old object for kfree_rcu() only after the new one is published,
matching ieee80211_set_probe_resp() and ieee80211_set_s1g_short_beacon().

Fixes: 3b1c256eb4ae ("wifi: mac80211: fixes in FILS discovery updates")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260621093532.884188-2-xmei5@asu.edu
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e926bced6a313d..0bc10136b816ef 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1145,9 +1145,6 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
 	fd->max_interval = params->max_interval;
 
 	old = sdata_dereference(link->u.ap.fils_discovery, sdata);
-	if (old)
-		kfree_rcu(old, rcu_head);
-
 	if (params->tmpl && params->tmpl_len) {
 		new = kzalloc(sizeof(*new) + params->tmpl_len, GFP_KERNEL);
 		if (!new)
@@ -1159,6 +1156,9 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
 		RCU_INIT_POINTER(link->u.ap.fils_discovery, NULL);
 	}
 
+	if (old)
+		kfree_rcu(old, rcu_head);
+
 	*changed |= BSS_CHANGED_FILS_DISCOVERY;
 	return 0;
 }
-- 
2.53.0



