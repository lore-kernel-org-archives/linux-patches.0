Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE9815218A;
	Tue,  2 Jul 2024 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940330; cv=none; b=jWFukjAVmZBiEojZsdBPxSUU1thumCxwAoFoafoX0Dd1pHb4ImiRDBZaTWDJqdq1WADXS0p/f2GZyyR4GbiT/xFi7ct5RRyFZt/3fqH9c8JQ7X5jAYtNPddWFX6sBh2M2DkGj5X7N0ITzbzW4wIba+HD3wqrDaCZH7Qb6v8BKJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940330; c=relaxed/simple;
	bh=9tT6VqapVe4furzrPnFl05e64zn9C4gyEgZo7ZSfVtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tR2USAXEy1/wOGZfTUe8D64o2blXvuFdtfwH6KmuXcYL1/qtPr06afeVtxreOa/9LPBeMwq8svWKSqOGlA6Px78ghP5haXc3wnUwUO3Wg3stPuIg0aauVW5Ge5wjedE4HTS1Nwz+EdXSPn7AGn++nmAARRSphkVBX8bRzUS7p8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApcQt4iy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApcQt4iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC43C4AF0A;
	Tue,  2 Jul 2024 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940330;
	bh=9tT6VqapVe4furzrPnFl05e64zn9C4gyEgZo7ZSfVtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApcQt4iy1yPwBqz+QZpw3YYMRCgQEzAx+mB5Ir4StSfWUBmzz3r3rf4FkZ6+OyXe7
	 YazV33YwNOejU0rPdhi4//ucxd2OzYrVzXG/Wh+b6jVIEi/Ia/RPZBQeB/GWMJ5/q+
	 XnrXmZ0FHhfd0WfzqiMlc21BqXoBO/yIutGvboMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.9 123/222] mmc: sdhci-pci: Convert PCIBIOS_* return codes to errnos
Date: Tue,  2 Jul 2024 19:02:41 +0200
Message-ID: <20240702170248.671445069@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit ebc4fc34eae8ddfbef49f2bdaced1bf4167ef80d upstream.

jmicron_pmos() and sdhci_pci_probe() use pci_{read,write}_config_byte()
that return PCIBIOS_* codes. The return code is then returned as is by
jmicron_probe() and sdhci_pci_probe(). Similarly, the return code is
also returned as is from jmicron_resume(). Both probe and resume
functions should return normal errnos.

Convert PCIBIOS_* returns code using pcibios_err_to_errno() into normal
errno before returning them the fix these issues.

Fixes: 7582041ff3d4 ("mmc: sdhci-pci: fix simple_return.cocci warnings")
Fixes: 45211e215984 ("sdhci: toggle JMicron PMOS setting")
Cc: stable@vger.kernel.org
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240527132443.14038-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-core.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1326,7 +1326,7 @@ static int jmicron_pmos(struct sdhci_pci
 
 	ret = pci_read_config_byte(chip->pdev, 0xAE, &scratch);
 	if (ret)
-		return ret;
+		goto fail;
 
 	/*
 	 * Turn PMOS on [bit 0], set over current detection to 2.4 V
@@ -1337,7 +1337,10 @@ static int jmicron_pmos(struct sdhci_pci
 	else
 		scratch &= ~0x47;
 
-	return pci_write_config_byte(chip->pdev, 0xAE, scratch);
+	ret = pci_write_config_byte(chip->pdev, 0xAE, scratch);
+
+fail:
+	return pcibios_err_to_errno(ret);
 }
 
 static int jmicron_probe(struct sdhci_pci_chip *chip)
@@ -2202,7 +2205,7 @@ static int sdhci_pci_probe(struct pci_de
 
 	ret = pci_read_config_byte(pdev, PCI_SLOT_INFO, &slots);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 
 	slots = PCI_SLOT_INFO_SLOTS(slots) + 1;
 	dev_dbg(&pdev->dev, "found %d slot(s)\n", slots);
@@ -2211,7 +2214,7 @@ static int sdhci_pci_probe(struct pci_de
 
 	ret = pci_read_config_byte(pdev, PCI_SLOT_INFO, &first_bar);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 
 	first_bar &= PCI_SLOT_INFO_FIRST_BAR_MASK;
 


