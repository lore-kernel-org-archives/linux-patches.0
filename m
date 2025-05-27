Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C875927FD61;
	Tue, 27 May 2025 16:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364860; cv=none; b=RfKWpQNaJY/iJrFAwDzUsv5t/ED6raa9VR1RnQ+WC2ydSgCmKdHAaaOaUTRvjGIvXCRTnHc/4LRLAt2/cDfGihmOnQHoF60ViPas9ONg9m8kpiDX0hNtR9XC1yzljbA6Ydr5wk8JZ64xA1qv9roUkVtgcf0f9BOVj7Jw/vaCiPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364860; c=relaxed/simple;
	bh=0Q2Vg9bLHBpl1aCrcDZNEbg5HglsepOBmJEjYQeyMxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU+q6Dsy0MQfixO0zmAIse8j1nRtflXpFSlR3aWHYr5rSYOlsKlIGkoyYKeLUXlQoFX0Ce3prC2/3olB0mgq041DCMyW8+iqoUQLiMjQUZryNTIJZp2L0poh+3BbblYIjM0k6gxyfF3cuE/3QSwQVs+6mQKsHY6+mmY5DtGSGcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5EoZgsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5EoZgsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0C9C4CEED;
	Tue, 27 May 2025 16:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364860;
	bh=0Q2Vg9bLHBpl1aCrcDZNEbg5HglsepOBmJEjYQeyMxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5EoZgsd8GNekc1FbKfWixaImnICMf4rDhFdMIDRMgy+PpuODlCkDo16lYNxoyyFH
	 j/7QVW8JvNixePq2W7o655LspUqqfMcQLJCKYMYPYnnTerVvR+nP2D7jAQ+/w+HBfw
	 31cYn4uufwYlN7eYzFQ8CjCuY21+/y9jiklt99/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 190/626] wifi: mac80211_hwsim: Fix MLD address translation
Date: Tue, 27 May 2025 18:21:23 +0200
Message-ID: <20250527162452.734381081@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 65bff0be9b154621b617fc2e4bd89f1e18e97cdb ]

Do address translations only between shared links. It is
possible that while an non-AP MLD station and an AP MLD
station have shared links, the frame is intended to be sent
on a link which is not shared (for example when sending a
probe response).

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308225541.1aa461270bb6.Ic21592e1b1634653f02b80628cb2152f6e9de367@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 3f424f14de4ec..4a2b7c9921bc6 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2008, Jouni Malinen <j@w1.fi>
  * Copyright (c) 2011, Javier Lopez <jlopex@gmail.com>
  * Copyright (c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2024 Intel Corporation
+ * Copyright (C) 2018 - 2025 Intel Corporation
  */
 
 /*
@@ -1983,11 +1983,13 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 			return;
 		}
 
-		if (sta && sta->mlo) {
-			if (WARN_ON(!link_sta)) {
-				ieee80211_free_txskb(hw, skb);
-				return;
-			}
+		/* Do address translations only between shared links. It is
+		 * possible that while an non-AP MLD station and an AP MLD
+		 * station have shared links, the frame is intended to be sent
+		 * on a link which is not shared (for example when sending a
+		 * probe response).
+		 */
+		if (sta && sta->mlo && link_sta) {
 			/* address translation to link addresses on TX */
 			ether_addr_copy(hdr->addr1, link_sta->addr);
 			ether_addr_copy(hdr->addr2, bss_conf->addr);
-- 
2.39.5



