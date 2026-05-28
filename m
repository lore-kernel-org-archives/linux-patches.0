Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93848352019;
	Thu, 28 May 2026 20:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998767; cv=none; b=Ts44RimHWNxJI/tFdDhVBcIcBeNOQDjKzfMH/1V+r+nr2MmoRD5RdFVvHFkb+vmVSPladzmsDpt4RZq7WpjVztFjZB3Rl3mujHsFTIkjkJjMOdAJNt/Z5PBar+3YFFUQaN71bHd/v5mXJwUzQgRTN92kWe3XGRE5Fda2jpZUcjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998767; c=relaxed/simple;
	bh=wlC6capQX5g9+Yet+hsHj9Lq3htlOfkFaBJniLTnKho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+b+SGmrivDt3UmB7UZ/hwo5Cg5ThEAimAaJQQg/8FJ6ghb1n/MKSfcAak/Vc7Rpw74OFUO1EbflpK+3GD8pATbPp14yT8eFrwU0yaSkO9ZdF9WPp1VfyU70RHMEUqJjD/OAu75u9N2IwF2rX7I21b8QTO2SnCilA6hJEc0xf6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WGc1v7y2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WGc1v7y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11F81F000E9;
	Thu, 28 May 2026 20:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998766;
	bh=sLo0aHVFIgW6Qo6FyErAicefvUrE3f2Qh5Lc4Wt4zzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGc1v7y2JlDZeIYe/jitqusmLC4BoZeG+Xk9fkqqayx+AAynrQ+0vlYRN3JRfDtvG
	 +qMUP7SBfzoPfI+itM0yDqzj7hirTHYt6ODRsz9//udfhsK/fm9VlVXqIXiv/Gc+2/
	 VnazpbEyYvCCkp9op5lx7Y5Mv3K4usgLyX+0PjdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Maar <lukas.maar@tugraz.at>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Zack McKevitt <zachary.mckevitt@oss.qualcomm.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 291/461] accel/qaic: Add overflow check to remap_pfn_range during mmap
Date: Thu, 28 May 2026 21:47:00 +0200
Message-ID: <20260528194655.640043787@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 95300c2f7d8af..1e4c579d27256 100644
--- a/drivers/accel/qaic/qaic_data.c
+++ b/drivers/accel/qaic/qaic_data.c
@@ -606,8 +606,11 @@ static const struct vm_operations_struct drm_vm_ops = {
 static int qaic_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
 {
 	struct qaic_bo *bo = to_qaic_bo(obj);
+	unsigned long remap_start;
 	unsigned long offset = 0;
+	unsigned long remap_end;
 	struct scatterlist *sg;
+	unsigned long length;
 	int ret = 0;
 
 	if (drm_gem_is_imported(obj))
@@ -615,11 +618,27 @@ static int qaic_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struc
 
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



