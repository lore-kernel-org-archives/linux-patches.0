Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149771E519;
	Mon, 10 Mar 2025 17:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626698; cv=none; b=gWHCvb8PEjSlrGxhH0hj3MM9ea4ywrn/Ncm/w5bLE6AV1QGymUmRp1jXQ3Hk8aiQZaOj3Tt30PGOEyQsv1yS5/4roAj1llRTAD/42t6r4PShQMyiFZVOlNdX71Vz96rVLDN0VRKiLJA89Zwbzg7VZuPk2asx37BhvaxQHLW839s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626698; c=relaxed/simple;
	bh=WoQDzEov8J/Z2oYhA2uIhFyvZ9xwxjQNGA/ULj0NQhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbQD5nqL3/Ug6uDaagf1KHozk8/2IdEPd4PROsLetKKluplMZfH7vFKbkqkI+/V+v282zT9IaqtgNPf2yE4Z5PEQtsi5zrktdvbIEbUuZf2jGJNNvYjja9MPrHmAP7YvNrdPsK+Buc9kEA0JTvFMXkeo+BcRu4/x9UQxdMbd4Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2Xyi5Ab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2Xyi5Ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7281C4CEF2;
	Mon, 10 Mar 2025 17:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626697;
	bh=WoQDzEov8J/Z2oYhA2uIhFyvZ9xwxjQNGA/ULj0NQhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2Xyi5AbRAfyQUdt8nN36CVwN0q8B6SXhYrqU95HxMlQOQTRbNAKFet017s8FLRbi
	 Hg0jBrCpf2hdHLAXoG2/byAwTqkJE+ugvY1OyAS4u1leWyY9Jo/zWFA62L4v6IZl+3
	 eD6U50MMliU7Krg6giYPFA+KsI4ecsXMguvG1Oew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 082/207] wifi: iwlwifi: mvm: clean up ROC on failure
Date: Mon, 10 Mar 2025 18:04:35 +0100
Message-ID: <20250310170451.022559645@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f9751163bffd3fe60794929829f810968c6de73d ]

If the firmware fails to start the session protection, then we
do call iwl_mvm_roc_finished() here, but that won't do anything
at all because IWL_MVM_STATUS_ROC_P2P_RUNNING was never set.
Set IWL_MVM_STATUS_ROC_P2P_RUNNING in the failure/stop path.
If it started successfully before, it's already set, so that
doesn't matter, and if it didn't start it needs to be set to
clean up.

Not doing so will lead to a WARN_ON() later on a fresh remain-
on-channel, since the link is already active when activated as
it was never deactivated.

Fixes: 35c1bbd93c4e ("wifi: iwlwifi: mvm: remove IWL_MVM_STATUS_NEED_FLUSH_P2P")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.0fe36c291068.I67f5dac742170dd937f11e4d4f937f45f71b7cb4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 72fa7ac86516c..17b8ccc275693 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -1030,6 +1030,8 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 		/* End TE, notify mac80211 */
 		mvmvif->time_event_data.id = SESSION_PROTECT_CONF_MAX_ID;
 		mvmvif->time_event_data.link_id = -1;
+		/* set the bit so the ROC cleanup will actually clean up */
+		set_bit(IWL_MVM_STATUS_ROC_P2P_RUNNING, &mvm->status);
 		iwl_mvm_roc_finished(mvm);
 		ieee80211_remain_on_channel_expired(mvm->hw);
 	} else if (le32_to_cpu(notif->start)) {
-- 
2.39.5



