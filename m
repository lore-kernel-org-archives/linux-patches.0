Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C58153800;
	Tue,  3 Dec 2024 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241078; cv=none; b=PcXfICtybCjhvRTc+iPy5P7a9btqQj6vPSvuACdSOCDCsT5P77MjQ5JuBAf2G2LZfjIJqHbQo0BD51DyHfvY2UI2eNBVzbzOebKkUA9kaumIInZERdQ0CN2hGEJr1OPAFFp7XSms0Wtxy7vYoclEUcUdF2QazeIUGgyhB4Qr9Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241078; c=relaxed/simple;
	bh=O3kqrkvIRdTv8jk4Cirs6th06/lcV97ZJ3Qc1zmCUZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ab0wnkNndJQh0geKO2yikxC7foU01xeONU1BVxh7vV8IJYCkuuSwEravVKqnaikUPWoq6V2BLSSXhriMoSSHqP264UlRixVV81XrVwlXicYuxuan7htbLJT6XXfJVipwtlbd89ya3vcX0ppa7Yhz+d9lYD/jiOHmt2XT0MYtSOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNvnDDom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNvnDDom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993EEC4CECF;
	Tue,  3 Dec 2024 15:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241078;
	bh=O3kqrkvIRdTv8jk4Cirs6th06/lcV97ZJ3Qc1zmCUZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNvnDDomzg92Fgbr68NZNJb8TegxepA10783eRk/qZ8ge+V4s9Zajm9a/TiT1tPun
	 xCEr2aKNc+2/hmQDZFQlN6MjQOE1+A6FfoqZVUSkMKCXYmB/ZYbeR9GkoQEmZr0h8p
	 YByR2UXgNaM3Rzy9EczK6HUdjzRdkcsJo2wnKrS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 319/826] wifi: iwlwifi: mvm: tell iwlmei when we finished suspending
Date: Tue,  3 Dec 2024 15:40:46 +0100
Message-ID: <20241203144756.205934131@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit d1a54ec21b8e7bca59141ff1ac6ce73e07d744f2 ]

Since we no longer shut down the device in suspend, we also no longer
call iwl_mvm_mei_device_state() and this is a problem because iwlmei
expects this to be called when it runs its own suspend sequence. It
checks mei->device_down in iwl_mei_remove() which is called upon
suspend.

Fix this by telling iwlmei when we're done accessing the device.
When we'll wake up, the device should be untouched if CSME didn't use it
during the suspend time. If CSME used it, we'll notice it through the
CSR_FUNC_SCRATCH register.

Fixes: e8bb19c1d590 ("wifi: iwlwifi: support fast resume")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241028135215.525287b90af2.Ibf183824471ea5580d9276d104444e53191e6900@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index eee7a385d9467..d37d83d246354 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1237,6 +1237,7 @@ int __iwl_mvm_mac_start(struct iwl_mvm *mvm)
 	fast_resume = mvm->fast_resume;
 
 	if (fast_resume) {
+		iwl_mvm_mei_device_state(mvm, true);
 		ret = iwl_mvm_fast_resume(mvm);
 		if (ret) {
 			iwl_mvm_stop_device(mvm);
@@ -1377,10 +1378,13 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm, bool suspend)
 		iwl_mvm_rm_aux_sta(mvm);
 
 	if (suspend &&
-	    mvm->trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_22000)
+	    mvm->trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_22000) {
 		iwl_mvm_fast_suspend(mvm);
-	else
+		/* From this point on, we won't touch the device */
+		iwl_mvm_mei_device_state(mvm, false);
+	} else {
 		iwl_mvm_stop_device(mvm);
+	}
 
 	iwl_mvm_async_handlers_purge(mvm);
 	/* async_handlers_list is empty and will stay empty: HW is stopped */
-- 
2.43.0



