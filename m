Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1162E717F;
	Tue, 15 Jul 2025 13:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587058; cv=none; b=AMP+/fk3/JZJpj9lkY8rKMabj956YLbxM9Amgk2tflgmAVNy6Q37MQx3grOk5fF6eb76kVPlsDvEYYfnQ3tUhkeLo9MrWKtFyVZccsNMRWtmNXV8OYNz7ZdEYjgZfP6HZMqqxO3Inn5gFK3EkfiCf2pcBYutSFtFnMEtm38D4jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587058; c=relaxed/simple;
	bh=brcNjlkOm2Owa0K2eziuACVeD9crF1RZbfztNdty6eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUN311rhG6O6U8DEJRH8Pk+c2Ha6YHdazlXFskYV3ZvMEgT9H8onUaF488H1Ti5H4v+QAef/q1g+++VjnhsNPURMGlqluCZvC8tjo1bfJzphxIEB7ROdo5NfH2kkWO8Y+gbdLP/djchYRgLh0zd/rloInctINz0Xf4SraojmMN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4EEp5Go; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4EEp5Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FF3C4CEE3;
	Tue, 15 Jul 2025 13:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587057;
	bh=brcNjlkOm2Owa0K2eziuACVeD9crF1RZbfztNdty6eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4EEp5GoWccPFI7NK5M9pmaGg61/SPq7RQHwPQEALh8jZOrxYjFuFx/buO1OEPtXY
	 Cv3+ovbvEhKTNdmo3dz6N1ZYG31qfAKI8gPKmbx7ObyQ0QUIQCf2+MgEAItWtrShnP
	 aMcmAFaR5++iSXZ8bMKsxNcfe2rhHCA3a1FWQsEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 150/192] wifi: mac80211: add the virtual monitor after reconfig complete
Date: Tue, 15 Jul 2025 15:14:05 +0200
Message-ID: <20250715130820.931243847@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit c07981af55d3ba3ec3be880cfe4a0cc10f1f7138 ]

In reconfig we add the virtual monitor in 2 cases:
1. If we are resuming (it was deleted on suspend)
2. If it was added after an error but before the reconfig
   (due to the last non-monitor interface removal).

In the second case, the removal of the non-monitor interface will succeed
but the addition of the virtual monitor will fail, so we add it in the
reconfig.

The problem is that we mislead the driver to think that this is an existing
interface that is getting re-added - while it is actually a completely new
interface from the drivers' point of view.

Some drivers act differently when a interface is re-added. For example, it
might not initialize things because they were already initialized.
Such drivers will - in this case - be left with a partialy initialized vif.

To fix it, add the virtual monitor after reconfig_complete, so the
driver will know that this is a completely new interface.

Fixes: 3c3e21e7443b ("mac80211: destroy virtual monitor interface across suspend")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709233451.648d39b041e8.I2e37b68375278987e303d6c00cc5f3d8334d2f96@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 82256eddd16bd..0fc3527e6fdd1 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2155,11 +2155,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		cfg80211_sched_scan_stopped_locked(local->hw.wiphy, 0);
 
  wake_up:
-
-	if (local->virt_monitors > 0 &&
-	    local->virt_monitors == local->open_count)
-		ieee80211_add_virtual_monitor(local);
-
 	/*
 	 * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
 	 * sessions can be established after a resume.
@@ -2213,6 +2208,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		}
 	}
 
+	if (local->virt_monitors > 0 &&
+	    local->virt_monitors == local->open_count)
+		ieee80211_add_virtual_monitor(local);
+
 	if (!suspended)
 		return 0;
 
-- 
2.39.5



