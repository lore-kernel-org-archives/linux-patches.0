Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4783C4F96D2;
	Thu, 17 Sep 2026 17:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664803; cv=none; b=m5iPD1Ec91vuSrKU8uMNc7789clZ2noA4nwTtEoqN6IM5ZZzF2SoIL7aAKxJ7VoCYfnC9vtYt7lzJTqvBdZrZ5TkdwrUIxXM0viVHb7iD35zQjQT636GVxmElFuXOBmk9NnzyIhnCwk7uPMt3KApGHFBGDnUAAjnPDDTTp+hW9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664803; c=relaxed/simple;
	bh=uqrxwDZJZvGDXs904PT3wDVv55t1VW2PNq+pve8R5l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkzljRUg87+023+tAjGQI2DE258/Zk7ITcE7WyWAEigGXYajfobdeoLogtcye0P+oRzjZawzoZg9/IDFzYsc2eB3IwXF5M2j1sRGDMwjWMPYOnTk+h+EClNvG7sg8g0/Rj9wOnIo2SNVayByATXQ8P27tbQfTtZs4p2HMZ7h1CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/X6hnTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/X6hnTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7991F000FF;
	Thu, 17 Sep 2026 17:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664802;
	bh=1LZJz5PsIM1Da2wU9kQKwQ7m62pkRSFfqa8eT2S3Y4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/X6hnTEglBL0eNNcLMUrTT/tJ/p4qs/GSCou9/ouByLRCP9dVsrS9YD6GJxEJyWV
	 LByPT5AvOGFKRPHp3aZEanU5+q+xuFXUUTL4VFlhACykK6ilY8RQeaALLmCmYHHKka
	 Dy1GnNT/Mw6ZeKyGqOqUCqlfFcp7PxmvJ6UqAuXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0493/1250] wifi: mac80211: validate deauth frame length before reason access
Date: Thu, 17 Sep 2026 16:04:48 +0100
Message-ID: <20260917151605.329999098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 70a34f8862c7b..0f4bd59a95ecc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5008,13 +5008,15 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+	u16 reason_code;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
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



