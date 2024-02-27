Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FA413B78F;
	Tue, 27 Feb 2024 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043257; cv=none; b=QZi1We5zA8RaPFifzi+yhQu2aKTSwsSyJjFm5zGXMcpqim+YtCKfCwfRvQbTFz/uoKsfXcHaq2tKWbCn6J8wUCMZLmGd7wnRtpFxmkltzpSX9KteUY5mtYNBgpGS21Lva1ZV9NALxUlLaxkwnxGE0ZLSTJwNObt0C6EcAMiu0kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043257; c=relaxed/simple;
	bh=UzmF6wjDkYo+Hj0PLpTup4I2te/Y4sQcGovuWS6CR2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYAjCG/b49OTcU2px5cT0ZM/ZoFtRI+s5SAVf7gRYotx3G+Mia3MnEpbelse7sYX4BT98vhKOmMfErM/L35PBTkNQRe+TlQ0WYp5Y2ukCQMPOpz02u88sYA+fycxJM2zgUU1e2wkMBpcTNHGkrpYgWPyrvdgN3UpNCjfukbpKas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHjFCk7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHjFCk7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166C7C433C7;
	Tue, 27 Feb 2024 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043257;
	bh=UzmF6wjDkYo+Hj0PLpTup4I2te/Y4sQcGovuWS6CR2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHjFCk7RUEN7XU1sTD5ADpBSeiyekV/3wSsLLhgTvV7HKE+NfP4Hwx4IkCa1V1lF9
	 bMS8BPSKzyh5DRvwT7rNs8ucMUXf1dHq9DyBnv785/vrcg9PMyf6VsG613lTXGjbv7
	 PLdl9FVHcIz/ti2ylVHz8KkAGS64/UATUx8O13cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/195] wifi: mac80211: fix race condition on enabling fast-xmit
Date: Tue, 27 Feb 2024 14:24:35 +0100
Message-ID: <20240227131610.870867307@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f3d6c3e4c970e..bd56015b29258 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -891,6 +891,8 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
 
+	ieee80211_check_fast_xmit(sta);
+
 	return 0;
  out_remove:
 	if (sta->sta.valid_links)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 322a035f75929..3d62e8b718740 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3044,7 +3044,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		goto out;
 
-	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED) || !sta->uploaded)
 		goto out;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
-- 
2.43.0



