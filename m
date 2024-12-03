Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB2E1FA179;
	Tue,  3 Dec 2024 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238635; cv=none; b=txVdlIPtaKeBGRdJYyejzEAmk6T30ojCPztIsCq5nW3l7dU/7ZuT9NVOZcauDp4eZVOazPEDHES88LseMl+2liVj6AnLrSt6Shbi2prjWL8uM+dx+z/WwFw+4gzFABjVE07w5pakQDM6b+Oy2NvJMFPpU4iz+NHmSsQbfOgJXlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238635; c=relaxed/simple;
	bh=ZBnFLSH5mesefKiXD1690R4E0Wtn3t2cXrsHfhzVHBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPDPGXG7eDlXvxkce0dKtGw/78Kbam7K+tkg3puhJBox/Nh7QOCO6VDQQj+Bycg5WwshRPqFro2SQT7+sFy4K2o7YTR3qJm/97kDof4i+cioh/Cs8Tpx3TZLWZAGeMv5TSfMvBSHGdpCnDpjOklsGQimnqyPvBMPOM7Bw3yy9H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d67oPlMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d67oPlMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A679DC4CECF;
	Tue,  3 Dec 2024 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238635;
	bh=ZBnFLSH5mesefKiXD1690R4E0Wtn3t2cXrsHfhzVHBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d67oPlMVOxbkc1Ucz71CakF6xwSUEsfBhDaArvFl2BUMCQFSuPQgf3nqGw7QPGHy1
	 Zic1fTOQQU+Hq57xdzVovs4TQe9xjmoq+sNSdYRJYJdQz5IdUr3+85vh+tj2Ade/gA
	 JKqxBOqVGdJBSSZHyXnTpMoHRFsejdrS9QO2rJSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 338/817] wifi: iwlwifi: mvm: tell iwlmei when we finished suspending
Date: Tue,  3 Dec 2024 15:38:30 +0100
Message-ID: <20241203144009.014917251@linuxfoundation.org>
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
index af4c2e7dab083..e9979f8a8827e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1236,6 +1236,7 @@ int __iwl_mvm_mac_start(struct iwl_mvm *mvm)
 	fast_resume = mvm->fast_resume;
 
 	if (fast_resume) {
+		iwl_mvm_mei_device_state(mvm, true);
 		ret = iwl_mvm_fast_resume(mvm);
 		if (ret) {
 			iwl_mvm_stop_device(mvm);
@@ -1376,10 +1377,13 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm, bool suspend)
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



