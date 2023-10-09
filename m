Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0381C1A596
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mi1nQcE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7407BC433C8;
	Mon,  9 Oct 2023 13:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857591;
	bh=iz31zE5nuX4PLMMgsA+mugbfuqhdyWaow5c9aM73xJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mi1nQcE/qLNYfnI4cIDT9Sbt/FoocZ8RRgM4R+J9C2ChDMRbTnKDYXc2h9A9kiGOL
	 1HIc0lAm76XnDovsfL076TrxqAu3/MZ1wFDl2KVPMXuSm73UlYUWrhru309rnaZ7UW
	 qUUaUrY3n0SH1SoHCwoL3gzY6kvTruqOajaJbAIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/162] wifi: mac80211: fix potential key use-after-free
Date: Mon,  9 Oct 2023 15:01:15 +0200
Message-ID: <20231009130125.516519771@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

[ Upstream commit 31db78a4923ef5e2008f2eed321811ca79e7f71b ]

When ieee80211_key_link() is called by ieee80211_gtk_rekey_add()
but returns 0 due to KRACK protection (identical key reinstall),
ieee80211_gtk_rekey_add() will still return a pointer into the
key, in a potential use-after-free. This normally doesn't happen
since it's only called by iwlwifi in case of WoWLAN rekey offload
which has its own KRACK protection, but still better to fix, do
that by returning an error code and converting that to success on
the cfg80211 boundary only, leaving the error for bad callers of
ieee80211_gtk_rekey_add().

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: fdf7cb4185b6 ("mac80211: accept key reinstall without changing anything")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 3 +++
 net/mac80211/key.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index cf3453b532d67..0167413d56972 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -566,6 +566,9 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	err = ieee80211_key_link(key, link, sta);
+	/* KRACK protection, shouldn't happen but just silently accept key */
+	if (err == -EALREADY)
+		err = 0;
 
  out_unlock:
 	mutex_unlock(&local->sta_mtx);
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index e8f6c1e5eabfc..23bb24243c6e9 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -901,7 +901,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	 */
 	if (ieee80211_key_identical(sdata, old_key, key)) {
 		ieee80211_key_free_unused(key);
-		ret = 0;
+		ret = -EALREADY;
 		goto out;
 	}
 
-- 
2.40.1



