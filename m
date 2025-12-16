Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D80A35BDBA;
	Tue, 16 Dec 2025 12:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886731; cv=none; b=CnaBvxUSBY3OGMzFO7Dyfgymkk3QoXCoHOLhm2OLvwAx2vNg8MU6GHcMF6vGyzxKHOnbEndKndFjjN+eQMci87FrlpEqkXQ6St7K+oVYqlJr82CfHGOLwtxCa0W1mNW5MR7BTjEXCatbLNXnsNrrzr0kPc6qb44EI+L9MZrkXDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886731; c=relaxed/simple;
	bh=V5Fp7qyCjzGt+stkkj5KaGL2r0fferOvGqhXhNSRm0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJkE7FoChLUqhqaGM4NTmJrtpM6hGyUbGhsL73VTt7dKOSPFy7aZU3H/7p7z1wFpk7egvZIZEhUORXSMRiV9ngqhyfToUAm6QyACmR8GnKlq39vTjCFZIoll+SYoZAAu5qUw1mkBpct6Sr0Mp4WXeap+8ozO338H3OeimgQP1t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOkg22lg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOkg22lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5F0C4CEF1;
	Tue, 16 Dec 2025 12:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886730;
	bh=V5Fp7qyCjzGt+stkkj5KaGL2r0fferOvGqhXhNSRm0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOkg22lg4UcWj7WFSGCo6zqO2fFB9LCWsxbfr1vN3jI3F7mzGP75U6rYsuAPyTmhb
	 hIT8otX72mnlCEmdlHC/ysMWFfv9Uir5qBhvHoqxgenwjTuoDwoD+0N6bVO7OusZwi
	 1wBX6GgCdlclyavaNtvZEG+xyXk6dBeSOIphrJQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/614] accel/ivpu: Fix DCT active percent format
Date: Tue, 16 Dec 2025 12:06:23 +0100
Message-ID: <20251216111401.890721648@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@linux.intel.com>

[ Upstream commit aa1c2b073ad23847dd2e7bdc7d30009f34ed7f59 ]

The pcode MAILBOX STATUS register PARAM2 field expects DCT active
percent in U1.7 value format. Convert percentage value to this
format before writing to the register.

Fixes: a19bffb10c46 ("accel/ivpu: Implement DCT handling")
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://lore.kernel.org/r/20251001104322.1249896-1-karol.wachowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_hw_btrs.c | 2 +-
 drivers/accel/ivpu/ivpu_hw_btrs.h | 2 +-
 drivers/accel/ivpu/ivpu_pm.c      | 9 +++++++--
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_hw_btrs.c b/drivers/accel/ivpu/ivpu_hw_btrs.c
index afdb3b2aa72a7..aa33f562d29c1 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.c
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.c
@@ -752,7 +752,7 @@ int ivpu_hw_btrs_dct_get_request(struct ivpu_device *vdev, bool *enable)
 	}
 }
 
-void ivpu_hw_btrs_dct_set_status(struct ivpu_device *vdev, bool enable, u32 active_percent)
+void ivpu_hw_btrs_dct_set_status(struct ivpu_device *vdev, bool enable, u8 active_percent)
 {
 	u32 val = 0;
 	u32 cmd = enable ? DCT_ENABLE : DCT_DISABLE;
diff --git a/drivers/accel/ivpu/ivpu_hw_btrs.h b/drivers/accel/ivpu/ivpu_hw_btrs.h
index 032c384ac3d4d..c4c10e22f30f3 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.h
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.h
@@ -36,7 +36,7 @@ u32 ivpu_hw_btrs_dpu_freq_get(struct ivpu_device *vdev);
 bool ivpu_hw_btrs_irq_handler_mtl(struct ivpu_device *vdev, int irq);
 bool ivpu_hw_btrs_irq_handler_lnl(struct ivpu_device *vdev, int irq);
 int ivpu_hw_btrs_dct_get_request(struct ivpu_device *vdev, bool *enable);
-void ivpu_hw_btrs_dct_set_status(struct ivpu_device *vdev, bool enable, u32 active_percent);
+void ivpu_hw_btrs_dct_set_status(struct ivpu_device *vdev, bool enable, u8 active_percent);
 u32 ivpu_hw_btrs_telemetry_offset_get(struct ivpu_device *vdev);
 u32 ivpu_hw_btrs_telemetry_size_get(struct ivpu_device *vdev);
 u32 ivpu_hw_btrs_telemetry_enable_get(struct ivpu_device *vdev);
diff --git a/drivers/accel/ivpu/ivpu_pm.c b/drivers/accel/ivpu/ivpu_pm.c
index 475ddc94f1cfe..457ccf09df545 100644
--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -502,6 +502,11 @@ void ivpu_pm_irq_dct_work_fn(struct work_struct *work)
 	else
 		ret = ivpu_pm_dct_disable(vdev);
 
-	if (!ret)
-		ivpu_hw_btrs_dct_set_status(vdev, enable, vdev->pm->dct_active_percent);
+	if (!ret) {
+		/* Convert percent to U1.7 format */
+		u8 val = DIV_ROUND_CLOSEST(vdev->pm->dct_active_percent * 128, 100);
+
+		ivpu_hw_btrs_dct_set_status(vdev, enable, val);
+	}
+
 }
-- 
2.51.0



