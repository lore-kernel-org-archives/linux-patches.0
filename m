Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E0B4E66A7;
	Fri,  9 Oct 2026 14:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556990; cv=none; b=Xuxy8LjX3XXW73789M5nYTARAB+iwVc9hhCNXT7E3arNOsekLBPRX2QPShEhMmvKXkz0yK2/cNlR3ury9YUdixtQrVEFjFUf/2u0gI8jqTIWe5s+7EBYa73kTg3/gYvtTl8l5pCGVdIlVafFnTyitsxb9IWNeXJJFPLAb0t+g4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556990; c=relaxed/simple;
	bh=h7IRbNS4jqUJE2akmp3Z+Zfus0RlKEHLV3iDjbWbWL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBUqYe16TfDhf2rJilSNBQGmLPGghiZzFsZd1xsun2h+cLabkO2Q0IQJQPtrJMPhKYbpKvDVRAkKbcrxBmufFxB57mEdkeS86g0PkE78MCgpK/xem1ukwuPfCUuW9Y1G9rjif0tmCPkdJRicBVF9YZuiOUnaFZilAQwI3e3Xp3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqlI6gJa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqlI6gJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247F71F00893;
	Fri,  9 Oct 2026 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556989;
	bh=cZZNe0QVYbidw7PRbRkgA6I+FtdGQlJPyIDZ/3Qsv5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DqlI6gJaIMyXqKZ+mu9AZjB/r0hpsuNzJOgk/2zG6XyqdND8DmPh+fgnSRgFx7//i
	 2wqxZKfCVZI2Fv/dX438yz5BA5ANRjdyo/Ifrx256hoBtalBSNMMO+1dMXhsVvQN6L
	 P7KnZ09cAzdj4ObcWinkAi2n3IcNmQtgLLZsdyTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rounak Das <rounakdas2025@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 7.2 278/428] EDAC/altera: Fix device node reference leaks in the SDMMC ECC setup
Date: Fri,  9 Oct 2026 16:10:15 +0200
Message-ID: <20261009140952.203507251@linuxfoundation.org>
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
@@ -1505,6 +1505,7 @@ static int altr_portb_setup(struct altr_
 	dci = edac_device_alloc_ctl_info(sizeof(*altdev), ecc_name, 1,
 					 ecc_name, 1, 0, edac_idx);
 	if (!dci) {
+		of_node_put(np);
 		edac_printk(KERN_ERR, EDAC_DEVICE,
 			    "%s: Unable to allocate PortB EDAC device\n",
 			    ecc_name);
@@ -1517,6 +1518,7 @@ static int altr_portb_setup(struct altr_
 
 	if (!devres_open_group(device->edac->dev, altr_portb_setup, GFP_KERNEL)) {
 		edac_device_free_ctl_info(dci);
+		of_node_put(np);
 		return -ENOMEM;
 	}
 
@@ -1585,6 +1587,8 @@ static int altr_portb_setup(struct altr_
 		rc = -ENOMEM;
 		goto err_release_group_1;
 	}
+	of_node_put(np);
+
 	altr_create_edacdev_dbgfs(dci, prv);
 
 	list_add(&altdev->next, &altdev->edac->a10_ecc_devices);
@@ -1601,6 +1605,7 @@ err_release_group_1:
 	 */
 	devres_release_group(device->edac->dev, altr_portb_setup);
 	edac_device_free_ctl_info(dci);
+	of_node_put(np);
 	edac_printk(KERN_ERR, EDAC_DEVICE,
 		    "%s:Error setting up EDAC device: %d\n", ecc_name, rc);
 	return rc;
@@ -1628,7 +1633,7 @@ static int socfpga_init_sdmmc_ecc(struct
 		goto exit;
 
 	/* Setup portB */
-	return altr_portb_setup(device);
+	rc = altr_portb_setup(device);
 
 exit:
 	of_node_put(child);


