Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3067D1E04A6;
	Wed,  6 Nov 2024 12:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897898; cv=none; b=euKjB38L1r3GTpytYaeed1zVsE64aK9QUt8GZawUPP3qGOEM6iLJhdJrCcJ1eBDapRKSgNdIacZH9MHVG3VZo8QAKSwXLgfiWcUips2Q07jMfRzymoj1fl8DMmYCpHnr5XuPgwSa0IRU4oYBO3HMyZbzKxEpm05auQmWguiT27s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897898; c=relaxed/simple;
	bh=TrzHEsEMaxBLisw91Jma+qELbL4Y1TYnVtPIpEkhuvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjGcviuzM/gjxFYn3gxo/EzsTFJea8RuYxPySqjq+LhAAhF8fVpT3MSymy1rqNwWNJ2T88v2k7HlWpaSVQ7K58wDB03EpZw1RDz0s9PbQ3VS25lwcwpmUJOChWSFSo2rJvCz9Nug4/p29rm36jbTmn2DPH+ZQyfFnefP3a3TkuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRIm2dt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRIm2dt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB08CC4CED3;
	Wed,  6 Nov 2024 12:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897898;
	bh=TrzHEsEMaxBLisw91Jma+qELbL4Y1TYnVtPIpEkhuvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRIm2dt1go/2XGhgWuPdBksDPUy/6ISRhpolpRu6II/QjlCugJzrqlq49BsebwNCW
	 d9+3rlUirECGg3teShfvOHedjUKTxNpBvEEl+FpmZq1YlDxhV6ydEiiEM/s0wjAWUf
	 cypmn5WVPJIb2r2F4h1dT6d7St/zXaglsChwhc2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/462] spi: ppc4xx: Avoid returning 0 when failed to parse and map IRQ
Date: Wed,  6 Nov 2024 12:59:09 +0100
Message-ID: <20241106120332.900675333@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9e72ee73c2f61..2b844594a9e6d 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -26,7 +26,6 @@
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
 #include <linux/interrupt.h>
@@ -491,9 +490,10 @@ static int spi_ppc4xx_of_probe(struct platform_device *op)
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



