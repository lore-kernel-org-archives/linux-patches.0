Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143284F207;
	Mon,  1 Apr 2024 16:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990347; cv=none; b=bw7eTpOqY0jJWHJm+U/L6Kqr7W5lgHISX6vQtVlrosEp9sFUbEQikkoZMk0iV7bXYRtTsoRuNcRR5AZsSAp3+X5NHJYlDiIaN8NJR+4+HWPb/y+UVqJCnFNs9mN9M8k3h0aQZXOPQv7pG7SvP1Clkgijz8pFkafllUCobwBYRro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990347; c=relaxed/simple;
	bh=xiqTiyEGZowxrRQ07+h+fkxMRd8DvneZEcW2g8RlNo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAcubtYwaPXmBgFqQ7dMXVSGrcigL596EPERlJCbHjRm7TN9uk5n7CNS0+ifIK3Hmm5J35RHuKQ5zHYeQmHVerSEMtvbuqAzRpOtf1bjK6f3eMzy/CDssAES2tSuLS7no2Zoyf4g8gr3muCFRT1kxw3r1EgKFzzsFlMUQiAJeA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvZAH8GL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvZAH8GL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398A7C433C7;
	Mon,  1 Apr 2024 16:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990346;
	bh=xiqTiyEGZowxrRQ07+h+fkxMRd8DvneZEcW2g8RlNo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvZAH8GLOG9uGzI2vgJZic7CIRkoIXOEDWa1uqEKOQpTxCNq+eHH2u8xKjjPyqNi/
	 BGRRUqBmMAPqfOF8vfE3uOGnw4BIYVRYVan+QODyM3jzkDE58INdPHuyhc0JeZhZxY
	 Kqis6JkrKF6IFGfgiSOiiomyIZmQt+9CqZis3veA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.6 323/396] wifi: iwlwifi: fw: dont always use FW dump trig
Date: Mon,  1 Apr 2024 17:46:12 +0200
Message-ID: <20240401152557.544507786@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 045a5b645dd59929b0e05375f493cde3a0318271 upstream.

Since the dump_data (struct iwl_fwrt_dump_data) is a union,
it's not safe to unconditionally access and use the 'trig'
member, it might be 'desc' instead. Access it only if it's
known to be 'trig' rather than 'desc', i.e. if ini-debug
is present.

Cc: stable@vger.kernel.org
Fixes: 0eb50c674a1e ("iwlwifi: yoyo: send hcmd to fw after dump collection completes.")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240319100755.e2976bc58b29.I72fbd6135b3623227de53d8a2bb82776066cb72b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2933,8 +2933,6 @@ static void iwl_fw_dbg_collect_sync(stru
 	struct iwl_fw_dbg_params params = {0};
 	struct iwl_fwrt_dump_data *dump_data =
 		&fwrt->dump.wks[wk_idx].dump_data;
-	u32 policy;
-	u32 time_point;
 	if (!test_bit(wk_idx, &fwrt->dump.active_wks))
 		return;
 
@@ -2965,13 +2963,16 @@ static void iwl_fw_dbg_collect_sync(stru
 
 	iwl_fw_dbg_stop_restart_recording(fwrt, &params, false);
 
-	policy = le32_to_cpu(dump_data->trig->apply_policy);
-	time_point = le32_to_cpu(dump_data->trig->time_point);
-
-	if (policy & IWL_FW_INI_APPLY_POLICY_DUMP_COMPLETE_CMD) {
-		IWL_DEBUG_FW_INFO(fwrt, "WRT: sending dump complete\n");
-		iwl_send_dbg_dump_complete_cmd(fwrt, time_point, 0);
+	if (iwl_trans_dbg_ini_valid(fwrt->trans)) {
+		u32 policy = le32_to_cpu(dump_data->trig->apply_policy);
+		u32 time_point = le32_to_cpu(dump_data->trig->time_point);
+
+		if (policy & IWL_FW_INI_APPLY_POLICY_DUMP_COMPLETE_CMD) {
+			IWL_DEBUG_FW_INFO(fwrt, "WRT: sending dump complete\n");
+			iwl_send_dbg_dump_complete_cmd(fwrt, time_point, 0);
+		}
 	}
+
 	if (fwrt->trans->dbg.last_tp_resetfw == IWL_FW_INI_RESET_FW_MODE_STOP_FW_ONLY)
 		iwl_force_nmi(fwrt->trans);
 


