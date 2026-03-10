Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5FA37B413;
	Tue, 10 Mar 2026 11:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142037; cv=none; b=HC8GmLWjQ7mL6QYzeUMgtB2e9nWVBI6n9wXpuAX+8irQUO7EIpMu/5iC1ZJHGiff12iahBDrmMJu3neYqd9wGr+KQlcs3uEkKg25fwLhywDfGhOAce2lsrxfZoUmZVE7YPTpq9LmeZoplIRjbwqPd8hKUvDBVZUOJ3OBta+q+NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142037; c=relaxed/simple;
	bh=g8dHd3fyyZpieAjjMobegQsRS5t4k8wMKou28ttvBu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqVdTBsJCmFgHW/C0Mqh2iN1NUmii+U53Doyk0kzBjxE0Fek/zR8t6bWbFnih33S1GnXBH/8poLdtXWFbR+5oZq5OzPUPUwq+S+mpgawcHByffwmKA1XDMEzYJljZbr7SWEt+6Xcaj7i5otOQIknBR+hxUo2HVIFtFea8MB3zvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MCP6vHqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MCP6vHqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F061C19423;
	Tue, 10 Mar 2026 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142036;
	bh=g8dHd3fyyZpieAjjMobegQsRS5t4k8wMKou28ttvBu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCP6vHqkbbX/ZPSTe20hS0/snphF9/6y7ufFgGwkE52d4Fsn4/RoI0S5yqwiu64xY
	 FZioOeKRUrH9U9zNOxaHT9+r5QiQeaxWE9ejVnUbMIBczxbcqNPtUXbvqOSuD62jQR
	 B4skYxYphHDXGO0pY1uiA23WZkb3RvNuivoD6Dma7p6JkuLCyvbPAnFMlTvdyAqk7x
	 ge0iJh6CgK2KxGQ98y8vuZ4vFWfmKJmWTZFF2GvUWGGyxFrpGYknpVDGX7S7pgFsPs
	 H6ru5oAgY8QpdYeO5WKHMx4UZySHlmTsAojYYGBsU3MLbpwaistGCkWWjD11ebveJU
	 Uhmk5zta8kRgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ariel Silver <arielsilver77@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 164/314] wifi: mac80211: bounds-check link_id in ieee80211_ml_reconfiguration
Date: Tue, 10 Mar 2026 07:17:03 -0400
Message-ID: <8a532385600191d6ce1d136852a6c11390704a12.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ariel Silver <arielsilver77@gmail.com>

commit 162d331d833dc73a3e905a24c44dd33732af1fc5 upstream.

link_id is taken from the ML Reconfiguration element (control & 0x000f),
so it can be 0..15. link_removal_timeout[] has IEEE80211_MLD_MAX_NUM_LINKS
(15) elements, so index 15 is out-of-bounds. Skip subelements with
link_id >= IEEE80211_MLD_MAX_NUM_LINKS to avoid a stack out-of-bounds
write.

Fixes: 8eb8dd2ffbbb ("wifi: mac80211: Support link removal using Reconfiguration ML element")
Reported-by: Ariel Silver <arielsilver77@gmail.com>
Signed-off-by: Ariel Silver <arielsilver77@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260220101129.1202657-1-Ariel.Silver@cybereason.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8ba199cd38c0f..f119149bcc1c1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6977,6 +6977,9 @@ static void ieee80211_ml_reconfiguration(struct ieee80211_sub_if_data *sdata,
 		control = le16_to_cpu(prof->control);
 		link_id = control & IEEE80211_MLE_STA_RECONF_CONTROL_LINK_ID;
 
+		if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+			continue;
+
 		removed_links |= BIT(link_id);
 
 		/* the MAC address should not be included, but handle it */
-- 
2.51.0

