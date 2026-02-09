Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CE837BE65;
	Mon,  9 Feb 2026 14:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648224; cv=none; b=suAAeSHO+imRijFTZudxGzefEAERrgVOI4NIDGWXJnHbs2NZmzliL9U6SB1enBQ5U00ftS+bGBqmoNG3WTH88PtDYSzIVI/xNHXq4WWuyT3x13+A6PijMiwyoopbILjqF1kEjdByh7etEgGnS7dgClZSmcNskQ+3c8O1h8i7dR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648224; c=relaxed/simple;
	bh=1V8MT4z4QXCyUe3oSGLbL08p3w5d+FPLZWOTiLI/Wy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbIpPulyB00QEpnIfCgVQTLhxH0RQRajL4eOxyBbCW/TD0OcKS1ZkFZ89awGhpHDKZJyK24WyNM3apMXn952pcrBLZuEWo51kIiwurkeryaOxwr7Ha40t3lWr3vdNmpsGQSzGEbbaXEumPqFnAes169YWzcoW+dWyV9X3Qykq18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Quk//NS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Quk//NS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7E9C16AAE;
	Mon,  9 Feb 2026 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648223;
	bh=1V8MT4z4QXCyUe3oSGLbL08p3w5d+FPLZWOTiLI/Wy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Quk//NSIEnxOfQGPT9KKG4sFGc7GW/n8RmKpwr7NlY+PJeyUOaJ4hYDQhJNkpwgn
	 F04PxEG1gE/KQdfAXNMi7M5FC/pj5lfzCJ/g6fVBVOv5orzzhZuKMBu3sGx3Pzmb+V
	 8gwP9dhppCiYrZWdPWvjfoYcObN9lGzzBYav+xWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 36/69] wifi: mac80211: collect station statistics earlier when disconnect
Date: Mon,  9 Feb 2026 15:24:04 +0100
Message-ID: <20260209142303.225510223@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e9ae920947944..8a92077da1536 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1314,6 +1314,10 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 		}
 	}
 
+	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
+	if (sinfo)
+		sta_set_sinfo(sta, sinfo, true);
+
 	if (sta->uploaded) {
 		ret = drv_sta_state(local, sdata, sta, IEEE80211_STA_NONE,
 				    IEEE80211_STA_NOTEXIST);
@@ -1322,9 +1326,6 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	sta_dbg(sdata, "Removed STA %pM\n", sta->sta.addr);
 
-	sinfo = kzalloc(sizeof(*sinfo), GFP_KERNEL);
-	if (sinfo)
-		sta_set_sinfo(sta, sinfo, true);
 	cfg80211_del_sta_sinfo(sdata->dev, sta->sta.addr, sinfo, GFP_KERNEL);
 	kfree(sinfo);
 
-- 
2.51.0



