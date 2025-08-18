Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7303376B4;
	Mon, 18 Aug 2025 14:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525679; cv=none; b=Xyzyx2s5sQ3UAigXl36ng7rGGEWRN4c6JIp7oHWnFzpfkMg8Ipo2zAdNT28JRFXX1OfgwHZQ5Hw8StTMjj0q0rU56wGx3+AuppUOX4FyaAiXGjeiWbdImfyHnRPyB57RftO/uJeIP1d0GJf/IDH1X2tCuzvPJRdisbO19PpBIrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525679; c=relaxed/simple;
	bh=c0LYctQsIWwpoj/0WkpOzosEcyduuoMoqyTeA+JLqd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCSxJWIC9EgqScybXRj2BRKTcFnK9pAzZTN+nEgJA2sm+Vds4kS82f8GkwfkhQ9lD6O+UZftvfg4BJgK3nOn4y/cQrVkICavik+s4FYxcxRvysIJieQXwYQ1pr1rzhrQQ0kYLeIe9MuEwIeh9vHLTB3jegckIb1kQa27fa5o6Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ok9CkTiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ok9CkTiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E80C4CEF1;
	Mon, 18 Aug 2025 14:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525678;
	bh=c0LYctQsIWwpoj/0WkpOzosEcyduuoMoqyTeA+JLqd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ok9CkTiBIOdiJN1tasl6KThNzR0I5cyWxn/lJJXx6rcjODbqBol5m713eAScoTA1o
	 S+aYbp+jyF680P6i+HKS1ut8/W4huHIGp6uQ7W37vDHfMW4kRdTblaqR5I4H1lL1me
	 Bafbzh819758Q5Y7GLGQH6ToRRuNtQfw5zYzpwpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 307/570] wifi: iwlwifi: pcie: reinit device properly during TOP reset
Date: Mon, 18 Aug 2025 14:44:54 +0200
Message-ID: <20250818124517.702130313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit eda36f5195d6c078e20331f1dfcf688bd6567c2b ]

During TOP reset a full _iwl_trans_pcie_start_hw() is needed so
the device is properly initialized for operation. Fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250609211928.903444f8e8e8.I7f70600339abb9d658f97924aef22faf1af00a3c@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 5 +++++
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c      | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 3b7c12fc4f9e..df4eaaa7efd2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1074,6 +1074,7 @@ void iwl_pcie_rx_allocator_work(struct work_struct *data);
 
 /* common trans ops for all generations transports */
 void iwl_trans_pcie_op_mode_enter(struct iwl_trans *trans);
+int _iwl_trans_pcie_start_hw(struct iwl_trans *trans);
 int iwl_trans_pcie_start_hw(struct iwl_trans *trans);
 void iwl_trans_pcie_op_mode_leave(struct iwl_trans *trans);
 void iwl_trans_pcie_write8(struct iwl_trans *trans, u32 ofs, u8 val);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 5a9c3b7976a1..c7ada07a7075 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -612,6 +612,11 @@ int iwl_trans_pcie_gen2_start_fw(struct iwl_trans *trans,
 		msleep(10);
 		IWL_INFO(trans, "TOP reset successful, reinit now\n");
 		/* now load the firmware again properly */
+		ret = _iwl_trans_pcie_start_hw(trans);
+		if (ret) {
+			IWL_ERR(trans, "failed to start HW after TOP reset\n");
+			goto out;
+		}
 		trans_pcie->prph_scratch->ctrl_cfg.control.control_flags &=
 			~cpu_to_le32(IWL_PRPH_SCRATCH_TOP_RESET);
 		top_reset_done = true;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index cc4d289b110d..07a9255c9868 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1845,7 +1845,7 @@ static int iwl_pcie_gen2_force_power_gating(struct iwl_trans *trans)
 	return iwl_trans_pcie_sw_reset(trans, true);
 }
 
-static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans)
+int _iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int err;
-- 
2.39.5



