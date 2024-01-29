Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E611015A49F;
	Mon, 29 Jan 2024 17:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548296; cv=none; b=lZ8aOUbDJmKXRPH5loDlPEu1gnz+u8bxUU5pqHvo3a2gvfCFvDCDv2X7dW3XlPrjlr7HRrrbaz+DH4MpWKARkenn4XtAMx+7kJAJMxQ81nJ13B/fNYpwSBYqPlBBEpCYDirobp9RVFziHC3zBtTLWqfSLratViPqa+GGCW7lS48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548296; c=relaxed/simple;
	bh=bqIGbPhxxDUSr5PTTuWQkBaQ+NhTvSTksyAJncI+40E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlVAf0QJtoaPHRamWVRkFt07hCABSHCY1poMUBLKAh466bLUj3mZYfZB0JxcRCQUNugSkkyZyVIwD9OuC6yXj0yZSN9E4jksU6DzbwLp9NgVOJhljxeFUSlCk6iTbguSSoWszVVAs+1n71/BaH53vGbeDSrs9fKNrZZz4GhIDYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jltpgB9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jltpgB9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBE4C43394;
	Mon, 29 Jan 2024 17:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548295;
	bh=bqIGbPhxxDUSr5PTTuWQkBaQ+NhTvSTksyAJncI+40E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jltpgB9Ezs8R5EAjnuizV5/GzqCGI3lB/BxQPPpGvyikNvGoYmfoHwRwDqfjmmA6i
	 yxy1W27RFQw6t28W8sLDzkW/LNq0nqfxyFxDWgr4SsK4p2xEMtayGz098ytqy4qQDX
	 IXj6vb8VO82phQ8QqP4YIj5wYMNL+haDFKAIe6fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/185] wifi: mac80211: fix potential sta-link leak
Date: Mon, 29 Jan 2024 09:04:36 -0800
Message-ID: <20240129170001.046549148@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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
index 49b71453dec3..f3d6c3e4c970 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -396,7 +396,10 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
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



