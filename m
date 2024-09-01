Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D481C68C;
	Sun,  1 Sep 2024 16:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208583; cv=none; b=NZ7/iTVdcHIUTb6F51dRWv2Rl6ehNKXH5ToNxvcwWPzlvuwJg5rpixLNfNxl6Alta1gqYT5sDQp22Ok4XoDe74pPOt42c5MyI4HqX8lu6YJ1OIIWAR61Z42zbOBflKrk6yxzGxNGuuaAAX9xd2o4lUxGEwqlCDfNq8uYy+HD0cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208583; c=relaxed/simple;
	bh=Ai4ErVdv2NjUEfrqQ+GCwHyutf704OUx8I/1jbuvvtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt1X8Fi8A6lNMidWy3mPEZw2wlUcwzIRxGixHg1BrS/LFpoqxDIi7VsWGlkNfusy//M4iO5T48cvabwCwobnuP0KwKp5FhzKd5Rw2CeIr5Io1H2QuyvRH/Nwz4SiOclJrXqa/kh75CBeBrFqvO8Is8rjs+iAT3wnt2c8CvbD4Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yG3+7Ipu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yG3+7Ipu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E5EC4CEC3;
	Sun,  1 Sep 2024 16:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208582;
	bh=Ai4ErVdv2NjUEfrqQ+GCwHyutf704OUx8I/1jbuvvtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yG3+7IpulDkcnW4EusKML8cOwhVMlK8Wh55jU8Sm1+L7vF/TtEp7rWmoodF159koF
	 dsg638gD6HhA4JbrypxcFVpxuss+fb93y+js4wAk05pJAz4wTCjLOF1ZpBqQotv46I
	 0f4VgZUWdUZuOsLCUwTvUjT56OELwHNG+7ArG5/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 095/149] wifi: iwlwifi: mvm: take the mutex before running link selection
Date: Sun,  1 Sep 2024 18:16:46 +0200
Message-ID: <20240901160821.035426022@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit cd6f46c2fdb82e80ca248549c1f3ebe08b4a63ab ]

iwl_mvm_select_links is called by the link selection worker and it
requires the mutex.
Take it in the link selection worker.
This logic used to run from iwl_mvm_rx_umac_scan_complete_notif which
had the mvm->mutex held. This was changed to run in a worker holding the
wiphy mutex, but we also need the mvm->mutex.

Fixes: 2e194efa3809 ("wifi: iwlwifi: mvm: Fix race in scan completion")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.0cacecd5db1e.Iaca38a078592b69bdd06549daf63408ccf1810e4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index d343432474db0..1380ae5155f35 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1190,10 +1190,12 @@ static void iwl_mvm_trig_link_selection(struct wiphy *wiphy,
 	struct iwl_mvm *mvm =
 		container_of(wk, struct iwl_mvm, trig_link_selection_wk);
 
+	mutex_lock(&mvm->mutex);
 	ieee80211_iterate_active_interfaces(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_find_link_selection_vif,
 					    NULL);
+	mutex_unlock(&mvm->mutex);
 }
 
 static struct iwl_op_mode *
-- 
2.43.0



