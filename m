Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F142215A497;
	Mon, 29 Jan 2024 17:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548585; cv=none; b=I4wUMmSvhFnmAF18v2R8an3eB80i5bhnrmg8ij+0S1uEWWpjFF8Oni0e4LGppeKuRt50BZw1+EMTMr3Z7ffjvmkxo1VsMyvsbQxnyNszzByd3etHEdZ6aE1vPOMp+qC1pbCRDYWgetknnEokNqLsS+lN+5O+UGeKflpqh+LqFcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548585; c=relaxed/simple;
	bh=5/1Ak+baGmXZ0uTQbs/utNs8x4PlkLsuS1Sn9U6uCzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTHAuWDc4TBw54zQDx4WeyQ4R4CvnWU7DHbg3Yju0ZnDhuZzXj7b6iz2I2BoYTfZw/NKrKAu6RilubqLbMOCKMIns+MXroImZbMZuJiyMZ5oFe2e0d02/MOn0vQc0N71ImTo9xS5SQoPf2tnqvTeMeUELCZQl+qOdoREJQH0a4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ItZ+sky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ItZ+sky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E71C433C7;
	Mon, 29 Jan 2024 17:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548584;
	bh=5/1Ak+baGmXZ0uTQbs/utNs8x4PlkLsuS1Sn9U6uCzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ItZ+skyi/iZZrUsiM4KBZqnjJeuQirj936/vQIjnR0oFNyQEdAjgU3d3Tf+pumUA
	 73m/t1p693K3FkBFO5g/24qadS2jYrbpuft4u1ULH4I1gRxmn2d0e9Z+wkc/0zRnAI
	 1KOPJ7sjzjfwfZYt6ODVRvmQ0jP9d0JC6z+VaEJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 240/331] wifi: iwlwifi: fix a memory corruption
Date: Mon, 29 Jan 2024 09:05:04 -0800
Message-ID: <20240129170021.898995068@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit cf4a0d840ecc72fcf16198d5e9c505ab7d5a5e4d upstream.

iwl_fw_ini_trigger_tlv::data is a pointer to a __le32, which means that
if we copy to iwl_fw_ini_trigger_tlv::data + offset while offset is in
bytes, we'll write past the buffer.

Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218233
Fixes: cf29c5b66b9f ("iwlwifi: dbg_ini: implement time point handling")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240111150610.2d2b8b870194.I14ed76505a5cf87304e0c9cc05cc0ae85ed3bf91@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2018-2023 Intel Corporation
+ * Copyright (C) 2018-2024 Intel Corporation
  */
 #include <linux/firmware.h>
 #include "iwl-drv.h"
@@ -1094,7 +1094,7 @@ static int iwl_dbg_tlv_override_trig_nod
 		node_trig = (void *)node_tlv->data;
 	}
 
-	memcpy(node_trig->data + offset, trig->data, trig_data_len);
+	memcpy((u8 *)node_trig->data + offset, trig->data, trig_data_len);
 	node_tlv->length = cpu_to_le32(size);
 
 	if (policy & IWL_FW_INI_APPLY_POLICY_OVERRIDE_CFG) {


