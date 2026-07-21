Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F3D36DA1D;
	Tue, 21 Jul 2026 21:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668204; cv=none; b=nYQPEZIvVjH/NL2OD+e0BJNB7/wqi3WVIz6XlDyLtfr7NgxXY5OSgRY2e35iAXkYUhzLCeJRw5JFL84hWVp3MBWxDJAD2D+itw2AFXUEChAYUsKJIjCjoJXUalrXLlriEH4eW0GJ5zu/UfYA/E1TcPtydmVBjNUbr/dhWffRSG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668204; c=relaxed/simple;
	bh=IQddlqL58DksUzY0460BEFIZqWUa2yB4BNjqxMd/mdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnweDvNAsHaHILEDbrHtiPmHWBV8pJYzRovpKJsIi9WVSkO5vGyKbFdtJ2dHxulCDx9mScgatsFvqGuSvY6XcEImdf483hyIK1lge05gA7knZiKTFbD/RACCveoiehruExdIKOI/h0BGkDebQMdablPV7TbWCYy2gwZVlRvfVfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWSbxy0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWSbxy0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41E81F000E9;
	Tue, 21 Jul 2026 21:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668203;
	bh=OqCauWU/hXc0aPe1g7XxYB0ER3KEfXYynfWj+aSwUfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWSbxy0t+svyygYCJzPdHjM4l6otLQaFwGHZm29dd0ifEMFr2SqS+D1WBEYlnmuP2
	 rcTIaiBvX0ENdGTKzYad0wP87qSkqV8gtHObv0ncYhUuC2a5WrC6VjJRx5MIolO/WW
	 hpUIAH9B6g9F8hzhJraQHcz/SO4JBWWFXmwWy/L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Williamson <alex.williamson@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.1 0086/1067] vfio/pci: Release the VGA arbiter client on register_device() failure
Date: Tue, 21 Jul 2026 17:11:27 +0200
Message-ID: <20260721152426.499304131@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@nvidia.com>

commit daedde7f024ecf88bc8e832ed40cf2c795f0796a upstream.

The re-order in the Fixes commit below displaced vfio_pci_vga_init() as
the last failure point of what is now vfio_pci_core_register_device()
without introducing an unwind for the VGA arbiter registration.

In current kernels this is mostly benign because vfio_pci_set_decode()
only uses pci_dev state, but the original failure path could leave a
callback with a freed vdev cookie.  The stale registration also becomes
unsafe again once the callback follows drvdata to the vfio device.

Add the required VGA unwind callout.

Fixes: 4aeec3984ddc ("vfio/pci: Re-order vfio_pci_probe()")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Alex Williamson <alex.williamson@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260615191241.688297-3-alex.williamson@nvidia.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/vfio_pci_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2193,6 +2193,7 @@ out_power:
 		pm_runtime_get_noresume(dev);
 
 	pm_runtime_forbid(dev);
+	vfio_pci_vga_uninit(vdev);
 out_vf:
 	vfio_pci_vf_uninit(vdev);
 	return ret;


