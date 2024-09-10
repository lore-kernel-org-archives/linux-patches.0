Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1D618E021;
	Tue, 10 Sep 2024 09:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962390; cv=none; b=rNX+UtMPcoN+vYoxWXv0/r1IXaJOpCfim0Mhl5377JjKnRN6xYROoG0XHfrzQiCwjzAIjxHWbxWHPVMMJW+kYxewozmPw8pwNsuqqIlmTs7tc3EcxmBN7wcR9XPevEnGSUovwJk44Y6bDQAaKWaPKUtQlO8XAhU6G0x/36zLyy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962390; c=relaxed/simple;
	bh=jOqfpA3xMmn9L9An1KuEWsWCL6zb8JTBoOWYCEOqt2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO5Bbfd3vu2i4gZSijpwj9vRLOeBXybidRDBdtROipliK6wBtfHZLK+czW+i4MxQH3iepzexoU3xf8pd1xCXvNT1Vn+mAT3bSAjcQQO3LIsCd/tSUXFEjUFUfTTrwi82qfaRDgKRLfFzxDYAl61v8GNwlPxJky6/dhtuDdzTRRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqy9mj0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqy9mj0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607D5C4CEC3;
	Tue, 10 Sep 2024 09:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962389;
	bh=jOqfpA3xMmn9L9An1KuEWsWCL6zb8JTBoOWYCEOqt2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqy9mj0Du3ZMiz1bD6LLMRmbcif/KId9om3LxDuQ48gK/SMGTJGjyZDrrXgGsXEEe
	 fjgI1sE+gn64syI55omtXPX0Vp1F+Yz2fY5Nhs9HPj56BvPORHI4pC9aNA97RPxnth
	 8ob4WC1N+0HMr3HhPbgXkVJGPcyGpsYwuiNX77EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/121] wifi: cfg80211: make hash table duplicates more survivable
Date: Tue, 10 Sep 2024 11:31:33 +0200
Message-ID: <20240910092546.600896301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c74882e3c309..b28e652514e8 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1003,7 +1003,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_get_bss);
 
-static void rb_insert_bss(struct cfg80211_registered_device *rdev,
+static bool rb_insert_bss(struct cfg80211_registered_device *rdev,
 			  struct cfg80211_internal_bss *bss)
 {
 	struct rb_node **p = &rdev->bss_tree.rb_node;
@@ -1019,7 +1019,7 @@ static void rb_insert_bss(struct cfg80211_registered_device *rdev,
 
 		if (WARN_ON(!cmp)) {
 			/* will sort of leak this BSS */
-			return;
+			return false;
 		}
 
 		if (cmp < 0)
@@ -1030,6 +1030,7 @@ static void rb_insert_bss(struct cfg80211_registered_device *rdev,
 
 	rb_link_node(&bss->rbn, parent, p);
 	rb_insert_color(&bss->rbn, &rdev->bss_tree);
+	return true;
 }
 
 static struct cfg80211_internal_bss *
@@ -1056,6 +1057,34 @@ rb_find_bss(struct cfg80211_registered_device *rdev,
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
@@ -1331,9 +1360,7 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 			bss_ref_get(rdev, pbss);
 		}
 
-		list_add_tail(&new->list, &rdev->bss_list);
-		rdev->bss_entries++;
-		rb_insert_bss(rdev, new);
+		cfg80211_insert_bss(rdev, new);
 		found = new;
 	}
 
@@ -2142,10 +2169,7 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
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
@@ -2153,9 +2177,7 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 		bss = container_of(nontrans_bss,
 				   struct cfg80211_internal_bss, pub);
 		bss->pub.channel = chan;
-		rb_erase(&bss->rbn, &rdev->bss_tree);
-		rb_insert_bss(rdev, bss);
-		rdev->bss_generation++;
+		cfg80211_rehash_bss(rdev, bss);
 	}
 
 done:
-- 
2.43.0



