Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080CA2BF3E2;
	Tue, 10 Mar 2026 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141132; cv=none; b=XezImqatqP3Rj7BCczTx9ekG1bPGiaSAtBkxBRBXPREcDYd9RWL6i0wjsI3nKmr1LPw7xFB7D8C5ELBDyjmWtEiOTPhGkPUnivMh9XzKKQfCncxzH67NxPfY6KLmSq1/ZjBFEC/gukXbzOVI6SFPrpQOtAMFlD2NTfsBzmB/QGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141132; c=relaxed/simple;
	bh=KCUYXTApTA7L6rm/Sny1M9fxAOwNzEMg+RRXJEfhf+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUrt+b9jDt4wk9r959fbCilXgyh4vfp0Yi5rU59rmcNzYKRnsik+YtPabzL8rDtfaiWqjzHuQl0gQ4AioWScfoLsKCnYpB/DSDbGaL3055qrgl0X6sy5LOyuBDR6YdpJ+3eSn0Gck0w3NjNJiC1DzkPzgZYqsoQSi2WQ57yKrNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaiEGqxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaiEGqxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B532C2BC86;
	Tue, 10 Mar 2026 11:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141131;
	bh=KCUYXTApTA7L6rm/Sny1M9fxAOwNzEMg+RRXJEfhf+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UaiEGqxXfhqxKEU62stoAh2T0oQNQGav4qHfWdev0upKQRqyisuJJMOOIzofDx2CV
	 p97iJNohHJrFtHVboV/4DE55uYuTeePR6nRgB145uSxpdE/rTXi44btYKHgaymGOTW
	 i7uscGYwonTyEYucxuP5zFKn4t2wtzju2hXYoeOgTXXCpbs/UT/IalSUVLFrrocet/
	 t4e/RvQIczWvCOWYVJFGO/uBsYn2PZJMFEGl01WdpUN62u9FxXmKKJdd1CDJNfwcpO
	 z8X7AmV3SZ0jRbFk619cm56qV0A/OLA1mvjVvFXWYr/OrlVa3kv33NRUkBkRsIpNNm
	 UEadSGSY4Ghxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ariel Silver <arielsilver77@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 135/311] wifi: mac80211: bounds-check link_id in ieee80211_ml_reconfiguration
Date: Tue, 10 Mar 2026 07:03:02 -0400
Message-ID: <57fd1ec6e166e2b106d4dc62924cb3cec694b025.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 73f57b9e0ebf7..63346ee15069a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6975,6 +6975,9 @@ static void ieee80211_ml_reconfiguration(struct ieee80211_sub_if_data *sdata,
 		control = le16_to_cpu(prof->control);
 		link_id = control & IEEE80211_MLE_STA_RECONF_CONTROL_LINK_ID;
 
+		if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+			continue;
+
 		removed_links |= BIT(link_id);
 
 		/* the MAC address should not be included, but handle it */
-- 
2.51.0

