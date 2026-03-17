Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E411AA7A6;
	Tue, 17 Mar 2026 17:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768085; cv=none; b=Gsplvv34Da3dwuNze3WR8vqRs/BOmO8thDPb1nlYd1w7PBnumFCX38/x/1WmUCX4W50Sp0Zta1rOPsCO9XoDY3hC4MaD72OIh5jCVKEp6cw/h46nNGnqqYWgkVTpz+60kY1/PIbuFHPMPgDGENoLe5VPSEb6AAocTuAKpLoUcaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768085; c=relaxed/simple;
	bh=hMvj3Uc0FRfeX7LUkYBWCGopvnipygVUd7xcFPZ6FyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajm3HohmR/FX8Z44lTJ9vdu8m7mPkoyo+QTcK2uHTQbwMFZwIlsqeXTpn3RAkqW/52bHv17bAHt1yAFppNKKlh4Vqqryx6sHKnHnEl0f2s5UNduroPCVubbFKh19Ui9rHPj35bpSQ653ovjgByCX/+uvCI0E9cZetd+wmcbkr3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yCum2rM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yCum2rM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A892C2BCAF;
	Tue, 17 Mar 2026 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768085;
	bh=hMvj3Uc0FRfeX7LUkYBWCGopvnipygVUd7xcFPZ6FyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yCum2rM5Ea0ZX96LmGj7YfDHXFZemAqehKuKmxYQQrHJRvncGk68N+69C1wplP7S
	 GGXC0VcfmaY4knNRgj8WPKGOTCU4xLmeYyk1M+gicP/a2DG4vz+Qvj5HhDOeYbgqVN
	 1+2GaxGwH4LFIXrTYmDwMmlxzwsb90modxrTv9ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Lytkin <iprintercanon@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 210/333] staging: sm750fb: add missing pci_release_region on error and removal
Date: Tue, 17 Mar 2026 17:33:59 +0100
Message-ID: <20260317163007.152654195@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Artem Lytkin <iprintercanon@gmail.com>

commit 8225489ddb900656cc21573b4e1b00c9181fd777 upstream.

hw_sm750_map() calls pci_request_region() but never releases the
region on error paths or in lynxfb_pci_remove(). This causes a
resource leak that prevents the PCI region from being mapped again
after driver removal or a failed probe. A TODO comment in the code
acknowledges this missing cleanup.

Restructure the error handling in hw_sm750_map() to properly release
the PCI region on ioremap failures, and add pci_release_region() to
lynxfb_pci_remove().

Signed-off-by: Artem Lytkin <iprintercanon@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260216202038.1828-1-iprintercanon@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/sm750fb/sm750.c    |    1 +
 drivers/staging/sm750fb/sm750_hw.c |   22 +++++++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -1118,6 +1118,7 @@ static void lynxfb_pci_remove(struct pci
 
 	iounmap(sm750_dev->pvReg);
 	iounmap(sm750_dev->pvMem);
+	pci_release_region(pdev, 1);
 	kfree(g_settings);
 }
 
--- a/drivers/staging/sm750fb/sm750_hw.c
+++ b/drivers/staging/sm750fb/sm750_hw.c
@@ -36,16 +36,11 @@ int hw_sm750_map(struct sm750_dev *sm750
 
 	pr_info("mmio phyAddr = %lx\n", sm750_dev->vidreg_start);
 
-	/*
-	 * reserve the vidreg space of smi adaptor
-	 * if you do this, you need to add release region code
-	 * in lynxfb_remove, or memory will not be mapped again
-	 * successfully
-	 */
+	/* reserve the vidreg space of smi adaptor */
 	ret = pci_request_region(pdev, 1, "sm750fb");
 	if (ret) {
 		pr_err("Can not request PCI regions.\n");
-		goto exit;
+		return ret;
 	}
 
 	/* now map mmio and vidmem */
@@ -54,7 +49,7 @@ int hw_sm750_map(struct sm750_dev *sm750
 	if (!sm750_dev->pvReg) {
 		pr_err("mmio failed\n");
 		ret = -EFAULT;
-		goto exit;
+		goto err_release_region;
 	}
 	pr_info("mmio virtual addr = %p\n", sm750_dev->pvReg);
 
@@ -79,13 +74,18 @@ int hw_sm750_map(struct sm750_dev *sm750
 	sm750_dev->pvMem =
 		ioremap_wc(sm750_dev->vidmem_start, sm750_dev->vidmem_size);
 	if (!sm750_dev->pvMem) {
-		iounmap(sm750_dev->pvReg);
 		pr_err("Map video memory failed\n");
 		ret = -EFAULT;
-		goto exit;
+		goto err_unmap_reg;
 	}
 	pr_info("video memory vaddr = %p\n", sm750_dev->pvMem);
-exit:
+
+	return 0;
+
+err_unmap_reg:
+	iounmap(sm750_dev->pvReg);
+err_release_region:
+	pci_release_region(pdev, 1);
 	return ret;
 }
 


