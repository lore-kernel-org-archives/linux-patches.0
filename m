Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FECB47A5D;
	Mon,  1 Apr 2024 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991371; cv=none; b=U/gLddDn4Cy92Kb22XfqvT1Kvv6kMCOhb00psy81px/LVpMeK/0nI4cXOgPTimKTNjEVcmh0lUDROhEzzQDKtIJ0rLzAf7LmJ1RqpCsvfhhBdnBtzUPiClIwEYYA0ugDMtYo43gkaC29AoP1urlg8TWj7PKlKUeDcnvgcJIxty4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991371; c=relaxed/simple;
	bh=GP7XDrKSyr5Izx19IqL7eN4MCGZXjSGj5vsSPGZnNeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpjPEL1/sfxFlEXCXXZogmNWc5Z5/RhBJ4k9Jp5amXp01uDGNxEdaOQcMd6ezw/OWmuKUou8wlydZ6l9CMpSEecp85Ymlw5CZHn5Bvc7aoFqjkpwYS4lPZMPqgHd8xDquzlos2YSRo1QKorh9RR16V4xboTEVgPvIh5oRVOEXE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhaLvOTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhaLvOTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66B2C433F1;
	Mon,  1 Apr 2024 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991371;
	bh=GP7XDrKSyr5Izx19IqL7eN4MCGZXjSGj5vsSPGZnNeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhaLvOTATdS/VRWIdFxM/GWne3bB8fzToyWmkW+wm550K6YaSyXhV/o49Cs8tq5yR
	 Xyg/ejzAPCOJSP653p7z0YXF5enTm/YQNYKdnps3+fFYaEw2MqUyHv711H9Z8+boEq
	 AN+xI5vpNvXq9AQX91dGTljt5/hMj6FKIY108miI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH 6.1 216/272] wifi: iwlwifi: fw: dont always use FW dump trig
Date: Mon,  1 Apr 2024 17:46:46 +0200
Message-ID: <20240401152537.673747130@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2903,8 +2903,6 @@ static void iwl_fw_dbg_collect_sync(stru
 	struct iwl_fw_dbg_params params = {0};
 	struct iwl_fwrt_dump_data *dump_data =
 		&fwrt->dump.wks[wk_idx].dump_data;
-	u32 policy;
-	u32 time_point;
 	if (!test_bit(wk_idx, &fwrt->dump.active_wks))
 		return;
 
@@ -2935,13 +2933,16 @@ static void iwl_fw_dbg_collect_sync(stru
 
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
 


