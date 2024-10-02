Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E501D0488;
	Wed,  2 Oct 2024 14:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879385; cv=none; b=hOYUluIzkw0dpo8H+KSGEddZPirrSPk2q7gIBU7gbjilvL/MkdiASm85nxDoLlTGv6cwEDMDGW/gsfhmlfS4BdGeW6wNmRIFhn7NTOVCDMSUxu2aDRpOPBIqD351mfr9EWzqnsqzaoXVZ1RaHJe3TGHqiWMIt1Ypuj+zpCfLt7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879385; c=relaxed/simple;
	bh=t44MCUISRYo7DW060qDAJmlY71tO36twyrf4EEhCT+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhOOpR2jNhfU59uk5oUYGwzMmK455v7YsdJ7GeRMRAYb4T4yMkAAljyej8fwRu0pEVy4uU/4xF2vqdrXoRG3pql1lTAhJ2+m4S9Mkpt2ffXOCyxKftSYBml2pi4lcfPVoVKCso+KycoVQ3HGiG1QDVy8eBPLRwSUGn0yUgCYQrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muuHZvix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muuHZvix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C48C4CEC2;
	Wed,  2 Oct 2024 14:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879384;
	bh=t44MCUISRYo7DW060qDAJmlY71tO36twyrf4EEhCT+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=muuHZvixK5pKL+O75D7y56kSqEMcp8aq9H0g3wJvqYpoMNBd36qwH5X1zBw21n0by
	 8QYtg1/xjeN3rHTii7lf6E/s2x22yUv2ep1a+Ds7qYq4wKNNGGX+zVryOpYMvvg0Ny
	 8WOIoKkEWE1Ie37Nre3b2pgg/ySXOtCrhP0ud01U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/538] spi: ppc4xx: Avoid returning 0 when failed to parse and map IRQ
Date: Wed,  2 Oct 2024 14:55:32 +0200
Message-ID: <20241002125755.900912560@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 0d698580194e9..1381563941fe3 100644
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



