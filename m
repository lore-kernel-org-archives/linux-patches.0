Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018018;
	b=sHz6jq45Mxl886rJR0VQAOQI+uCnRMN6BLYfkRQtuHc/5PnaC59uRgZHxa918rLokAlt
	 rRUo/htD9xT3so9qcamY+WwoJSCLStGTwcl1g8gevL5QzBy7dDOyms0ecUQcJpz1jVP59
	 iOgoY7s+c9kTp8LZ3M2c9pnRrzsZpbUsN4xNofBJElbXeSEFafTFeTpmZNDrN8rv0nFuM
	 gdLB+3a4NRRMgYyXdug66MKWHaJqRtHd2hJN7TiAsAwltiRMKdcbx0DSnT8FvBmi64spi
	 iE0g21ueavvnrzbWZWyTHGC9JTNfDMopKWYSXSv9aHL7tcjGyjNjHFB1IwYVnn7zS5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hqRgJffigR2yDuA/Wm4JG1xPCCGscqW6qvRcg6oKM3U=;
	b=14TKdfbzqW0OPnYvP5gFzNEQxfA4//WKJuWSVz/TDYOM2Zbd+JwN5UfboLR7QdSPhPRD
	 AESMgn83bNLlsqxZiQ0K3xp7LCd+TV9YrBHtETSvkn5Wx4y3VUzgqEF+9S7CyLZwDbBvr
	 bcSqClhe6askdrrYLYtAT/ejyFmoc1lSyYwX9Kf5zR13fWhMTdPZe3EfOlrpjsYM8XGh3
	 Qufl4ZgsdH6dhmt9dUQ/atVc1hZvJcbwkhbheLKyVdR9N6SGCScmSZahwia2PmBOxQEdh
	 j0S9Zd4aEImAH/6bdKo50zU7ZFDnMDP7Cl23JFzzHZ0sZf/VP0Ddsc3ElWnosDcmMUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoF+1lLV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1F8606A325;
	Wed, 18 Nov 2026 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoF+1lLV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E671F000C4;
	Wed, 18 Nov 2026 16:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018018;
	bh=hqRgJffigR2yDuA/Wm4JG1xPCCGscqW6qvRcg6oKM3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoF+1lLVB7HUZvxhdrixq3on5S5Sxe3p2NJlflhxTEPCaxYVTOovZ5a0UQhYPa435
	 H07zkgusWs/hs6LfXE/Nmvnl3i/2oadV9YvsJNluJkNR62uBPf+wdRaBiKOFSujDOd
	 QS5uIvy5Jmi91/pTYE7nr3+nPl9i8MO/ykh4thxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1050/2651] vfio/cdx: prevent read-only region mappings from becoming writable
Date: Wed, 18 Nov 2026 15:38:10 +0100
Message-ID: <20261118150325.772888707@linuxfoundation.org>
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
index b31ed4be7bdc1..28386fdb01f2e 100644
--- a/drivers/vfio/cdx/main.c
+++ b/drivers/vfio/cdx/main.c
@@ -281,9 +281,13 @@ static int vfio_cdx_mmap(struct vfio_device *core_vdev,
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



