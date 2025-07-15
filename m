Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C292E62D8;
	Tue, 15 Jul 2025 13:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587013; cv=none; b=L/uRtbo8hWy1syaeFil4QA7qSXJJml0CS26g6QGOIxRRu5FE0uD54ZAp1Uz6hna32j4J/A0owtLhaF7seKzy+WJ7TmX6M2R4KEyulN+M6dPwaBgr7Ha/CpqdGJxNf43GVhEIA2WcK6heBrmwnH3sw5PkQQlaAgSGJtnosgLNooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587013; c=relaxed/simple;
	bh=2gXvh7B3Eire2lSTEmL3iRyvSpxZsGN8fTuDCPav+1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShBm2MB+hSQO7eAj8Tt4AVOmME8h4WEJqP3cryXIXz/pcVx0utwtPOn4mT8NfjubH+eenKlDXIMRRVApt4l/8k2t9yKiRt42uJHOu/EkTazxwpo25PnJh6Hpiz971cTmqMay61zzabJqaQfOYUQWNbyAK3++uheH2eTrgWwvMgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFbPrTv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFbPrTv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA92C4CEE3;
	Tue, 15 Jul 2025 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587013;
	bh=2gXvh7B3Eire2lSTEmL3iRyvSpxZsGN8fTuDCPav+1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFbPrTv2lULGosZx75N3zIcyrhlCjE1Luq3t1iUGmxsRCUGDB1wqsuWyJ2Sk7G7e8
	 bdxvCUL+hakzSXQiUPgZS7y/zePa5RIstX22Pf9MtHg448HWASZ54uDwW0FSAfxLwf
	 6TQEwajxqxH1Q3/hK9OrKYHYTCdjeDzauSOoayPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael-CY Lee <michael-cy.lee@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 134/192] wifi: mac80211: fix non-transmitted BSSID profile search
Date: Tue, 15 Jul 2025 15:13:49 +0200
Message-ID: <20250715130820.277444787@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e1e6ebf490e55fee1ae573aa443c1d4aea5e4a40 ]

When the non-transmitted BSSID profile is found, immediately return
from the search to not return the wrong profile_len when the profile
is found in a multiple BSSID element that isn't the last one in the
frame.

Fixes: 5023b14cf4df ("mac80211: support profile split between elements")
Reported-by: Michael-CY Lee <michael-cy.lee@mediatek.com>
Link: https://patch.msgid.link/20250630154501.f26cd45a0ecd.I28e0525d06e8a99e555707301bca29265cf20dc8@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/parse.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 6da39c864f45b..922ea9a6e2412 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -758,7 +758,6 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 {
 	const struct element *elem, *sub;
 	size_t profile_len = 0;
-	bool found = false;
 
 	if (!bss || !bss->transmitted_bss)
 		return profile_len;
@@ -809,15 +808,14 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 					       index[2],
 					       new_bssid);
 			if (ether_addr_equal(new_bssid, bss->bssid)) {
-				found = true;
 				elems->bssid_index_len = index[1];
 				elems->bssid_index = (void *)&index[2];
-				break;
+				return profile_len;
 			}
 		}
 	}
 
-	return found ? profile_len : 0;
+	return 0;
 }
 
 static void
-- 
2.39.5



