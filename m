Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C235E134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A884C433EF;
	Mon, 12 Jun 2023 10:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566790;
	bh=/lidx5yxEFkLG8jrqGhcbc3PwFij7Hsr130aIJ4NcyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kWhWYV3+dhUmt0hm7tKNzrSgjZos1mjuWL72h9cuMgzt8FvNFN7WknPQVxaSyeD/F
	 jAg/6P7Ly9+JcUXDaY6/lZUZ2Ew2ZpPeoGBtiubouwCJAp1rSmjzABRC8XkHAil+n+
	 L+rab7KqC0Ko1G7FUiu1Tdh9UICTL+JnhCYUCQjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 033/160] wifi: mac80211: dont translate beacon/presp addrs
Date: Mon, 12 Jun 2023 12:26:05 +0200
Message-ID: <20230612101716.560011405@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 47c171a426e305f2225b92ed7b5e0a990c95f6d4 ]

Don't do link address translation for beacons and probe responses,
this leads to reporting multiple scan list entries for the same AP
(one with the MLD address) which just breaks things.

We might need to extend this in the future for some other (action)
frames that aren't MLD addressed.

Fixes: 42fb9148c078 ("wifi: mac80211: do link->MLD address translation on RX")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230604120651.62adead1b43a.Ifc25eed26ebf3b269f60b1ec10060156d0e7ec0d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index af57616d2f1d9..0e66ece35f8e2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4884,7 +4884,9 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 	}
 
 	if (unlikely(rx->sta && rx->sta->sta.mlo) &&
-	    is_unicast_ether_addr(hdr->addr1)) {
+	    is_unicast_ether_addr(hdr->addr1) &&
+	    !ieee80211_is_probe_resp(hdr->frame_control) &&
+	    !ieee80211_is_beacon(hdr->frame_control)) {
 		/* translate to MLD addresses */
 		if (ether_addr_equal(link->conf->addr, hdr->addr1))
 			ether_addr_copy(hdr->addr1, rx->sdata->vif.addr);
-- 
2.39.2



