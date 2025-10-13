Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5475A241C8C;
	Mon, 13 Oct 2025 15:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369700; cv=none; b=cFAayEHb8XWYeWRUB2K61taDm7+oA0KgM2MEvb7KWhY3xPRiwNn1ws7OQ3aD5LtCUUAQyWjI6SSnrzhrFktalkDSJDbAgSK7COXZRCSXp75dBRBaEOC7ZxDJ5bVPoZObNtuOhh2Z5MYMKvfvRfAJH7QjxWXANdB5akUKSCll3ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369700; c=relaxed/simple;
	bh=lpHieRhJ9wX2x4VPqwIO0pJhCtUi9UAz/l1Db8OEjvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU/6+rSBP6TTdRjsW2Ki6E1SQ/+gAo/YcBa0HJab91jGOOyhD4nv2H9qwqLDpNjFEY27Kua3+XMpVS71QU2b6BBJXewaPRtkakP1je+PCqnIhHTTzyxV3Bmz1uGZhq6fj+LfIUUZ2iX6NC5+mhBP1Sp5AwF960cZhgCNZ/B/6kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=um+OsVff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="um+OsVff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1A7C4CEE7;
	Mon, 13 Oct 2025 15:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369700;
	bh=lpHieRhJ9wX2x4VPqwIO0pJhCtUi9UAz/l1Db8OEjvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=um+OsVffxn8nbj3gSa8uDEE2Y/HfkPA59LqFauNCixvGa4yMuZlfITwyieXXSPxHz
	 +H7KchNqSkywUIKD4v/Mw3hIxsN5xsl7jfQm59X0HzGIfOqAzSmKamc7ii/HRt1qCo
	 Zc8wLFwoIkAxbdrtjG/bZgVdY79r0Q/rbJCa5LMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 337/563] wifi: mac80211: fix reporting of all valid links in sta_set_sinfo()
Date: Mon, 13 Oct 2025 16:43:18 +0200
Message-ID: <20251013144423.478496309@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarika Sharma <quic_sarishar@quicinc.com>

[ Upstream commit eebccbfea4184feb758c104783b870ec4ddb6aec ]

Currently, sta_set_sinfo() fails to populate link-level station info
when sinfo->valid_links is initially 0 and sta->sta.valid_links has
bits set for links other than link 0. This typically occurs when
association happens on a non-zero link or link 0 deleted dynamically.
In such cases, the for_each_valid_link(sinfo, link_id) loop only
executes for link 0 and terminates early, since sinfo->valid_links
remains 0. As a result, only MLD-level information is reported to
userspace.

Hence to fix, initialize sinfo->valid_links with sta->sta.valid_links
before entering the loop to ensure loop executes for each valid link.
During iteration, mask out invalid links from sinfo->valid_links if
any of sta->link[link_id], sdata->link[link_id], or sinfo->links[link_id]
are not present, to report only valid link information.

Fixes: 505991fba9ec ("wifi: mac80211: extend support to fill link level sinfo structure")
Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Link: https://patch.msgid.link/20250904104054.790321-1-quic_sarishar@quicinc.com
[clarify comment]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8c550aab9bdce..ebcec5241a944 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -3206,16 +3206,20 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 		struct link_sta_info *link_sta;
 
 		ether_addr_copy(sinfo->mld_addr, sta->addr);
+
+		/* assign valid links first for iteration */
+		sinfo->valid_links = sta->sta.valid_links;
+
 		for_each_valid_link(sinfo, link_id) {
 			link_sta = wiphy_dereference(sta->local->hw.wiphy,
 						     sta->link[link_id]);
 			link = wiphy_dereference(sdata->local->hw.wiphy,
 						 sdata->link[link_id]);
 
-			if (!link_sta || !sinfo->links[link_id] || !link)
+			if (!link_sta || !sinfo->links[link_id] || !link) {
+				sinfo->valid_links &= ~BIT(link_id);
 				continue;
-
-			sinfo->valid_links = sta->sta.valid_links;
+			}
 			sta_set_link_sinfo(sta, sinfo->links[link_id],
 					   link, tidstats);
 		}
-- 
2.51.0



