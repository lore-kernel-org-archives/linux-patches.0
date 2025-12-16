Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7872D97B8;
	Tue, 16 Dec 2025 11:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885021; cv=none; b=muW+mubfaXcs305jeu4ZpNtF3p9z+xN56G8e1kgxWyKXkoiOk5hqMZPReoPBLCNlO39xw2IboFDQuQ+BcliaysdugILQHtU0M05LTbpSqUl/TeGvHvHIbRgqm+Hv/faN8zgjSJvj6OehP+/Yb9GxrQcp2GBHb98veUoDnbZd7hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885021; c=relaxed/simple;
	bh=oQwCXeDJsbunCdwAukhWQffR/p/2ztiAhithZycI+5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFtrGKFDDpGEnU0nZNdPgOmmKtQ4qyQNZzBjcP1BHd1M7oBtul/ff9EHbfaGNND1clS7WpR044k7ZdGo0+zoKLUWHU39/44DdjjRV2YWGz+gjnJDt0n7dLvdB0tcy85n/oFPhbQ8ooEByG4J1fISA0z99NhHJbszT+2DYWnBpt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QciV1BEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QciV1BEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414E2C4CEF1;
	Tue, 16 Dec 2025 11:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885021;
	bh=oQwCXeDJsbunCdwAukhWQffR/p/2ztiAhithZycI+5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QciV1BEjnS/qZJsdI+4nZdUPAnJEnJm6yQ3mQ5YWec3tGaNcWl9KJj6myK97pqCQG
	 9D5VIa+EWQlQYs8myCS/evhs+PY4asD1eOZkN1QEl3F9sJdwL21rF+hdl/Sjo1XRWP
	 rydbj86AzmstbUlhfXZEfZ4ni8uVQgaUWZNIKYF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 015/507] accel/ivpu: Fix DCT active percent format
Date: Tue, 16 Dec 2025 12:07:36 +0100
Message-ID: <20251216111346.087952762@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index b236c7234daab..05f4133c3511a 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.c
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.c
@@ -753,7 +753,7 @@ int ivpu_hw_btrs_dct_get_request(struct ivpu_device *vdev, bool *enable)
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



