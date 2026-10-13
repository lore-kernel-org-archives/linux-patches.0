Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0296D4A35;
	Tue, 13 Oct 2026 12:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895211; cv=none; b=mU4oyFe8RihFtWrzsPSVoqI7eCG4xVKFy7eA/bQQypbfXTrfu5DVD68fa59/iLWo3vOoNcp76HkuXgPYUbHEdpazcNWBtGJ5rFULnk2af+rIItDOv2br5EqglM2hlTApgzk/F+Q4OtgO9hPC4IeGL6jMlpffw3sRcnMjsG941dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895211; c=relaxed/simple;
	bh=YAjdeoo/O1Jv23SUgdgKHIj1XMdoR8KUr3Xb6f6oWU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUEhEG8f+IxIja9P8FD0ouUXnlcr+7mRddFpC2fKa7ArnMiE3Fsm6yja5MLHeLM9m/y+qwFnmYHt/xE/4mS6n3VzUTK/fjgG8Eyjxf8jln803ZaXVtHediivSu273HEIve0YjgL37rL8bvhCTJl3r1QkkcgzplhJSiyTLNN1W0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXoB41W5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXoB41W5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC931F000FF;
	Tue, 13 Oct 2026 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895209;
	bh=1ZB8ub49+6nWuvrw6fgXP27eONwKiQW1ijoAfl9bvNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXoB41W5k6d4UntoSFbW+VHIbTP7nqSQKV0PXqnDDvEPYsTRshOcTS4Zg92XpsvwA
	 6SyUMDPfye1ALldrwgdhP6nkC0Ezv2q177uGiJPXLtY5LMKiRdSOIds1H4Tf5sxmpa
	 NZo6V6YEMDxthhtuNoJj2EtcvOIt7gMwWfQrLJhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 198/497] mtd: rawnand: cadence: Initialize IRQ state before requesting IRQ
Date: Tue, 13 Oct 2026 13:36:05 +0200
Message-ID: <20261013112912.591974991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


