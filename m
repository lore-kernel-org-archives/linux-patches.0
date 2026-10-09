Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596691A682B;
	Fri,  9 Oct 2026 14:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556367; cv=none; b=oJssBUhUZiATC4G1a7t3UTGK+h8jSxRCuq4RH613abYfyY4vYS0GFKdSTDQDH80e5KLYrZQ2QyPkFabOV3dTgU7vIVnmlQaUNPArswoWDyPcLFYyVU6V6k4VKCKyQD6wFHSnGepDklWwLgNyqJ7nSfh5oNBuolMNF4YK66fA8go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556367; c=relaxed/simple;
	bh=ZAe6ii9XHhwuJFuHMEUhQB/4dA2FfQGXRv84PeLi4P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDs+YbHhLPnVQtHb3vlGumPn/xztLSLyo52ixhXEM6gEJxq/uL6zg0T2nHl3Fsb62Dfmlvi7Vj4JYeVp1n2E5nQa8Kw+AHnbtXN6KeNcvIpleqxCU4NAV3KgrpDRUZjJB1jC1Jiqg9TiTtN/BQc9Av+FxV2mcuKCNRxsbr/SLxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HC7rz8lC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HC7rz8lC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1831F000FF;
	Fri,  9 Oct 2026 14:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556366;
	bh=u/N0w9NC9u7X6zZmfM7qpVz4IHAsjyXRRvv0GEtm1YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HC7rz8lCJgxlSJtVG4tQTVNp3dq5atobwTnvLlirtCmyhupu2VI5fuPBeOgkxh/zH
	 3xYGgGzctpGQcHkzqIHIPNViNkRTH0la6WrCcYHF1eBE+KLcnOIIxyyk5oR+P9OpwO
	 otG9jhzzZQSnNgHuuAYDi8LIjC16p3+tyRdlqEk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rounak Das <rounakdas2025@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 6.18 222/403] EDAC/altera: Fix device node reference leaks in the SDMMC ECC setup
Date: Fri,  9 Oct 2026 16:09:43 +0200
Message-ID: <20261009140957.337919423@linuxfoundation.org>
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

From: Rounak Das <rounakdas2025@gmail.com>

commit 7d5a36a5490d496e17823085fbe7ec6c0a7bf43d upstream.

Under altr_portb_setup() and socfpga_init_sdmmc_ecc(),
of_find_compatible_node() was being used to look up the sdmmc-ecc
node. This node wasn't being dropped using of_node_put().

altr_portb_setup() did not drop its reference under its success path
or on any error path.

socfpga_init_sdmmc_ecc() did an early return thereby skipping the
common exit label and thus leaking the reference.

Add the missing of_node_put() calls in altr_portb_setup(), and route
socfpga_init_sdmmc_ecc()'s success path through the common exit label.

Fixes: 911049845d70 ("EDAC, altera: Add Arria10 SD-MMC EDAC support")
Fixes: 788586efd116 ("EDAC/altera: Initialize peripheral FIFOs in probe()")
Closes: https://sashiko.dev/#/patchset/20260708091135.94114-1-rounakdas2025%40gmail.com
Signed-off-by: Rounak Das <rounakdas2025@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Cc: stable@vger.kernel.org # 6.18+
Link: https://patch.msgid.link/20260926120846.35716-1-rounakdas2025@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -1506,6 +1506,7 @@ static int altr_portb_setup(struct altr_
 	dci = edac_device_alloc_ctl_info(sizeof(*altdev), ecc_name, 1,
 					 ecc_name, 1, 0, edac_idx);
 	if (!dci) {
+		of_node_put(np);
 		edac_printk(KERN_ERR, EDAC_DEVICE,
 			    "%s: Unable to allocate PortB EDAC device\n",
 			    ecc_name);
@@ -1518,6 +1519,7 @@ static int altr_portb_setup(struct altr_
 
 	if (!devres_open_group(device->edac->dev, altr_portb_setup, GFP_KERNEL)) {
 		edac_device_free_ctl_info(dci);
+		of_node_put(np);
 		return -ENOMEM;
 	}
 
@@ -1584,6 +1586,8 @@ static int altr_portb_setup(struct altr_
 		rc = -ENOMEM;
 		goto err_release_group_1;
 	}
+	of_node_put(np);
+
 	altr_create_edacdev_dbgfs(dci, prv);
 
 	list_add(&altdev->next, &altdev->edac->a10_ecc_devices);
@@ -1600,6 +1604,7 @@ err_release_group_1:
 	 */
 	devres_release_group(device->edac->dev, altr_portb_setup);
 	edac_device_free_ctl_info(dci);
+	of_node_put(np);
 	edac_printk(KERN_ERR, EDAC_DEVICE,
 		    "%s:Error setting up EDAC device: %d\n", ecc_name, rc);
 	return rc;
@@ -1627,7 +1632,7 @@ static int socfpga_init_sdmmc_ecc(struct
 		goto exit;
 
 	/* Setup portB */
-	return altr_portb_setup(device);
+	rc = altr_portb_setup(device);
 
 exit:
 	of_node_put(child);


