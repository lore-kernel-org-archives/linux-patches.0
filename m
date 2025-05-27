Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73191185E7F;
	Tue, 27 May 2025 17:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366550; cv=none; b=DiXgFJPfWd2q5W4A6/qrcrgzqrN1YygtYJtk60WmRXXae/kDkKxajVN7waH3eY19V/j1RDZbx/HolZC4m6AV8TahLNWXKT8xFMFgtt9iUW08tbI7suBnK+i3Xytwxute0BOkWTohLCnLc/+lBe9MPdeLHLyt5PypJOufwSXn6hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366550; c=relaxed/simple;
	bh=tFTgkB7IPZvDQzirQZ3dL1QhHgXbaTuqJUrVOBpVNUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cXhnVlIALm9iUGjfHYbtM7xtanTfX5lV7/bp02BI/qSVpHAchakYSakQPnUxFocceIUt8wwqGzno3LELPszvrW3aBYU9NEGYR7ISuk4rCFH0BUJslmMmEcORMwIgtIXZE0wzRPnuxhjSJMeJi4QWIKCZf998fth2PBuvFL6qr0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFvCi2ZU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFvCi2ZU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908F7C4CEE9;
	Tue, 27 May 2025 17:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366550;
	bh=tFTgkB7IPZvDQzirQZ3dL1QhHgXbaTuqJUrVOBpVNUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFvCi2ZUGeuwBg+jhJlm1yhZ/0/7x4tyjpDlpyk1nvkUnCcGuwRDe3TMGzJrFBEp9
	 4+AtlwLhgDK/i7VCq+B0czKQm7kiM2TSIpjNbA5t4hXk/FppkcqlkZvNCqEm3AB3qI
	 LiHgUVpUEcJMnU6Q6FvlmirA/BBNtaQNArovt3nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 104/783] PCI: vmd: Disable MSI remapping bypass under Xen
Date: Tue, 27 May 2025 18:18:21 +0200
Message-ID: <20250527162517.378424236@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 94ceec50a2b94..8df064b62a2ff 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -17,6 +17,8 @@
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
 
+#include <xen/xen.h>
+
 #include <asm/irqdomain.h>
 
 #define VMD_CFGBAR	0
@@ -970,6 +972,24 @@ static int vmd_probe(struct pci_dev *dev, const struct pci_device_id *id)
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



