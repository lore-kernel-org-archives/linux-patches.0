Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5934E274650;
	Thu, 30 Jul 2026 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423616; cv=none; b=OhGe92UrmFXB71kOgGKobQ3LSy+ZFFatPyxAMqcFTMt32jvlEBXjXwdkfH05ky+U9aeWMqzNTuVE4Ym2Fx4EoAv2gtRxjnVZ+hmtGu/2ZxLjrRIWfu6WYtW9jV97+bvql95q4AuBj7myAIkjSYsmp0ON7VhoILmlaZmQX8dQKMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423616; c=relaxed/simple;
	bh=SAcW3GqBzCg4Dm+0DhF1z62HaZerbjvAMs9mojmuwRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSla7tsYCI508+sZzfR9ZO/tCctw8Oromew3lWkxAfqxt64LQ7kMRu23LlDyq9fzT0tR9LBs/v/8MbrQiwM5/rQxo2RoIqKPyCk3wnfxKhQaT+PNYqHidKbE+TaoU9M/dAmJ3i2fOokRq/O515Zn+dbn65aS128CPQbbUjEtl4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/y7Eosa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/y7Eosa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9791F000E9;
	Thu, 30 Jul 2026 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423615;
	bh=cNva+gt0OTG5K5n0eBAPKQimTQbDXIuUjoefJaYUgyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/y7Eosa7oN+8hTyN6ty9gaONR1Ok36E9glm9wTrvY1uIr75iN6V0b75FWmvdceLM
	 HN+4igu0Wf19dr492dPyhzHAsowSc5jJjBZ7D3FYrxiN1kXhzTw86hKsLmt9vAy0hw
	 ISpGDTC5n9+D4gbGFu+TM/YglGEbU2dB4cJ14Q7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/675] accel/ivpu: Fix wrong register read in LNL failure diagnostics
Date: Thu, 30 Jul 2026 16:07:15 +0200
Message-ID: <20260730141447.368389394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

[ Upstream commit e4159045c2704dfe146f0ccb0445d9d074cd6882 ]

diagnose_failure_lnl() read VPU_HW_BTRS_MTL_INTERRUPT_STAT instead of
VPU_HW_BTRS_LNL_INTERRUPT_STAT, which on LNL and newer parts is a
different register with a different bit layout, so failure diagnostics
decoded the wrong register and reported a bogus error cause.
Read the LNL interrupt status register instead.

Fixes: 8a27ad81f7d3 ("accel/ivpu: Split IP and buttress code")
Reviewed-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260710101331.1899505-1-karol.wachowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_hw_btrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_hw_btrs.c b/drivers/accel/ivpu/ivpu_hw_btrs.c
index aa33f562d29c12..e9786204feca43 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.c
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.c
@@ -845,7 +845,7 @@ static void diagnose_failure_mtl(struct ivpu_device *vdev)
 
 static void diagnose_failure_lnl(struct ivpu_device *vdev)
 {
-	u32 reg = REGB_RD32(VPU_HW_BTRS_MTL_INTERRUPT_STAT) & BTRS_LNL_IRQ_MASK;
+	u32 reg = REGB_RD32(VPU_HW_BTRS_LNL_INTERRUPT_STAT) & BTRS_LNL_IRQ_MASK;
 
 	if (REG_TEST_FLD(VPU_HW_BTRS_LNL_INTERRUPT_STAT, ATS_ERR, reg)) {
 		ivpu_err(vdev, "ATS_ERR_LOG1 0x%08x ATS_ERR_LOG2 0x%08x\n",
-- 
2.53.0



