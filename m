Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336E218A93F;
	Sat, 12 Sep 2026 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223392; cv=none; b=GZaB0MRXPvtOW30YyF7fIch7Osp2nvkDnd7pqumU8nf0E5ACOl485nmFQdxM5BmRw1roEwELLeH1+eWuoPEZtIQSc/6bw6cKGEiVRYqFJFiOSRfthmss7si5K+63gnA+QLZehOlYDkPrtcnJXvM5/2WIhAdxzEZv/8TFjiC6izk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223392; c=relaxed/simple;
	bh=eEy1yYoM3YichYWDiD2CfG+7+talZrwdWs95LgbtiqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFNcO5DhjuyDLRqfouMOi4DONNvl1nLjcJBHK2ffwXwDy5GM07vM52eJY0pLTGPYTX3+fLstVzN1II6TeaibZ3KTDBcL3Sf+bmaWluHxahw0ZevgE4SwJTvmADXJF6Pk8m0vthgZhwGJd92ZA9Q9JJLW1S1nri6vU2j911M0J9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRHrPE5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRHrPE5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385201F000FF;
	Sat, 12 Sep 2026 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223391;
	bh=FNlXz0nej/CqsDCogGAk1NQKAX8qPkNwqsj6gWYR7oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MRHrPE5Zba66HiH8FFXDp1eY6c6xN0M57FAzkIw0uYCZ1F9TQFYTynJ6zTsRlNTFZ
	 cU3/6UtPEDmNTO1Fih9nzoTkyqtgiemnqVWfuHDZ0nvpbQoc07GVKnR8zpfC3ZT/Uf
	 qI0aY1lXxUJ7Z7vmP9L3kXIRVqsC0ZCSnSqeJBtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0781/1424] wifi: iwlwifi: mei: check SAP message length before reading it
Date: Sat, 12 Sep 2026 08:53:33 +0200
Message-ID: <20260912065624.788555209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 7d8cc301bcba233f31b589a45f4c1c97f2bb90d6 ]

Verify the SAP message size is not larger than the local buffer before
reading the message to avoid buffer overflow.

Fixes: bcd68b3dbe78 ("wifi: iwlwifi: mei: fix tx DHCP packet for devices with new Tx API")
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.f0026ce26218.I00a856d3aacae1caac605c708f7362689b734234@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index dce0b7cf7b265..c083af5240593 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2021-2024 Intel Corporation
+ * Copyright (C) 2026 Intel Corporation
  */
 
 #include <linux/etherdevice.h>
@@ -1147,6 +1148,11 @@ static void iwl_mei_handle_sap_rx_cmd(struct mei_cl_device *cldev,
 		iwl_mei_read_from_q(q_head, q_sz, &rd, wr, hdr, sizeof(*hdr));
 		valid_rx_sz -= sizeof(*hdr);
 		len = le16_to_cpu(hdr->len);
+		if (len + sizeof(*hdr) > PAGE_SIZE) {
+			dev_err(&cldev->dev,
+				"SAP message is too big: %u\n", len);
+			break;
+		}
 
 		if (valid_rx_sz < len)
 			break;
-- 
2.53.0



