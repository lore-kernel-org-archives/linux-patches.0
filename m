Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FB63B19BF;
	Sat, 17 Oct 2026 16:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255663; cv=none; b=mxWwpSpYeAqzkVhrVgklIrQoAdyvdEkm76t2ah38wb8OrrOEcjns8+t7G+Oc2VvzlqBQiERZ2PU1BCouAC6aFttpYkP3HpyXTJp4mJ0zHXzsC8D+nscFWLLrpmv5w1En2+meiQutBcSrJ0zW6G06DAG6N/upzxrO8c16041rWAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255663; c=relaxed/simple;
	bh=SzDd9zlxUlZsILXS+/yOGHnHg8XjR62zHdx549B+V+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B5MiYVVCc1YIFMBQEmfjHlAH4E1Ij4BV1OsKgY5UtYvKGeFhAiEz19xu98un/wJ3VsNzjt3K1g4C1lRLvNf+4/WPTA0jTwXLRtyp7/VXrBtFMIx/MyE3czYj1wSw9fGqgruizOaBhn3kl03/+D5FFxb+QzXBMBkZf+TCpG7Evy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+G0SX08; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+G0SX08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCBD1F000C4;
	Sat, 17 Oct 2026 16:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255662;
	bh=NizAS1/a+Chzr5SDGqYet2pcZeJuJQy7NbSobS3e2CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+G0SX08fjIExaOKTVIC4D6qxDU8uOf1PH+rSjEtbVjjo1YN4wF7bNdj/ttNnzbJA
	 NtHmgH0eRpLfnVDD8mjhqXkTzdnQnH/mbQGPjuAQ9tOgJxwk1aJPT8QOBpoZx4vbtv
	 3rWIpGzUnXfmaHRT+5zGvO9UsidPiZHgHTlKYz48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Borislav Petkov <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 851/869] EDAC/igen6: Fix NULL pointer dereference
Date: Sat, 17 Oct 2026 18:01:32 +0200
Message-ID: <20261017160058.682877029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 88efa0de3285be66969b71ec137d9dab1ee19e52 ]

A kernel panic was reported with the following kernel log:

  EDAC igen6: Expected 2 mcs, but only 1 detected.
  BUG: unable to handle page fault for address: 000000000000d570
  ...
  Hardware name: Notebook V54x_6x_TU/V54x_6x_TU, BIOS Dasharo (coreboot+UEFI) v0.9.0 07/17/2024
  RIP: e030:ecclog_handler+0x7e/0xf0 [igen6_edac]
  ...
  igen6_probe+0x2a0/0x343 [igen6_edac]
  ...
  igen6_init+0xc5/0xff0 [igen6_edac]
  ...

This issue occurred because one memory controller was disabled by
the BIOS but the igen6_edac driver still checked all the memory
controllers, including this absent one, to identify the source of
the error. Accessing the null MMIO for the absent memory controller
resulted in the oops above.

Fix this issue by reverting the configuration structure to non-const
and updating the field 'res_cfg->num_imc' to reflect the number of
detected memory controllers.

Fixes: 20e190b1c1fd ("EDAC/igen6: Skip absent memory controllers")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Closes: https://lore.kernel.org/all/aFFN7RlXkaK_loQb@mail-itl/
Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Link: https://lore.kernel.org/r/20250618162307.1523736-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 0cf7f8bde6cac..28a6f9e667218 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -558,7 +558,7 @@ static struct res_config mtl_p_cfg = {
 	.err_addr_to_imc_addr	= adl_err_addr_to_imc_addr,
 };
 
-static const struct pci_device_id igen6_pci_tbl[] = {
+static struct pci_device_id igen6_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, DID_EHL_SKU5), (kernel_ulong_t)&ehl_cfg },
 	{ PCI_VDEVICE(INTEL, DID_EHL_SKU6), (kernel_ulong_t)&ehl_cfg },
 	{ PCI_VDEVICE(INTEL, DID_EHL_SKU7), (kernel_ulong_t)&ehl_cfg },
@@ -1347,9 +1347,11 @@ static int igen6_register_mcis(struct pci_dev *pdev, u64 mchbar)
 		return -ENODEV;
 	}
 
-	if (lmc < res_cfg->num_imc)
+	if (lmc < res_cfg->num_imc) {
 		igen6_printk(KERN_WARNING, "Expected %d mcs, but only %d detected.",
 			     res_cfg->num_imc, lmc);
+		res_cfg->num_imc = lmc;
+	}
 
 	return 0;
 
-- 
2.53.0



