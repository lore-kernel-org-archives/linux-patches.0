Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FB213B2B8;
	Tue, 27 Feb 2024 13:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041627; cv=none; b=CQnUi2shtk4B2NXFN7WQUlerSOgXRYyH0jzOWC5OElID6O28B0huYE7EETwThzZWReh1JyeyQKYbi8nL89Z2kQKrclyCDjLxO+oCEe5/JwpNq4swY+M3xJnawsNExs6Z2Sm3D2MO1STuavHy0bBAlqsX/K++mpV/VC7V7S+zOIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041627; c=relaxed/simple;
	bh=3jk+uiVXzvOpYkPZ22mW7mJGjgZPtsIAixZ01mPFjC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUjjnEfUTd+J3mSgqmgGxsfD/1UUBWxELlnJIAeJUoSCnxuDgCY/D3qIRdWV77rk1ejNP6LSxr7L5dOCUQDHzv10vtw/QtrU5DGUvDG5kJvF/KOiZeQnKpW8GyZSqSBTX0EI+yNKpc+rFLwzz4fiPZbjlg+BYVXmaLnPHKdIitA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsPltciA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsPltciA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C18C433F1;
	Tue, 27 Feb 2024 13:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041626;
	bh=3jk+uiVXzvOpYkPZ22mW7mJGjgZPtsIAixZ01mPFjC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsPltciABO6Y+HgelWPIyIY7ww7c+tsLUOXam76WyYez7Pm95srfiP/DuPBV4NfQq
	 HC0n0ZCMh+iDF/64EXlYyKaa/yvOsG5URYhucTDpSSa8dOGR5zh36ujcEOsCNFDpKz
	 m2OBbXdYusBIrTAhx6+fOKZc7xTj1gkZdKHZlgaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/299] wifi: mac80211: fix race condition on enabling fast-xmit
Date: Tue, 27 Feb 2024 14:22:06 +0100
Message-ID: <20240227131626.323126188@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e112300caaf75..c61eb867bb4a7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -914,6 +914,8 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
 
+	ieee80211_check_fast_xmit(sta);
+
 	return 0;
  out_remove:
 	if (sta->sta.valid_links)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5ab9594ae119e..5c6c5254d987f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3034,7 +3034,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		goto out;
 
-	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED) || !sta->uploaded)
 		goto out;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
-- 
2.43.0



