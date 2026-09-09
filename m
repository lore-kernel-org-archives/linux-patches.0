Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960FC572673;
	Wed,  9 Sep 2026 14:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962976; cv=none; b=nQTfIiCjrQ+n+dvU+SRBXmRMldot/mtyY9qVn3LfCKVCrC26fsZW4K9eZXOLtr6mfmDWTX20mj86hzgCTSqubvr6SQ72kA0dRs/rMo8QCjAJaugFkseJHuVvMIybgpofyBNITDdm2f652Lgog4h6dVQguaTsJYxn9Oz6dinuoZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962976; c=relaxed/simple;
	bh=NSjaFj3Pkfa10t3FIXXW6m02pN1J1htdItZVWcU6dvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oh1V1Vgf1fz4rL7zzRlBXa1Ldcq7kGhL0EZ0+vfCYT5jf7RSAxwbsvaQIMIsPAJ6jjjJipwZ9FEfNefEB645ckrE9eQ5KFWmkqcozsjRRq8BQtsM3Ue6lkw63IkOwfZjz7JfkGej8dBpwSy7yEhdG6GNH03kt2uIwbC87my+ahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfz26m9s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfz26m9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDFD1F00A3A;
	Wed,  9 Sep 2026 14:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962974;
	bh=to0wvWexPSOCMdcXINqK1czgph64KMp/8QjVwOPDHhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfz26m9sodxUKIMdW/kmM22ZzATxi3P6x3LgUlp69LTpKMDBB0b0kdRVcWRk+Ad9E
	 zjXGGcBipV0lkMsFuJYknZk12oHG0xv1PY4pdEafGtjPOIGImI2IRH9uaXffhDJ5eT
	 Sn7DPAtN0tw37ar1FNmH5wyzuEM+wfJ7O9ujnU0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 7.2 476/556] drm/panthor: fix firmware control interface bounds checks
Date: Wed,  9 Sep 2026 15:42:36 +0200
Message-ID: <20260909134247.286432961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Osama Abdelkader <osama.abdelkader@gmail.com>

commit 6a47f9fd2d970674ed9dedc52fc7ab76fd015785 upstream.

panthor_init_cs_iface() and panthor_init_csg_iface() validate firmware
control interface offsets with 32-bit arithmetic and the size of the host
wrapper structures. The offsets are derived from firmware-provided strides,
so the arithmetic can wrap before the bounds check, and the host wrapper
size is not the size of the firmware control interface being mapped.

Use 64-bit arithmetic for the computed offsets and validate against the
actual firmware control interface structure sizes with subtraction-based
bounds checks. Also validate that the shared section is large enough for
the global control interface before using it.

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260720134435.13377-1-osama.abdelkader@gmail.com
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -895,14 +895,15 @@ static int panthor_init_cs_iface(struct
 	struct panthor_fw_csg_iface *csg_iface = panthor_fw_get_csg_iface(ptdev, csg_idx);
 	struct panthor_fw_cs_iface *cs_iface = &ptdev->fw->iface.streams[csg_idx][cs_idx];
 	u64 shared_section_sz = panthor_kernel_bo_size(ptdev->fw->shared_section->mem);
-	u32 iface_offset = CSF_GROUP_CONTROL_OFFSET +
-			   (csg_idx * glb_iface->control->group_stride) +
+	u64 iface_offset = CSF_GROUP_CONTROL_OFFSET +
+			   ((u64)csg_idx * glb_iface->control->group_stride) +
 			   CSF_STREAM_CONTROL_OFFSET +
-			   (cs_idx * csg_iface->control->stream_stride);
+			   ((u64)cs_idx * csg_iface->control->stream_stride);
 	struct panthor_fw_cs_iface *first_cs_iface =
 		panthor_fw_get_cs_iface(ptdev, 0, 0);
 
-	if (iface_offset + sizeof(*cs_iface) >= shared_section_sz)
+	if (iface_offset > shared_section_sz ||
+	    sizeof(*cs_iface->control) > shared_section_sz - iface_offset)
 		return -EINVAL;
 
 	spin_lock_init(&cs_iface->lock);
@@ -952,10 +953,12 @@ static int panthor_init_csg_iface(struct
 	struct panthor_fw_global_iface *glb_iface = panthor_fw_get_glb_iface(ptdev);
 	struct panthor_fw_csg_iface *csg_iface = &ptdev->fw->iface.groups[csg_idx];
 	u64 shared_section_sz = panthor_kernel_bo_size(ptdev->fw->shared_section->mem);
-	u32 iface_offset = CSF_GROUP_CONTROL_OFFSET + (csg_idx * glb_iface->control->group_stride);
+	u64 iface_offset = CSF_GROUP_CONTROL_OFFSET +
+			   ((u64)csg_idx * glb_iface->control->group_stride);
 	unsigned int i;
 
-	if (iface_offset + sizeof(*csg_iface) >= shared_section_sz)
+	if (iface_offset > shared_section_sz ||
+	    sizeof(*csg_iface->control) > shared_section_sz - iface_offset)
 		return -EINVAL;
 
 	spin_lock_init(&csg_iface->lock);
@@ -1007,11 +1010,15 @@ static u32 panthor_get_instr_features(st
 static int panthor_fw_init_ifaces(struct panthor_device *ptdev)
 {
 	struct panthor_fw_global_iface *glb_iface = &ptdev->fw->iface.global;
+	u64 shared_section_sz = panthor_kernel_bo_size(ptdev->fw->shared_section->mem);
 	unsigned int i;
 
 	if (!ptdev->fw->shared_section->mem->kmap)
 		return -EINVAL;
 
+	if (sizeof(*glb_iface->control) > shared_section_sz)
+		return -EINVAL;
+
 	spin_lock_init(&glb_iface->lock);
 	glb_iface->control = ptdev->fw->shared_section->mem->kmap;
 


