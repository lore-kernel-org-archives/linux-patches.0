Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52FE20F079;
	Tue,  6 Jan 2026 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720639; cv=none; b=u/NkwvBlv6syomwXMDST3JwJVLs+xUGQhbFgyqyp0803is3kdPQhchYw18UEXruCJG6apRgygklAzzPXuQ1JK+yd7YPln72b7gAnvSJf0Jvff66fY3INu+sle6qkj8HdZrFmP9zeqHNHYIHt89tFa8YXyau9w0ZproqfCbfesRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720639; c=relaxed/simple;
	bh=fxSmhu6HdsROrme6dM5KBIcmeyHvLhROi2li6RmJ1qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+CWhKvo7EvibEpIiKEYafN9HmXxd15ArAmLgDxzKs3sWQoWpFwJEMrlb415yGSlimP7OfjWb2ezt4MuSfwyg1I33vQ8FZvgodaV4EBdEI8e1+w5TNTJ8n4ZNB6JA89gC2+MWDRJd6XgCIsh5OwISOF0QVwv/kmWGnXvNobpdiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGMVxD96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGMVxD96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543ACC116C6;
	Tue,  6 Jan 2026 17:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720639;
	bh=fxSmhu6HdsROrme6dM5KBIcmeyHvLhROi2li6RmJ1qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGMVxD96gNrkb4Rkl7DWkyH7P3TJuciBKkqjB7mmNHltrauR4fu9HP9PhmAQzLVK7
	 HGqFFaEBbZspbY5a3aczswS5tiH0hNi1/5XOZDupwyOQrzVcb9OkVQfQT9YIJqFJb4
	 wr0X2N56fmM3W8/inf1FMcmPr/mp4GJurvBGlV/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 297/567] wifi: mac80211: do not use old MBSSID elements
Date: Tue,  6 Jan 2026 18:01:19 +0100
Message-ID: <20260106170502.318036004@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Aloka Dixit <aloka.dixit@oss.qualcomm.com>

[ Upstream commit a519be2f5d958c5804f2cfd68f1f384291271fab ]

When userspace brings down and deletes a non-transmitted profile,
it is expected to send a new updated Beacon template for the
transmitted profile of that multiple BSSID (MBSSID) group which
does not include the removed profile in MBSSID element. This
update comes via NL80211_CMD_SET_BEACON.

Such updates work well as long as the group continues to have at
least one non-transmitted profile as NL80211_ATTR_MBSSID_ELEMS
is included in the new Beacon template.

But when the last non-trasmitted profile is removed, it still
gets included in Beacon templates sent to driver. This happens
because when no MBSSID elements are sent by the userspace,
ieee80211_assign_beacon() ends up using the element stored from
earlier Beacon template.

Do not copy old MBSSID elements, instead userspace should always
include these when applicable.

Fixes: 2b3171c6fe0a ("mac80211: MBSSID beacon handling in AP mode")
Signed-off-by: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
Link: https://patch.msgid.link/20251215174656.2866319-2-aloka.dixit@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2df4df75f195..0abb687fd58d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1140,7 +1140,6 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 
 	size = sizeof(*new) + new_head_len + new_tail_len;
 
-	/* new or old multiple BSSID elements? */
 	if (params->mbssid_ies) {
 		mbssid = params->mbssid_ies;
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
@@ -1150,15 +1149,6 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
 							mbssid->cnt);
-	} else if (old && old->mbssid_ies) {
-		mbssid = old->mbssid_ies;
-		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		if (old && old->rnr_ies) {
-			rnr = old->rnr_ies;
-			size += struct_size(new->rnr_ies, elem, rnr->cnt);
-		}
-		size += ieee80211_get_mbssid_beacon_len(mbssid, rnr,
-							mbssid->cnt);
 	}
 
 	new = kzalloc(size, GFP_KERNEL);
-- 
2.51.0



