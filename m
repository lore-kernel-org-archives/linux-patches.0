Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7B34D0CDF;
	Wed, 30 Sep 2026 15:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782760; cv=none; b=PQSkhOEey0xLlllqiu4Sb2P8f3lcY//kGqe8ajqnk/tpMUEHNx9DinUeah/bM3XoPHdzj2/9jqXNwN9EgYqkqP0osPkofmHNcBkWdpsxXf6ipgEPYjWZVXVgx/B4Gl1U3IJ7pYKwYtBkE5JbNrym48t2+rgQLAIYXvAtkV/FCys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782760; c=relaxed/simple;
	bh=RIHG+iBoa6AkJLfe3uxMaqLEXynD2Drv+erBnHjgbxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QV2O6yMhQEAsLUXFjX3BmtmLglJI0VT/OlwgUuwJUceQvn7mLaz1cU36xQjtXN80mJgS19nJ9NvG9fAlvrtHbfnVjSJAn0kGDTjn7AUSLcTWPkc9mIAsxOKMJI5DaIW1gRz6wHWDtZt0jlBo+RpdAl7kSrEhprIL/dpBnYt0UV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHMoHq0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHMoHq0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ACC1F00899;
	Wed, 30 Sep 2026 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782754;
	bh=QfLjHgCFQtY/ySJi0yjyU1c2gqy8CvtXACSoOaKxQqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHMoHq0LEmKcnJYGpzX1QWFVQS+/ZYV3YT1dPyfzJeYKFJ34VWYzLgCDSaM8kOVRA
	 nJX++B+6bu9jGX6fEt4rDMA9/RHuySIi7kf49rmI2584AB6ub+rquJvG2q4KaWPRqy
	 4PVS7tI5qSPStgGYLJ2esxv7sv2X9Lmn7olg9hmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 156/595] wifi: mac80211: validate deauth frame length before reason access
Date: Wed, 30 Sep 2026 17:20:49 +0200
Message-ID: <20260930152351.092659034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 4a360c6e18dfa9d70006c7247a6a8cc8dfe0d60f ]

ieee80211_rx_mgmt_deauth() reads the deauth reason code before checking
that the fixed field is actually present in the received frame.

Validate the deauth frame length first and only then read the reason
code.

Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612185042.66260-6-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 66276122aed6c..79f7f3812da92 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3119,13 +3119,15 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+	u16 reason_code;
 
 	sdata_assert_lock(sdata);
 
-	if (len < 24 + 2)
+	if (len < offsetofend(struct ieee80211_mgmt, u.deauth.reason_code))
 		return;
 
+	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+
 	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
 		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
 		return;
-- 
2.53.0



