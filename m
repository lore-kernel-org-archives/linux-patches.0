Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB8F1F8EE9;
	Tue,  3 Dec 2024 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238612; cv=none; b=fm8DE+KUXeqsY0hivOmOSeQe6L6bGv4PHK80rxG/vFLCSN+z3g3I6CHtgkgpWNJX9JabzfkZ4XA2A+0k93A9E3nkZUiL8N6I3x4gek/6iisnipvOXKnBbdfEJ/LWQrAb1LySoS5CU/emJD9AXMbjxs7RNjUJkm1ARQm4+szK/wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238612; c=relaxed/simple;
	bh=ecrJLj5DzDf72jsVtd8nqedg+w4x7bNlk9h5IWPHMMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPDrUsHvas271GXc0/3EreaqcOzgl7qj3PCWaEgvQbGeUaZVuetNI89Nke+6RinWPDDcY/62cE4aawKmoL42tkVkitWh++mNXdy04iOsvpNhB3zgo8LKo6GZ0cAUb14ARnW4vVSys9qhVY/BWkmxghjewHY4N++02WOiAxy7CuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q838SFFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q838SFFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4C5C4CECF;
	Tue,  3 Dec 2024 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238612;
	bh=ecrJLj5DzDf72jsVtd8nqedg+w4x7bNlk9h5IWPHMMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q838SFFrqBJN7bszr6fIrPinOrLnQjH/IL3THk/gyczuWjokhut5h4G998OfdzFrz
	 Epocbm2+vdmwepbQKWee3CUTCn+ap/Vch/NYJFGRxW8pDAPrz3MpIpYBED2BRMRGxs
	 oepm0nH1Q+rvjWUurrri60orZMl4hFc3y/y32Xic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lingbo Kong <quic_lingbok@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 336/817] wifi: cfg80211: Remove the Medium Synchronization Delay validity check
Date: Tue,  3 Dec 2024 15:38:28 +0100
Message-ID: <20241203144008.936926033@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 4052041a19ead..98637ded58a68 100644
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



