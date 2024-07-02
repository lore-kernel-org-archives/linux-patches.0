Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB651C006A;
	Tue,  2 Jul 2024 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940658; cv=none; b=GS3rkT6Fe2+VmaR8KPS56UkWBK1ghIJxthCMINQWCAkn51vPGnjXdy4PIH41fjhvldCAxCMlDIWFF9yeV2IoQv98TT/P8eyq8OT8s17CeRqDorKpTBGiC/y2LoKSXUCQaddJOXYSUAN4nT5wez4S5b6IeD/sszDvA3NLLEef8LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940658; c=relaxed/simple;
	bh=gOgq5l+vXErrNiLZA+Hzq7MFwz3PhVb5EVDBHaNRXEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aP2x3e+v58hz6lB+bdi4Q2c5Fa46tz638tHqGc2nsa72F0O4d6BizOGqBglCynujO1Eq5VCp2KruXlNb0F+VAnbuji2qwJ4pijz3muSUlQXeskZdMMHJBN76NZbsLVsas3U2QiC/UuZg5GkEYNKb7RN6nSCWevIplVqLr56D1gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2bRS8Ao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2bRS8Ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C185C4AF11;
	Tue,  2 Jul 2024 17:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940658;
	bh=gOgq5l+vXErrNiLZA+Hzq7MFwz3PhVb5EVDBHaNRXEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2bRS8AoB7ahEQTKXKRuIdq0JARNDW0Ihp6hAXR4i5O5+nSeE7BZYQ69cML0ekPLW
	 PqE7NHwMs7eyf9GGwbmm91XHPNLx8YeyF2uiRPU/TlZ37bda5yn2mqP7cwA8XZggEk
	 VnIkDiOYONOkhpExl+Wk001bt9TEKmi9qXn7lLVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.9 190/222] ata: ahci: Clean up sysfs file on error
Date: Tue,  2 Jul 2024 19:03:48 +0200
Message-ID: <20240702170251.247729919@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit eeb25a09c5e0805d92e4ebd12c4b0ad0df1b0295 upstream.

.probe() (ahci_init_one()) calls sysfs_add_file_to_group(), however,
if probe() fails after this call, we currently never call
sysfs_remove_file_from_group().

(The sysfs_remove_file_from_group() call in .remove() (ahci_remove_one())
does not help, as .remove() is not called on .probe() error.)

Thus, if probe() fails after the sysfs_add_file_to_group() call, the next
time we insmod the module we will get:

sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:04.0/remapped_nvme'
CPU: 11 PID: 954 Comm: modprobe Not tainted 6.10.0-rc5 #43
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-2.fc40 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x5d/0x80
 sysfs_warn_dup.cold+0x17/0x23
 sysfs_add_file_mode_ns+0x11a/0x130
 sysfs_add_file_to_group+0x7e/0xc0
 ahci_init_one+0x31f/0xd40 [ahci]

Fixes: 894fba7f434a ("ata: ahci: Add sysfs attribute to show remapped NVMe device count")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Link: https://lore.kernel.org/r/20240629124210.181537-10-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1975,8 +1975,10 @@ static int ahci_init_one(struct pci_dev
 	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
 
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
-	if (!host)
-		return -ENOMEM;
+	if (!host) {
+		rc = -ENOMEM;
+		goto err_rm_sysfs_file;
+	}
 	host->private_data = hpriv;
 
 	if (ahci_init_msi(pdev, n_ports, hpriv) < 0) {
@@ -2031,11 +2033,11 @@ static int ahci_init_one(struct pci_dev
 	/* initialize adapter */
 	rc = ahci_configure_dma_masks(pdev, hpriv);
 	if (rc)
-		return rc;
+		goto err_rm_sysfs_file;
 
 	rc = ahci_pci_reset_controller(host);
 	if (rc)
-		return rc;
+		goto err_rm_sysfs_file;
 
 	ahci_pci_init_controller(host);
 	ahci_pci_print_info(host);
@@ -2044,10 +2046,15 @@ static int ahci_init_one(struct pci_dev
 
 	rc = ahci_host_activate(host, &ahci_sht);
 	if (rc)
-		return rc;
+		goto err_rm_sysfs_file;
 
 	pm_runtime_put_noidle(&pdev->dev);
 	return 0;
+
+err_rm_sysfs_file:
+	sysfs_remove_file_from_group(&pdev->dev.kobj,
+				     &dev_attr_remapped_nvme.attr, NULL);
+	return rc;
 }
 
 static void ahci_shutdown_one(struct pci_dev *pdev)


