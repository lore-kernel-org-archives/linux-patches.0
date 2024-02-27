Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1309145338;
	Tue, 27 Feb 2024 14:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043970; cv=none; b=QUSVC6XEs9G0CC1Lwe8mDJ+ivNYuwgvOw5Ey0UlIWx4t/LzJhuuH/+kN/LpVNLBNHhPiJjAfZRanK5GvQRBGEMR6ZlV9w8AolxirJWV8+WhqFlAvQcj9is1W3htBs0qIs2FEfvByb4t5zUogDeJFBLR/hD2AreEvZ4iRm7mmyaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043970; c=relaxed/simple;
	bh=KQNzqD5CnK+Adv5Moxw0j3LWtqtul8AbtW94y6vaaJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3KdH1dXPreFQ1wDlo5HnIBSWUwVjZbbXgT/jVHmS53KU1r6pfcr1elosm3sS/gnJzUEppOCQfzj1ITnywZyYCUqveFfJT+Qb732AXvCVreBef+IYZUSW2q97Q6i9kiZAaBAEgfQTJg6OeFMqSSb97tZqgYMKIxE+jloPEYBtGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtcCVqud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtcCVqud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273ECC43394;
	Tue, 27 Feb 2024 14:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043970;
	bh=KQNzqD5CnK+Adv5Moxw0j3LWtqtul8AbtW94y6vaaJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtcCVqudj58JQeZ+O2mgsDOeHHgmdgkVFn++/JNQnOFuzTZhnndtlwHmwSnieeiOm
	 2ih2WnQ8RsFG98UFosVeEc5HIFaLyY9vJCZXICoVIsRwRPMIBGK3S8DI5Itmd46fs9
	 AjlFUvI234XsJSajr0ndhiXH2gB+PSIVWIVNHhsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/122] wifi: mac80211: fix race condition on enabling fast-xmit
Date: Tue, 27 Feb 2024 14:26:17 +0100
Message-ID: <20240227131559.237892271@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2e84360990f0c..44bd03c6b8473 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -700,6 +700,8 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
 
+	ieee80211_check_fast_xmit(sta);
+
 	return 0;
  out_remove:
 	sta_info_hash_del(local, sta);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 55abc06214c4d..0d6d12fc3c07e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2959,7 +2959,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		goto out;
 
-	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED) || !sta->uploaded)
 		goto out;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
-- 
2.43.0



