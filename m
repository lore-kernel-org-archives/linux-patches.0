Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018015;
	b=Aq2k+cY2bMJVtyT1aA0LNf2KinaAHOxpGv2oW+DjnWNN0SwswWVuA/mGwOpTftktpQrS
	 BSDlkkEb51KWnZbh2HcYtRslS9hvp4QIFmZcVGO+BENWvfgRJPrPh60pc5atQFiqsFRQZ
	 JcOxytgZawRmiPfRmQXw/s9cJ+KPzuGDWnkPr1u4OvfTl3dkwi86cpGCZ+PiOZw5zicY+
	 kr03IikMeHB4oaE+3zeybIV+ArAChNyF5Lt+miNvcoS1NjuxGN1QPR+qdonO90bqHExw1
	 MDseq+FRNLnPXoAfw6JUtUMYQrVF6idRRopk7EmNcoC0KLTCImA/v42aS0Txz9Zzk/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x5yb6iyepMOHWfxa7+lcqM+IfsrMqFSrSxXjknpU89g=;
	b=cjS6FMh5wC83JUHAmU96bPG/1Y4cRslqRIZO31q14/rZAUczK9nWsd1Nasto7oDGJecg
	 cfR2uEosgFSO9PES9bfTXqN+c3zvI8QXiilzrrt9DTTNCjOOOayXs0b6EVc1l37pzYMZ5
	 NtEL6XSuySh5ksSngGJLjIxadV400N0642p+Rfz0BOyCnGlNcK+cHSgx3HvlB5ap+MHtY
	 Qotc/vWegSDx+SALyHg90GKCuh3ESrAvDqPKrSRcb+DAtY2du5EomurCVJovKZAWlHSEc
	 VwKBVhpVpMNqzg+YDy3ne1R6T7lxi/IyzF2+goGamc/bTLzZWuweQF8wftmPiYCbZgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ecr58V3X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CD2606A320;
	Wed, 18 Nov 2026 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ecr58V3X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A5D1F000C4;
	Wed, 18 Nov 2026 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018015;
	bh=x5yb6iyepMOHWfxa7+lcqM+IfsrMqFSrSxXjknpU89g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ecr58V3XX3WTE8uNvnRheuctYMf2eHPAWmbrk2y+4obDHK2Nbr0KwpAR+Hp5rHDw5
	 wt30OdZypHVDrhQ9MaOJCeHBNVtooPQgHokei13RLyL+ZseVc/Y7Xkz50ofQfoROJ+
	 2m38ZGfc/Wb7PMWfn+HL0bUqTaMI29J0OC0IfQZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1049/2651] vfio/fsl-mc: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:38:09 +0100
Message-ID: <20261118150325.733539275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdifatah Suruur <suruurism@gmail.com>

[ Upstream commit 25fd8b27ee8d4f59cc2ad99cf67aef4570b82096 ]

vfio_fsl_mc_mmap() rejects writable mappings of regions without the
WRITE flag, but leaves VM_MAYWRITE set.  Userspace can map such a region
read-only and then upgrade the mapping to writable with mprotect().

Clear VM_MAYWRITE for regions without the WRITE flag, as i915 does for
its read-only objects and as fixed in drm/vc4 (CVE-2026-68445),
drm/panthor (CVE-2024-53071) and commit a5edadbae57e ("ptp: vmclock:
prevent read-only mappings from becoming writable").

Note this is defensive hardening: the fsl-mc bus publishes all device
regions with the WRITE flag set, so no device can currently reach the
read-only path.  The guard costs nothing and keeps the mmap() interface
honest if a read-only region ever appears.

Fixes: 67247289688d4 ("vfio/fsl-mc: Allow userspace to MMAP fsl-mc device MMIO regions")
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Link: https://lore.kernel.org/r/20260929094848.7439-3-suruurism@gmail.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index b4c3958201b25..5a6cd78dcc06a 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -403,9 +403,13 @@ static int vfio_fsl_mc_mmap(struct vfio_device *core_vdev,
 			&& (vma->vm_flags & VM_READ))
 		return -EINVAL;
 
-	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)
-			&& (vma->vm_flags & VM_WRITE))
-		return -EINVAL;
+	/* Prevent read-only region mappings from being upgraded with mprotect() */
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)) {
+		if (vma->vm_flags & VM_WRITE)
+			return -EINVAL;
+
+		vm_flags_clear(vma, VM_MAYWRITE);
+	}
 
 	vma->vm_private_data = mc_dev;
 
-- 
2.53.0



