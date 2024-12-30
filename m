Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9EE1531C4;
	Mon, 30 Dec 2024 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574239; cv=none; b=YBxXd7WTW4XkGGqh8Ne9vWxwr4s+b1I9ZBTp93iKc9kYaQsrEpsShOwMnJWJgvUftOoZD1CRWSVX1VeT81lHGp6tn/DYToXyrv1VWqvIzzEZhgJ5m4i1DynYbC3ZlD21PZRH41Q1iicN6CxWxYm931WEU1OgyucewJi4OVZLnYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574239; c=relaxed/simple;
	bh=SFTE2Vc46vi9MrfNhAlWfI+SnZvbtzUbOt5p83YbYis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rW24FkN03oNcpBgEsk6p0b3htt5++OT0xOa4+8N6hKOoFvuFObSMwtTDrParRMu91LmeYAFpwMuhnyihGMav5/2uYwzN7Na2IwexzjaGE9NoAS4Chz6EQWIX119xysSJkFfhkKekv0rB7olo9KrzUur+nZ+3VvhKOqxq9suQYB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KdwwgyPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KdwwgyPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C49C4CED0;
	Mon, 30 Dec 2024 15:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574239;
	bh=SFTE2Vc46vi9MrfNhAlWfI+SnZvbtzUbOt5p83YbYis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdwwgyPdzoDIHck3dUSZpchOKEIpIacu/XvpVEgXE/hQ/8KMQF5DwA84+7hImyAiQ
	 SmB3O9aS8m5OIkZ5X464WjF8oCLJiDx6SCM2ZrWp0vCi82czh72hELkbWHDHEeAJc5
	 mean6RaocflbyIJzUgBiXpEJJrTfKv8HObDZEEAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/114] wifi: iwlwifi: be less noisy if the NIC is dead in S3
Date: Mon, 30 Dec 2024 16:43:14 +0100
Message-ID: <20241230154221.058207210@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

commit 0572b7715ffd2cac20aac00333706f3094028180 upstream

If the NIC is dead upon resume, try to catch the error earlier and exit
earlier. We'll print less error messages and get to the same recovery
path as before: reload the firmware.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20241028135215.3a18682261e5.I18f336a4537378a4c1a8537d7246cee1fc82b42c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219597
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/iwl-trans.h    | 13 +++++----
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c   | 28 ++++++++++++++-----
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  2 ++
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index e95ffe303547..c70da7281551 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1074,12 +1074,13 @@ int iwl_trans_read_config32(struct iwl_trans *trans, u32 ofs,
 void iwl_trans_debugfs_cleanup(struct iwl_trans *trans);
 #endif
 
-#define iwl_trans_read_mem_bytes(trans, addr, buf, bufsize)		      \
-	do {								      \
-		if (__builtin_constant_p(bufsize))			      \
-			BUILD_BUG_ON((bufsize) % sizeof(u32));		      \
-		iwl_trans_read_mem(trans, addr, buf, (bufsize) / sizeof(u32));\
-	} while (0)
+#define iwl_trans_read_mem_bytes(trans, addr, buf, bufsize)	\
+	({							\
+		if (__builtin_constant_p(bufsize))		\
+			BUILD_BUG_ON((bufsize) % sizeof(u32));	\
+		iwl_trans_read_mem(trans, addr, buf,		\
+				   (bufsize) / sizeof(u32));	\
+	})
 
 int iwl_trans_write_imr_mem(struct iwl_trans *trans, u32 dst_addr,
 			    u64 src_addr, u32 byte_cnt);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 244ca8cab9d1..1a814eb6743e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -3032,13 +3032,18 @@ static bool iwl_mvm_rt_status(struct iwl_trans *trans, u32 base, u32 *err_id)
 		/* cf. struct iwl_error_event_table */
 		u32 valid;
 		__le32 err_id;
-	} err_info;
+	} err_info = {};
+	int ret;
 
 	if (!base)
 		return false;
 
-	iwl_trans_read_mem_bytes(trans, base,
-				 &err_info, sizeof(err_info));
+	ret = iwl_trans_read_mem_bytes(trans, base,
+				       &err_info, sizeof(err_info));
+
+	if (ret)
+		return true;
+
 	if (err_info.valid && err_id)
 		*err_id = le32_to_cpu(err_info.err_id);
 
@@ -3635,22 +3640,31 @@ int iwl_mvm_fast_resume(struct iwl_mvm *mvm)
 	iwl_fw_dbg_read_d3_debug_data(&mvm->fwrt);
 
 	if (iwl_mvm_check_rt_status(mvm, NULL)) {
+		IWL_ERR(mvm,
+			"iwl_mvm_check_rt_status failed, device is gone during suspend\n");
 		set_bit(STATUS_FW_ERROR, &mvm->trans->status);
 		iwl_mvm_dump_nic_error_log(mvm);
 		iwl_dbg_tlv_time_point(&mvm->fwrt,
 				       IWL_FW_INI_TIME_POINT_FW_ASSERT, NULL);
 		iwl_fw_dbg_collect_desc(&mvm->fwrt, &iwl_dump_desc_assert,
 					false, 0);
-		return -ENODEV;
+		mvm->trans->state = IWL_TRANS_NO_FW;
+		ret = -ENODEV;
+
+		goto out;
 	}
 	ret = iwl_mvm_d3_notif_wait(mvm, &d3_data);
+
+	if (ret) {
+		IWL_ERR(mvm, "Couldn't get the d3 notif %d\n", ret);
+		mvm->trans->state = IWL_TRANS_NO_FW;
+	}
+
+out:
 	clear_bit(IWL_MVM_STATUS_IN_D3, &mvm->status);
 	mvm->trans->system_pm_mode = IWL_PLAT_PM_MODE_DISABLED;
 	mvm->fast_resume = false;
 
-	if (ret)
-		IWL_ERR(mvm, "Couldn't get the d3 notif %d\n", ret);
-
 	return ret;
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 3b9943eb6934..d19b3bd0866b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1643,6 +1643,8 @@ int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 out:
 	if (*status == IWL_D3_STATUS_ALIVE)
 		ret = iwl_pcie_d3_handshake(trans, false);
+	else
+		trans->state = IWL_TRANS_NO_FW;
 
 	return ret;
 }
-- 
2.39.5



