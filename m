Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F040515957C;
	Mon, 29 Jan 2024 17:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548193; cv=none; b=K+vk1eYnr75j9m5ueEDmFXb9wZRn53ffuo5+Jz1EfVDuQbfOkr+gP2am+fXp4NA3KGMDIXoI8aSA8qQz7CZDYW0TS3hra3KfWnMLuDz3JUEeHWLOtYz+7/q3+7ESNJ2jmzrx5DG/OUCTZifPgcbqJt9tNT8AyIrMnlq5lVPirwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548193; c=relaxed/simple;
	bh=UqSHOyHyrUSX5WJ2x37aMfX+Cg2OioofkXaPtKb1wz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rABmafYtM4OG6Kab95KGUDfTvU0MOqGd/+xR4JRozGeLifg+CB2KpdgB1rzlUjNWW+4LtnUN9zbhCeHQcpgxFqjFvZ59akLZu8bhx9ZKSrBy2jyHYtS2kegx8TynrRFFmS5CRastS1lYnxHwWM8QUQ02Nc25TUoqKbQZbaEaXBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QreZF35q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QreZF35q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92E2C433C7;
	Mon, 29 Jan 2024 17:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548192;
	bh=UqSHOyHyrUSX5WJ2x37aMfX+Cg2OioofkXaPtKb1wz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QreZF35qqmKVJOovrMFjAe3rU8xxyUZ2W1MnU68YTFw2UZik4SyidBhJOyxU+bRTB
	 dArnaAVcPS+ie7FSCLX+c1vSZwJa5dLJKmbwIljXvlJXNHD2aRo16QaD7CFDVPWsTn
	 TYmjJSVZTS85/3McCvD9AzbF+lkXRj6gyXXZB6uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.7 231/346] wifi: iwlwifi: fix a memory corruption
Date: Mon, 29 Jan 2024 09:04:22 -0800
Message-ID: <20240129170023.192079405@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1096,7 +1096,7 @@ static int iwl_dbg_tlv_override_trig_nod
 		node_trig = (void *)node_tlv->data;
 	}
 
-	memcpy(node_trig->data + offset, trig->data, trig_data_len);
+	memcpy((u8 *)node_trig->data + offset, trig->data, trig_data_len);
 	node_tlv->length = cpu_to_le32(size);
 
 	if (policy & IWL_FW_INI_APPLY_POLICY_OVERRIDE_CFG) {


