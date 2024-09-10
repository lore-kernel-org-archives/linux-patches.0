Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5591885A6;
	Tue, 10 Sep 2024 09:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961309; cv=none; b=Y5etes0haM6zb4twggCV755F+SI1QxrJQYwfX3lC+4fUgGmoyidtsiZsfv9siZMdCdWUciYtz2LJk1vn1ddt1h85cKUVVJ3AmAMwGaXW+pCSYuQ1onR/5z4TPHHUPB1NKJWIMt1JuoIG1b/K1kZVhz985ADiz387ultofXONs3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961309; c=relaxed/simple;
	bh=lqj3Ws0XVfiIaeKYA77focjmd/UbH6YuVqCL/xbG9Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIgzSiAM1a+8dXPxngK5KCMyX73/O5qjyvd/ZM4+E5l3xBeAUgEexU2qxuPgN0WpiwqdsM7PMPfqrUFwC8qbXSDJXXaaBQRQQvCRD3YQdaLNQjfPXGtzFa3Ft0IM4bnTh80jbVmOb6dbXc/uX4YviEyLKp5wZWIZ2dAiBQkwCVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4RBb0nJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4RBb0nJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF30C4CEC3;
	Tue, 10 Sep 2024 09:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961309;
	bh=lqj3Ws0XVfiIaeKYA77focjmd/UbH6YuVqCL/xbG9Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4RBb0nJPn9O7R/d0EUkfrKJFPKSE6gTlsuol8nWjOXNYQWCT74VLG5dqwvII6Cye
	 qQW0cUpYl797pok7f3bkkfnv/8M9f6od0sbN8CZ0nBjcUpUHf5bNGYmQu6s1r6F6KA
	 VtgRhdeyxIQ09/X5FFHAA7ST08xpC4JjJtT75+/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH 6.10 027/375] irqchip/riscv-aplic: Fix an IS_ERR() vs NULL bug in probe()
Date: Tue, 10 Sep 2024 11:27:04 +0200
Message-ID: <20240910092623.167700364@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit efe81b7bdf7d882d0ce3d183f1571321046da8f1 upstream.

The devm_platform_ioremap_resource() function doesn't return NULL, it
returns error pointers.  Fix the error handling to match.

Fixes: 2333df5ae51e ("irqchip: Add RISC-V advanced PLIC driver for direct-mode")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/a5a628d6-81d8-4933-81a8-64aad4743ec4@stanley.mountain
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-riscv-aplic-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-aplic-main.c b/drivers/irqchip/irq-riscv-aplic-main.c
index 28dd175b5764..981fad6fb8f7 100644
--- a/drivers/irqchip/irq-riscv-aplic-main.c
+++ b/drivers/irqchip/irq-riscv-aplic-main.c
@@ -175,9 +175,9 @@ static int aplic_probe(struct platform_device *pdev)
 
 	/* Map the MMIO registers */
 	regs = devm_platform_ioremap_resource(pdev, 0);
-	if (!regs) {
+	if (IS_ERR(regs)) {
 		dev_err(dev, "failed map MMIO registers\n");
-		return -ENOMEM;
+		return PTR_ERR(regs);
 	}
 
 	/*
-- 
2.46.0



