Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC683542F8;
	Sat, 12 Sep 2026 09:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204376; cv=none; b=VeNAI3neLdX1KCQ0YSf7VWt02CiflKyWWYaCHXrfw4y42ms/0Ba6YPFanT9UJrnCa2aIVzv4Uvru1eV9j2/IYw+41n9LiorIHOcoWucxIJKS09oF+NTBbrHe6M/uAQu5IfC/9I0lhNENR4B4lV7mOSstoWu/R211ELBeC9IhqQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204376; c=relaxed/simple;
	bh=nhXCHGcq2q53vugpCSjz6dGWmsyrI/RiVmAkjFvBJvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5dS9HMDr0RfB7mS+Zy0RtweAB2HHbwwFY309AV8O0Si4624KF7Jl4vzp+r7don6dPDzsCrBDWLvhtuPrTkAB/hIPtgC2P/evMrz03+oazTpNQEcsgXGue5b/e+trc2YTmMGwc3meyO4MpSl+UctiUzAX2sc6rNOndE2yuNszP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvEVX0Lw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvEVX0Lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8E01F00893;
	Sat, 12 Sep 2026 09:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204375;
	bh=Z53Jciwcax3lqWYFcn/fKoL+serQdNA9ZQxh/4Sc12Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rvEVX0LwcFTIx/zvHqWbiHGEC/bRcWUtAMwCxBU908WH1l++tEHtDvZCzvQE3NnF2
	 GNk3fBl02qq1ANnp1JBOWX7rB96rmDcya/K4U5P+Uk+FdKeBk7Bc7CH8cW+fw4sZOO
	 TkTAi+fP7uq7QGbFQ+05PQC/fl7WX59QhUaaY1OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Yen <Patrick_Yen@asmedia.com.tw>,
	Jian-Ming Liao <Jm_Liao@asmedia.com.tw>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1598/1815] i3c: mipi-i3c-hci: Fix missing STAT_IBI_STATUS_THLD in PIO mode
Date: Sat, 12 Sep 2026 08:55:48 +0200
Message-ID: <20260912065726.504698718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian-Ming Liao <Jm_Liao@asmedia.com.tw>

[ Upstream commit 308ecb824db329a8e22dd0b10f2a3411a6fbbde3 ]

In PIO mode initialization, STAT_IBI_STATUS_THLD was missing from
pio->enabled_irqs. As a result, the host controller interrupt signal for
IBI threshold was never enabled when transfer starts, preventing IBI
status descriptors from being properly processed in PIO mode.

Include STAT_IBI_STATUS_THLD in pio->enabled_irqs so that the IBI
threshold interrupt is activated alongside error interrupts upon the first
transfer.

Fixes: 9ad9a52cce28 ("i3c/master: introduce the mipi-i3c-hci driver")
Co-developed-by: Patrick Yen <Patrick_Yen@asmedia.com.tw>
Signed-off-by: Patrick Yen <Patrick_Yen@asmedia.com.tw>
Signed-off-by: Jian-Ming Liao <Jm_Liao@asmedia.com.tw>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260818104106.763772-2-Jm_Liao@asmedia.com.tw
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/pio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/pio.c b/drivers/i3c/master/mipi-i3c-hci/pio.c
index ff2657ee220ba..a1341d66bc656 100644
--- a/drivers/i3c/master/mipi-i3c-hci/pio.c
+++ b/drivers/i3c/master/mipi-i3c-hci/pio.c
@@ -185,8 +185,11 @@ static void __hci_pio_init(struct i3c_hci *hci, u32 *size_val_ptr)
 	pio_reg_write(INTR_SIGNAL_ENABLE, 0x0);
 	pio_reg_write(INTR_STATUS_ENABLE, 0xffffffff);
 
-	/* Always accept error interrupts (will be activated on first xfer) */
-	pio->enabled_irqs = STAT_ALL_ERRORS;
+	/*
+	 * Always accept error interrupts and IBI threshold interrupt
+	 * (will be activated on first xfer).
+	 */
+	pio->enabled_irqs = STAT_ALL_ERRORS | STAT_IBI_STATUS_THLD;
 }
 
 static void hci_pio_suspend(struct i3c_hci *hci)
-- 
2.53.0



