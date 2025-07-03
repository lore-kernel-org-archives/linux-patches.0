Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69817126BFF;
	Thu,  3 Jul 2025 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554164; cv=none; b=PVEIKhN+Gdr/nHPlRPFIV8r5DYWFb+Iqhl4u9OuxjBnYz9EJ7MMDbprQZmWXK5QmBNHehyTPdKHDvUS+PDFCuTzZMupr17VPYSoLmPxL7ePCnYWg/CK6TWJ7cHSd5fGQcryRPoxPj2QpyVbkvacqDlLdCrqZoeS4sc02Q0AWspU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554164; c=relaxed/simple;
	bh=sGW7PdNdXuc/NhITC097AhFXIwrpw15mPiMA1wSpyFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jg74yq1E8qhCwcIimtGP6/nUB15XtdxIbnf/7pD8rxhD9OwO1rBH+72woeEhKl2BpxidoZZc7yfS9UrZ3yUOD5fIueSRKdT8qBjyE+hFIQgLp9H0hDBeqyZgZ+FOW0+mbQJjFJvBPRm7qIyw6fhDAVIWoeMXiHxES0kfs0k0/Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krhVg6Yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krhVg6Yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3962C4CEE3;
	Thu,  3 Jul 2025 14:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554164;
	bh=sGW7PdNdXuc/NhITC097AhFXIwrpw15mPiMA1wSpyFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krhVg6YtQxegpZo1nPmFzCMBETtby2RmdbEEgj+jeeuktN7vIZIt9JRcGahu/S7hw
	 GgEZrHSJRqFII8wdm15m9zyScdQ7kD4MF5CfTkkYWUvsX/jh7nNWG8zTRwdB0MAHgj
	 zKCHvDAdmfh9knUGGX/vbhosocFBWvEJQgB/U9FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/218] wifi: mac80211: finish link init before RCU publish
Date: Thu,  3 Jul 2025 16:40:49 +0200
Message-ID: <20250703143959.980630849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit d87c3ca0f8f1ca4c25f2ed819e954952f4d8d709 ]

Since the link/conf pointers can be accessed without any
protection other than RCU, make sure the data is actually
set up before publishing the structures.

Fixes: b2e8434f1829 ("wifi: mac80211: set up/tear down client vif links properly")
Link: https://patch.msgid.link/20250624130749.9a308b713c74.I4a80f5eead112a38730939ea591d2e275c721256@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/link.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 0525f9e44c37b..9484449d6a347 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -93,9 +93,6 @@ void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
 	if (link_id < 0)
 		link_id = 0;
 
-	rcu_assign_pointer(sdata->vif.link_conf[link_id], link_conf);
-	rcu_assign_pointer(sdata->link[link_id], link);
-
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		struct ieee80211_sub_if_data *ap_bss;
 		struct ieee80211_bss_conf *ap_bss_conf;
@@ -142,6 +139,9 @@ void ieee80211_link_init(struct ieee80211_sub_if_data *sdata,
 
 		ieee80211_link_debugfs_add(link);
 	}
+
+	rcu_assign_pointer(sdata->vif.link_conf[link_id], link_conf);
+	rcu_assign_pointer(sdata->link[link_id], link);
 }
 
 void ieee80211_link_stop(struct ieee80211_link_data *link)
-- 
2.39.5



