Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65E91D90CD;
	Tue, 15 Oct 2024 11:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992279; cv=none; b=mmNYqLWc/F1eEkplwxMu+ClYuKGaClnrkZ95+bfksOQt4HGpIy2XvY9MVFa6W8IoYUCj4t0Itn9XahUjuz/3f2jz8GLIM2Yfqu5iJIgUUR4ab72MxAieJXQSj8dh7wCD5Y2nk8BsVEAVkOxpjAwO55AXAz2UBhAOOviU9eM3ago=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992279; c=relaxed/simple;
	bh=hY0xNqwJjPGyjy/bqEJB/Ez2e8JFp6pf3pAkslfpOx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH3gE20BTEPDabtzabmoglrawWwwT+jjO7K/kdw7iFepYF/6wVRTCpMBx1xeOsBh68MvQdLSZMlbu5GotmsGBfh6H026sqfGoW+bOipbVyLPIwHiqBC1zZzl+GAcpWytO6+8sQmfPn7o5pol1YqZ36FfrXrTl9RLF4ocsVrWnjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fIW9Te8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fIW9Te8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4DBC4CECE;
	Tue, 15 Oct 2024 11:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992279;
	bh=hY0xNqwJjPGyjy/bqEJB/Ez2e8JFp6pf3pAkslfpOx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fIW9Te8RVAwOHIqiwZJcggZcq/ABKYetNRHEFEP0riFzYxu0kiN0NmXoEMC4ROPB
	 rY0zFLAAcVrhcu0IkqtRVnieA5S7iUZ2o86CuhT7YlsuqpB+YYqNXTf9o30gso5g+0
	 jYb6umHL+jWuVTjB75rySvfecHItjV0pEs+pV9q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/691] wifi: iwlwifi: clear trans->state earlier upon error
Date: Tue, 15 Oct 2024 13:20:18 +0200
Message-ID: <20241015112443.132354638@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 094513f8a2fbddee51b055d8035f995551f98fce ]

When the firmware crashes, we first told the op_mode and only then,
changed the transport's state. This is a problem if the op_mode's
nic_error() handler needs to send a host command: it'll see that the
transport's state still reflects that the firmware is alive.

Today, this has no consequences since we set the STATUS_FW_ERROR bit and
that will prevent sending host commands. iwl_fw_dbg_stop_restart_recording
looks at this bit to know not to send a host command for example.

To fix the hibernation, we needed to reset the firmware without having
an error and checking STATUS_FW_ERROR to see whether the firmware is
alive will no longer hold, so this change is necessary as well.

Change the flow a bit.
Change trans->state before calling the op_mode's nic_error() method and
check trans->state instead of STATUS_FW_ERROR. This will keep the
current behavior of iwl_fw_dbg_stop_restart_recording upon firmware
error, and it'll allow us to call iwl_fw_dbg_stop_restart_recording
safely even if STATUS_FW_ERROR is clear, but yet, the firmware is not
alive.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.9d7427fbdfd7.Ia056ca57029a382c921d6f7b6a6b28fc480f2f22@changeid
[I missed this was a dependency for the hibernation fix, changed
 the commit message a bit accordingly]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c    | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index f34a02b33ccd4..fc630a0d9c83c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2862,7 +2862,7 @@ void iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
 {
 	int ret __maybe_unused = 0;
 
-	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status))
+	if (!iwl_trans_fw_running(fwrt->trans))
 		return;
 
 	if (fw_has_capa(&fwrt->fw->ucode_capa,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index a2919a32d7081..d2b31599340fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1393,8 +1393,8 @@ static inline void iwl_trans_fw_error(struct iwl_trans *trans, bool sync)
 
 	/* prevent double restarts due to the same erroneous FW */
 	if (!test_and_set_bit(STATUS_FW_ERROR, &trans->status)) {
-		iwl_op_mode_nic_error(trans->op_mode, sync);
 		trans->state = IWL_TRANS_NO_FW;
+		iwl_op_mode_nic_error(trans->op_mode, sync);
 	}
 }
 
-- 
2.43.0



