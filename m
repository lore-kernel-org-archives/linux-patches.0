Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B70B78B61;
	Tue, 27 Feb 2024 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042512; cv=none; b=mNHZ329UUZJJbKFm/2ha16SQs0cY7s8WLQdqSXsB4MsL4c7yrhi+l/Imt8qORH613OV9po4+/29k9dPPSV9TT/uH0fAtmiFFPgIc5zrh5FISIP+V6krGmYIyZeCL3ZmH7KkOWerhAQXrxBuA3D/SnTyd6UVCTBJBqtmVb0wtmnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042512; c=relaxed/simple;
	bh=EdsKlsi7hPb4wYSm0oXpCZyW0p0JCbFP54zhcyW6IlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hE6Tc837NyywI/ZBlM3DY2Guvv7TztUnPzylg7XoJQZ2zzAC0RvNL1tqW3+5kSer0XvZOYi6S3xGZL83t513Sym9w+gzLSJjwVNzRzifmdTlbRMGhxxkDTkIw7jyzIfGVrP+E1tkmtGRZ5KWZjtcezD/HVAuCfGY20usEv7Zy14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrwLJkzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrwLJkzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F1DC433F1;
	Tue, 27 Feb 2024 14:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042512;
	bh=EdsKlsi7hPb4wYSm0oXpCZyW0p0JCbFP54zhcyW6IlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrwLJkzTdFH8ziYKg++XjAJuIiZUeU27+RIvOzqIhseKU2UCYYfzwIfo+Gl1VhLwF
	 wSFSkb2SBklW+HtI3CybjL/Dg/qg388mD4QvkiNLV4v0LHF5HqaYlR6Mwzr3Rw67tu
	 g3TgPEU/HRD9LnN+KKUbC7ZsHcYgEgAi9y89c5B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/245] wifi: mac80211: fix race condition on enabling fast-xmit
Date: Tue, 27 Feb 2024 14:23:30 +0100
Message-ID: <20240227131615.838024499@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bcbc84af1183c8cf3d1ca9b78540c2185cd85e7f ]

fast-xmit must only be enabled after the sta has been uploaded to the driver,
otherwise it could end up passing the not-yet-uploaded sta via drv_tx calls
to the driver, leading to potential crashes because of uninitialized drv_priv
data.
Add a missing sta->uploaded check and re-check fast xmit after inserting a sta.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://msgid.link/20240104181059.84032-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 2 ++
 net/mac80211/tx.c       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e10bcfa20526d..f4deee1926e58 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -696,6 +696,8 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
 
+	ieee80211_check_fast_xmit(sta);
+
 	return 0;
  out_remove:
 	sta_info_hash_del(local, sta);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 481b6b34797da..c4e6fbe4343ee 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2965,7 +2965,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		goto out;
 
-	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED) || !sta->uploaded)
 		goto out;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
-- 
2.43.0



