Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CC6563FD6;
	Wed,  9 Sep 2026 14:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964288; cv=none; b=BGZgRBAdaRvutzHvOwxrIUwHLrg5rtyS/jM8GyfyvYrdL588efFe0CYLVD98/uFjEBmY5NgqxSVTfjoJXOZz2aF94/lztpjuf4hpkzlnZ2zpW1atafIIF4ua7LJO1YaHAyfmN+XvDG1MahJccZSm/3fJsMHorntcILc249UovfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964288; c=relaxed/simple;
	bh=PM0fJE+Pv7xjYZtyZGYm7ab28ldWK0Ns/BeWzBl61eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izExNkymr+0qemnme4Qi8K4JKlGut1iX5oyiJ3m2Vy0fo3ASq+nZ6oZMlEyBZEwrHp5cyOmv6y8zMiE5s8dz0ZOzdhrxG7dCJtGp2doCKTasQ3PxWtAbOVwcozKzVs+1pD56c6IkyB/QwYSuP4PqNmg0MGrG/mCCsv2FalhG0hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gM6qn/Aq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gM6qn/Aq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5230D1F00A3A;
	Wed,  9 Sep 2026 14:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964286;
	bh=7PU5BJeSm1rn7Uw0hyv7jd0Odz4dSO4LVqRa4NFyL6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gM6qn/AqR75qIjNDe+8Yj9o4Pp06h1sCquaBWHugMucxzEQcG+09mmhp5gzaqApJn
	 JnSNJTEN5ZLpxxIwQzb6abkehiBSwXnF7ZfMeW8BkZGzlTElISaDJrbPEU79+DOIAY
	 i2p1QdG5v3ktArKMUKV1cog96GMaE3ZDFOEFncF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>
Subject: [PATCH 6.18 372/583] drm/panthor: fix firmware control interface bounds checks
Date: Wed,  9 Sep 2026 15:40:57 +0200
Message-ID: <20260909134250.914762133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -843,14 +843,15 @@ static int panthor_init_cs_iface(struct
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
@@ -900,10 +901,12 @@ static int panthor_init_csg_iface(struct
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
@@ -955,11 +958,15 @@ static u32 panthor_get_instr_features(st
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
 


