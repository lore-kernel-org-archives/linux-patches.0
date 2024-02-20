Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB0C612D7;
	Tue, 20 Feb 2024 21:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465218; cv=none; b=t51TZSqpElEYmqnU5cyWYTlpD5S0Ssr/gd2qMWGnx5L4ypFdkhzU8lV1baNrpOCgR22LO2fFYSkaEv/P9tlg8iMYgU0F6Zaq7MKRDX0ExFFjcqubr/Gp3MG4tiSZY9HLtKnNusvUwQn5vhIJYsnxARqFViCMW0j29gDGNUJ2qrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465218; c=relaxed/simple;
	bh=S4SH48UWF0ynNzzGeutNdyxmTZ7JwNGyhaaFauSuQso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2jPhTNoIc5ANx6C2xe6Sz1mv9hLmErJ0yg+BQH2C5XCz4lcng1WdjR+hC7Lb/+vMk2o2n61yimeG0+5EgaLtPjFaPo60/oxOPtImv1x6B3rncGER7LYmtKTrQhHpArxpdtlYYHnoFZryKimO9ZT1ZHRDvOq8+Sag/bp/AavSPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwgMsSQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwgMsSQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F79CC433F1;
	Tue, 20 Feb 2024 21:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465217;
	bh=S4SH48UWF0ynNzzGeutNdyxmTZ7JwNGyhaaFauSuQso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vwgMsSQ2zxTVw6r9lFPHflfoBltcIg+8yDltBsHglQ7C97dHOhi6bbEjOD3ZEjO+m
	 RWFpq6I6BCnj8jcYkfZY3MKQRCGlYZ+caSpuORYzEnHbz6hI6qQoPM6ZblLLKDZJ0M
	 SGtDTlEnpKiQTAvlC5Axki90fBv0fkYsv+M0MlXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 6.7 256/309] irqchip/gic-v3-its: Restore quirk probing for ACPI-based systems
Date: Tue, 20 Feb 2024 21:56:55 +0100
Message-ID: <20240220205641.170264507@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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
 drivers/irqchip/irq-gic-v3-its.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5091,6 +5091,8 @@ static int __init its_probe_one(struct i
 	u32 ctlr;
 	int err;
 
+	its_enable_quirks(its);
+
 	if (is_v4(its)) {
 		if (!(its->typer & GITS_TYPER_VMOVP)) {
 			err = its_compute_its_list_map(its);
@@ -5442,7 +5444,6 @@ static int __init its_of_probe(struct de
 		if (!its)
 			return -ENOMEM;
 
-		its_enable_quirks(its);
 		err = its_probe_one(its);
 		if (err)  {
 			its_node_destroy(its);


