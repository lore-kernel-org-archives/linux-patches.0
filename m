Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAB537D11B;
	Mon,  4 May 2026 14:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904131; cv=none; b=XT+K2aRrY+QwM6rNoJOwN/ZMjj+D09UKqQbt2Nm+QS9+FgmPkNoM6OmwN76arq0ZOUUj2nOzv8tU6SbG6mWFAp4xjwFcZv5wQeRTU768D2uCJlTWsyqjQleXBfcCionT/1urV0uMZ4Qpgevui/2J+p8mTAaDVxBiwe/AsKK21Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904131; c=relaxed/simple;
	bh=fCI4jqhH01adjbhNNox9Vv4NlxAGYi86baOL68VW66Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU7DTG8DLbyWuLHPMjGf3YFsG12SbrgzzQAquin0Fa8k8Mtb3+OmZU8jQOfNBs9CuwbhDTrOaLC9FUHvri/hRHauRvabyEmytFMJseKLQMKjKa7O7Mg90DAaioIc9rsfDAwB87K6XiMeDPn02+dK7RHKfsq+Pc0STnZfpbEd22c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwic7mf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwic7mf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F405FC2BCB8;
	Mon,  4 May 2026 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904131;
	bh=fCI4jqhH01adjbhNNox9Vv4NlxAGYi86baOL68VW66Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwic7mf4SFBlDm+2wH1Zzuvk+sRWY5Uf9jadcPde8D/p7uQHiooZabrJqcRMSmwBk
	 FT61/jsp2Orc5OjrCCeOl/9ug19LpJ/SsVIrm6ZJSvYMUlXpTBEVl/mn4tVLv+ny3n
	 BVrvffvDS3hQ58g2Wo6F4+KHfcFeORvc17kVgwUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Liu <liuyun01@kylinos.cn>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 162/275] mm/mempolicy: fix memory leaks in weighted_interleave_auto_store()
Date: Mon,  4 May 2026 15:51:42 +0200
Message-ID: <20260504135149.065364268@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Jackie Liu <liuyun01@kylinos.cn>

commit 6fae274ce0e3109cbbc4c18b354eaace1f0af7d7 upstream.

weighted_interleave_auto_store() fetches old_wi_state inside the if
(!input) block only.  This causes two memory leaks:

1. When a user writes "false" and the current mode is already manual,
   the function returns early without freeing the freshly allocated
   new_wi_state.

2. When a user writes "true", old_wi_state stays NULL because the
   fetch is skipped entirely. The old state is then overwritten by
   rcu_assign_pointer() but never freed, since the cleanup path is
   gated on old_wi_state being non-NULL. A user can trigger this
   repeatedly by writing "1" in a loop.

Fix both leaks by moving the old_wi_state fetch before the input check,
making it unconditional.  This also allows a unified early return for both
"true" and "false" when the requested mode matches the current mode.

Link: https://lore.kernel.org/20260401005702.7096-1-liu.yun@linux.dev
Link: https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev
Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed by: Donet Tom <donettom@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org> # v6.16+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3636,18 +3636,19 @@ static ssize_t weighted_interleave_auto_
 		new_wi_state->iw_table[i] = 1;
 
 	mutex_lock(&wi_state_lock);
-	if (!input) {
-		old_wi_state = rcu_dereference_protected(wi_state,
-					lockdep_is_held(&wi_state_lock));
-		if (!old_wi_state)
-			goto update_wi_state;
-		if (input == old_wi_state->mode_auto) {
-			mutex_unlock(&wi_state_lock);
-			return count;
-		}
+	old_wi_state = rcu_dereference_protected(wi_state,
+				lockdep_is_held(&wi_state_lock));
+
+	if (old_wi_state && input == old_wi_state->mode_auto) {
+		mutex_unlock(&wi_state_lock);
+		kfree(new_wi_state);
+		return count;
+	}
 
-		memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
-					       nr_node_ids * sizeof(u8));
+	if (!input) {
+		if (old_wi_state)
+			memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
+						       nr_node_ids * sizeof(u8));
 		goto update_wi_state;
 	}
 


