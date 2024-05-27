Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B74615ECFF;
	Mon, 27 May 2024 19:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836562; cv=none; b=edZuMInbFMH1WoYqZNy9CA3B8tOJPjgAiSNOSC0GtxuW/AlF57O3SZ4fqRimudBZs4QrheiUVicy/CfUTHngWINSZ2K3Nggu7G0PVQ47zlHiHbFvD6+1wQLDBGOTcgVwEV9kaZXpEXTqcTw2kzvXys8PsPR6XlWTuB5eDt6T2zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836562; c=relaxed/simple;
	bh=tlDq7ge+4cNtzpAMg6paAxmOc+lZCP6jiaxtKIQ+fCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moQZqDMaWfnNf4xSFCI711t12yactf/5xlx2Dd6yrA1K8rDth6LyL8ubDlG06lz7xlVrLXAFGN3/0344SN4IHI6Mi4kYJEOCgs2y4ImpWAjuzrnLCFza5r8H7z2Fj1mdSN8XLbvUAwRE6wlfGM1IxviB/9ZqDTAY10UjhF1IGl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5j7HqTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5j7HqTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCEBC2BBFC;
	Mon, 27 May 2024 19:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836561;
	bh=tlDq7ge+4cNtzpAMg6paAxmOc+lZCP6jiaxtKIQ+fCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5j7HqTdmitSL0EuTXv8F5zIMZRrl9Ud9d3UqYKaQFnubw7NorEYQE1XZIMLxSy1S
	 vKrUZXojKd643ChQSSgRjBxSaxY6RpmSyFy+8lYz6anT4tQG7OZz1KDylyd5Nccw+w
	 mJhiAsoDTN8tJ1kxrr4UrU4kWxNPQsM4El5u95aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ayala Beker <ayala.beker@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 103/427] wifi: mac80211: dont select link ID if not provided in scan request
Date: Mon, 27 May 2024 20:52:30 +0200
Message-ID: <20240527185611.367119691@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayala Beker <ayala.beker@intel.com>

[ Upstream commit 80b0aacd1ad046b46d471cf8ed6203bbd777f988 ]

If scan request doesn't include a link ID to be used for TSF
reporting, don't select it as it might become inactive before
scan is actually started by the driver.
Instead, let the driver select one of the active links.

Fixes: cbde0b49f276 ("wifi: mac80211: Extend support for scanning while MLO connected")
Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240320091155.a6b643a15755.Ic28ed9a611432387b7f85e9ca9a97a4ce34a6e0f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/scan.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 73850312580f7..3da1c5c450358 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -708,19 +708,11 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 		return -EBUSY;
 
 	/* For an MLO connection, if a link ID was specified, validate that it
-	 * is indeed active. If no link ID was specified, select one of the
-	 * active links.
+	 * is indeed active.
 	 */
-	if (ieee80211_vif_is_mld(&sdata->vif)) {
-		if (req->tsf_report_link_id >= 0) {
-			if (!(sdata->vif.active_links &
-			      BIT(req->tsf_report_link_id)))
-				return -EINVAL;
-		} else {
-			req->tsf_report_link_id =
-				__ffs(sdata->vif.active_links);
-		}
-	}
+	if (ieee80211_vif_is_mld(&sdata->vif) && req->tsf_report_link_id >= 0 &&
+	    !(sdata->vif.active_links & BIT(req->tsf_report_link_id)))
+		return -EINVAL;
 
 	if (!__ieee80211_can_leave_ch(sdata))
 		return -EBUSY;
-- 
2.43.0



