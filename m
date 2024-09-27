Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD418BB91;
	Fri, 27 Sep 2024 12:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439903; cv=none; b=QhvUXDH9PD5o7jEhny7REapPoS9eULCoYpqG9RyPL32mk4wJEaZSUq+5UHUPO8eSdBhvuGKnMWDM039DhfmE7iaXoRVbNDUkOdwiBjKZ0kgWLmJnOXw0FfdLxgj30wytiaBUoxSAqiOnc/MloZcwXweYUuldGRGHfaJ61v7/vsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439903; c=relaxed/simple;
	bh=kxVUtgjulB3OFFzY3ZrcNsaLHm/Fl4PVScGrhVsROCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hstiLruAGmT3u1uKhbkGVsuHRadSk/9oJhAXu//Fy2bCRbxxwyAp4OmO+dcLOAIxEi5VRerf8VUUy7RXZtY2e9K4SZcS+SlWSLAofncqOOI7nXAJ+Jp9989NzqAOrqKghn6stT7J9nnGaez3TcIzi+OpuRJARzDTZfOkBmoQw4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUoHMHeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUoHMHeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5180CC4CEC4;
	Fri, 27 Sep 2024 12:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439902;
	bh=kxVUtgjulB3OFFzY3ZrcNsaLHm/Fl4PVScGrhVsROCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUoHMHeq7xntq2CIi12Ma5Y8DmPwNMvsMdtLw3Gjoltyj5zepfQXY/6d6OfXqRFe5
	 kbjkseBCfwldA7Q7TjTrV/d0J7lh35pLkQ0WLvL2f/AjD0UJSaElnlGwvvKWZRaG9Y
	 QczA7iMCX2abL7sgZVBexI2empDLxfn2O7lfnd2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/54] wifi: iwlwifi: mvm: pause TCM when the firmware is stopped
Date: Fri, 27 Sep 2024 14:23:09 +0200
Message-ID: <20240927121720.389046283@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 0668ebc8c2282ca1e7eb96092a347baefffb5fe7 ]

Not doing so will make us send a host command to the transport while the
firmware is not alive, which will trigger a WARNING.

bad state = 0
WARNING: CPU: 2 PID: 17434 at drivers/net/wireless/intel/iwlwifi/iwl-trans.c:115 iwl_trans_send_cmd+0x1cb/0x1e0 [iwlwifi]
RIP: 0010:iwl_trans_send_cmd+0x1cb/0x1e0 [iwlwifi]
Call Trace:
 <TASK>
 iwl_mvm_send_cmd+0x40/0xc0 [iwlmvm]
 iwl_mvm_config_scan+0x198/0x260 [iwlmvm]
 iwl_mvm_recalc_tcm+0x730/0x11d0 [iwlmvm]
 iwl_mvm_tcm_work+0x1d/0x30 [iwlmvm]
 process_one_work+0x29e/0x640
 worker_thread+0x2df/0x690
 ? rescuer_thread+0x540/0x540
 kthread+0x192/0x1e0
 ? set_kthread_struct+0x90/0x90
 ret_from_fork+0x22/0x30

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.5abe71ca1b6b.I97a968cb8be1f24f94652d9b110ecbf6af73f89e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 945524470a1e9..b2cf5aeff7e3c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1418,6 +1418,8 @@ void iwl_mvm_stop_device(struct iwl_mvm *mvm)
 
 	clear_bit(IWL_MVM_STATUS_FIRMWARE_RUNNING, &mvm->status);
 
+	iwl_mvm_pause_tcm(mvm, false);
+
 	iwl_fw_dbg_stop_sync(&mvm->fwrt);
 	iwl_trans_stop_device(mvm->trans);
 	iwl_free_fw_paging(&mvm->fwrt);
-- 
2.43.0



