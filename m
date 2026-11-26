Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704844;
	b=r/WtA0h9Hle9xDa87q6z8uTh0hH7UM5yg6Yw/QJqDo4XLzvLYCMrrbN1F8mHjINJG866
	 +93ltNY7G/NlCiHMtCTkl9yrUwttAFB8NslOnb1HgHojYh/SYmNCgwoqNd8KsSFpkTHs6
	 Gny2zs+RgXEn5g9BeqLapcyHPxCJ/pw85PFs5DIPziGXyvg/9VIkeBddERibfTC695lG7
	 89+VzS0mv45GogOYlxmjjFAo2jfpBraq9AaUam2WlX/U1g/GOxfYvaK3gHEEel+kf54PS
	 oJlwtilwzM2yKvW6cfvhcEjbL/Oe/gF8LRBnrFO7xVElUpRNqnREwd5lYmqdHj+UY/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7g7NwwK97y5AUE5gsRXRXZ3gkzQT8ohUlXlbGOcH3SQ=;
	b=rDvBb9VL30Iqvt5fZmZJcgfN3rD/Mzkdwhk7JKiJsQCg40sPevqvhre7d7SbVC+gk02x
	 G5i42oUPhlf6MpHq5scNpvvpLsm5NjKkUo5Jx4DlVuBTx7ypXmrnO+2wRyOkw+vzWQVsr
	 VBDKh/uX/zKpjNpjd6UQLAf+0yCNBPOA/qfwsbs3oF1KfRKSqi1G9+xYLpr4GXmhhKjSY
	 qdlTdNJhcI6c2JR6AVtF4VORb0ymxtNbIfjUb261nRVhdEi2GqXUtWDoPaGJ26nB2F2fq
	 j7ap3xHZg4bb5zhykANfNzMvzExtfxfx8+9xyzFYgYPHj/JfzA6uqgFiyk93kBAgt0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mob36/WH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFCAA606A321;
	Thu, 26 Nov 2026 14:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mob36/WH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E861F000C0;
	Thu, 26 Nov 2026 14:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704844;
	bh=7g7NwwK97y5AUE5gsRXRXZ3gkzQT8ohUlXlbGOcH3SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mob36/WHQBVwxFHw5Ss8pwpOWU4EgUybqxAr/e3SCeRnCaDba+Ia4kKqZbKFw9nk+
	 8kfavRDYoj4lwQ0biJDjgNZgDV7V3dVbfbxfTTCeo+4MdcZx7CiYYhMBDtt3Qfrq76
	 7UrxiWUg5virTy+DsHWPjNby3niEEWWGFSiKYFcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>
Subject: [PATCH 5.10 261/265] vfio/fsl-mc: prevent read-only region mappings from becoming writable
Date: Thu, 26 Nov 2026 15:39:51 +0100
Message-ID: <20261126143623.482116290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -494,9 +494,13 @@ static int vfio_fsl_mc_mmap(void *device
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
 


