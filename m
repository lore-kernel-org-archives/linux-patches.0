Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A403C1F7561;
	Tue,  3 Dec 2024 15:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241071; cv=none; b=XNKC0VCw0iq1XKNOIa9dT5rrDl8Q+aI4pPdXSgZzHl7BkP17berOLKJt9tkkSLuhWSickelYVciavalNMWjH0KgENRriC7p7rxqv56X9OaFg8APipd3FCjF9d3RifJu8M7uqbjTqY3sFxQBCqgen4LP4iFcNmmWvnoL3MWxnhhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241071; c=relaxed/simple;
	bh=2ndcP1kAN5Pr6tAGEHajqlBS/hSuOzG121gBETvdDOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMvl4FE4ZQjW2Is2deql5jkhvhHfhpCs9ad/wDjzEudKcQmaxGy+0cQAzJAnUCjkcUTT0/56NQVHzhjhv6pEey5VpE3fJ1yydM+bi6OHPpHng5nOpU05BnR3VIwhmaE6TM5tjsFBOm9YUfeyi51Mur5ZsLq4ytQvCZcaiTv7clg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oThAT9HE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oThAT9HE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2F7C4CECF;
	Tue,  3 Dec 2024 15:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241071;
	bh=2ndcP1kAN5Pr6tAGEHajqlBS/hSuOzG121gBETvdDOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oThAT9HENQw9BgbR4vmTG7zAdpzqnBPAUBZ7UlG2u5Jx0Nc4mkr9U5/1cN+cYf6IJ
	 R+Rt25snR/MpPCxUoVU+1a52sDMCi33LIyP1NCog6GOHG59ux52IqShyW0ItPPvoVc
	 BK9yn9t9qQ/H7KIT861XQ3dm+c0COKt0Mxt+n57s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lingbo Kong <quic_lingbok@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 317/826] wifi: cfg80211: Remove the Medium Synchronization Delay validity check
Date: Tue,  3 Dec 2024 15:40:44 +0100
Message-ID: <20241203144756.128646961@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lingbo Kong <quic_lingbok@quicinc.com>

[ Upstream commit b4ebb58cb9a4b1b5cb5278b09d6afdcd71b2a6b4 ]

Currently, when the driver attempts to connect to an AP MLD with multiple
APs, the cfg80211_mlme_check_mlo_compat() function requires the Medium
Synchronization Delay values from different APs of the same AP MLD to be
equal, which may result in connection failures.

This is because when the driver receives a multi-link probe response from
an AP MLD with multiple APs, cfg80211 updates the Elements for each AP
based on the multi-link probe response. If the Medium Synchronization Delay
is set in the multi-link probe response, the Elements for each AP belonging
to the same AP MLD will have the Medium Synchronization Delay set
simultaneously. If non-multi-link probe responses are received from
different APs of the same MLD AP, cfg80211 will still update the Elements
based on the non-multi-link probe response. Since the non-multi-link probe
response does not set the Medium Synchronization Delay
(IEEE 802.11be-2024-35.3.4.4), if the Elements from a non-multi-link probe
response overwrite those from a multi-link probe response that has set the
Medium Synchronization Delay, the Medium Synchronization Delay values for
APs belonging to the same AP MLD will not be equal. This discrepancy causes
the cfg80211_mlme_check_mlo_compat() function to fail, leading to
connection failures. Commit ccb964b4ab16
("wifi: cfg80211: validate MLO connections better") did not take this into
account.

To address this issue, remove this validity check.

Fixes: ccb964b4ab16 ("wifi: cfg80211: validate MLO connections better")
Signed-off-by: Lingbo Kong <quic_lingbok@quicinc.com>
Link: https://patch.msgid.link/20241031134223.970-1-quic_lingbok@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/mlme.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 4dac818547210..a5eb92d93074e 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -340,12 +340,6 @@ cfg80211_mlme_check_mlo_compat(const struct ieee80211_multi_link_elem *mle_a,
 		return -EINVAL;
 	}
 
-	if (ieee80211_mle_get_eml_med_sync_delay((const u8 *)mle_a) !=
-	    ieee80211_mle_get_eml_med_sync_delay((const u8 *)mle_b)) {
-		NL_SET_ERR_MSG(extack, "link EML medium sync delay mismatch");
-		return -EINVAL;
-	}
-
 	if (ieee80211_mle_get_eml_cap((const u8 *)mle_a) !=
 	    ieee80211_mle_get_eml_cap((const u8 *)mle_b)) {
 		NL_SET_ERR_MSG(extack, "link EML capabilities mismatch");
-- 
2.43.0



