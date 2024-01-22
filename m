Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADE014AD2B;
	Tue, 23 Jan 2024 00:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969266; cv=none; b=MoyY5ct6USqKo8ctorPGlclPT16DYFfN9IdxBhCzYdtPKdygIx/yCOGzCXgUj1ppv/8LqgDBx7V9uLmrrPe7fP1fqVvkhDZXwfVQFr56m4pcjijj58SzWEHmgg71roGn3mjDvATEoIjT3/q0YlUEQ1XoTbmgwoYjXK/v5tuJnOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969266; c=relaxed/simple;
	bh=vGDosuZ3DcrV5eE5V6lsJIrPoPjTLMBTaW/AuIypB7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/Uj35tp/vHYtJbbr3VJWos2jET8uI3c9KdC/t1VRO/l474M1MbqgeJMHKCoCznlO3KjXNDIq70ao2Xa2IApSPFSdtDaNwXjTq6Q2eW3Jx+3QqH6BSPc5Ap2S9SG5VWfB1DlypYZQVugsOick9UFdF/OOzlf8joKb+m+so6QHLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VU2ixWkf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VU2ixWkf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9DCC43394;
	Tue, 23 Jan 2024 00:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969266;
	bh=vGDosuZ3DcrV5eE5V6lsJIrPoPjTLMBTaW/AuIypB7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VU2ixWkf8OoL76W4SzQ6Uh1vWqnm9spZ7jw8veLon8u6ALSv/1kesfcnCBPk+hubp
	 /19oKHtTcK586lJscSELumnvKF7s3S8CS0FaqcbB4kT9Y89AYBIBwIPOjs/01oV7xr
	 v9q3PV2DdllQ/hIFnS5CqB/8flyb+Aj7klebanoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 108/641] wifi: ath12k: fix the error handler of rfkill config
Date: Mon, 22 Jan 2024 15:50:12 -0800
Message-ID: <20240122235821.422737545@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

From: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>

[ Upstream commit 898d8b3e1414cd900492ee6a0b582f8095ba4a1a ]

When the core rfkill config throws error, it should free the
allocated resources. Currently it is not freeing the core pdev
create resources. Avoid this issue by calling the core pdev
destroy in the error handler of core rfkill config.

Found this issue in the code review and it is compile tested only.

Fixes: 004ccbc0dd49 ("wifi: ath12k: add support for hardware rfkill for WCN7850")
Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20231111040107.18708-1-quic_periyasa@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index b936760b5140..6c01b282fcd3 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/module.h>
@@ -698,13 +698,15 @@ int ath12k_core_qmi_firmware_ready(struct ath12k_base *ab)
 	ret = ath12k_core_rfkill_config(ab);
 	if (ret && ret != -EOPNOTSUPP) {
 		ath12k_err(ab, "failed to config rfkill: %d\n", ret);
-		goto err_core_stop;
+		goto err_core_pdev_destroy;
 	}
 
 	mutex_unlock(&ab->core_lock);
 
 	return 0;
 
+err_core_pdev_destroy:
+	ath12k_core_pdev_destroy(ab);
 err_core_stop:
 	ath12k_core_stop(ab);
 	ath12k_mac_destroy(ab);
-- 
2.43.0



