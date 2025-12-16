Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B10C25FA10;
	Tue, 16 Dec 2025 11:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883832; cv=none; b=eJL2dn2uq6wOUdPfkhQba+K2hNrmIe6U2kBiBZ1N4XZjmdequf+Z43dvnp+D4Mmxfzm/TV038IEnaldImmlZ0QNqkvZY/cVsJThNWAtYdmB8PGSWPA3FPsohibUGCOJX34WAyjOqj066S9P+gaN4bAPWgs/eCq4BuuelZdnuthA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883832; c=relaxed/simple;
	bh=kpvE5zpDj9hW3YI+YCOdJlhw4RE1N7I1BUhvdhJR2WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmAGljEk4IUoWrYXY0ASCf3UD5TN/9aPotgL3K3Hy8ElvnoY90U+UBRYn8kwWw+QlzxLcOxlbcg0s8OEG4pAHf9jFo9j2A3q95DjbWaGbidAmi14djOA724tT+2FlyZQYYCfzrKQB8E+H2iQ2Mafu0uU4w6L3l9ZXbcHtMC/YLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwLnhYU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwLnhYU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3ABC4CEF1;
	Tue, 16 Dec 2025 11:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883832;
	bh=kpvE5zpDj9hW3YI+YCOdJlhw4RE1N7I1BUhvdhJR2WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwLnhYU5kvbkDcLwXD6UbG5nDt809ZGCgtPh452B2p9UTnByGau6J6nDzkJ59o18f
	 mchUbQgORE2CuN/ySOwXkUomQAU8FURMwBaG3j4g7Fa1L53qe6eyEjgONvkiDUSA3J
	 mf1wXwrtOtoDMw9taD+yue6ov9O7KSnuqJiAjCns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/354] accel/ivpu: Fix DCT active percent format
Date: Tue, 16 Dec 2025 12:09:40 +0100
Message-ID: <20251216111321.388175056@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2d88357b9a3a4..4af1b164d85a7 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.c
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.c
@@ -759,7 +759,7 @@ int ivpu_hw_btrs_dct_get_request(struct ivpu_device *vdev, bool *enable)
 	}
 }
 
-void ivpu_hw_btrs_dct_set_status(struct ivpu_device *vdev, bool enable, u32 active_percent)
+void ivpu_hw_btrs_dct_set_status(struct ivpu_device *vdev, bool enable, u8 active_percent)
 {
 	u32 val = 0;
 	u32 cmd = enable ? DCT_ENABLE : DCT_DISABLE;
diff --git a/drivers/accel/ivpu/ivpu_hw_btrs.h b/drivers/accel/ivpu/ivpu_hw_btrs.h
index 7650f15b7ffa4..ac0cf50f004ff 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.h
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.h
@@ -35,7 +35,7 @@ u32 ivpu_hw_btrs_dpu_max_freq_get(struct ivpu_device *vdev);
 bool ivpu_hw_btrs_irq_handler_mtl(struct ivpu_device *vdev, int irq);
 bool ivpu_hw_btrs_irq_handler_lnl(struct ivpu_device *vdev, int irq);
 int ivpu_hw_btrs_dct_get_request(struct ivpu_device *vdev, bool *enable);
-void ivpu_hw_btrs_dct_set_status(struct ivpu_device *vdev, bool enable, u32 active_percent);
+void ivpu_hw_btrs_dct_set_status(struct ivpu_device *vdev, bool enable, u8 active_percent);
 u32 ivpu_hw_btrs_telemetry_offset_get(struct ivpu_device *vdev);
 u32 ivpu_hw_btrs_telemetry_size_get(struct ivpu_device *vdev);
 u32 ivpu_hw_btrs_telemetry_enable_get(struct ivpu_device *vdev);
diff --git a/drivers/accel/ivpu/ivpu_pm.c b/drivers/accel/ivpu/ivpu_pm.c
index ad02b71c73bbf..bd8adba5ba70c 100644
--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -466,6 +466,11 @@ void ivpu_pm_dct_irq_thread_handler(struct ivpu_device *vdev)
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



