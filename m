Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077C62ECE9B;
	Tue, 17 Jun 2025 16:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176354; cv=none; b=jAEQFPqORkyOqyQ0ABWu606V+p7tT7gF4bfGxRV64SXBI3BllexRstDobDuEDrm6m3bS4nkJBIUFVYUD9w7Zcm3dX2Vfexb5S3Zk8M4YQntoWrWWDrHtNxR+gXpni6g8hk3Tt1zyWXTFl2CTxI6mj3hUONWEes87v9I7QcH0FxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176354; c=relaxed/simple;
	bh=FbumuAnw6VDKi33UGjQMjb4gRharB5p0pssoBFT/K8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSy0/7vNCLdRZSsDJlohwtN+eIQBIqWaPRZP+z9ElldCor4JLA23O9AJ/mkW6lpr/DD++CZod5ccgDEyjpCCdj1HzYqbjLwE9h7V5QMVN3EyO84xgSsTRPgAaUI+EiLajFAjN/b5CBHN11sHQMWBa5rHlg3Bcu3ltduhvSaPCEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rqolzt6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rqolzt6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6E2C4CEE3;
	Tue, 17 Jun 2025 16:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176353;
	bh=FbumuAnw6VDKi33UGjQMjb4gRharB5p0pssoBFT/K8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rqolzt6Lrotro2J4Wlj+69+Hq+XFbypPqhsqLKvgAzZ44XFbP1Jytqk4RG1rPGMqx
	 Roq08gtEm1R9fcFJroSxdj/iEg1nbKRlZ0Y4C4ec8IYq7X8ZLxQ801NIef5QPvMd6f
	 zsOh76TyL5UPa1BKMO0kzKoHeB5BoDtPuhflQSg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 181/780] wifi: ath12k: fix ATH12K_FLAG_REGISTERED flag handling
Date: Tue, 17 Jun 2025 17:18:09 +0200
Message-ID: <20250617152458.843259580@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

[ Upstream commit 6af396942bf132a1a49523e8fe2f816dc1ebd913 ]

Commit a5686ae820fa ("wifi: ath12k: move ATH12K_FLAG_REGISTERED handling to
ath12k_mac_register()") relocated the setting of the ATH12K_FLAG_REGISTERED
flag to the ath12k_mac_register() function. However, this function only
accesses the first device (ab) via ag->ab[0], resulting in the flag being
set only for the first device in the group. Similarly,
ath12k_mac_unregister() only unsets the flag for the first device. The flag
should actually be set for all devices in the group to avoid issues during
recovery.

Hence, move setting and clearing of this flag in the function
ath12k_core_hw_group_start() and ath12k_core_hw_group_stop() respectively.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.4.1-00199-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Fixes: a5686ae820fa ("wifi: ath12k: move ATH12K_FLAG_REGISTERED handling to ath12k_mac_register()")
Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250408-fix_reboot_issues_with_hw_grouping-v4-4-95e7bf048595@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 5 +++++
 drivers/net/wireless/ath/ath12k/mac.c  | 6 ------
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 0b2dec081c6ee..34eaa6b5bf772 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -891,6 +891,9 @@ static void ath12k_core_hw_group_stop(struct ath12k_hw_group *ag)
 		ab = ag->ab[i];
 		if (!ab)
 			continue;
+
+		clear_bit(ATH12K_FLAG_REGISTERED, &ab->dev_flags);
+
 		ath12k_core_device_cleanup(ab);
 	}
 
@@ -1026,6 +1029,8 @@ static int ath12k_core_hw_group_start(struct ath12k_hw_group *ag)
 
 		mutex_lock(&ab->core_lock);
 
+		set_bit(ATH12K_FLAG_REGISTERED, &ab->dev_flags);
+
 		ret = ath12k_core_pdev_create(ab);
 		if (ret) {
 			ath12k_err(ab, "failed to create pdev core %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 3883dab6771b8..bd67140688290 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -11569,7 +11569,6 @@ void ath12k_mac_mlo_teardown(struct ath12k_hw_group *ag)
 
 int ath12k_mac_register(struct ath12k_hw_group *ag)
 {
-	struct ath12k_base *ab = ag->ab[0];
 	struct ath12k_hw *ah;
 	int i;
 	int ret;
@@ -11582,8 +11581,6 @@ int ath12k_mac_register(struct ath12k_hw_group *ag)
 			goto err;
 	}
 
-	set_bit(ATH12K_FLAG_REGISTERED, &ab->dev_flags);
-
 	return 0;
 
 err:
@@ -11600,12 +11597,9 @@ int ath12k_mac_register(struct ath12k_hw_group *ag)
 
 void ath12k_mac_unregister(struct ath12k_hw_group *ag)
 {
-	struct ath12k_base *ab = ag->ab[0];
 	struct ath12k_hw *ah;
 	int i;
 
-	clear_bit(ATH12K_FLAG_REGISTERED, &ab->dev_flags);
-
 	for (i = ag->num_hw - 1; i >= 0; i--) {
 		ah = ath12k_ag_to_ah(ag, i);
 		if (!ah)
-- 
2.39.5



