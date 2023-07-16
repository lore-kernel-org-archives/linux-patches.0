Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CA98F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F95C433C8;
	Sun, 16 Jul 2023 20:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540299;
	bh=/0+TbdQvXaAK8m69OLAsmxCVe/gVFpdNm1uLw9T6Lt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQ2QN7YkV5cS+ThK8YAy/9DRTaYyv+J1kEaFZvP+9JJPgpTeP6g+OaWI82mlHcahg
	 UUa+lJzMqbXDyKzcpoGF8mJ6mE+NBBs+VocxBn6CJ4TyYOaPw6DXK82Q+wPLnrt7R8
	 y7EZg6KA42f551mou1Oco3kolWqRiuPCHdA1ZZOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Jon Derrick <jonathan.derrick@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 286/591] PCI: vmd: Reset VMD config register between soft reboots
Date: Sun, 16 Jul 2023 21:47:05 +0200
Message-ID: <20230716194931.293382533@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit b61cf04c49c3dfa70a0d6725d3eb40bf9b35cf71 ]

VMD driver can disable or enable MSI remapping by changing
VMCONFIG_MSI_REMAP register. This register needs to be set to the
default value during soft reboots. Drives failed to enumerate
when Windows boots after performing a soft reboot from Linux.
Windows doesn't support MSI remapping disable feature and stale
register value hinders Windows VMD driver initialization process.
Adding vmd_shutdown function to make sure to set the VMCONFIG
register to the default value.

Link: https://lore.kernel.org/r/20230224202811.644370-1-nirmal.patel@linux.intel.com
Fixes: ee81ee84f873 ("PCI: vmd: Disable MSI-X remapping when possible")
Signed-off-by: Nirmal Patel <nirmal.patel@linux.intel.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Jon Derrick <jonathan.derrick@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 769eedeb8802a..50a187a29a1d8 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -979,6 +979,13 @@ static void vmd_remove(struct pci_dev *dev)
 	ida_simple_remove(&vmd_instance_ida, vmd->instance);
 }
 
+static void vmd_shutdown(struct pci_dev *dev)
+{
+        struct vmd_dev *vmd = pci_get_drvdata(dev);
+
+        vmd_remove_irq_domain(vmd);
+}
+
 #ifdef CONFIG_PM_SLEEP
 static int vmd_suspend(struct device *dev)
 {
@@ -1056,6 +1063,7 @@ static struct pci_driver vmd_drv = {
 	.id_table	= vmd_ids,
 	.probe		= vmd_probe,
 	.remove		= vmd_remove,
+	.shutdown	= vmd_shutdown,
 	.driver		= {
 		.pm	= &vmd_dev_pm_ops,
 	},
-- 
2.39.2



