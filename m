Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9CF1292C8;
	Tue, 30 Apr 2024 10:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474063; cv=none; b=E5QMoCqwLighgbwRCmybgiB9X7O5JB1elcJGpHfJS5Iq2OXH4sSdGrVWef06SKO7sQCfhusW/U6B0OJXmfAa5ElGJocFALERLcE1zpoXS5vizCj19qf3eohWCFLSf497WXzIdwBGC8Ua24GUCzmf9EWPXQ8gFw+m3mYUzQbQEeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474063; c=relaxed/simple;
	bh=JWjMVKdmAYGywGrzfTF3sue/rU91UneRug6C8sBvdzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyBc+02R6clEOkgzTWh25gFYMFUm9upB5Jtt5TvAg8c+EcwQE9BFBRMl3vcXJj3KUmUWtRLOgbbzgR2EkfgZdW8ZxAVJGV15Maf38lEDgW5YzuZuCxCe9llWy8b0iDgylTKOLqFkv2rWEibbCNtTqCIVffe6pzIWecg9R8JbXIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHa7bCY0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHa7bCY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68AD6C2BBFC;
	Tue, 30 Apr 2024 10:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474062;
	bh=JWjMVKdmAYGywGrzfTF3sue/rU91UneRug6C8sBvdzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHa7bCY0TuJukQ2iDpKo4XZi5j+I6ghAU//f74Yjh0mANzTJ9ghm/QYWtLSZt2adn
	 WjShkWmbFZqx5hn3OVX/ZOBzj4F+P71KsbzktfRpeI4dVhljC4yKrl/H8QpEKEeFFk
	 CDMszAfAUWbAdz+4FkqcS25SjAptuWUt0RKSoFIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 047/228] wifi: mac80211: fix unaligned le16 access
Date: Tue, 30 Apr 2024 12:37:05 +0200
Message-ID: <20240430103105.170757727@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c53d8a59351e4347452e263e2e5d7446ec93da83 ]

The AP removal timer field need not be aligned, so the
code shouldn't access it directly, but use unaligned
loads. Use get_unaligned_le16(), which even is shorter
than the current code since it doesn't need a cast.

Fixes: 8eb8dd2ffbbb ("wifi: mac80211: Support link removal using Reconfiguration ML element")
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240418105220.356788ba0045.I2b3cdb3644e205d5bb10322c345c0499171cf5d2@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fb9860d508707..94028b541beba 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5848,7 +5848,7 @@ static void ieee80211_ml_reconfiguration(struct ieee80211_sub_if_data *sdata,
 		 */
 		if (control &
 		    IEEE80211_MLE_STA_RECONF_CONTROL_AP_REM_TIMER_PRESENT)
-			link_removal_timeout[link_id] = le16_to_cpu(*(__le16 *)pos);
+			link_removal_timeout[link_id] = get_unaligned_le16(pos);
 	}
 
 	removed_links &= sdata->vif.valid_links;
-- 
2.43.0



