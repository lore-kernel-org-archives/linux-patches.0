Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E419E7497
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CDC9C433C0;
	Mon, 19 Jun 2023 10:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172341;
	bh=kn5cdVjAARyR0aMANtkwTmbxaMEjTqWBiFrubMU9P7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcV6YAN0kxxgrhz3j8hsS8hFZUi7qy56RuL/9Vk7TBCeap+aIjySqkeq+pUD1D8gv
	 BXnuSOaNgBYZ4ovGYeElgtt88H16WKxQUqLFGOD0D0u8IHpqudaRW0Kyku/D3XLp/G
	 CB8U0Oj1xWDOzoz30SNf67zdQqzEWL4xFilGeyb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 034/107] wifi: cfg80211: fix double lock bug in reg_wdev_chan_valid()
Date: Mon, 19 Jun 2023 12:30:18 +0200
Message-ID: <20230619102143.134019452@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 996c3117dae4c02b38a3cb68e5c2aec9d907ec15 upstream.

The locking was changed recently so now the caller holds the wiphy_lock()
lock.  Taking the lock inside the reg_wdev_chan_valid() function will
lead to a deadlock.

Fixes: f7e60032c661 ("wifi: cfg80211: fix locking in regulatory disconnect")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/40c4114a-6cb4-4abf-b013-300b598aba65@moroto.mountain
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/reg.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2398,9 +2398,7 @@ static bool reg_wdev_chan_valid(struct w
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_ADHOC:
-		wiphy_lock(wiphy);
 		ret = cfg80211_reg_can_beacon_relax(wiphy, &chandef, iftype);
-		wiphy_unlock(wiphy);
 
 		return ret;
 	case NL80211_IFTYPE_STATION:


