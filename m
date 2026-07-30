Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB80436BF8;
	Thu, 30 Jul 2026 14:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421419; cv=none; b=L13TCTh71aGYIykgW3e1T14qlGAqM+i20wy6WHNOJZ4LS+KBp90gqxBP31TQH9upBbe4QIGHXcmnZCjuHvCvoQVUji3OcQMgJi5xgPSCwUnkn8itt9UJOADEmRyf2tLFiY4snFO2oRhSmlX3wmSnzqz+VGHZ/u59SBzhPWlaE8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421419; c=relaxed/simple;
	bh=fjPg7bzl0bcZOSMS6S+xJhfTciO8lpvCZW2RiGDaIJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/XB/P+rFXblFXe1piN6vi11NnsPrcM8D/p4y5+YHod6d+750s3mqX4LS2woadyl6mdyI4lLDEa13IEGifmbIG/eyC4QnCD4JuO7RpcFUWktmaDeAHfzO6F95eEVNp9/iVrmroqNuLh0qgl3IcirvzLfDutSZSPT6H7OQT6VMPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wr7OQXF2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wr7OQXF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170721F000E9;
	Thu, 30 Jul 2026 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421418;
	bh=c82a8O+02UvtfT8aGggkDCqElYIHApat7qVxAF3vhcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wr7OQXF2+IlPzxHUsC0Jm8vE1YiAn7gscLS3BvT/0tK7ubj/tbPtN5E2fqhqU14Sy
	 bQOGbUX+Ao+GgPlFv/VWE0peluysq4Nrg5F7AFem5Rl1qZv1jZoFja5BbzxpnLUfqb
	 aTfH+JRsb/DP/A1mSjtA3buuTBiY0lI/S5dn7NKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 097/744] accel/ivpu: Fix wrong register read in LNL failure diagnostics
Date: Thu, 30 Jul 2026 16:06:10 +0200
Message-ID: <20260730141446.329180607@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 06e65c59261854..992addabbd3c65 100644
--- a/drivers/accel/ivpu/ivpu_hw_btrs.c
+++ b/drivers/accel/ivpu/ivpu_hw_btrs.c
@@ -861,7 +861,7 @@ static void diagnose_failure_mtl(struct ivpu_device *vdev)
 
 static void diagnose_failure_lnl(struct ivpu_device *vdev)
 {
-	u32 reg = REGB_RD32(VPU_HW_BTRS_MTL_INTERRUPT_STAT) & BTRS_LNL_IRQ_MASK;
+	u32 reg = REGB_RD32(VPU_HW_BTRS_LNL_INTERRUPT_STAT) & BTRS_LNL_IRQ_MASK;
 
 	if (REG_TEST_FLD(VPU_HW_BTRS_LNL_INTERRUPT_STAT, ATS_ERR, reg)) {
 		ivpu_err(vdev, "ATS_ERR_LOG1 0x%08x ATS_ERR_LOG2 0x%08x\n",
-- 
2.53.0



