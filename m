Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2044C1586E8;
	Mon, 29 Jan 2024 17:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548142; cv=none; b=KxGv0gr+hbrUEmQHqLilkWIZ/ortnDq0+3SokP1pDwY/pJrnhh1EfB4B0hpo5jRWlOY8gOi+EeeGUr/kZ1YzITeSdQaBfQimwt5s+fNx+prhbEfaFaMgN1IOd6nb8u6f9Uq9I3T4UcNBiCdrhhgve7bLoebR5FvCr49vqzG/V38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548142; c=relaxed/simple;
	bh=i/Wdz/3Sb6hFrn5WPZjZmNRJorR8givYoCJtkic4cyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAHQEsW75IvHqKLed+vf1MCPQHrL3+yKgut8eL7YqdRbJ734YU4/hDqFZJFhvk5KkHqwwo3cNrgMP4dbV6TCsnqvj9LdP+2sl74VkQmVyj0cq9R3WFQNYq+LbbWHMGQ3+wUFviIuVUx1Q4B3MSI+xehPw+yhT2cHenE6tO0pm4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xd9uacwq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xd9uacwq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3B7C433F1;
	Mon, 29 Jan 2024 17:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548142;
	bh=i/Wdz/3Sb6hFrn5WPZjZmNRJorR8givYoCJtkic4cyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xd9uacwqxAq+o70JureTOvHGH2ck9WzQDw9p5Fw0XBgOt4ldNu6N1PdVy+XUG5wdb
	 /SY8xQ2oUmrqjmtiK+UJ2TGrQf/r0Cxus2dbglAftdjpGXDNcggTAx4vbFIAkgCc8C
	 8B5AzaeXKZMnZ0ULqhBGIjWPhNqt7Fs0SJXwtoUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 146/346] wifi: mac80211: fix potential sta-link leak
Date: Mon, 29 Jan 2024 09:02:57 -0800
Message-ID: <20240129170020.697044128@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 0ba613dd1cc4..c33decbb97f2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -404,7 +404,10 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
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



