Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4709014BFA2;
	Sun,  7 Sep 2025 20:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276197; cv=none; b=ThQtx6gNf1cU1+QlL9dsNJdkjxHc4LLAlrjN75KheZDEZw5JZDlfMqUwz3R/fnf2DAR6e1XlViYESRL2dygRHoyOCo9JpHI55Q3BOa9c5cldxMF4gxGWiwvYnlBIH8kTkf7dnllaDVY21nZ8+mtRDDSci7W6Y9MXRG7vPEQzlGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276197; c=relaxed/simple;
	bh=CGYA2gC7JeNFPDvctMTfa5e1Kn6qSloL3decvYSg2Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXXKbYp1unbiTUpWN/IvAFbsy04lRm254bRI8Ov5t86Kf4Gu3r8zUT7u94Ztmq4MmOqzOTnJaR0DCJoF75YRZpG2sZ6YBLgIj+51VWgrJ33DVfhPV/KLnNI1/8dhBGZQyx8ubYX2xuE1YlHW2cAtYiXl0GUY+YkrwpQDasHvs1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B76c81bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B76c81bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3757C4CEF0;
	Sun,  7 Sep 2025 20:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276197;
	bh=CGYA2gC7JeNFPDvctMTfa5e1Kn6qSloL3decvYSg2Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B76c81bnZyPmv9YNLE+ypcAu7ME6iOXIGuOWN4Ij/X4imqjO5/0VVQaF/Ce++Zl4i
	 BfbWrBXvH1IPSwu4hV6gBUZlGmtfmxCj5+GLUDG97TLnS5afSgAqSB4YZjeyCN/FKi
	 EMInigu7TvgIU5Eb1hUbHdW/ZVjclvgIFKY3Nr0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/104] wifi: cfg80211: sme: cap SSID length in __cfg80211_connect_result()
Date: Sun,  7 Sep 2025 21:57:46 +0200
Message-ID: <20250907195608.454863919@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 62b635dcd69c4fde7ce1de4992d71420a37e51e3 ]

If the ssid->datalen is more than IEEE80211_MAX_SSID_LEN (32) it would
lead to memory corruption so add some bounds checking.

Fixes: c38c70185101 ("wifi: cfg80211: Set SSID if it is not already set")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/0aaaae4a3ed37c6252363c34ae4904b1604e8e32.1756456951.git.dan.carpenter@linaro.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index e35c3c29cec7d..ed16e852133e7 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -886,13 +886,16 @@ void __cfg80211_connect_result(struct net_device *dev,
 	if (!wdev->u.client.ssid_len) {
 		rcu_read_lock();
 		for_each_valid_link(cr, link) {
+			u32 ssid_len;
+
 			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
 						      WLAN_EID_SSID);
 
 			if (!ssid || !ssid->datalen)
 				continue;
 
-			memcpy(wdev->u.client.ssid, ssid->data, ssid->datalen);
+			ssid_len = min(ssid->datalen, IEEE80211_MAX_SSID_LEN);
+			memcpy(wdev->u.client.ssid, ssid->data, ssid_len);
 			wdev->u.client.ssid_len = ssid->datalen;
 			break;
 		}
-- 
2.50.1



