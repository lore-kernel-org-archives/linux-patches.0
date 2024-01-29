Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047F67375F;
	Mon, 29 Jan 2024 17:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548550; cv=none; b=Y7dzgXS22ndw5gWRI23ZBa4NLFLd8kQw38mOWCSgS7eofKr6IToGrulN2nKwyaiGKLh02b4ENeVsKq/6nZrqddsgPyY0NCi8WCK9K/tBptKWSITIFPDH9C0keDQ+UR0P0etRczBSkS/qnyWY/2AOlUrjhxF1nzgbN6keZlyrstg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548550; c=relaxed/simple;
	bh=EWbQYV4YLoI0U0/9fUUsOmvCmShMSqOU2+URcBe/WtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmqDMM6X7IcCVWL60bjZZw65sRDG/jtUYQsKhGOhomxyJox/e2gf/6mMMG0tIDYpwZXOlT3aDbh6NjTgcpE/qwafhMkxHkrbRJ3rMvUJbwRIS1d72SiCAeAEdyrepchMNP9QaeJWRxAm3+CSXBwXh76GZTa9jMacVxHICZ/gElg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qg/PAdFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qg/PAdFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05C3C43390;
	Mon, 29 Jan 2024 17:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548549;
	bh=EWbQYV4YLoI0U0/9fUUsOmvCmShMSqOU2+URcBe/WtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qg/PAdFAaayQvictiC0VAihO8QMRQbs9BE0xNEcx9nasd+HdgzRLvqRCtN06zgYve
	 2D+6JrUcowackWDnpXuUp09HQHdWBmdPGjLO9WmJvUk+OOz033AofOa4ctUg5R3xfp
	 MG/5nbjEdLLeAvc3oVXxHq3ZS+E3JmJl9lGyNlPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/331] wifi: mac80211: fix potential sta-link leak
Date: Mon, 29 Jan 2024 09:03:52 -0800
Message-ID: <20240129170019.832876029@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit b01a74b3ca6fd51b62c67733ba7c3280fa6c5d26 ]

When a station is allocated, links are added but not
set to valid yet (e.g. during connection to an AP MLD),
we might remove the station without ever marking links
valid, and leak them. Fix that.

Fixes: cb71f1d136a6 ("wifi: mac80211: add sta link addition/removal")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240111181514.6573998beaf8.I09ac2e1d41c80f82a5a616b8bd1d9d8dd709a6a6@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 0c5cc75857e4..e112300caaf7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -398,7 +398,10 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(sta->link); i++) {
-		if (!(sta->sta.valid_links & BIT(i)))
+		struct link_sta_info *link_sta;
+
+		link_sta = rcu_access_pointer(sta->link[i]);
+		if (!link_sta)
 			continue;
 
 		sta_remove_link(sta, i, false);
-- 
2.43.0



