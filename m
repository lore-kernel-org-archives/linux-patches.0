Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F4E26982C;
	Sat, 12 Sep 2026 07:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198852; cv=none; b=IDbAxv/TWo/KMe2SYvIclA729OEMVTxltqqVL4Lg1MueP47loCblf7ha0DV17BRU/ZhkKvpUmw0YHtldQNtIae0CwZ9IO744WpNr8AofHlVgDA6PnZtzF45DORhPfB/vwwNd1uh95dCW3YoNNngjapMuUFMdJMHf1yXoC5fOC1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198852; c=relaxed/simple;
	bh=K9DJ5BYuRCtwWDycuozsIhrcM058vT1nNpiKwWSNaOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aH6QabZh4kIROxCqtxts9vOqBGPGsK/iRhTy9q+s84vT4Qa/C6HrCBl7TH6hZx/ZpxyxHAsKfWu2d4nQwbKYsSSU5rGBbfp+HVu0ezLFF6lHvnxSekXae8NtfkH5bT+QY38p7+S+U/5+gyIVuD6hRluZ097q226HR81Q1gv4OAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmfqNwWj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmfqNwWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C4F1F000FF;
	Sat, 12 Sep 2026 07:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198850;
	bh=g5Jws7rt0IwwgoTAsvBBw00a0spA5ND/o3FLNhexhy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmfqNwWjNyCyAeYHXC4yohf3/hEflbZsqcFj23oASWeBkKxUOxCVKcMrX9nDw8Azl
	 9lAi4E9ipdQMehcKg/uKVcvcKA7YUIhFzp02vNfajrnrtPf0pqaFDns4COFycNd3Y4
	 h+OoPyIfDO5cc/SVIDPa6JnByRptA02EgQ1iUhmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0466/1815] wifi: iwlwifi: mei: check SAP message length before reading it
Date: Sat, 12 Sep 2026 08:36:56 +0200
Message-ID: <20260912065659.828651960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c5ff1b1b720f3..c014358593498 100644
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



