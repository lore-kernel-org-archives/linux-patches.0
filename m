Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6480A231A30;
	Mon, 10 Mar 2025 17:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626706; cv=none; b=oD8SMXIVovsY3FBJRyXJ8LAMv/KrmEmEoeUAcqThjVrGFlG+4P1stcP1Bt2q8j0VuIEv2zkJ7GgqLXEPXMNd//03yjRenabLx/IE+7VWWz453iUqtpFq64JDJp47FzUNYA5wdNK9s/hK8rjh7Gls9m3qoKmMM7761lkjqXfajD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626706; c=relaxed/simple;
	bh=Hl7Z41DY5KZSNKW8z25gfmaqF1MZLx6BkcAnwUUJ0ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+tUpr2R9yDpv7pF0lrFjiKbfFEMHxN9mbSre/7InR3joQjJH8IRObn4d1KnXCQDRTTpIH1IPQpbHa1UYfohPeuTC1Dys0rmMPaJoAFgXKxBzqKQVWVAlqo0j0Uo2hrmbzwca5Lp3WOigJJabu8MsNkCQeJFb2sLTjN96h4KoSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OipRiGub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OipRiGub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38F9C4CEE5;
	Mon, 10 Mar 2025 17:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626706;
	bh=Hl7Z41DY5KZSNKW8z25gfmaqF1MZLx6BkcAnwUUJ0ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OipRiGubi4g4+nc+yUSD8xg9fa32M28PIq18ky+DghwLRy7dq2ZYsfkr6M7jUGOVF
	 GYHdeujuIefCyFj3ON7UlPR/sNXLxQ00OF3CPgbhXxedDVF3OrJ0tmC3oee4Mg3QXq
	 ngTr6F4Zxwms/yGSjmP59qYpU6A7zIYBKEp+YWH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 085/207] wifi: iwlwifi: mvm: dont try to talk to a dead firmware
Date: Mon, 10 Mar 2025 18:04:38 +0100
Message-ID: <20250310170451.141201886@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit d73d2c6e3313f0ba60711ab4f4b9044eddca9ca5 ]

This fixes:

 bad state = 0
 WARNING: CPU: 10 PID: 702 at drivers/net/wireless/inel/iwlwifi/iwl-trans.c:178 iwl_trans_send_cmd+0xba/0xe0 [iwlwifi]
 Call Trace:
  <TASK>
  ? __warn+0xca/0x1c0
  ? iwl_trans_send_cmd+0xba/0xe0 [iwlwifi 64fa9ad799a0e0d2ba53d4af93a53ad9a531f8d4]
  iwl_fw_dbg_clear_monitor_buf+0xd7/0x110 [iwlwifi 64fa9ad799a0e0d2ba53d4af93a53ad9a531f8d4]
  _iwl_dbgfs_fw_dbg_clear_write+0xe2/0x120 [iwlmvm 0e8adb18cea92d2c341766bcc10b18699290068a]

Ask whether the firmware is alive before sending a command.

Fixes: 268712dc3b34 ("wifi: iwlwifi: mvm: add a debugfs hook to clear the monitor data")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250209143303.8e1597b62c70.I12ea71dd9b805b095c9fc12a10c9f34a4e801b61@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
index 91ca830a7b603..f4276fdee6bea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
@@ -1518,6 +1518,13 @@ static ssize_t iwl_dbgfs_fw_dbg_clear_write(struct iwl_mvm *mvm,
 	if (mvm->trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_9000)
 		return -EOPNOTSUPP;
 
+	/*
+	 * If the firmware is not running, silently succeed since there is
+	 * no data to clear.
+	 */
+	if (!iwl_mvm_firmware_running(mvm))
+		return count;
+
 	mutex_lock(&mvm->mutex);
 	iwl_fw_dbg_clear_monitor_buf(&mvm->fwrt);
 	mutex_unlock(&mvm->mutex);
-- 
2.39.5



