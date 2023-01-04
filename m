Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8343CAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:22:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC88C433EF;
	Wed,  4 Jan 2023 16:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849325;
	bh=tpTT5AEq+v0/3j8CsYJZrSMV1OS7xwr1Ck0yGVZL3Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9Pf2J0D13/9nDRYJWt78ytDKCFaU+EjOCEgtnUeqv3PMOqza5iTefS3Us/1Qbjuj
	 ujXnldSs5BU2CufWuajXbDZaQhL1wb+a8cFDlsK7LgyoYsNaz2ODgncWDiT2DEGA0o
	 rEIvWVNXAD3ORz4AKwKWSSA5RhXZl/TMaEhTFdAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.0 103/177] PCI/sysfs: Fix double free in error path
Date: Wed,  4 Jan 2023 17:06:34 +0100
Message-Id: <20230104160510.761340692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sascha Hauer <s.hauer@pengutronix.de>

commit aa382ffa705bea9931ec92b6f3c70e1fdb372195 upstream.

When pci_create_attr() fails, pci_remove_resource_files() is called which
will iterate over the res_attr[_wc] arrays and frees every non NULL entry.
To avoid a double free here set the array entry only after it's clear we
successfully initialized it.

Fixes: b562ec8f74e4 ("PCI: Don't leak memory if sysfs_create_bin_file() fails")
Link: https://lore.kernel.org/r/20221007070735.GX986@pengutronix.de/
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-sysfs.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1174,11 +1174,9 @@ static int pci_create_attr(struct pci_de
 
 	sysfs_bin_attr_init(res_attr);
 	if (write_combine) {
-		pdev->res_attr_wc[num] = res_attr;
 		sprintf(res_attr_name, "resource%d_wc", num);
 		res_attr->mmap = pci_mmap_resource_wc;
 	} else {
-		pdev->res_attr[num] = res_attr;
 		sprintf(res_attr_name, "resource%d", num);
 		if (pci_resource_flags(pdev, num) & IORESOURCE_IO) {
 			res_attr->read = pci_read_resource_io;
@@ -1196,10 +1194,17 @@ static int pci_create_attr(struct pci_de
 	res_attr->size = pci_resource_len(pdev, num);
 	res_attr->private = (void *)(unsigned long)num;
 	retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
-	if (retval)
+	if (retval) {
 		kfree(res_attr);
+		return retval;
+	}
+
+	if (write_combine)
+		pdev->res_attr_wc[num] = res_attr;
+	else
+		pdev->res_attr[num] = res_attr;
 
-	return retval;
+	return 0;
 }
 
 /**


