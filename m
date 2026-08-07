Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25936442393;
	Fri,  7 Aug 2026 15:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115561; cv=none; b=I1N0GOg+vSq17pNvO2rfTUYQIkoup+satbnjZ5HgmIrTHt97ssaKdJhDmrf9GXpREt3tx4SXJnD/aL4CVuwn2b3o/PpLcIFXYDsPVWzbeCCjktqeHtBS4GpB6VzJHOfpVLIZAszAxPyNLx/BhLWsKZJwYsZgnKPN64nF40gtbLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115561; c=relaxed/simple;
	bh=V2kX7BPZrLzPMrSfF7+Wi9cs/JcJkbDBYvYV51a4cAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siem1q8HJN61Sf7e2VBffaXd1qcVgdSdlTcQpc7bxwQe4mFqcK/IyKmaoLV6sxwetRz0Hmb9+kpZkqYr+7/bLOFoG2EdWrVfrZLokIxWhXrajOohEPbFuA3OA+aZaNCywikimSi6v1GkgWsD2LrVQM+Qo6GqTBCNGyMUxe5AmB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RH+0zCr9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RH+0zCr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5616D1F000E9;
	Fri,  7 Aug 2026 15:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115556;
	bh=KRK+tgwDK7cedWkpjW2hUk24C5oDMnAoLrJbukdgNEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RH+0zCr9P3psG5BLyWxf350YV60eG7aO8vc9fWOlDMIIn+N2xxalNf/pExK669H11
	 qdr78UxHC2YH5N6gceaCtlRoOCgCpYCB2g7z0S2SmdyzeShymc3J+9emdlJaPdfg1A
	 fYudECk4w1XfYIjeEmIIiJUSX76SKkzBXe8gzHtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 6.18 317/396] drm/panthor: validate firmware interface structure sizes
Date: Fri,  7 Aug 2026 16:37:57 +0200
Message-ID: <20260807143431.102186013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

commit b921b8613790a3f9e78ab64017fa7149ef0b750c upstream.

iface_fw_to_cpu_addr() only checks that the firmware-provided MCU virtual
address points inside the shared section. The returned pointer is later
used as a full firmware interface structure, so accepting an address near
the end of the shared section can still lead to out-of-bounds accesses.

Pass the expected object size to iface_fw_to_cpu_addr() and reject ranges
that do not fit entirely in the shared section.

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20260720114918.15973-1-osama.abdelkader@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c |   36 +++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -812,18 +812,24 @@ out:
  * iface_fw_to_cpu_addr() - Turn an MCU address into a CPU address
  * @ptdev: Device.
  * @mcu_va: MCU address.
+ * @size: Size of the object pointed to by @mcu_va.
  *
- * Return: NULL if the address is not part of the shared section, non-NULL otherwise.
+ * Return: NULL if the object is not part of the shared section, non-NULL otherwise.
  */
-static void *iface_fw_to_cpu_addr(struct panthor_device *ptdev, u32 mcu_va)
+static void *iface_fw_to_cpu_addr(struct panthor_device *ptdev, u32 mcu_va, size_t size)
 {
 	u64 shared_mem_start = panthor_kernel_bo_gpuva(ptdev->fw->shared_section->mem);
-	u64 shared_mem_end = shared_mem_start +
-			     panthor_kernel_bo_size(ptdev->fw->shared_section->mem);
-	if (mcu_va < shared_mem_start || mcu_va >= shared_mem_end)
+	size_t shared_mem_size = panthor_kernel_bo_size(ptdev->fw->shared_section->mem);
+	u64 offset;
+
+	if (mcu_va < shared_mem_start)
+		return NULL;
+
+	offset = mcu_va - shared_mem_start;
+	if (offset > shared_mem_size || size > shared_mem_size - offset)
 		return NULL;
 
-	return ptdev->fw->shared_section->mem->kmap + (mcu_va - shared_mem_start);
+	return ptdev->fw->shared_section->mem->kmap + offset;
 }
 
 static int panthor_init_cs_iface(struct panthor_device *ptdev,
@@ -845,8 +851,10 @@ static int panthor_init_cs_iface(struct
 
 	spin_lock_init(&cs_iface->lock);
 	cs_iface->control = ptdev->fw->shared_section->mem->kmap + iface_offset;
-	cs_iface->input = iface_fw_to_cpu_addr(ptdev, cs_iface->control->input_va);
-	cs_iface->output = iface_fw_to_cpu_addr(ptdev, cs_iface->control->output_va);
+	cs_iface->input = iface_fw_to_cpu_addr(ptdev, cs_iface->control->input_va,
+					       sizeof(*cs_iface->input));
+	cs_iface->output = iface_fw_to_cpu_addr(ptdev, cs_iface->control->output_va,
+						sizeof(*cs_iface->output));
 
 	if (!cs_iface->input || !cs_iface->output) {
 		drm_err(&ptdev->base, "Invalid stream control interface input/output VA");
@@ -896,8 +904,10 @@ static int panthor_init_csg_iface(struct
 
 	spin_lock_init(&csg_iface->lock);
 	csg_iface->control = ptdev->fw->shared_section->mem->kmap + iface_offset;
-	csg_iface->input = iface_fw_to_cpu_addr(ptdev, csg_iface->control->input_va);
-	csg_iface->output = iface_fw_to_cpu_addr(ptdev, csg_iface->control->output_va);
+	csg_iface->input = iface_fw_to_cpu_addr(ptdev, csg_iface->control->input_va,
+						sizeof(*csg_iface->input));
+	csg_iface->output = iface_fw_to_cpu_addr(ptdev, csg_iface->control->output_va,
+						 sizeof(*csg_iface->output));
 
 	if (csg_iface->control->stream_num < MIN_CS_PER_CSG ||
 	    csg_iface->control->stream_num > MAX_CS_PER_CSG)
@@ -954,8 +964,10 @@ static int panthor_fw_init_ifaces(struct
 		return -EINVAL;
 	}
 
-	glb_iface->input = iface_fw_to_cpu_addr(ptdev, glb_iface->control->input_va);
-	glb_iface->output = iface_fw_to_cpu_addr(ptdev, glb_iface->control->output_va);
+	glb_iface->input = iface_fw_to_cpu_addr(ptdev, glb_iface->control->input_va,
+						sizeof(*glb_iface->input));
+	glb_iface->output = iface_fw_to_cpu_addr(ptdev, glb_iface->control->output_va,
+						 sizeof(*glb_iface->output));
 	if (!glb_iface->input || !glb_iface->output) {
 		drm_err(&ptdev->base, "Invalid global control interface input/output VA");
 		return -EINVAL;


