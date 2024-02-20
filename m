Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357CB152DE4;
	Tue, 20 Feb 2024 21:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464028; cv=none; b=B7nNLUiCCk2ljHsTH5PjOFxaS/4BvwGWZoRsNyq646PgO/90hyQE+JH/49CX6NfltPhDNh8PDYtbRFJXARNPIsviZlFyPxiyUs6WFdAE8oZMAQ3/J/Rth7bHoE4aEaLBN9s2cqQdUfpJy2b98yzdiDpIH5710oGVvThK3ndLp6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464028; c=relaxed/simple;
	bh=7mI/qhrjbesQlCf0jhkbNEFJybg/dtnNsEbHyzOJPDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRfaNe2LocU33cvOdWLHU2i6FCFmFmqDr3XT5u3hFchgTHnhpSkxThBuXYlo+8DszeP5Wb7OL8wev66R7nFwKUbpSKrA6/XAeGm1Dv0wZ5P2T1V2NPAJpVg9zT4lM1WTL1m0+kIWfQ70coV5RqvAQV1qYSlluk5JoRl4bggW83o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jwg7sBw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jwg7sBw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F39C433F1;
	Tue, 20 Feb 2024 21:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464026;
	bh=7mI/qhrjbesQlCf0jhkbNEFJybg/dtnNsEbHyzOJPDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jwg7sBw1EmniY6ALZULdckZ6PNDact/030OiTYFVIqjlMrZlWdQxiSVj4GMmzvwrX
	 mn50eVxhRzXW27yFquGE6mvmZvaTN5k4jDFikL08xMrTOl2TAPvO0cEJRD3XemCur7
	 8CcuwS/6wSDn0ZdcIG6fF0YEBRQSl2Q+8K41/ARY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 6.6 211/331] irqchip/gic-v3-its: Restore quirk probing for ACPI-based systems
Date: Tue, 20 Feb 2024 21:55:27 +0100
Message-ID: <20240220205644.340131079@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 8b02da04ad978827e5ccd675acf170198f747a7a upstream.

While refactoring the way the ITSs are probed, the handling of quirks
applicable to ACPI-based platforms was lost. As a result, systems such as
HIP07 lose their GICv4 functionnality, and some other may even fail to
boot, unless they are configured to boot with DT.

Move the enabling of quirks into its_probe_one(), making it common to all
firmware implementations.

Fixes: 9585a495ac93 ("irqchip/gic-v3-its: Split allocation from initialisation of its_node")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240213101206.2137483-3-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index fec1b58470df..250b4562f308 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5091,6 +5091,8 @@ static int __init its_probe_one(struct its_node *its)
 	u32 ctlr;
 	int err;
 
+	its_enable_quirks(its);
+
 	if (is_v4(its)) {
 		if (!(its->typer & GITS_TYPER_VMOVP)) {
 			err = its_compute_its_list_map(its);
@@ -5442,7 +5444,6 @@ static int __init its_of_probe(struct device_node *node)
 		if (!its)
 			return -ENOMEM;
 
-		its_enable_quirks(its);
 		err = its_probe_one(its);
 		if (err)  {
 			its_node_destroy(its);
-- 
2.43.2



