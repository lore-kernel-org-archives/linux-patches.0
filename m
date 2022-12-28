Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2601C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23E4C433EF;
	Wed, 28 Dec 2022 16:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244073;
	bh=Jjc9H8ByxV5FEEeucXxpjQhNtP17Ff7Lp2ToEYiH7mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+4SvdbYksSWWxmujhJ6prPi50fwrg8SLJu7iufQ5oY8yBtX5yMJzqcIqYA+gTe6q
	 t52N8LAFEtXtYzuoc+ionTSZxCp398QGx3kLAUERsspGT+uj4sJ1elpdNwYtpTVnVg
	 6CL35eqE2/D1Ul3G21r5Gb8nldtSQ/PsTKnFva5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Francisco Munoz <francisco.munoz.ruiz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0605/1146] PCI: vmd: Disable MSI remapping after suspend
Date: Wed, 28 Dec 2022 15:35:44 +0100
Message-Id: <20221228144346.605948535@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nirmal Patel <nirmal.patel@linux.intel.com>

[ Upstream commit d899aa668498c07ff217b666ae9712990306e682 ]

MSI remapping is disabled by VMD driver for Intel's Icelake and
newer systems in order to improve performance by setting
VMCONFIG_MSI_REMAP. By design VMCONFIG_MSI_REMAP register is cleared
by firmware during boot. The same register gets cleared when system
is put in S3 power state. VMD driver needs to set this register again
in order to avoid interrupt issues with devices behind VMD if MSI
remapping was disabled before.

Link: https://lore.kernel.org/r/20221109142652.450998-1-nirmal.patel@linux.intel.com
Fixes: ee81ee84f873 ("PCI: vmd: Disable MSI-X remapping when possible")
Signed-off-by: Nirmal Patel <nirmal.patel@linux.intel.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Francisco Munoz <francisco.munoz.ruiz@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index e06e9f4fc50f..98e0746e681c 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -980,6 +980,11 @@ static int vmd_resume(struct device *dev)
 	struct vmd_dev *vmd = pci_get_drvdata(pdev);
 	int err, i;
 
+       if (vmd->irq_domain)
+               vmd_set_msi_remapping(vmd, true);
+       else
+               vmd_set_msi_remapping(vmd, false);
+
 	for (i = 0; i < vmd->msix_count; i++) {
 		err = devm_request_irq(dev, vmd->irqs[i].virq,
 				       vmd_irq, IRQF_NO_THREAD,
-- 
2.35.1



