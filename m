Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B3128725B;
	Mon,  9 Feb 2026 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648650; cv=none; b=L6UVqpVmpj6P/DYgRY0Acad5K/5sDvduX9WWbTU8d3C+lcFc6V29ReHkUw5iHj1qeNwDhGXrh2OTF0mMdF6Fc468toVzz1nWdgJw+uZkIFy0S6X/8IjAq7uwVAwlyo4NQj+yhb74mmTtwGPjC7IWlMPVNlCh57HX9LJwOvyF8xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648650; c=relaxed/simple;
	bh=5lk6M6xb+AIKK9oxuOQXViOpbo/QlPaPTrJRgpoSmnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1sBkC35505BOtZX1icAh4YgwccMmQo3x+/msWjsWH6DWjD2aa5OS7VMDTSMCHxFijGC8KNXQhFUzuG5RLAk+2zAAnfK8P0aRug16x5q3J/kLoThaiCV+MjkhE8NJqoFTjmsyUE2NkLLA3aoZM8G3wqfYFZL+hmwMNx7rvrwZCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsq1v/wp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsq1v/wp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B19C116C6;
	Mon,  9 Feb 2026 14:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648650;
	bh=5lk6M6xb+AIKK9oxuOQXViOpbo/QlPaPTrJRgpoSmnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsq1v/wpWlhNrQChjRE8oJb1zFD93od17deqkWP81a3PNr+zJAI7ITbBXp1xomN7q
	 LydzicIzSoiYdxyMiwFkX956k9uvMExzg/ghSKep5frJgdC/7HKeLQ/CHlOIi36hdT
	 d9StPGMMyiKV3oHiSZuKO1R97aTSpXT9x8vkd+8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/41] wifi: mac80211: collect station statistics earlier when disconnect
Date: Mon,  9 Feb 2026 15:24:37 +0100
Message-ID: <20260209142257.393646517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit a203dbeeca15a9b924f0d51f510921f4bae96801 ]

In __sta_info_destroy_part2(), station statistics are requested after the
IEEE80211_STA_NONE -> IEEE80211_STA_NOTEXIST transition. This is
problematic because the driver may be unable to handle the request due to
the STA being in the NOTEXIST state (i.e. if the driver destroys the
underlying data when transitioning to NOTEXIST).

Move the statistics collection to before the state transition to avoid
this issue.

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251222-mac80211-move-station-stats-collection-earlier-v1-1-12cd4e42c633@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 3bb7a3314788e..529f8701a54f7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1105,6 +1105,10 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 		}
 	}
 
+	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+	if (sinfo)
+		sta_set_sinfo(sta, sinfo, true);
+
 	if (sta->uploaded) {
 		ret = drv_sta_state(local, sdata, sta, IEEE80211_STA_NONE,
 				    IEEE80211_STA_NOTEXIST);
@@ -1113,9 +1117,6 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
 
-	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
-	if (sinfo)
-		sta_set_sinfo(sta, sinfo, true);
 	cfg80211_del_sta_sinfo(sdata->dev, sta->sta.addr, sinfo, GFP_KERNEL);
 	kfree(sinfo);
 
-- 
2.51.0



