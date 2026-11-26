Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705811;
	b=my/akZASkEoglrwf1GQIb4uBao/CYN7pky2t2oSQ/BTe0IwHaF8sgVs5gb6nDWDaVihC
	 k0OC1mhYajOqI78Gm5WhavVxYKLl28E/ZL20aVqCz/zourqK1vUsT0uRRYrGVWx67LYjF
	 RNE/a+A4nTRaFZ/Q9xGMP5CTIsUD1gizdMOw7AQMnFws0lOweLKhEUF+Cf8ojzG/RQedl
	 J2IgazLgCKk4XIM4i/GZc+3rRGiSaSpVR7M3evQkDD6ejuNZD7kZjetICP8FeDk9p8W2l
	 Y6aEK+voCUlZKwceU7UaJ1XoRibsyx+7LBv7jAN/nV7sxVW0gRQuZrzjq83egHGnM8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4KEVTKOtjnp7TH6QejIznuwTsilVnGbLIgxOF78Ry9Q=;
	b=5EFJff/1nO/2bS/6u5GUnpSYZCLJrBP/pKnmzU8eAuAK2GdWYOeFEvYsVSxt0auGgdpY
	 ldcxlMXvs1Hu62T2p9bKdhRCgdhN9OKNaR11Tkuh3NnMvXaVupIhyocN39b2I/XjL0P2F
	 GP6MAxn3V8PYRosIWiOiWakBNUHY6J8abG/EOVbCjMJCnmLHrWtd9h6iNY3MSWXkTI68G
	 4C0s7B76RRiPONTboqpC9LKn/YGSb8OERjUgwj605PujpOK6S+HLHOEYdkbvha0L1POHW
	 Jytt3zM/RIENrMqM/obfO+h75HKGT0j2kEQR6n/KN/8TszPC+fAOWMkPtJcuR1fGnNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n64BqFvO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB26606A321;
	Thu, 26 Nov 2026 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n64BqFvO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62B91F0093E;
	Thu, 26 Nov 2026 15:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705811;
	bh=4KEVTKOtjnp7TH6QejIznuwTsilVnGbLIgxOF78Ry9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n64BqFvOJH0Rsm9krVesnR8U98YhM4B8Kve/pu7tW0W7VfCkTS3SC/kojgY2ASu61
	 rUGQGS648bRne+qNUSP4TiAIQ9yKZC04ZZtQisIpO9ATaos83zO4QcpJi9FlZZ92af
	 595bLYdUQjuY/XNkjNOaIRTaESKdD+WO+/ql6/hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>
Subject: [PATCH 5.15 316/319] vfio/fsl-mc: prevent read-only region mappings from becoming writable
Date: Thu, 26 Nov 2026 15:41:24 +0100
Message-ID: <20261126144013.893521177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdifatah Suruur <suruurism@gmail.com>

commit 25fd8b27ee8d4f59cc2ad99cf67aef4570b82096 upstream.

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
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/fsl-mc/vfio_fsl_mc.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -394,9 +394,13 @@ static int vfio_fsl_mc_mmap(struct vfio_
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
+		vma->vm_flags &= ~VM_MAYWRITE;
+	}
 
 	vma->vm_private_data = mc_dev;
 


