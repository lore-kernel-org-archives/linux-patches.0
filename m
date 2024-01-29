Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15BC7157E6D;
	Mon, 29 Jan 2024 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548642; cv=none; b=aOP0EaBscOb5GvtjweOuWg/rYuRd/9FbVibfZQDSvSmqWUdzqPc0WZxhhlVDVPBamQ/VI6OpvW06Ss9/8BCJa4I1oLbZVRclVKUfOvck8s3G75SJ4vqDVcsUgfAb5Eu0L15dzFVzMG+mseegbZqe/Zeer3ps2cu2/9YVZs1cgng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548642; c=relaxed/simple;
	bh=jm8wAoEuzoOzDNcTEbxURuzBNPl+2CfNh2xU8v0Afns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i54f7pnXTpuwzEhco67v7VU2gCTamtvlygKLjVEEgdWt5tk5wAnUJhxfmnBDQyiJnz5pFF923RQswTRDdiRjstccr4lhwu6ShrPnuRB8Oi6Q5ZY1OnORzK6C0DK3BgtdhL6rq4Hf7Cb7Y6sJwBsAI6rw2VTbkIbj0PBWMIL2MlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Uk2FlY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Uk2FlY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECF2C43390;
	Mon, 29 Jan 2024 17:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548641;
	bh=jm8wAoEuzoOzDNcTEbxURuzBNPl+2CfNh2xU8v0Afns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Uk2FlY8pKHE6JYHbV2gdByoYNgtcoGuh0Ula39M4UtAnlBNC7qC6KqlBtCKk8prG
	 TtBM1S8ZFr5mCPBgB/7FhZLi79ajWotAaFteFfE+rXKBX5jrwLb+6lQn/X5Jf83ksM
	 GofpmUC3y5Mwh9/OtzHSUYnTvZkbVjCTyotFkrWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 318/331] spi: bcm-qspi: fix SFDP BFPT read by usig mspi read
Date: Mon, 29 Jan 2024 09:06:22 -0800
Message-ID: <20240129170024.189702384@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Dasu <kamal.dasu@broadcom.com>

[ Upstream commit 574bf7bbe83794a902679846770f75a9b7f28176 ]

SFDP read shall use the mspi reads when using the bcm_qspi_exec_mem_op()
call. This fixes SFDP parameter page read failures seen with parts that
now use SFDP protocol to read the basic flash parameter table.

Fixes: 5f195ee7d830 ("spi: bcm-qspi: Implement the spi_mem interface")
Signed-off-by: Kamal Dasu <kamal.dasu@broadcom.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://msgid.link/r/20240109210033.43249-1-kamal.dasu@broadcom.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index ef08fcac2f6d..0407b91183ca 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -19,7 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/spi/spi.h>
-#include <linux/spi/spi-mem.h>
+#include <linux/mtd/spi-nor.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
 #include "spi-bcm-qspi.h"
@@ -1221,7 +1221,7 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 
 	/* non-aligned and very short transfers are handled by MSPI */
 	if (!IS_ALIGNED((uintptr_t)addr, 4) || !IS_ALIGNED((uintptr_t)buf, 4) ||
-	    len < 4)
+	    len < 4 || op->cmd.opcode == SPINOR_OP_RDSFDP)
 		mspi_read = true;
 
 	if (!has_bspi(qspi) || mspi_read)
-- 
2.43.0



