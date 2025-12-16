Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E8F349B1E;
	Tue, 16 Dec 2025 11:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885188; cv=none; b=JJsthVx+fC04OlhuouZ3LCTVYg5C3DEa9D51TYV9J94C3A6XbzGp6iPKCVSnHtV/HEhjvwqzYZmn1Uu7Qe/byw5+OlhiLFpoU1GMRbpPCg7jgWxRmVGjX+FI4Dx6vWg+D/z4bwvysqw4SxTu+FQq5D0VSlqI6PeM8KN0e3cDRcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885188; c=relaxed/simple;
	bh=WvW/YXyTARYsXGzFYCLYkVOHjgRp7Av90N/iXE8Xq8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SYGZdnIrgG9oG+oQVFqeQgQhBelZ7EuAwllKPFuyTJ3L3fYfGIX5FPzaRRNi2ZFM+H4sc+FDm0UCa33fvuS8yrkWfNNhXrblwRi8/YfQhq5x7gRwY7o8jTJHYf1ZNMXgwux8lg+6V/kG1IUiLaPVa5a67uRrsDJ0aYorK84Wixg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMEj+w0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMEj+w0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31E4C4CEF1;
	Tue, 16 Dec 2025 11:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885188;
	bh=WvW/YXyTARYsXGzFYCLYkVOHjgRp7Av90N/iXE8Xq8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMEj+w0jCs2LI3QV+QSyquXz7ujBoFCw6FzeJm9VXfIQMA+Swt3QwdtbHzWqikfH4
	 Mtzx4mWkyj2e7djOyLh3bUfOL4P2u60AhtlcTIkQjXTKqCij5y6tChLJD+IfO9qOaS
	 mmpbWk4E+zRS+XzbNKj0XhmDaZkVy+ILI2jqL1q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 032/507] wifi: ath10k: move recovery check logic into a new work
Date: Tue, 16 Dec 2025 12:07:53 +0100
Message-ID: <20251216111346.701217759@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit f35a07a4842a88801d9182b1a76d178bfa616978 ]

Currently, ath10k has a recovery check logic. It will wait for the
last recovery to finish by wait_for_completion_timeout();

But in SDIO scenarios, the recovery function may be invoked from
interrupt context, where long blocking waits are undesirable and can
lead to system instability.

Additionally, Linux’s ordered workqueue processes one task at a time.
If a previous recovery is still queued or executing, new triggers are
ignored. This prevents accurate tracking of consecutive failures and
delays transition to the WEDGED state.

To address this, move the recovery check logic into a different
workqueue.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Fixes: c256a94d1b1b ("wifi: ath10k: shutdown driver when hardware is unreliable")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251014110757.155-1-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 20 +++++++++-----------
 drivers/net/wireless/ath/ath10k/core.h |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c  |  2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 6f78f1752cd6f..9ae3595fb6986 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
  * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
@@ -2493,8 +2492,9 @@ static int ath10k_init_hw_params(struct ath10k *ar)
 	return 0;
 }
 
-static bool ath10k_core_needs_recovery(struct ath10k *ar)
+static void ath10k_core_recovery_check_work(struct work_struct *work)
 {
+	struct ath10k *ar = container_of(work, struct ath10k, recovery_check_work);
 	long time_left;
 
 	/* Sometimes the recovery will fail and then the next all recovery fail,
@@ -2504,7 +2504,7 @@ static bool ath10k_core_needs_recovery(struct ath10k *ar)
 		ath10k_err(ar, "consecutive fail %d times, will shutdown driver!",
 			   atomic_read(&ar->fail_cont_count));
 		ar->state = ATH10K_STATE_WEDGED;
-		return false;
+		return;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "total recovery count: %d", ++ar->recovery_count);
@@ -2518,27 +2518,24 @@ static bool ath10k_core_needs_recovery(struct ath10k *ar)
 							ATH10K_RECOVERY_TIMEOUT_HZ);
 		if (time_left) {
 			ath10k_warn(ar, "previous recovery succeeded, skip this!\n");
-			return false;
+			return;
 		}
 
 		/* Record the continuous recovery fail count when recovery failed. */
 		atomic_inc(&ar->fail_cont_count);
 
 		/* Avoid having multiple recoveries at the same time. */
-		return false;
+		return;
 	}
 
 	atomic_inc(&ar->pending_recovery);
-
-	return true;
+	queue_work(ar->workqueue, &ar->restart_work);
 }
 
 void ath10k_core_start_recovery(struct ath10k *ar)
 {
-	if (!ath10k_core_needs_recovery(ar))
-		return;
-
-	queue_work(ar->workqueue, &ar->restart_work);
+	/* Use workqueue_aux to avoid blocking recovery tracking */
+	queue_work(ar->workqueue_aux, &ar->recovery_check_work);
 }
 EXPORT_SYMBOL(ath10k_core_start_recovery);
 
@@ -3734,6 +3731,7 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
 
 	INIT_WORK(&ar->register_work, ath10k_core_register_work);
 	INIT_WORK(&ar->restart_work, ath10k_core_restart);
+	INIT_WORK(&ar->recovery_check_work, ath10k_core_recovery_check_work);
 	INIT_WORK(&ar->set_coverage_class_work,
 		  ath10k_core_set_coverage_class_work);
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8c72ed386edb7..859176fcb5a29 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -3,7 +3,6 @@
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
  * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
- * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
@@ -1208,6 +1207,7 @@ struct ath10k {
 
 	struct work_struct register_work;
 	struct work_struct restart_work;
+	struct work_struct recovery_check_work;
 	struct work_struct bundle_tx_work;
 	struct work_struct tx_complete_work;
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 154ac7a709824..da6f7957a0ae7 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3,7 +3,6 @@
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
  * Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
@@ -5428,6 +5427,7 @@ static void ath10k_stop(struct ieee80211_hw *hw, bool suspend)
 	cancel_work_sync(&ar->set_coverage_class_work);
 	cancel_delayed_work_sync(&ar->scan.timeout);
 	cancel_work_sync(&ar->restart_work);
+	cancel_work_sync(&ar->recovery_check_work);
 }
 
 static int ath10k_config_ps(struct ath10k *ar)
-- 
2.51.0



