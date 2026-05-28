Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DFD2F1FEF;
	Thu, 28 May 2026 20:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001469; cv=none; b=uufPI6tbIJ05xrhg9fl4BtWArrhOMMgTZ0NlUyM/MSlm/qBKCzU1bL00lJNliCWJX4D2fTnYwJ3woi2MpaJk+81opngoFOQJuTc4C6oH44NA20uQhwP36DB5CZO7Mqqw85WnYuPH/WVz1s36YUuIcP+3yhkypWxrJq4n2fV3ans=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001469; c=relaxed/simple;
	bh=lfdU/oCoHklpxgcL6j2mRbxILEurCUYdqQIzTvyCkMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/ujR2DLbETkjsepTUi5PjxbkX/a2saunPvWY0VI/vIEA1D0GItfQR1bOfhUJkkF/jHwdUxpzJQ00IESkhoCdqGwXxHYLGB0DPcP91kmTA8qF6+u5SIiSLOhOCk4HWmBFDNydrnwkCNaLHsRgZ42BU6DysN9q0Hex3be9Thr/l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKK2FyNI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKK2FyNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4E21F000E9;
	Thu, 28 May 2026 20:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001467;
	bh=hrBXteUUA+vHxNxO6TbSctu3j85RcDuMsaoEq4SJWDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKK2FyNI3y1sC6EDpPbCwJPxQj9dCJHbfUgeBxuuf+T244+Geq7EuHlCsaJos3dT3
	 6ga+VdhRD8/7ZaXbtbICUSPp10jUb4kn5qUm3hKxTC4MLzlrE5IpbSZ73z6vS8/ZeG
	 Eex7iGswpiMDxGZDmJloBYUCiRuikZG716LGaLhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Maar <lukas.maar@tugraz.at>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Zack McKevitt <zachary.mckevitt@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/186] accel/qaic: Add overflow check to remap_pfn_range during mmap
Date: Thu, 28 May 2026 21:50:17 +0200
Message-ID: <20260528194932.651346519@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack McKevitt <zachary.mckevitt@oss.qualcomm.com>

[ Upstream commit aa16b2bc0f02709919e2435f531406531e5bcc69 ]

The call to remap_pfn_range in qaic_gem_object_mmap is susceptible to
(re)mapping beyond the VMA if the BO is too large. This can cause use
after free issues when munmap() unmaps only the VMA region and not the
additional mappings. To prevent this, check the remaining size of the
VMA before remapping and truncate the remapped length if sg->length is
too large.

Reported-by: Lukas Maar <lukas.maar@tugraz.at>
Fixes: ff13be830333 ("accel/qaic: Add datapath")
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Signed-off-by: Zack McKevitt <zachary.mckevitt@oss.qualcomm.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
[jhugo: fix braces from checkpatch --strict]
Signed-off-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260430193858.1178641-1-zachary.mckevitt@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/qaic/qaic_data.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/accel/qaic/qaic_data.c b/drivers/accel/qaic/qaic_data.c
index d00068987d9bd..7beab1309e369 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -595,8 +595,11 @@ static const struct vm_operations_struct drm_vm_ops = {
 static int qaic_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
 {
 	struct qaic_bo *bo = to_qaic_bo(obj);
+	unsigned long remap_start;
 	unsigned long offset = 0;
+	unsigned long remap_end;
 	struct scatterlist *sg;
+	unsigned long length;
 	int ret = 0;
 
 	if (obj->import_attach)
@@ -604,11 +607,27 @@ static int qaic_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struc
 
 	for (sg = bo->sgt->sgl; sg; sg = sg_next(sg)) {
 		if (sg_page(sg)) {
+			/* if sg is too large for the VMA, so truncate it to fit */
+			if (check_add_overflow(vma->vm_start, offset, &remap_start))
+				return -EINVAL;
+			if (check_add_overflow(remap_start, sg->length, &remap_end))
+				return -EINVAL;
+
+			if (remap_end > vma->vm_end) {
+				if (check_sub_overflow(vma->vm_end, remap_start, &length))
+					return -EINVAL;
+			} else {
+				length = sg->length;
+			}
+
+			if (length == 0)
+				goto out;
+
 			ret = remap_pfn_range(vma, vma->vm_start + offset, page_to_pfn(sg_page(sg)),
-					      sg->length, vma->vm_page_prot);
+					      length, vma->vm_page_prot);
 			if (ret)
 				goto out;
-			offset += sg->length;
+			offset += length;
 		}
 	}
 
-- 
2.53.0



