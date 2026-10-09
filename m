Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0DF4EC64D;
	Fri,  9 Oct 2026 14:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557155; cv=none; b=XhtBa8FUJJFjz5zrieprN2HdFTIPNM0xN0GGMpsCHWHrZrL7LZuVkNXwcJXuDM5a9z/DGt1P3UMjgolpFB9a3hPMCjeBIIC/7wpXWGNXteyyLK2Fyq1ooN6hJhpWXcY3h5TkOjJjO0O30byAAd8+/bQAWGmRyrG4ggwfioXMcgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557155; c=relaxed/simple;
	bh=pI+njXCIETxLKvQItQw3dGTjfbDuO/foiaRs4rc+Fxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VDaKTwD/i7GEL7lfRU10P2A60p7RFlEvO+ZWQi4dQC5S14zDI9VWpy2iTq44t+Dzps71SHPhY7tsgJ3oCL7Py9AS8BGU2xLlRdGip1Fpl5uTJoGyQnSxiUjNWulXVDjQLNfCekqiAOkUD7CL6/kSCP2ddQf3NeJ4NOMaEaNRMWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t97Lkm9R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t97Lkm9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13101F000FF;
	Fri,  9 Oct 2026 14:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557153;
	bh=NisLsiy0A4TlZ8wejtv0vQfgahzSsK9oDPvfr2awCEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t97Lkm9RbnhHP2S4b4uppbx2vWyZWLyxCevyRX5sA6Eex292VuCCwEHGhcBBOBVGK
	 EvHAYbUb/QMXV817Zd8PGtOwKhcZrTTWDvIQerKQcYJI6JbvyCqsAlUV71xzvbLE4f
	 amcKLN1QNe4K62vOXVUjTbxeEzY9snYYBR0akbp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.2 304/428] mtd: rawnand: cadence: Initialize IRQ state before requesting IRQ
Date: Fri,  9 Oct 2026 16:10:41 +0200
Message-ID: <20261009140952.794415962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
@@ -3143,6 +3143,9 @@ static int cadence_nand_init(struct cdns
 		goto free_buf_desc;
 	}
 
+	spin_lock_init(&cdns_ctrl->irq_lock);
+	init_completion(&cdns_ctrl->complete);
+
 	if (devm_request_irq(cdns_ctrl->dev, cdns_ctrl->irq, cadence_nand_isr,
 			     IRQF_SHARED, "cadence-nand-controller",
 			     cdns_ctrl)) {
@@ -3151,9 +3154,6 @@ static int cadence_nand_init(struct cdns
 		goto free_buf;
 	}
 
-	spin_lock_init(&cdns_ctrl->irq_lock);
-	init_completion(&cdns_ctrl->complete);
-
 	ret = cadence_nand_hw_init(cdns_ctrl);
 	if (ret)
 		goto disable_irq;


