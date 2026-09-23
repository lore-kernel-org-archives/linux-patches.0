Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194734756D2;
	Wed, 23 Sep 2026 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173990; cv=none; b=SIAXrAk1VRJq3CNnCMDxQ1BWi7r1Ze9VaJyCOMAl+cMx/V3YHx4/lCXPgCbgqItjHyRwsGqodTgSic6t0TNRdka+noFJ6F5cxqVQhyC6O7Zds9f9oHoVrvabLj0hTSbTscGtvUJn08qJwN2KjTkEC6TGxE4jSsuo0rDVAGmrfDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173990; c=relaxed/simple;
	bh=dAxfpnyK1jPV/EFejIJzcMXcJUYAdi7Za0hcqj4aafk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0A+LKLxobt0ZGTNVbK+i60vUgWmbpYsSkV7KszarI8cJZyPKVjfMGTFWwqVSKqo4xwr+HAJ4tK7Pkn6RZcvvk5LBRvdV3oVUtyJ3i9xex5QC87s7bB0/QANi9iXgNfAgwFOVyf+QUq49hgdIc8/mJ5+mz7IxnSPlDBwd+iS9ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6ahmwLV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6ahmwLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A6F1F000FF;
	Wed, 23 Sep 2026 14:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173988;
	bh=iX2VoU9G/AuQ4xhFchACUoFlW/CmrktACSi367jV5lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6ahmwLVJ2x+3rVGcQbGlvW53uMqzIr30BxHb1zLaSvkmcng9sDoifCP6/zmxLzBo
	 vfSGPEVefAPsJvBgBIOh7a8i+P0f3GQMUdZRqVmdX26OU05iW8eQ+lhFADjT4U8ncC
	 dcFa0B8KsPOqmPhhkdyPMyqfZnGjbQqFDSTn6OPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Pustogarov <ivan@ipust.net>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 398/438] wifi: mac80211: avoid out-of-bounds read for empty PREQ elements
Date: Wed, 23 Sep 2026 16:06:59 +0200
Message-ID: <20260923140655.208403570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Pustogarov <ivan@ipust.net>

commit e6031f02269c0f51cf67886d177f02bc300b47cd upstream.

ieee80211_mesh_preq_size_ok() derives the location of the PREQ bottom
fields before checking whether the element contains even the fixed
header. ieee80211_mesh_hwmp_preq_get_bottom() reads the flags byte to
account for the optional Address Extension field. Consequently, an
empty PREQ element causes a one-byte read beyond its declared payload.

Move the helper call after both size checks, so the bottom fields are
only accessed when they are present.

Fixes: 8b40b1d24a60 ("wifi: mac80211: Fix overread in PREQ frame processing")
Cc: stable@vger.kernel.org
Signed-off-by: Ivan Pustogarov <ivan@ipust.net>
Link: https://patch.msgid.link/20260903152616.1646637-1-ivan@ipust.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ieee80211-mesh.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211-mesh.h b/include/linux/ieee80211-mesh.h
index 7eb15834531c..9e548b9173df 100644
--- a/include/linux/ieee80211-mesh.h
+++ b/include/linux/ieee80211-mesh.h
@@ -361,8 +361,7 @@ ieee80211_mesh_hwmp_perr_get_rcode(const u8 *ie, u8 dst_idx)
 /* IEEE Std 802.11-2016 9.4.2.113 PREQ element */
 static inline bool ieee80211_mesh_preq_size_ok(const u8 *pos, u8 elen)
 {
-	struct ieee80211_mesh_hwmp_preq_bottom *preq_elem_bottom =
-		ieee80211_mesh_hwmp_preq_get_bottom(pos);
+	struct ieee80211_mesh_hwmp_preq_bottom *preq_elem_bottom;
 	u8 target_count;
 	int needed;
 
@@ -378,6 +377,7 @@ static inline bool ieee80211_mesh_preq_size_ok(const u8 *pos, u8 elen)
 	if (elen < needed)
 		return false;
 
+	preq_elem_bottom = ieee80211_mesh_hwmp_preq_get_bottom(pos);
 	target_count = preq_elem_bottom->target_count;
 	/* IEEE Std 802.11-2016 Table 14-10 to 14-16 */
 	if (target_count < 1)
-- 
2.55.0



