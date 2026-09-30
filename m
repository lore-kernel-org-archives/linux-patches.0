Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3583B05A4;
	Wed, 30 Sep 2026 18:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794652; cv=none; b=YjBzjCE+vJ1YpR43G9gp5RDvIP92fpJM9/GEGsdDfHVhypwNB7muY0DYxPwdK/trMpPlvHRWuafIwnnWJJHDIlcGi3WqzAjiy+axNUq5BTBJo7aQM7Ne812MFu21HvmzbqO7GU5E1G0WSW7Osj8Mi5n8tELWHn06BTikPnOfKf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794652; c=relaxed/simple;
	bh=wI8AJXWR4OtV5LeKwIh78BOZRoxHpLOMDYYHreaQoaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn1uCNWC0yp7fxu1lg0T67HyvNENCuz2cPoS5v2FFKrvjlohKqlqL86PIHzmgFKR9UXKL9FaXBazBDWxxr4HsvDPgb0GTMRmJvkqVO7v0ry4hvnejGGBLfX+7agTYb5xNv/KY98aSQwwjPYZ7iixsv39KW+aNF+77L42gSOx1m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4nB62YK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4nB62YK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DDF1F000FF;
	Wed, 30 Sep 2026 18:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794651;
	bh=WbGurcfOZ7Pqe+pJokJvKeU2G057su/YS5tYkTKnChY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4nB62YK8U0fynyj9sWesxBpjzEXO5C2vWH7ng2Det9NOy7TtOJjXInyD1FZe4daE
	 iE8qkGvdVvzGFqIMvvyotEBLG+vKd7GwqPInLajH5tXqhlUGlhCXSr5HSU5Pe7s0u0
	 q4U/WPWt/6jLXw1gP0XVG12nJm0avZmrDhaZveCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0287/1193] wifi: mac80211: validate deauth frame length before reason access
Date: Wed, 30 Sep 2026 17:16:11 +0200
Message-ID: <20260930152440.541650720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 496f2b36a0bed..ac3c2c3334fdf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3826,13 +3826,15 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
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



