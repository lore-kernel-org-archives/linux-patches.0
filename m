Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B177F3815E1;
	Fri,  4 Sep 2026 05:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500141; cv=none; b=cUKHfl5LZa9NhPjOJHRC9BYTaXisVIwVJmw04POac2IstW0p48tZLFL0L4TB3bwXsiBbJpkBj6cRb/xhDE47ddIOyyCIpUbjttEdVgjNIK5GcutkANHnmpe5kUTxi2sYG13UnotCQZOTFsumS1BrHVQd2jZ90cIBT5Oa6+h6sIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500141; c=relaxed/simple;
	bh=6C3Yv5XDFHwg3ps15az4Vd5dujsXtCzZCsOmU3BVWmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSDp6L+4SwMaw/w6e7jRdJQA8r0W4L6/i2plj4raZrVhVbs1vaqMmUPvJhIxOI2O4CR71hDMts/BB+GXHYBxRSj/TIKmHtlzZ8USFMyiBt7H2NEYXqeaEabD+/DYHJZLOqcxZttb01tJdKZlsY5OJjrbjz0Oe+Zua9u0x5yuFik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHqaYWdc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHqaYWdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154BF1F00A3D;
	Fri,  4 Sep 2026 05:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500140;
	bh=OSWaHcuXyG4xRgg0108eP/IOSvFGdExD+qZazQUDDvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HHqaYWdchsq8qCA6qLtz5mY9ThwSYptp9vDsqHYj+hSbtko6ZuiYl9sS2nr2glZOq
	 tSJvKztguCdBSfS/ZUkHA/VSdQvK0tzpUVXJyQd8dfBfApS4CxHBrJgeIezaOL6X0r
	 ZypSGKDogd/ajxY6jxm7wT5M2d/Ftf2Xy+/X6SJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 664/713] i3c: master: adi: initialize the lock before enabling interrupts
Date: Fri,  4 Sep 2026 07:00:32 +0200
Message-ID: <20260904045818.719834024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 8a53f9102a0d3eeb8784999f925028acf339c276 upstream.

adi_i3c_master_probe() requests the IRQ and unmasks REG_IRQ_PENDING_CMDR
before the controller's IBI state, transfer queue list and transfer
queue lock are initialized.  A pending CMDR interrupt can therefore run
adi_i3c_master_irq() and take master->xferqueue.lock before the dynamic
lock has been initialized.

This issue was found by our static analysis tool and then manually
reviewed against the current tree.

The grounded PoC kept the probe ordering and the IRQ path
adi_i3c_master_probe() -> adi_i3c_master_irq() -> xferqueue.lock, with a
pending CMDR interrupt arriving after REG_IRQ_PENDING_CMDR is unmasked.
Lockdep reported:

  INFO: trying to register non-static key.
  you didn't initialize this object before use?
  lock_acquire+0xbb/0x290
  _raw_spin_lock_irqsave+0x36/0x60
  adi_i3c_master_irq+0x32/0x56 [vuln_msv]
  adi_i3c_master_probe+0x5a/0xf47 [vuln_msv]

Initialize the transfer queue and IBI state before requesting and
unmasking the IRQ.

Fixes: a79ac2cdc91d ("i3c: master: Add driver for Analog Devices I3C Controller IP")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260617150138.628578-1-runyu.xiao@seu.edu.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/adi-i3c-master.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/i3c/master/adi-i3c-master.c
+++ b/drivers/i3c/master/adi-i3c-master.c
@@ -964,17 +964,9 @@ static int adi_i3c_master_probe(struct p
 	writel(0x00, master->regs + REG_ENABLE);
 	writel(0x00, master->regs + REG_IRQ_MASK);
 
-	ret = devm_request_irq(&pdev->dev, irq, adi_i3c_master_irq, 0,
-			       dev_name(&pdev->dev), master);
-	if (ret)
-		return ret;
-
 	platform_set_drvdata(pdev, master);
 
 	master->free_rr_slots = GENMASK(ADI_MAX_DEVS, 1);
-
-	writel(REG_IRQ_PENDING_CMDR, master->regs + REG_IRQ_MASK);
-
 	spin_lock_init(&master->ibi.lock);
 	master->ibi.num_slots = 15;
 	master->ibi.slots = devm_kcalloc(&pdev->dev, master->ibi.num_slots,
@@ -986,6 +978,13 @@ static int adi_i3c_master_probe(struct p
 	spin_lock_init(&master->xferqueue.lock);
 	INIT_LIST_HEAD(&master->xferqueue.list);
 
+	ret = devm_request_irq(&pdev->dev, irq, adi_i3c_master_irq, 0,
+			       dev_name(&pdev->dev), master);
+	if (ret)
+		return ret;
+
+	writel(REG_IRQ_PENDING_CMDR, master->regs + REG_IRQ_MASK);
+
 	return i3c_master_register(&master->base, &pdev->dev,
 				   &adi_i3c_master_ops, false);
 }


