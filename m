Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C168C26773A;
	Tue,  8 Apr 2025 11:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110809; cv=none; b=DO7cSr2H88m5cADlD9DUBlQK56AsteAv3T9A2AFm3Aqxq3nL96/pFkVqxXbi8uKRuStsDA0fiIY3qDo70w9nf3HOrEnYlII7zo51LSjknrla7yEwISctELzZlG0t13GJzRd65uKAFtFMzZFiw1RtsCZ5rBy0u8JSeI9N9GkyMYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110809; c=relaxed/simple;
	bh=tIV8xxde/HBXAqnDhZ3mS5ZLIlBiIdHUQkHw/S0BxJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+4XquebVLMzJnObkNDg/MYiSNmL/7oXdseX/tfVxlinyxKqzS8e0BFivETZ9ufhaNP38Sm3T2uOv4g/Ax+r1sykscVCj3zyBrh3RpDWg0jTT58PMf8+jGOzGJ8PSrgdsa3M6lTAKJ0Y3Gtwfd11TsjAUultq+lQ4ptNqDq2lU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKwGYkSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKwGYkSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA4CC4CEE5;
	Tue,  8 Apr 2025 11:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110809;
	bh=tIV8xxde/HBXAqnDhZ3mS5ZLIlBiIdHUQkHw/S0BxJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKwGYkSA8//Ls85lWqTMKZmtzbgzFrWWHi1FWf1VLBoxiLsZj66kcm3j6x3qGITGb
	 dF8ccZaIPiZkQPz8vfQdFqS1FEn0EmkZ5s3LX7qbYjjpUKtf1Mh+OhALBlvuigty+H
	 HoT96k1EOgbDUndlaHT/zYCN8VrjjSmObFMqnkpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 201/731] wifi: nl80211: store chandef on the correct link when starting CAC
Date: Tue,  8 Apr 2025 12:41:38 +0200
Message-ID: <20250408104918.956166421@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

[ Upstream commit ea841520c50f5f7c72c8070e3b79e1927b94fabf ]

Link ID to store chandef is still being used as 0 even in case of MLO which
is incorrect. This leads to issue during CAC completion where link 0 as well
gets stopped.

Fixes: 0b7798232eee ("wifi: cfg80211/mac80211: use proper link ID for DFS")
Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250314-fix_starting_cac_during_mlo-v1-1-3b51617d7ea5@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index aac0e7298dc7a..b457fe78672b7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10172,7 +10172,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
-		wdev->links[0].ap.chandef = chandef;
+		wdev->links[link_id].ap.chandef = chandef;
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		wdev->u.ibss.chandef = chandef;
-- 
2.39.5



