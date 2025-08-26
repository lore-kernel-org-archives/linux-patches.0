Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35F630146A;
	Tue, 26 Aug 2025 13:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216800; cv=none; b=JrQ2RLs9OQRL8LQUv1gDa6It+kW9NE4wRSnYyGoTN582UW5cVj8H7fala7Ii7bzYW9+Eidl88Bx4C7Ohu7LQibdvNZoSSWjE3ZGZ9bLgJeMtXqErXIXsEIfAnJ6QtIBcisbqtFSiq4PY0WmPNXukcN+fouhb9EAHOlqKlfyvjl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216800; c=relaxed/simple;
	bh=vRzRD/5Jw6jGqZegq0xDC5T+D/oGDeDF/ixQN1Dgsd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk4zCm6A9UKGykHf9+5H/b1CesJeZ3ksUk6g9BJLaZk1BkMq7+G/KTgR6xdrPDrPUW1NJLF6s8UcsqV3NpoTkxuXCgjYrtXXUr1JQCYlQpY0yy1xgh38SddJiA+PgqX5RWqalr3m+qp70qLeEs6Ys1pvzpY402mnHgcPX0Ieu9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgHQvNOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgHQvNOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71ADAC113D0;
	Tue, 26 Aug 2025 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216799;
	bh=vRzRD/5Jw6jGqZegq0xDC5T+D/oGDeDF/ixQN1Dgsd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgHQvNOIc9OFttaB4G/PrCsuJf3bsZ/u6Yfnvf9vXr9BuEF7gGGxI3GCUHpSN//AU
	 H47CRKgp7brADN3RIXHgwkBgsIyrsjZrPbMqR58yI3mmXhiT8aYmuJdxouZ5artx5L
	 XXvJW2k0sAihGb5P88o5K4Z5Jwu6+GFg0bVZYzak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Artur Piechocki <artur.piechocki@open-e.com>
Subject: [PATCH 5.15 549/644] PCI: vmd: Assign VMD IRQ domain before enumeration
Date: Tue, 26 Aug 2025 13:10:40 +0200
Message-ID: <20250826111000.131625512@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmal Patel <nirmal.patel@linux.intel.com>

commit 886e67100b904cb1b106ed1dfa8a60696aff519a upstream.

During the boot process all the PCI devices are assigned default PCI-MSI
IRQ domain including VMD endpoint devices. If interrupt-remapping is
enabled by IOMMU, the PCI devices except VMD get new INTEL-IR-MSI IRQ
domain. And VMD is supposed to create and assign a separate VMD-MSI IRQ
domain for its child devices in order to support MSI-X remapping
capabilities.

Now when MSI-X remapping in VMD is disabled in order to improve
performance, VMD skips VMD-MSI IRQ domain assignment process to its
child devices. Thus the devices behind VMD get default PCI-MSI IRQ
domain instead of INTEL-IR-MSI IRQ domain when VMD creates root bus and
configures child devices.

As a result host OS fails to boot and DMAR errors were observed when
interrupt remapping was enabled on Intel Icelake CPUs. For instance:

  DMAR: DRHD: handling fault status reg 2
  DMAR: [INTR-REMAP] Request device [0xe2:0x00.0] fault index 0xa00 [fault reason 0x25] Blocked a compatibility format interrupt request

To fix this issue, dev_msi_info struct in dev struct maintains correct
value of IRQ domain. VMD will use this information to assign proper IRQ
domain to its child devices when it doesn't create a separate IRQ domain.

Link: https://lore.kernel.org/r/20220511095707.25403-2-nirmal.patel@linux.intel.com
Signed-off-by: Nirmal Patel <nirmal.patel@linux.intel.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
[ This patch has already been backported to the Ubuntu 5.15 kernel
  and fixes boot issues on Intel platforms with VMD rev 04,
  confirmed on version 5.15.189. ]
Signed-off-by: Artur Piechocki <artur.piechocki@open-e.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/vmd.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -799,6 +799,9 @@ static int vmd_enable_domain(struct vmd_
 	vmd_attach_resources(vmd);
 	if (vmd->irq_domain)
 		dev_set_msi_domain(&vmd->bus->dev, vmd->irq_domain);
+	else
+		dev_set_msi_domain(&vmd->bus->dev,
+				   dev_get_msi_domain(&vmd->dev->dev));
 
 	WARN(sysfs_create_link(&vmd->dev->dev.kobj, &vmd->bus->dev.kobj,
 			       "domain"), "Can't create symlink to domain\n");


