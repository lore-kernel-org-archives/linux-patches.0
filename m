Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040458;
	b=Nic2PnkYFWa+c+TS7LwRU2Op0+prj4FDqR6wQN1Hq42CZ8qAzHHbiTdvsi8w10RNE2ks
	 DGhXfjt3Kp09CAvOu8W06lRMjPpmcu5M/P4uEbfdPggZSBp04W+FMwF2xDrgGO7vlpbzQ
	 SpZTc3+fkt01h6hWlZgsDpXhMhHGCjcVismIwShkZilmB6nj4dozFo9SkMh3w4KNsURj8
	 njHRcoV9LOc4OhjyvcUxuoiadj7xt9vubLXIOCWwb48FkhuRxhZWXV117ZF+k8TklpCOa
	 1qOV7B9QHvNNtgNTaSW+37sXdZVgfrql7a7WPLduYmV6D4SwE7OMX3zFsyrycsLqWkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MHAdU3a8KGGgRvX1/cNrHpIDOFHLnp4yG3uIlVGmYw0=;
	b=mfUVEiPpXKUFPKvRcwzIT5laeyYMaHQ/1Bdl3ijznAxawvqLAJrGL5J3KrDFsokzs3MJ
	 sFi0cer3t5giA8GDlPVLYm1tOXeHnydvFjTTz9yCY2mgMr0V5o7n5pZWFtI80BXbDkoC5
	 obkcdpGBnjFuCKb+GjZRKNHsVPdd34l060/jsc2fd9PsCGMp9wHDUhljAPI/M8Mmz6f5E
	 ayY4kE6bH+S/viJrpYjySbiCuAn7tHeNdVbJSqGhDeRo+y/ZllK5BH6LaaqXhddhQbDGO
	 T3kP/ZJJV7DIXSYUXG/4XaMATYpf9AL4XgnEIgAumUGRwnhQ3qVBt3IWVPHDN4KmH0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SwwkM9sl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF15606A32A;
	Wed, 18 Nov 2026 22:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SwwkM9sl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6431E1F000C4;
	Wed, 18 Nov 2026 22:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040457;
	bh=MHAdU3a8KGGgRvX1/cNrHpIDOFHLnp4yG3uIlVGmYw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SwwkM9sl3J99TzhYJvTJsXs3xgu5LD6NZMyYT4ZDcBgMP1juJ84mNeQFtNLYhCYzO
	 Sr6r4W5VfwqPIZHWZcGcIqqSRphiADWNdOKVNYDDQtURx8Ns6KZ38RDy1ougiiFnE0
	 Bx2nqru358HjlhdoMt+Jk+sojpuC4iy6nrCxyUHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2465/3318] vfio/cdx: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:51:27 +0100
Message-ID: <20261118150435.370187218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdifatah Suruur <suruurism@gmail.com>

[ Upstream commit 9c5cd385d295fa8621dff0e9f6063e3f6ff24159 ]

vfio_cdx_mmap() rejects writable mappings of regions without the WRITE
flag, but leaves VM_MAYWRITE set.  Userspace can map such a region
read-only and then upgrade the mapping to writable with mprotect(),
writing to MMIO regions the device marks read-only.

Clear VM_MAYWRITE for regions without the WRITE flag, as i915 does for
its read-only objects and as fixed in drm/vc4 (CVE-2026-68445),
drm/panthor (CVE-2024-53071) and commit a5edadbae57e ("ptp: vmclock:
prevent read-only mappings from becoming writable").

Note this is defensive hardening: no in-tree cdx device currently
publishes a region without the WRITE flag.  The guard costs nothing and
keeps the mmap() interface honest if a read-only region ever appears.

Fixes: 234489ac56130 ("vfio/cdx: add support for CDX bus")
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Link: https://lore.kernel.org/r/20260929094848.7439-4-suruurism@gmail.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/cdx/main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/cdx/main.c b/drivers/vfio/cdx/main.c
index de56686581ae4..5f815cb03d25c 100644
--- a/drivers/vfio/cdx/main.c
+++ b/drivers/vfio/cdx/main.c
@@ -157,9 +157,13 @@ static int vfio_cdx_mmap(struct vfio_device *core_vdev,
 	    (vma->vm_flags & VM_READ))
 		return -EPERM;
 
-	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE) &&
-	    (vma->vm_flags & VM_WRITE))
-		return -EPERM;
+	/* Prevent read-only region mappings from being upgraded with mprotect() */
+	if (!(vdev->regions[index].flags & VFIO_REGION_INFO_FLAG_WRITE)) {
+		if (vma->vm_flags & VM_WRITE)
+			return -EPERM;
+
+		vm_flags_clear(vma, VM_MAYWRITE);
+	}
 
 	return vfio_cdx_mmap_mmio(vdev->regions[index], vma);
 }
-- 
2.53.0



