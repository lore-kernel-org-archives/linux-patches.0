Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6852FE59E;
	Tue, 12 Aug 2025 18:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024956; cv=none; b=kewhNOb7a/VfiUSmeHX/ImB4MyOwLjF9UA86t25gopydEjmCysUB4EhYwPUlEU3BF2uE5SD5GqKy3uTTj22X2019wx4HmTrp56Kj0NKNJtzt13VLNjmi84toW6hP90QP8RnpLDmHcEyl7zthETbNoxscvAGtnLa4nj/bVw2HE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024956; c=relaxed/simple;
	bh=FKuBd7ZWw8t7i7QhKoZv3psVLe2AWnxIo1qmv74rcUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3j23x3g9Fxi5V4wQjPEe3SvnJhGduag3tRUvs6j39xlP+yLCS26dwcy/vjtieHYNSr57XMqduXMp2H9TqZOEwOov62/0oAr1ukzkrLiDEiyJYxdhgnfOX0KxYQqEQf74dfHFdR/zBSPG841+2Jxq++ay6mY1kKVBVYVXXPcrTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8p8xdlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8p8xdlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB838C4CEF0;
	Tue, 12 Aug 2025 18:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024956;
	bh=FKuBd7ZWw8t7i7QhKoZv3psVLe2AWnxIo1qmv74rcUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8p8xdlwiVi0yXBEMXuq//8ECiTgEwS3/bumxwpUJS9jQ5BHRDB6UrXwbKQ9XqLHi
	 I9HZq/EaUBMplNGYCfFQlI4b52VOFQuNGEj6pHiPhM35jjozxLo4XZCZa6d1urVUdt
	 z7/GzomNRKzC8Z+6/g5fEeQsbxP0SveOezK4iy1E=
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
Subject: [PATCH 6.16 493/627] vfio/pci: Separate SR-IOV VF dev_set
Date: Tue, 12 Aug 2025 19:33:08 +0200
Message-ID: <20250812173445.694053212@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 6328c3a05bcd..261a6dc5a5fc 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2149,7 +2149,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 		return -EBUSY;
 	}
 
-	if (pci_is_root_bus(pdev->bus)) {
+	if (pci_is_root_bus(pdev->bus) || pdev->is_virtfn) {
 		ret = vfio_assign_device_set(&vdev->vdev, vdev);
 	} else if (!pci_probe_reset_slot(pdev->slot)) {
 		ret = vfio_assign_device_set(&vdev->vdev, pdev->slot);
-- 
2.39.5



