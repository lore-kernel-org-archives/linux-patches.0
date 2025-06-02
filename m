Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D022A1FA;
	Mon,  2 Jun 2025 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876792; cv=none; b=bGc6YYg+SDmrUOEL9w8BvlAfQUSEchqbEz7ZjGSDx6dyLoEqge0UG4w6w3dPY1qriD8L0kkP0Nvscizx3msuXcNTgQ5Gf+xJwpC4yU1Sb24NNd/QxCeKjvjSWy0hgAcc77AaPepfEMOTQHJDNyRjwWRLJKvO6E+gBq/GUCirl84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876792; c=relaxed/simple;
	bh=VMNAUQnqHhZMiNfvV4Rm0jSy4EtgNvG4lbWn8Z4/His=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PXgCalO+1Aeul3IVBzy3Fbu9cvfoXX9zhdDbXZdF8Izk7PtKxH0yt4ksamPdlfIshNcfvt3y81sqgjenWxydPrkZfGSya9DbiPbOyUDkSfYQvAVbejZGfw+qyldXuxiQ934Djln/lI/mlfaJJudQvw/IAavmq8VIpGAPfl3eUFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmQuRIYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmQuRIYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE363C4CEEB;
	Mon,  2 Jun 2025 15:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876792;
	bh=VMNAUQnqHhZMiNfvV4Rm0jSy4EtgNvG4lbWn8Z4/His=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmQuRIYZ5odPjKsT4P5PzIpmHEsPP4wVoj0qr0iX9Z5JzJEUViv13Htq//QT4OGmC
	 nSInnpT5EtpIFmq1HR1TF++eHD544ffo4W+94BpXS5CGYk9DkC1Q7uhHwEygb3wf/7
	 JC22vwnZ7NkhvBncf/40kzUEPtSHnlcIIj46epZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/325] PCI: vmd: Disable MSI remapping bypass under Xen
Date: Mon,  2 Jun 2025 15:45:21 +0200
Message-ID: <20250602134321.583075644@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Pau Monne <roger.pau@citrix.com>

[ Upstream commit 6c4d5aadf5df31ea0ac025980670eee9beaf466b ]

MSI remapping bypass (directly configuring MSI entries for devices on the
VMD bus) won't work under Xen, as Xen is not aware of devices in such bus,
and hence cannot configure the entries using the pIRQ interface in the PV
case, and in the PVH case traps won't be setup for MSI entries for such
devices.

Until Xen is aware of devices in the VMD bus prevent the
VMD_FEAT_CAN_BYPASS_MSI_REMAP capability from being used when running as
any kind of Xen guest.

The MSI remapping bypass is an optional feature of VMD bridges, and hence
when running under Xen it will be masked and devices will be forced to
redirect its interrupts from the VMD bridge.  That mode of operation must
always be supported by VMD bridges and works when Xen is not aware of
devices behind the VMD bridge.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Message-ID: <20250219092059.90850-3-roger.pau@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 09995b6e73bcc..771ff0f6971f9 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -17,6 +17,8 @@
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
 
+#include <xen/xen.h>
+
 #include <asm/irqdomain.h>
 
 #define VMD_CFGBAR	0
@@ -919,6 +921,24 @@ static int vmd_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	struct vmd_dev *vmd;
 	int err;
 
+	if (xen_domain()) {
+		/*
+		 * Xen doesn't have knowledge about devices in the VMD bus
+		 * because the config space of devices behind the VMD bridge is
+		 * not known to Xen, and hence Xen cannot discover or configure
+		 * them in any way.
+		 *
+		 * Bypass of MSI remapping won't work in that case as direct
+		 * write by Linux to the MSI entries won't result in functional
+		 * interrupts, as Xen is the entity that manages the host
+		 * interrupt controller and must configure interrupts.  However
+		 * multiplexing of interrupts by the VMD bridge will work under
+		 * Xen, so force the usage of that mode which must always be
+		 * supported by VMD bridges.
+		 */
+		features &= ~VMD_FEAT_CAN_BYPASS_MSI_REMAP;
+	}
+
 	if (resource_size(&dev->resource[VMD_CFGBAR]) < (1 << 20))
 		return -ENOMEM;
 
-- 
2.39.5



