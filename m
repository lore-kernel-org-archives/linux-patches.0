Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023D4168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1CEC433D2;
	Mon,  8 May 2023 10:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540410;
	bh=rYiCoB+DKt+7REm0/FM7ikuKnN3Sy5KsDk4tv4VrQ/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yivo1bPS3xJdv6ak6E+gsIWYa1N8CTGVfDPxTQRrCFaKvQoyMWlclDe6XbmsSijf1
	 7N6i35ZNZv6oYawahbS9WYQ+2NbENfyks/9brg15mOnAPka16Ak2AHcH3QV7wj7fc+
	 Uq3ER56bhUzn0BHo2Q3q7E8dveVDC9AEcMqswms8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 355/611] wifi: iwlwifi: yoyo: Fix possible division by zero
Date: Mon,  8 May 2023 11:43:17 +0200
Message-Id: <20230508094433.936113178@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Gabay <daniel.gabay@intel.com>

[ Upstream commit ba30415118eee374a08b39a0460a1d1e52c24a25 ]

Don't allow buffer allocation TLV with zero req_size since it
leads later to division by zero in iwl_dbg_tlv_alloc_fragments().
Also, NPK/SRAM locations are allowed to have zero buffer req_size,
don't discard them.

Fixes: a9248de42464 ("iwlwifi: dbg_ini: add TLV allocation new API support")
Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230413213309.5d6688ed74d8.I5c2f3a882b50698b708d54f4524dc5bdf11e3d32@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 3237d4b528b5d..a1d34f3e7a9f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -138,6 +138,12 @@ static int iwl_dbg_tlv_alloc_buf_alloc(struct iwl_trans *trans,
 	    alloc_id != IWL_FW_INI_ALLOCATION_ID_DBGC1)
 		goto err;
 
+	if (buf_location == IWL_FW_INI_LOCATION_DRAM_PATH &&
+	    alloc->req_size == 0) {
+		IWL_ERR(trans, "WRT: Invalid DRAM buffer allocation requested size (0)\n");
+		return -EINVAL;
+	}
+
 	trans->dbg.fw_mon_cfg[alloc_id] = *alloc;
 
 	return 0;
-- 
2.39.2



