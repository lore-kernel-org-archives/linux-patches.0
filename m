Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CE41991C9;
	Thu,  5 Sep 2024 09:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529895; cv=none; b=HsMcC0btuyGOzjNizlvVXiiJFQzsLDlZqG7Oo+t+5HUd9+GIx4pBqCTZy5HgxeMWoJPr6BmCzgqX47ML01yAmGavHtmp4P1UKNQcysXepjJVbW41zXYpVCkHAn7ujcmFe2lfmveOM6sNYMczWuwU8mnYYXYZ2XeQ/GR+CdV7ZEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529895; c=relaxed/simple;
	bh=tHEvlODD0tqitD3+LNfW37TrH9mZeOD+ktySSHFPrdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QU2Mc3t9hmGC/MbTrYw7+InwGLoti/NvmDMACW4kBYTeOACXi8cy03g7TephFgS2gsx1d8Sut/OvKuT8Bmyjt7hBf6dx+wfQWEm9reSKosqzznuVtpYbv+h3TSIJlBaxjjcIk1MrUxbzWPGaUB4TTMvJbmSPlv0GKz2+IXQsp6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTUHLuw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTUHLuw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0836C4CEC3;
	Thu,  5 Sep 2024 09:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529895;
	bh=tHEvlODD0tqitD3+LNfW37TrH9mZeOD+ktySSHFPrdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTUHLuw6HJ7VzMbZIqky5YR1rDdr22/ZpCOWCUy+y00+OqhjjJHzFYnkKA5kmo+0H
	 dwV8OIoL+OLQCiDKcAiAE2kLHwjrZdd94YnaurvrY2OSiLQa967wGfWebQ0IqMuPUZ
	 7wHy7Iu6TFTSHPqiYeyOqKtenGX2cUpZYnbrAHN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 158/184] wifi: cfg80211: make hash table duplicates more survivable
Date: Thu,  5 Sep 2024 11:41:11 +0200
Message-ID: <20240905093738.512444250@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7f12e26a194d0043441f870708093d9c2c3bad7d ]

Jiazi Li reported that they occasionally see hash table duplicates
as evidenced by the WARN_ON() in rb_insert_bss() in this code.  It
isn't clear how that happens, nor have I been able to reproduce it,
but if it does happen, the kernel crashes later, when it tries to
unhash the entry that's now not hashed.

Try to make this situation more survivable by removing the BSS from
the list(s) as well, that way it's fully leaked here (as had been
the intent in the hash insert error path), and no longer reachable
through the list(s) so it shouldn't be unhashed again later.

Link: https://lore.kernel.org/r/20231026013528.GA24122@Jiazi.Li
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://msgid.link/20240607181726.36835-2-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 46 +++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 292b530a6dd3..64c779788a64 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1604,7 +1604,7 @@ struct cfg80211_bss *__cfg80211_get_bss(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(__cfg80211_get_bss);
 
-static void rb_insert_bss(struct cfg80211_registered_device *rdev,
+static bool rb_insert_bss(struct cfg80211_registered_device *rdev,
 			  struct cfg80211_internal_bss *bss)
 {
 	struct rb_node **p = &rdev->bss_tree.rb_node;
@@ -1620,7 +1620,7 @@ static void rb_insert_bss(struct cfg80211_registered_device *rdev,
 
 		if (WARN_ON(!cmp)) {
 			/* will sort of leak this BSS */
-			return;
+			return false;
 		}
 
 		if (cmp < 0)
@@ -1631,6 +1631,7 @@ static void rb_insert_bss(struct cfg80211_registered_device *rdev,
 
 	rb_link_node(&bss->rbn, parent, p);
 	rb_insert_color(&bss->rbn, &rdev->bss_tree);
+	return true;
 }
 
 static struct cfg80211_internal_bss *
@@ -1657,6 +1658,34 @@ rb_find_bss(struct cfg80211_registered_device *rdev,
 	return NULL;
 }
 
+static void cfg80211_insert_bss(struct cfg80211_registered_device *rdev,
+				struct cfg80211_internal_bss *bss)
+{
+	lockdep_assert_held(&rdev->bss_lock);
+
+	if (!rb_insert_bss(rdev, bss))
+		return;
+	list_add_tail(&bss->list, &rdev->bss_list);
+	rdev->bss_entries++;
+}
+
+static void cfg80211_rehash_bss(struct cfg80211_registered_device *rdev,
+                                struct cfg80211_internal_bss *bss)
+{
+	lockdep_assert_held(&rdev->bss_lock);
+
+	rb_erase(&bss->rbn, &rdev->bss_tree);
+	if (!rb_insert_bss(rdev, bss)) {
+		list_del(&bss->list);
+		if (!list_empty(&bss->hidden_list))
+			list_del_init(&bss->hidden_list);
+		if (!list_empty(&bss->pub.nontrans_list))
+			list_del_init(&bss->pub.nontrans_list);
+		rdev->bss_entries--;
+	}
+	rdev->bss_generation++;
+}
+
 static bool cfg80211_combine_bsses(struct cfg80211_registered_device *rdev,
 				   struct cfg80211_internal_bss *new)
 {
@@ -1969,9 +1998,7 @@ __cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 			bss_ref_get(rdev, bss_from_pub(tmp->pub.transmitted_bss));
 		}
 
-		list_add_tail(&new->list, &rdev->bss_list);
-		rdev->bss_entries++;
-		rb_insert_bss(rdev, new);
+		cfg80211_insert_bss(rdev, new);
 		found = new;
 	}
 
@@ -3354,19 +3381,14 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 		if (!WARN_ON(!__cfg80211_unlink_bss(rdev, new)))
 			rdev->bss_generation++;
 	}
-
-	rb_erase(&cbss->rbn, &rdev->bss_tree);
-	rb_insert_bss(rdev, cbss);
-	rdev->bss_generation++;
+	cfg80211_rehash_bss(rdev, cbss);
 
 	list_for_each_entry_safe(nontrans_bss, tmp,
 				 &cbss->pub.nontrans_list,
 				 nontrans_list) {
 		bss = bss_from_pub(nontrans_bss);
 		bss->pub.channel = chan;
-		rb_erase(&bss->rbn, &rdev->bss_tree);
-		rb_insert_bss(rdev, bss);
-		rdev->bss_generation++;
+		cfg80211_rehash_bss(rdev, bss);
 	}
 
 done:
-- 
2.43.0



