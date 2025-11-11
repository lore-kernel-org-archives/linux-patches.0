Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AE525F797;
	Tue, 11 Nov 2025 01:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824443; cv=none; b=dOhVAKJ/kpWr0KAHtsG+0wh30mHRM/ctqwRxXEH8IZKArdTjL+vB+RxqepOeSBo45qMHFp/J/tdyHOL9FpUcVas1gBE/hAf6AtsaaJ1nwCD2WYEvhqClxyA6Fh1h/Ncaj91toNTGU/jS0R2x/h42xou4N+r7sA553scje6PinA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824443; c=relaxed/simple;
	bh=b+YNgyE9Xa83SH/6fbBhshDukSu3BiZepGsZgzYUaTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjOAAi5i3ZQ72KZ070EFAy4+v1Y5qj2VUfK+kZem5kBF6OIPH+7tFbm5KH/5ScltmXX/GG+alp/yW3EL3WbX2v43FqO0tQeMfI9ltwtBZ2g5OfbEv2AR9PEvBE5PGc2YHQiC+c6tVWvdXBkO5eYVKD5A5YM5Q6ieGcds2CS28wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhPFq2b4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhPFq2b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD9BC116D0;
	Tue, 11 Nov 2025 01:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824443;
	bh=b+YNgyE9Xa83SH/6fbBhshDukSu3BiZepGsZgzYUaTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhPFq2b4c3oYAxJTTPisq8MyLKRn1PBuUFvmLG+67ilwwLpKobbQd8A8wHGoTtVz4
	 bweQCB2UdVRDyWQoSpx0kP4ru9RMM6N2s02mDpfhrJ1WDcDyw8Zc3n9fi6qEBz2VV3
	 Fb5+cpEOvPtEdyt9xj0g6sfif26pHX0ISPCageyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 501/849] wifi: cfg80211: update the time stamps in hidden ssid
Date: Tue, 11 Nov 2025 09:41:11 +0900
Message-ID: <20251111004548.545632394@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 185cc2352cb1ef2178fe4e9a220a73c94007b8bb ]

In hidden SSID we have separate BSS entries for the beacon and for the
probe response(s).
The BSS entry time stamps represent the age of the BSS;
when was the last time we heard the BSS.
When we receive a beacon of a hidden SSID it means that we heard that
BSS, so it makes sense to indicate that in the probe response entries.
Do that.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250907115135.712745e498c0.I38186abf5d20dec6f6f2d42d2e1cdb50c6bfea25@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 6c7b7c3828a41..90a9187a6b135 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1816,6 +1816,9 @@ static void cfg80211_update_hidden_bsses(struct cfg80211_internal_bss *known,
 		WARN_ON(ies != old_ies);
 
 		rcu_assign_pointer(bss->pub.beacon_ies, new_ies);
+
+		bss->ts = known->ts;
+		bss->pub.ts_boottime = known->pub.ts_boottime;
 	}
 }
 
@@ -1882,6 +1885,10 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 {
 	lockdep_assert_held(&rdev->bss_lock);
 
+	/* Update time stamps */
+	known->ts = new->ts;
+	known->pub.ts_boottime = new->pub.ts_boottime;
+
 	/* Update IEs */
 	if (rcu_access_pointer(new->pub.proberesp_ies)) {
 		const struct cfg80211_bss_ies *old;
@@ -1945,8 +1952,6 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 	if (signal_valid)
 		known->pub.signal = new->pub.signal;
 	known->pub.capability = new->pub.capability;
-	known->ts = new->ts;
-	known->pub.ts_boottime = new->pub.ts_boottime;
 	known->parent_tsf = new->parent_tsf;
 	known->pub.chains = new->pub.chains;
 	memcpy(known->pub.chain_signal, new->pub.chain_signal,
-- 
2.51.0



