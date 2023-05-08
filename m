Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90510168A7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A74C433EF;
	Mon,  8 May 2023 10:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542267;
	bh=32aKnBLwRXIWwpLC/disRxlKfHXEetT47fxkcjWCCHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4eSS8s0sRwcdPzR/G5kpgjmyeAA3qJ03qrimtA74AsVCc9GhoCHXncb3iEG70aCu
	 zI8j7owbzNkEPtp0jAFjx3R8vJFRGVJ7H7avD2gzzcYrC/LSKVjjfuB/C3RbHH3yUG
	 pcshsjAgP6Opw2Aw+NwmITkivlOKsduRdV/NH+nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 379/663] wifi: iwlwifi: yoyo: Fix possible division by zero
Date: Mon,  8 May 2023 11:43:25 +0200
Message-Id: <20230508094440.406382761@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
index 48e7376a5fea7..7ed4991f8dab9 100644
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



