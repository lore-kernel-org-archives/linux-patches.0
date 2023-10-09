Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A34019464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVQbuPTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79853C433C8;
	Mon,  9 Oct 2023 13:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857080;
	bh=iK18w4ZWMzLVwB+92cOTtvuLBsC7TkSnrmVKICFKbOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVQbuPTyb/F+vMmThjP+eQGLBWJal1Q9sl9Im+2om/vUYXctZk7wTR4qB+yhQ4agJ
	 SwM56Ks38y2qa0rPKKpiXWTpp7wHAs7DUx/A6TSIPaYixaAuO+7uq3VapLRaRW8L2w
	 x8pC2LWlx3VCZ6LEXczjGfaVJjr+bfNP34ZBrmKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 089/163] wifi: mac80211: Create resources for disabled links
Date: Mon,  9 Oct 2023 15:00:53 +0200
Message-ID: <20231009130126.496165627@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit aaba3cd33fc9593a858beeee419c0e6671ee9551 ]

When associating to an MLD AP, links may be disabled. Create all
resources associated with a disabled link so that we can later enable it
without having to create these resources on the fly.

Fixes: 6d543b34dbcf ("wifi: mac80211: Support disabled links during association")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://lore.kernel.org/r/20230925173028.f9afdb26f6c7.I4e6e199aaefc1bf017362d64f3869645fa6830b5@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 46d46cfab6c84..24b2833e0e475 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5107,9 +5107,10 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 				continue;
 
 			valid_links |= BIT(link_id);
-			if (assoc_data->link[link_id].disabled) {
+			if (assoc_data->link[link_id].disabled)
 				dormant_links |= BIT(link_id);
-			} else if (link_id != assoc_data->assoc_link_id) {
+
+			if (link_id != assoc_data->assoc_link_id) {
 				err = ieee80211_sta_allocate_link(sta, link_id);
 				if (err)
 					goto out_err;
@@ -5124,7 +5125,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_link_data *link;
 		struct link_sta_info *link_sta;
 
-		if (!cbss || assoc_data->link[link_id].disabled)
+		if (!cbss)
 			continue;
 
 		link = sdata_dereference(sdata->link[link_id], sdata);
-- 
2.40.1



