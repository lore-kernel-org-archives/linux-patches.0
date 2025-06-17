Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B19F221550;
	Tue, 17 Jun 2025 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176607; cv=none; b=cKtO7wsNKjWizOmJYEACOZqayzpVmacxULk4Y+r6l/W0kZIBNy4KWFHPiQCYjr6Qbull2wkz6P8BtU4RrmYLMc7H2wKWlhB8vt1qW0XPDqhNfvsOfSFzQpsOYEBsT+XY+E5ICkFrfDAlD9N4kg4eoxPAP7xUqSNu6v+m6LIZPz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176607; c=relaxed/simple;
	bh=565540z2tHhKSVHEXVAWC3UtDgpKMQ0b9Uq5S1lkJRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muu+5mNk2296Fq1aQrXKzAzn5al12b2mkYsjUZEdlX9f26x+Xy4CorYVxakDYKQBjY0YErkssWRxzM2/sHWBjNZqDsZavXKGgiTAsPajckYA/fFlChvq5MplFetYT2pyCvnLW3t5dnOCIyZnCAq7PYE+Xka6EfJ97YVYikUgAKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Re6q6Ds/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Re6q6Ds/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA9EC4CEE3;
	Tue, 17 Jun 2025 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176607;
	bh=565540z2tHhKSVHEXVAWC3UtDgpKMQ0b9Uq5S1lkJRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Re6q6Ds//j/GC2LtcV/6X4u2t2CRt7NqddbsZBUwEbWheYQbu9btiSNqcalJ9IX1e
	 hszZLeapFUBkvAEor4/h6OLAuRDCVPLoU//b2dZyyfuWvy5cFxln5IzzVYAPcUw/9n
	 r6+X7DJ+MTmU/7TGGzTHB83jCsb8rfmRZq3Ab5xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 297/356] wifi: ath11k: fix soc_dp_stats debugfs file permission
Date: Tue, 17 Jun 2025 17:26:52 +0200
Message-ID: <20250617152350.126290341@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <quic_jjohnson@quicinc.com>

[ Upstream commit fa645e663165d69f05f95a0c3aa3b3d08f4fdeda ]

Currently the soc_dp_stats debugfs file has the following permissions:

# ls -l /sys/kernel/debug/ath11k/pci-0000:03:00.0/soc_dp_stats
-rw------- 1 root root 0 Mar  4 15:04 /sys/kernel/debug/ath11k/pci-0000:03:00.0/soc_dp_stats

However this file does not actually support write operations -- no .write()
method is registered. Therefore use the correct permissions when creating
the file.

After the change:

# ls -l /sys/kernel/debug/ath11k/pci-0000:03:00.0/soc_dp_stats
-r-------- 1 root root 0 Mar  4 15:15 /sys/kernel/debug/ath11k/pci-0000:03:00.0/soc_dp_stats

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240305-fix-soc_dp_stats-permission-v1-1-2ec10b42f755@quicinc.com
Stable-dep-of: 9f6e82d11bb9 ("wifi: ath11k: avoid burning CPU in ath11k_debugfs_fw_stats_request()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 8cda73b78ebf4..34aa04d27a1d7 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2020 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2023 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/vmalloc.h>
@@ -980,7 +980,7 @@ int ath11k_debugfs_pdev_create(struct ath11k_base *ab)
 	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
 			    &fops_simulate_fw_crash);
 
-	debugfs_create_file("soc_dp_stats", 0600, ab->debugfs_soc, ab,
+	debugfs_create_file("soc_dp_stats", 0400, ab->debugfs_soc, ab,
 			    &fops_soc_dp_stats);
 
 	if (ab->hw_params.sram_dump.start != 0)
-- 
2.39.5



