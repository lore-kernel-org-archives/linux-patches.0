Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3ACF2566;
	Tue, 27 May 2025 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367021; cv=none; b=K3A5ZKELE/2l+NA6E0JG03VoUDv/U/V2Ji98qxeKFZizjy3r5Qmh33g8ZxH7b+gwA9Kq5CZzmp39rRrGBRGKu6yVGN60QiQASOjhCB32hKjgJ3lKTOX8nf331pu+GZP+GmOcIGMA/62B3L43jr8Lg0TshiMUzl1fqaKf17GJzJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367021; c=relaxed/simple;
	bh=xXDnVc//DHQogvIezNtGKS+n5tNl0b1717aUDpkt6OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jje0aa46hQXVkDyHa1807+KEjY+w7qFKrPcYSKa1MLB9j0yMYAfGqsie5gLxfpvkK3D/M3CV6lvAYlJqjn+rALDRdnF+mdHdi1V/zG8F8gm3d16vW4lY9ZqRcBgqsr2t218ICx3uypTWmrGZbLPaLiGIEBaHGzmPBVBJCHjxeXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtTNnbfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtTNnbfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05E9C4CEEA;
	Tue, 27 May 2025 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367021;
	bh=xXDnVc//DHQogvIezNtGKS+n5tNl0b1717aUDpkt6OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtTNnbfehYg5CENO9vY8YjGt2SAr1wox1b2q9XI64+vGLUfRmSmigj0XWDabHV4Eu
	 Iryu/JS0PIMpG929Vm8OXfOWq98FijtcuOl6ZX+VvPRpjUafWYwPN0c/4ds8cJDGcz
	 tEINb+jsbcum6D5mYoFi61ys2s/o3pSr6QA73wmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 222/783] wifi: cfg80211: Update the link address when a link is added
Date: Tue, 27 May 2025 18:20:19 +0200
Message-ID: <20250527162522.162651576@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit e16caea70610ed4226034dfcdaa5c43b36ff9e0a ]

When links are added, update the wireless device link addresses based
on the information provided by the driver.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308225541.d694a9125aba.I79b010ea9aab47893e4f22c266362fde30b7f9ac@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 1 +
 net/wireless/mlme.c    | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 363d7dd2255aa..c168b0e89b79d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -9750,6 +9750,7 @@ struct cfg80211_mlo_reconf_done_data {
 	u16 added_links;
 	struct {
 		struct cfg80211_bss *bss;
+		u8 *addr;
 	} links[IEEE80211_MLD_MAX_NUM_LINKS];
 };
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index e10f2b3b4b7f6..c1b71179601db 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -1361,6 +1361,10 @@ void cfg80211_mlo_reconf_add_done(struct net_device *dev,
 		if (data->added_links & BIT(link_id)) {
 			wdev->links[link_id].client.current_bss =
 				bss_from_pub(bss);
+
+			memcpy(wdev->links[link_id].addr,
+			       data->links[link_id].addr,
+			       ETH_ALEN);
 		} else {
 			cfg80211_unhold_bss(bss_from_pub(bss));
 			cfg80211_put_bss(wiphy, bss);
-- 
2.39.5



