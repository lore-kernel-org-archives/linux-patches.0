Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0912868AF;
	Tue, 12 Aug 2025 17:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021020; cv=none; b=gn3uCR9404n0j4zpko98JquVPMuLjQHZ31nL0MkhlbSeHQrz/H+6czbRl+ynrI09/XYk1+fLOpMgMmfB8Loy7xJfEEL5LmE2ACDW9UbH5ZF/Tstpg0I9Ot9j5MtbjBORCyQyd1UjJefyEkkq/hOfdip8U4Wz7bIXCCXMBD16Zvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021020; c=relaxed/simple;
	bh=oPwKqfHTRWSVJiIAVkYPGVn4rpQvWlOE2Jmnqv9geYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZxRXq2dsoiCdbNk7GuZCo2svTyalo5xuiUb34iNUhkMRhw5Wpk0MKvFOXDEAGCYJf2W2xQk9u733zJtDxZV5JkA0fZocvFNRQSPqocCHwuwpHdizLnRhSk3F2ws71GtbKwEoF4qX+/j2wqn+MS+V6iYIYyYXN3rssDjgs/GjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SudwwCJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SudwwCJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C42C4CEF0;
	Tue, 12 Aug 2025 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021017;
	bh=oPwKqfHTRWSVJiIAVkYPGVn4rpQvWlOE2Jmnqv9geYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SudwwCJZQzpqCX+n8W5QmcbEjvcX1kGl+1TUZPNuGAgUB8dtT78Lk3Q4l61r0dr4Y
	 8IvwyJsyY63q3HuarmHEM0jHiQqs67U1MgX+QcZJ5VDpHx0ryB8LYhAZ/JNzcmuLwe
	 jF/uy+iBs5ID/OMRqrIFYzoxWsWqzS26zrbFlSg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Lewis <aaronlewis@google.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/253] vfio/pci: Separate SR-IOV VF dev_set
Date: Tue, 12 Aug 2025 19:29:48 +0200
Message-ID: <20250812172957.318626301@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit e908f58b6beb337cbe4481d52c3f5c78167b1aab ]

In the below noted Fixes commit we introduced a reflck mutex to allow
better scaling between devices for open and close.  The reflck was
based on the hot reset granularity, device level for root bus devices
which cannot support hot reset or bus/slot reset otherwise.  Overlooked
in this were SR-IOV VFs, where there's also no bus reset option, but
the default for a non-root-bus, non-slot-based device is bus level
reflck granularity.

The reflck mutex has since become the dev_set mutex (via commit
2cd8b14aaa66 ("vfio/pci: Move to the device set infrastructure")) and
is our defacto serialization for various operations and ioctls.  It
still seems to be the case though that sets of vfio-pci devices really
only need serialization relative to hot resets affecting the entire
set, which is not relevant to SR-IOV VFs.  As described in the Closes
link below, this serialization contributes to startup latency when
multiple VFs sharing the same "bus" are opened concurrently.

Mark the device itself as the basis of the dev_set for SR-IOV VFs.

Reported-by: Aaron Lewis <aaronlewis@google.com>
Closes: https://lore.kernel.org/all/20250626180424.632628-1-aaronlewis@google.com
Tested-by: Aaron Lewis <aaronlewis@google.com>
Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20250626225623.1180952-1-alex.williamson@redhat.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/vfio_pci_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index aa362b434413..13c223228c31 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2144,7 +2144,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		return -EBUSY;
 	}
 
-	if (pci_is_root_bus(pdev->bus)) {
+	if (pci_is_root_bus(pdev->bus) || pdev->is_virtfn) {
 		ret = vfio_assign_device_set(&vdev->vdev, vdev);
 	} else if (!pci_probe_reset_slot(pdev->slot)) {
 		ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);
-- 
2.39.5



