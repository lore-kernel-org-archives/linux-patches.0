Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE3F4E36D6;
	Fri,  9 Oct 2026 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556535; cv=none; b=MoiYcRBRRL/AT+ANCUBi+C1039YciPE6Qh/mEE3U2hWTWCEccnxIciDY/j8062iIBWV5W5RD+OUN5wFpx+nJZXxEISi2vbQsuBeXC1Dy99QOyo9yjfOK9MvHEdkKQTA/zfs7JoovSXanxUyvilt6eUg9XLsCRT8D6wMDwzHuJvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556535; c=relaxed/simple;
	bh=TNC7yiP01nDLBpxQTUdYRAmSKos26N8AJiFKlLxrPcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=snw7dO75J5T191Hcp4oaD2Y0idhXguxnyaWYRLzpfxyPQnZvO5XNeZgSI4bCJgMWXGbV9nD/BeOgzhVuV97hOgGv/SGYh8F1dovjkDdJqe0Ki2t7MjdgZSHE3RnxI9zq/hPJHNdbLdxaSSssCLDTRorW83AO+rFY5Ft1et9Hs4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otjn9fed; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otjn9fed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDC51F00893;
	Fri,  9 Oct 2026 14:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556533;
	bh=W7MYmPgvnYtykJfxt9aJi2E9VJRMDe7FF5E0RCCWCDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otjn9fedgzaqj34D4g3ef+bJqH9imrMRAkSqp9Z+r4pYwL26Pxny3qjKR1Y4WMfSN
	 kMqD/IdtGWQi5Tpf89F5AeiTPamvIOut2/41MbjB/swpi3BP+Rv73RcMugpBuaXrvV
	 FthkshZgT0rJYK6PNIHKAJDPjRH/3A3V3kkkVb6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 251/403] mtd: rawnand: cadence: Initialize IRQ state before requesting IRQ
Date: Fri,  9 Oct 2026 16:10:12 +0200
Message-ID: <20261009140958.039786040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 21f027016b1290d13c30b198ae7a00e6b3d1d5a5 upstream.

The Cadence NAND interrupt handler uses both the IRQ lock and completion
object. Registering the IRQ before initializing them leaves a window in
which a pending interrupt can access uninitialized synchronization state.

Initialize them before registering the handler.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2888,6 +2888,9 @@ static int cadence_nand_init(struct cdns
 		goto free_buf_desc;
 	}
 
+	spin_lock_init(&cdns_ctrl->irq_lock);
+	init_completion(&cdns_ctrl->complete);
+
 	if (devm_request_irq(cdns_ctrl->dev, cdns_ctrl->irq, cadence_nand_isr,
 			     IRQF_SHARED, "cadence-nand-controller",
 			     cdns_ctrl)) {
@@ -2896,9 +2899,6 @@ static int cadence_nand_init(struct cdns
 		goto free_buf;
 	}
 
-	spin_lock_init(&cdns_ctrl->irq_lock);
-	init_completion(&cdns_ctrl->complete);
-
 	ret = cadence_nand_hw_init(cdns_ctrl);
 	if (ret)
 		goto disable_irq;


