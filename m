Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DF08F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCACEC433C8;
	Sun, 16 Jul 2023 20:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537636;
	bh=hK3PhZbMy8cFByA6JhpnJEF+lN1/DWhxonLZYMQHvqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9NYnQLz5ChjY66CDczldsaYPs5EJj2Xq2+SSP7ZJt2h0GtldFI8FL3/o/E0pxTfj
	 zDxtE3d/M5EQja9c8A1d1O7YQ/M2bLccNnl+4ky5u+STCMfA62bkL6JuEe3rezgFcn
	 B43TpysWgBlam84KDpbf5bXI7HTE1zg2BENXBj74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 166/800] wifi: iwlwifi: fw: print PC register value instead of address
Date: Sun, 16 Jul 2023 21:40:19 +0200
Message-ID: <20230716194952.964928846@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

[ Upstream commit 2b69d242e29b891b11f1190201f4a08abb0c8342 ]

The program counter address is read from the TLV and
PC address is printed in debug messages.
Read the value at PC address and print the value
instead of the register address.

Fixes: 5e31b3df86ec ("wifi: iwlwifi: dbg: print pc register data once fw dump occurred")
Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230612184434.e5a5f18f1b2c.Ib6117a4e7f66a075913241cc81477c0059953d5d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dump.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index f86f7b4baa181..f61f1ce7fe795 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -507,11 +507,16 @@ void iwl_fwrt_dump_error_logs(struct iwl_fw_runtime *fwrt)
 	iwl_fwrt_dump_fseq_regs(fwrt);
 	if (fwrt->trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_22000) {
 		pc_data = fwrt->trans->dbg.pc_data;
+
+		if (!iwl_trans_grab_nic_access(fwrt->trans))
+			return;
 		for (count = 0; count < fwrt->trans->dbg.num_pc;
 		     count++, pc_data++)
 			IWL_ERR(fwrt, "%s: 0x%x\n",
 				pc_data->pc_name,
-				pc_data->pc_address);
+				iwl_read_prph_no_grab(fwrt->trans,
+						      pc_data->pc_address));
+		iwl_trans_release_nic_access(fwrt->trans);
 	}
 
 	if (fwrt->trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ) {
-- 
2.39.2



