Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5907D141995;
	Tue, 27 Feb 2024 13:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041466; cv=none; b=qo5FVQKy/BeTgHOcL/X0iCy4HD+EZXaA4+7RD07395t5WEZn/W+3FU5Wl3VtFrNI5CeFom5yN3yIfzuGyJA5dgPWkT7H1MlRU7UiJHZ3CRVWqtU3dqFmMMJQAScNLYb+vOEfbVdaYEYBltS0MhdnCg4bi3tci4ujyIqPyktBDNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041466; c=relaxed/simple;
	bh=QVudef+G5DajMp0e464Bk8N8uuDx3i7rDTDUxhBkWgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owtW0sV05vpBDZqpU/yGjBegEBwtwERT8JludLo4gf7nx6dy20aDxUivtrFpV/jcZQV1v/afnNkfYV+O7L9RKsLDx58Zk9QDXOyy7Y/LIeIwgSQdaF0cvmQI3MKH0r8bxfCJdKL+/01mlav6N4jO7DMBzgM/nJFvGlR9FU69gF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r02VAkcz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r02VAkcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C0CC433F1;
	Tue, 27 Feb 2024 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041466;
	bh=QVudef+G5DajMp0e464Bk8N8uuDx3i7rDTDUxhBkWgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r02VAkczTyuY3ajrlVQ8thv7BT0qUNzttvVXnTngPjHhD4pS0x4zk+OaYZxnzF669
	 40fkclN1RbJ0ESov15RhZTaiS8ZqhWORMhZI+/n+pMQZkX8Nt59b46fcGHztQiiFYK
	 YTLo8E1/vB4eGpCJKguz5oqQbPTfxkXwQ3TU5yaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/52] wifi: mac80211: fix race condition on enabling fast-xmit
Date: Tue, 27 Feb 2024 14:26:02 +0100
Message-ID: <20240227131549.034364396@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 5c209f72de701..714d0b01ea629 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -629,6 +629,8 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
 
+	ieee80211_check_fast_xmit(sta);
+
 	return 0;
  out_remove:
 	sta_info_hash_del(local, sta);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 3a0aadf881fc9..89500b1fe3016 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2868,7 +2868,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		goto out;
 
-	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED) || !sta->uploaded)
 		goto out;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
-- 
2.43.0



