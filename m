Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF50D3F788A;
	Sat, 12 Sep 2026 11:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214257; cv=none; b=Sv867X9doOs0qKOgZ+EHsrYlOLoErUdZVEyfy3IOdrEO1kf4YGhgEx53AsWN37KMZSPATnk9c58uZIlGf2lKuqy/Xe/Kcmzznp+ESEfBM6V1Oky6vHMn3d4iUG935iec5UypaHEsGJ+QFZwKH57uNK4O2ruTd0s6FSJxoaWZnf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214257; c=relaxed/simple;
	bh=X3CmMC79RwexvWqx0eyZaUezGDQ4WiQyhVUK6bXlveU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJfqznxB12DkI1mifdQo9h23zLXJXO4hlK29nzI1bWCd2H60ZwwBI90IWmqc7FLrk1MWINXJu9iWcNjckD9QN5vfM1oRocuiJgaVabDMBX3QVLA1NpN4wQYR6+jaNIzj0U7RFo+Zh+n5mXdZei+15LULITkYJoXZfKmhajVXtVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHT8YkPv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHT8YkPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C1F1F00893;
	Sat, 12 Sep 2026 11:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214255;
	bh=1CX2hWmBAKJZQqb3Xd4iJ778LWzTaaDuKuL9/eYW/gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHT8YkPv4lkh10CgFM8Bqu3wxhj0ySDAYCAKRDCYYpOfVpavMYMDPv74g/uurikyj
	 ThRkgyKS0KD74SqkBBdyrYZht4QZMXw3HZhV3bS+M+c5iSmV4Iib2nHvNK6mLSU15W
	 ggM4Z4sllMDDo1UYF17wY5Fy5xheQa7cjND6iUhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.12 0258/1376] drm/panthor: fix firmware control interface bounds checks
Date: Sat, 12 Sep 2026 08:44:44 +0200
Message-ID: <20260912065613.289149724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -797,14 +797,15 @@ static int panthor_init_cs_iface(struct
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
@@ -854,10 +855,12 @@ static int panthor_init_csg_iface(struct
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
@@ -909,11 +912,15 @@ static u32 panthor_get_instr_features(st
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
 


