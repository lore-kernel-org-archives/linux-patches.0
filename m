Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DCD157053;
	Mon, 29 Jan 2024 17:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548336; cv=none; b=G2NY5YucSTMhme6Lq9w2c2MFlqE+gj7wmkB00oRXj0aPXqj3U8zzJg0Le+Rp2ysRZzLsxruff83A+P8e6rT0WNFCK4uAQe5T8KSAUQ+hPH67fGaB4ObHCKSUJKIgh8Nzza6BBPojtoBHk3kybornByvZytCfFVLNY4xssdhG7es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548336; c=relaxed/simple;
	bh=0iwIHB0f2rc+w7oyboJfa59V0on82SRquNv5Bkhjeh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed3EX8r4zpQuR0aOEs0q4BT4sJg7qddzA4SRyZrNX79jFOMycKf5U3kM3nsCX6GPGWIsLHws6aKh2+Dy0x1fL4uvnWwEYYig9nQbLsY0Ys5pgPuu6oCfxVIXCa8wtGiqgxq98DhHhKyuQX4mxExKOQqYENMFuXRotDVWXk524Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgRasUGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgRasUGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A865FC43390;
	Mon, 29 Jan 2024 17:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548335;
	bh=0iwIHB0f2rc+w7oyboJfa59V0on82SRquNv5Bkhjeh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgRasUGbLSyTIUesZFOF6Lr2oBM0eLXxc0/CRM7RIccY3k7zBHhJJK8wha41d89sF
	 HXdEGqM7yxeGqz1zEaX9hRjYTgNZCP6+aaMJjPlS8J3PMIWwyntK135BlXGXlMyiYx
	 nZxZiBNDkbal/TqbIoNA0sDugYJcv6cr19kxC8L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 332/346] spi: bcm-qspi: fix SFDP BFPT read by usig mspi read
Date: Mon, 29 Jan 2024 09:06:03 -0800
Message-ID: <20240129170026.242997547@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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



