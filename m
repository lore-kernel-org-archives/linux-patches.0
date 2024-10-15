Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AEE1C07C4;
	Tue, 15 Oct 2024 13:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997284; cv=none; b=B8b2q2GSOF2ZZNh+WESl9kPGvMLRXRdJEu1ZpKyx4sT8wihlJQ4/ho7PDz+LBTNZchYPdw0j/tInTtZlWM8KiFI+txf/Bp1OUt93p7B3tzOXY8vLPJi8RC7yTfvwrVFCW25a1h4aGoe+EHNrKLKDbqH5HPR6MBUjhTsLEcK4Brw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997284; c=relaxed/simple;
	bh=1a8m/mWEeaTlCfvL97KvZ5BgT1szXiIhFlm0HtO85og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoUF/Uzq0QnobIzRiSErDCaaL2W4uuNR2ha7MntQvw3efA/wJrttBLx+FumkX5rZNzEaYN8ArzP0LaJVxgF+wgnjpKi2Y6xQnRFxk/3pVMus35FtdG5gEtSrAA5I6dG/f58LVGoxlQ9mT6CmgS3PsmGTWuAbkjCfakNCs/WMyz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NapMgkV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NapMgkV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DCAC4CEC6;
	Tue, 15 Oct 2024 13:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997284;
	bh=1a8m/mWEeaTlCfvL97KvZ5BgT1szXiIhFlm0HtO85og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NapMgkV25eG4ZMy64e4oshX2TXvld4j75sj+zeeIQ1PilX9O7MG3SMF8lcccQx3yJ
	 R5zoj2RT64Wcid7nyJQTbrARIz6x0Dlv4uFDrDdnfbGvsJYCCiNh4cadronvMr2n60
	 T8GyyccCpkkM8zmd93nLNHRhEvfsNfp14GSlCb5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/518] spi: ppc4xx: Avoid returning 0 when failed to parse and map IRQ
Date: Tue, 15 Oct 2024 14:40:00 +0200
Message-ID: <20241015123920.707285382@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7781f1d120fec8624fc654eda900fc8748262082 ]

0 is incorrect error code when failed to parse and map IRQ.
Replace OF specific old API for IRQ retrieval with a generic
one to fix this issue.

Fixes: 0f245463b01e ("spi: ppc4xx: handle irq_of_parse_and_map() errors")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20240814144525.2648450-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ppc4xx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index bfcfafda3eb1c..6413bcd28913a 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -26,7 +26,6 @@
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
@@ -410,9 +409,10 @@ static int spi_ppc4xx_of_probe(struct platform_device *op)
 	}
 
 	/* Request IRQ */
-	hw->irqnum = irq_of_parse_and_map(np, 0);
-	if (hw->irqnum <= 0)
+	ret = platform_get_irq(op, 0);
+	if (ret < 0)
 		goto free_host;
+	hw->irqnum = ret;
 
 	ret = request_irq(hw->irqnum, spi_ppc4xx_int,
 			  0, "spi_ppc4xx_of", (void *)hw);
-- 
2.43.0



