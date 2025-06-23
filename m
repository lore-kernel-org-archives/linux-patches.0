Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E02255F59;
	Mon, 23 Jun 2025 13:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685446; cv=none; b=mmQ2AEveOp4NDNCe6HjlpvHCjizS2sZIXyVch1EFilRor4JFces7HNd2/8scIwFgVql12TZD+3Z4RQdeoreBE+EMzIPSQC1bPRbCAKwCr7P384YFYyW2C7h4ejo7itaIzCANktWJuCWgOwed3/17y/TMJJp2IW/lkUZduJTvi5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685446; c=relaxed/simple;
	bh=AfUGZ9sng1clDVGjFqNSID4FbTkget+emqPolUDhfz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwoxbmKKS1B/cg3nIFLbsnpJyPIsxpUGtpZA1+w45U75U73rPILMGnBrs6gh37H7h3lyHPkYZrfmcD66MYoA+tuHQaOLJMqj++kydUjnKMlAk4/CHnAg0u+cUmujSZcdnrx60m9dLUijL7HkuGf6D/VRkm+mfOXgzCPBfRgwu9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFXFWJyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFXFWJyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D976C4CEEA;
	Mon, 23 Jun 2025 13:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685446;
	bh=AfUGZ9sng1clDVGjFqNSID4FbTkget+emqPolUDhfz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFXFWJyuA+3P1mPxi59JvakLUN/5jTiBT5oB5f3+9dh377BMx4Y09V9ralFls5RXq
	 HO/ZZfgr0sx4ms9FvfV/Xtcz5uebtQcubIw7Da7zTvwWlupjJMr/cmtx9QTZkzO8zG
	 M79B1531mRHq4yu/mOoMzI1fM9mf4U8kQMO55NwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gautam Menghani <gautam@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 008/290] powerpc/pseries/msi: Avoid reading PCI device registers in reduced power states
Date: Mon, 23 Jun 2025 15:04:29 +0200
Message-ID: <20250623130627.212896622@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautam Menghani <gautam@linux.ibm.com>

commit 9cc0eafd28c7faef300822992bb08d79cab2a36c upstream.

When a system is being suspended to RAM, the PCI devices are also
suspended and the PPC code ends up calling pseries_msi_compose_msg() and
this triggers the BUG_ON() in __pci_read_msi_msg() because the device at
this point is in reduced power state. In reduced power state, the memory
mapped registers of the PCI device are not accessible.

To replicate the bug:
1. Make sure deep sleep is selected
	# cat /sys/power/mem_sleep
	s2idle [deep]

2. Make sure console is not suspended (so that dmesg logs are visible)
	echo N > /sys/module/printk/parameters/console_suspend

3. Suspend the system
	echo mem > /sys/power/state

To fix this behaviour, read the cached msi message of the device when the
device is not in PCI_D0 power state instead of touching the hardware.

Fixes: a5f3d2c17b07 ("powerpc/pseries/pci: Add MSI domains")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250305090237.294633-1-gautam@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/msi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -519,7 +519,12 @@ static struct msi_domain_info pseries_ms
 
 static void pseries_msi_compose_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	__pci_read_msi_msg(irq_data_get_msi_desc(data), msg);
+	struct pci_dev *dev = msi_desc_to_pci_dev(irq_data_get_msi_desc(data));
+
+	if (dev->current_state == PCI_D0)
+		__pci_read_msi_msg(irq_data_get_msi_desc(data), msg);
+	else
+		get_cached_msi_msg(data->irq, msg);
 }
 
 static struct irq_chip pseries_msi_irq_chip = {


