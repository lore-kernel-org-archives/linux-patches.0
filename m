Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321DE38C2C0;
	Sat, 17 Oct 2026 18:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260153; cv=none; b=BbFpKfM2TuMVYrLGDQa/6UMuzUsLlnaxUo5O2fLnn5KGlSZJ5vk9CTVE9VCdUltOXvMt15KN3E4c7JpnZ1FxmbmD9iFKKXBW//8sWd6UU87ZRZc4OC0cRIAR9LkDgLG/mBf/rxg+kHlKcM7xs2cCZ+QfYY7OEgOqVa7Z3tjsFko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260153; c=relaxed/simple;
	bh=FcLTqdinmjbrPLRzgv2xNUmpxXb4UPR1CAuhh6SLfEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYQYgjOzPDH4sgMfjbUtLQbvabA7nu3aNctLK9n7J2Yg3uWdYqyBUkxhTbJODbv6UTwzWlHRLh+6gtOguyJ+IlixHCHAcogL7txE6lVdFJHNehL1n9LWLOj4mj8tarP1B3I6UNHl+AOjNgJ6R95vK9Y8UcHreOHz7bdwmvvOXMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vg4FOkq0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vg4FOkq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE6C1F000C4;
	Sat, 17 Oct 2026 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260152;
	bh=VH0+0anYqHRFGMxvj6O03itMUyYnVwvaJg9t/c2R4MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vg4FOkq0TDpB8nH9qCuFFufgFsUfM4OEbUaKNq7kTqkDn4NwsuPPxSpUXHF2oLraV
	 94bFUlqAuAAhga5SP5k/En51GfRx0qzV7D/t61tXRKZViaR6MLDsSHXBLU/aFBPuwa
	 7EaHg2he6bVKs6pgQ1SgasI41ZETz70z3vVsMWRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1449/1674] wifi: mt76: mt7915: Fix an error handling path in mt7915_add_interface()
Date: Sat, 17 Oct 2026 18:02:01 +0200
Message-ID: <20261017160508.376176177@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 126a516fe30639708e759678bcb10178938cc718 ]

If mt76_wcid_alloc() fails, the "mt76.mutex" mutex needs to be released as
done in the other error handling paths of mt7915_add_interface().

Fixes: f3049b88b2b3 ("wifi: mt76: mt7915: allocate vif wcid in the same range as stations")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/b9d8fbfc19360bfe60b9cea1cb0f735ab3b4bc26.1727639596.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 2fb6480c52f6 ("wifi: mt76: mt7915: unwind state on add_interface failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index 22875dc94b5b8..05d22da7ee654 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -246,8 +246,10 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	phy->omac_mask |= BIT_ULL(mvif->mt76.omac_idx);
 
 	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, mt7915_wtbl_size(dev));
-	if (idx < 0)
-		return -ENOSPC;
+	if (idx < 0) {
+		ret = -ENOSPC;
+		goto out;
+	}
 
 	INIT_LIST_HEAD(&mvif->sta.rc_list);
 	INIT_LIST_HEAD(&mvif->sta.wcid.poll_list);
-- 
2.53.0



