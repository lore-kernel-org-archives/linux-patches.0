Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8AD231A24;
	Mon, 10 Mar 2025 17:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627481; cv=none; b=qo4z7gJ5vH4RYUF+rEHeVw0FsqgkRYyFQs/yJxZEs+/ndHuTH03J5+/PUx+SC2uoCRhXy7g+9MXE/PCdJBSvQVSrr4fhiHuATJDl1SW5N0/R0GMxj+onIgkn+b0Yc0LrR2/ooTgZyGn6y9p9hHiZ7nr/QosLlNDKMaqhg4LnYFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627481; c=relaxed/simple;
	bh=usPRVcX57tkr91GXqiY3ukgTAHwwZFr+N+/mIRPEmFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8RMSCbfrzfQNQMk3SDVZ4Wpf7B+GP/HZYcYqAN9wJHhCrGFfsaKujNBnK/ro2nt0iMwSkcJBUit9nrQoRSYJ9RDuT44Mw3Hp/iaPmegLZ8wcIbtLZ8/GrYnJcVs7WPlMFK4ocwJFxVEZf1ZiLwAlCtpH+CLMWnhKHBytP6g094=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkA9I+k3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkA9I+k3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E008C4CEE5;
	Mon, 10 Mar 2025 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627480;
	bh=usPRVcX57tkr91GXqiY3ukgTAHwwZFr+N+/mIRPEmFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkA9I+k3Cvo1guJLCL8XtE/k1gRmJSy1sRdqRZG71fJBzqTe55zKVj1kHBjHjVpxa
	 WHDG5Y3VYidoW3G8IUHMjrJgv2bzJry+8zC5LtVTKYnG3NZkP9SJARRpmdwrHXxEGP
	 FZwUD553N4Jgyws0M1T6vik/n3/H2FroLOtEWcII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/269] wifi: iwlwifi: mvm: dont try to talk to a dead firmware
Date: Mon, 10 Mar 2025 18:04:55 +0100
Message-ID: <20250310170503.376593920@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



