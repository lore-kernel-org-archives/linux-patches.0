Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C4222323;
	Thu, 18 Jan 2024 10:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575096; cv=none; b=pHNY4b6CnEcdoWi3eZzmq3/MDpMvmsxcYub2e0rO+sWctZXN89/kB52wwepZVBGKq4+CuzKnm1q6Eo9kPfZNQG7m14ZdiGe3eUJMkod2U3oXhpQmN+r2YP7MwH+xQkCgTcFUqOfSM10EvwLu85rJu0l7FLOgVjfqRuNMn3H+sTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575096; c=relaxed/simple;
	bh=xg+GHzgFWUWzT7VGslN1YDdU1+Xutf3TU+4V7iXuHNs=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=fVCtrrJ1SA9eIkcljcHRDSp1f5SB3jaQWyOmGMDfo1D1qypKPfnHj5rh2CUiXMkdMHM9Nsy+44jrqoqGNiUB/l+dE+iOtQpb1G5v6xFgA6hQAYDKIsj+hLP0O9wfRPxU8kWgm/3736eSi77IcGp0Vro7lh6iKK7phLlTR4MCTiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIQHh02R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIQHh02R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB11C43390;
	Thu, 18 Jan 2024 10:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575096;
	bh=xg+GHzgFWUWzT7VGslN1YDdU1+Xutf3TU+4V7iXuHNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIQHh02RPFSajHTVe744KRrG4C2aWzAgN85KcnPQhkZp8HOgsj7xoYnhJjKTFbjjh
	 NlnO5IFjX03b1/gHf8asx2fVvEaAu06OMZZrp0PMyLpz07NYS4uxi35LwgJO1rjjmc
	 m3DDgbVed3VMGgizWlsveQ8U4LibQDIl2qokIC9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/150] wifi: mac80211: handle 320 MHz in ieee80211_ht_cap_ie_to_sta_ht_cap
Date: Thu, 18 Jan 2024 11:47:12 +0100
Message-ID: <20240118104320.508541499@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 00f7d153f3358a7c7e35aef66fcd9ceb95d90430 ]

The new 320 MHz channel width wasn't handled, so connecting
a station to a 320 MHz AP would limit the station to 20 MHz
(on HT) after a warning, handle 320 MHz to fix that.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Link: https://lore.kernel.org/r/20231109182201.495381-1-greearb@candelatech.com
[write a proper commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ht.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 33729870ad8a..b3371872895c 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -271,6 +271,7 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	case NL80211_CHAN_WIDTH_80:
 	case NL80211_CHAN_WIDTH_80P80:
 	case NL80211_CHAN_WIDTH_160:
+	case NL80211_CHAN_WIDTH_320:
 		bw = ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40 ?
 				IEEE80211_STA_RX_BW_40 : IEEE80211_STA_RX_BW_20;
 		break;
-- 
2.43.0



