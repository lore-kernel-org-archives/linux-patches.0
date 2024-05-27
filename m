Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A1F168C4;
	Mon, 27 May 2024 19:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837988; cv=none; b=VJm+qYheQBrzdxieaSe2V6n1zOmDC8Un19BWJSvkHNtJQzckspwr6w75vBCiZ+TRpcOhXpXKBWpSRoAE/4L/IzmIM012T4Z1dh56U26xojzRaipOhM3GPicq8lM/89QxWcQaX8AioevuayMiC/41eveYfRdYugoub7HuOnrLwPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837988; c=relaxed/simple;
	bh=UDW7LOJRumGpvNeOAXfys6Vt1EUGEj1SLtLaeO1ja8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6BDn9EXEwsXfzpcxRDeushrOCk1x9qX0I9eHLDkBQJaT2tysrieeromezjnOY0viIeNGce2q0V48A3MWaPPSHCyY5uUz2ohXeges74SyFvPaLka1GyJM+US57wlT/49e//U+zStu6rZFiyVEnSlxlRmCf1hk4LloxPWxCGoVGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PznJurGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PznJurGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0081C2BBFC;
	Mon, 27 May 2024 19:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837988;
	bh=UDW7LOJRumGpvNeOAXfys6Vt1EUGEj1SLtLaeO1ja8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PznJurGtHZPGcmOZLZfP8byGiBWDkivPmc7VCl8iGvEMbki/CScBep7kTcoqXlveH
	 gDzaBE/KBXc2dAStFpiWoUO88al+SCy4btPcIbWuDi7N9qw3TGYs9pJLQKQpmLEj+0
	 uAw2qnqPHYXxpbhOEAiTTNyTs5xOO6kT4+AiWX3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 170/493] wifi: iwlwifi: mvm: Do not warn on invalid link on scan complete
Date: Mon, 27 May 2024 20:52:52 +0200
Message-ID: <20240527185635.918972224@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 1c78d39f4ede227e50e36165b3a76bc7c37ead02 ]

As it is possible that by the time the scan is completed the link was
already removed.

Fixes: 3a5a5cb06700 ("wifi: iwlwifi: mvm: Correctly report TSF data in scan complete")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240319100755.619d3574a757.I0523e92547f0288c8b0119b1fdc5e967a5a8956e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 97d44354dbbb5..3dc6fb0600aae 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -3173,8 +3173,13 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 		struct iwl_mvm_vif_link_info *link_info =
 			scan_vif->link[mvm->scan_link_id];
 
-		if (!WARN_ON(!link_info))
+		/* It is possible that by the time the scan is complete the link
+		 * was already removed and is not valid.
+		 */
+		if (link_info)
 			memcpy(info.tsf_bssid, link_info->bssid, ETH_ALEN);
+		else
+			IWL_DEBUG_SCAN(mvm, "Scan link is no longer valid\n");
 
 		ieee80211_scan_completed(mvm->hw, &info);
 		mvm->scan_vif = NULL;
-- 
2.43.0



