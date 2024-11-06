Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CF91DF249;
	Wed,  6 Nov 2024 12:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894915; cv=none; b=Shk81MjA2OglW6tAReMKJtaIqmhN2/fStjISG+XSHWC/dM1TsZGx6lbP+I+fr2tQGGNhp1ly3TmB428Nqo112URYhM9yVR/xPRixD1ZNygdhElC3oeLadByAQUnu9zZHCuBxkTT8OIEalYRLASxcKad4R58y89HXMG85DTUmUvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894915; c=relaxed/simple;
	bh=waeWc/eYmJrXk2FGKZ2fefahSMIE5Ro8A+yfqCSquSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzZTH3rchTaR9369YjjY9hQNiwMc2C7Gl1DDmzbSs282/Bv0p8f2gtkpvy3S+bPsl/JmaXKvWu9EaioyawnGa+TJqIwOZevg+TwDEZLoqMBMvbfMhZngB4LhzjKfIO11PX2gqmzM4ZR0qGf3M/SS+866TY4EaFxtsfnmdtDY6JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqNn63XQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqNn63XQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1645C4CECD;
	Wed,  6 Nov 2024 12:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894915;
	bh=waeWc/eYmJrXk2FGKZ2fefahSMIE5Ro8A+yfqCSquSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqNn63XQCi+7+7mqxWOkZUmziIMV95C0M1ghYgG7Tis2jtI5+l9ijgdEstAcqxQqO
	 uyJsK7iC7I25nGtlL+xw0psayKFIpBZ0hFxbVcBHyLAhBcTWAni5Y3wFJgXmA56AF3
	 +oL9RwU0aubxopvnpqZr4LtCCjXHr6oSV4W3VRhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 041/350] spi: ppc4xx: Avoid returning 0 when failed to parse and map IRQ
Date: Wed,  6 Nov 2024 12:59:29 +0100
Message-ID: <20241106120321.901336399@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8a1290fb4dd9d..7e8fc572f26cc 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -29,7 +29,6 @@
 #include <linux/errno.h>
 #include <linux/wait.h>
 #include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of_gpio.h>
 #include <linux/interrupt.h>
@@ -494,9 +493,10 @@ static int spi_ppc4xx_of_probe(struct platform_device *op)
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



