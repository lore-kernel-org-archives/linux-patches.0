Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A274442134;
	Thu, 30 Jul 2026 15:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425653; cv=none; b=sDzH30V+hBqJZ9OOXIlNTh+/B89KBykXktkO4O7VtBOzWapGBe2UaSArV+lSQZqNqYrhps4qzez0st013hxxKTWyrH6rn3U2cwo1DuLGFzwkCQxZcK1nQzInFUnW0O6YgdL5DPogs7yP5pIaUW3kAlvJudYG+2Lqf2oEUQ+g080=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425653; c=relaxed/simple;
	bh=r80ZjKaQxvB90llUcwwXz5sH0Vtfj8x6pHKbnL4xRTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Arjtre0XcY91LmoDiaovpdu+6T4PTK47CBS+HziKvTW5KGTW99G78yUHevZKXcFpIfVfsDRjPj6Ih9OS1UyGlfpwVnZo6B2z2CpxAvOePCVz1plFzcIJgpA4NHpEpq1s06TgXl/RXKSq2Em/eH87OJy7vsPWw6Tuh+gF1fJrxmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tWlRPaDI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tWlRPaDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776DC1F000E9;
	Thu, 30 Jul 2026 15:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425652;
	bh=RKjRor5TnJAQV/C0CpppEaxKfCov6JBhVGhv0cmIVzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tWlRPaDIfZfvkEBMSBDEVds5+C/1bH14M+r97dNzptAXaguddzYZZ/3PCapo1vru2
	 x0cPxwE9T2zxRhVNl1FOYmkA2uyWOf4ZC+Mxs0W8di/PjFYw9WKEIxXEquvyPaQW8A
	 g13LgfYke6UJXrMm2T3Qclyqgd7luEyOQpOloFtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 089/602] accel/ivpu: Fix wrong register read in LNL failure diagnostics
Date: Thu, 30 Jul 2026 16:08:01 +0200
Message-ID: <20260730141437.866586011@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index 4af1b164d85a73..c9e1922aff5e84 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.c
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.c
@@ -852,7 +852,7 @@ static void diagnose_failure_mtl(struct ivpu_device *vdev)
 
 static void diagnose_failure_lnl(struct ivpu_device *vdev)
 {
-	u32 reg = REGB_RD32(VPU_HW_BTRS_MTL_INTERRUPT_STAT) & BTRS_LNL_IRQ_MASK;
+	u32 reg = REGB_RD32(VPU_HW_BTRS_LNL_INTERRUPT_STAT) & BTRS_LNL_IRQ_MASK;
 
 	if (REG_TEST_FLD(VPU_HW_BTRS_LNL_INTERRUPT_STAT, ATS_ERR, reg)) {
 		ivpu_err(vdev, "ATS_ERR_LOG1 0x%08x ATS_ERR_LOG2 0x%08x\n",
-- 
2.53.0



