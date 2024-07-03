Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0445316DEAC;
	Wed,  3 Jul 2024 11:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005052; cv=none; b=Fw4ha640TWfvvXmcl4Z9de0STXUK7iKRj79O0kSTWZYF+fTo8WhlWQ9jeUA5fAxBomPn6OaZzDSXfAdLqI4YRzIOOsr6EI/97bLBRC7ri1Rjrx83TTx3ioKxEBk3ikLHgQck1oCa0Kymc6ap1ZvJELyjCz6TabEG3v3IdU4Edn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005052; c=relaxed/simple;
	bh=UJ+wiOksZUp6tNDCjRssM3ZpN3kAluKxAKRb+JRoWbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqmCw+Xwozz8T//vzHQ052dVYLpHXAzJ11SKlMORUgzbwWUwB4GL/lkPIXGq9SvHCme3hfDAqCI9DuLrZzrIJm13cEcmwnXl7I7+yiE2B/KMrRQo0xRWRvI/N1SBBTks6igt5wGd14gS62Pr47LVz8CkAT0dlhWh4N+FP5IGIcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deWAeEQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deWAeEQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775DCC2BD10;
	Wed,  3 Jul 2024 11:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005051;
	bh=UJ+wiOksZUp6tNDCjRssM3ZpN3kAluKxAKRb+JRoWbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deWAeEQN32/QLbGGc0zTdiKmEz1OhFlXkAPL28uL2ImUzTuWgHI4Mm1R6Kf8bJbfS
	 GHhsiiq/21JeeTXE0MMRswGV+sO/OKDfOPm1C1gMoVmM3HGlSKS8i9aeyAf5nFPuBx
	 0hSODsI88eZxhThfzbcAYctOb2YPl69q1TB9xSvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 244/290] mmc: sdhci-pci: Convert PCIBIOS_* return codes to errnos
Date: Wed,  3 Jul 2024 12:40:25 +0200
Message-ID: <20240703102913.369061724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1380,7 +1380,7 @@ static int jmicron_pmos(struct sdhci_pci
 
 	ret = pci_read_config_byte(chip->pdev, 0xAE, &scratch);
 	if (ret)
-		return ret;
+		goto fail;
 
 	/*
 	 * Turn PMOS on [bit 0], set over current detection to 2.4 V
@@ -1391,7 +1391,10 @@ static int jmicron_pmos(struct sdhci_pci
 	else
 		scratch &= ~0x47;
 
-	return pci_write_config_byte(chip->pdev, 0xAE, scratch);
+	ret = pci_write_config_byte(chip->pdev, 0xAE, scratch);
+
+fail:
+	return pcibios_err_to_errno(ret);
 }
 
 static int jmicron_probe(struct sdhci_pci_chip *chip)
@@ -2308,7 +2311,7 @@ static int sdhci_pci_probe(struct pci_de
 
 	ret = pci_read_config_byte(pdev, PCI_SLOT_INFO, &slots);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 
 	slots = PCI_SLOT_INFO_SLOTS(slots) + 1;
 	dev_dbg(&pdev->dev, "found %d slot(s)\n", slots);
@@ -2317,7 +2320,7 @@ static int sdhci_pci_probe(struct pci_de
 
 	ret = pci_read_config_byte(pdev, PCI_SLOT_INFO, &first_bar);
 	if (ret)
-		return ret;
+		return pcibios_err_to_errno(ret);
 
 	first_bar &= PCI_SLOT_INFO_FIRST_BAR_MASK;
 


