Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784B918801A;
	Tue, 30 Jul 2024 16:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358547; cv=none; b=rLm9Q6TyOTVCPTesUTPrLLuP5iWqVb6E///zLLx2KmWILECg61pDUvQL9DiNE+T0Zcwc8zvCuSVooba2EFj0zGPkBFJX/3RO9FjiE8LNPRBiI1ffSdzIFMyG1Cj4CYIIEgThddpcdcWKaPFsMS+u93Fxu23reuNCrgnGLz1kfDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358547; c=relaxed/simple;
	bh=IQfRzZL0GmHVQ4o/nLrMWZYb6llT/1ehKBNR2Onx9to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TcA/uBAGHNk8MdnbJvKYuUyawc8KamNZ4TFjfjJxGrxecNy75/xsZlo8mb1/mHRAllWNMaP7jtx/NqAGC+g9a/mBF3LH5/n79paha6ajidYmCTCNaOqw6wLlcc4hgvrcb0TgzmJXxzeEhhI2Zu3O7tM5j1GtAlxm4l4n29gtk2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ht4TcCrn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ht4TcCrn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B887DC32782;
	Tue, 30 Jul 2024 16:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358547;
	bh=IQfRzZL0GmHVQ4o/nLrMWZYb6llT/1ehKBNR2Onx9to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ht4TcCrnJN+jRWovoUsgrPbnpzZ7INUFjFYxH5O7GR6NIcoR1rv6uLj5NspiI/5hY
	 28Joppaym5zKHF5P6OYQKVQgWKaqSWy3DgU+KSgjD29H68lBu+f8HPuYAdbov06+47
	 hhihMml72/tt1ut648bsl0f1cxk/LGsFI3OqiM1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjelique Melendez <quic_amelende@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 350/809] leds: rgb: leds-qcom-lpg: Add PPG check for setting/clearing PBS triggers
Date: Tue, 30 Jul 2024 17:43:46 +0200
Message-ID: <20240730151738.458952092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anjelique Melendez <quic_amelende@quicinc.com>

[ Upstream commit 7e776e21255bf4c271e0df0a7d289a4963580e61 ]

Currently, all LED LPG devices will call lpg_{set,clear}_pbs_trigger()
when setting brightness regardless of if they support PPG and have PBS
triggers. Check if device supports PPG before setting/clearing PBS
triggers.

Fixes: 6ab1f766a80a ("leds: rgb: leds-qcom-lpg: Add support for PPG through single SDAM")
Fixes: 5e9ff626861a ("leds: rgb: leds-qcom-lpg: Include support for PPG with dedicated LUT SDAM")
Signed-off-by: Anjelique Melendez <quic_amelende@quicinc.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20240607005250.4047135-1-quic_amelende@quicinc.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/rgb/leds-qcom-lpg.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/rgb/leds-qcom-lpg.c b/drivers/leds/rgb/leds-qcom-lpg.c
index 9467c796bd041..e74b2ceed1c26 100644
--- a/drivers/leds/rgb/leds-qcom-lpg.c
+++ b/drivers/leds/rgb/leds-qcom-lpg.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (c) 2017-2022 Linaro Ltd
  * Copyright (c) 2010-2012, The Linux Foundation. All rights reserved.
- * Copyright (c) 2023, Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2023-2024, Qualcomm Innovation Center, Inc. All rights reserved.
  */
 #include <linux/bits.h>
 #include <linux/bitfield.h>
@@ -254,6 +254,9 @@ static int lpg_clear_pbs_trigger(struct lpg *lpg, unsigned int lut_mask)
 	u8 val = 0;
 	int rc;
 
+	if (!lpg->lpg_chan_sdam)
+		return 0;
+
 	lpg->pbs_en_bitmap &= (~lut_mask);
 	if (!lpg->pbs_en_bitmap) {
 		rc = nvmem_device_write(lpg->lpg_chan_sdam, SDAM_REG_PBS_SEQ_EN, 1, &val);
@@ -276,6 +279,9 @@ static int lpg_set_pbs_trigger(struct lpg *lpg, unsigned int lut_mask)
 	u8 val = PBS_SW_TRIG_BIT;
 	int rc;
 
+	if (!lpg->lpg_chan_sdam)
+		return 0;
+
 	if (!lpg->pbs_en_bitmap) {
 		rc = nvmem_device_write(lpg->lpg_chan_sdam, SDAM_REG_PBS_SEQ_EN, 1, &val);
 		if (rc < 0)
-- 
2.43.0



