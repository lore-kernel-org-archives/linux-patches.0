Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127D93A6F0A;
	Fri,  7 Aug 2026 15:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117636; cv=none; b=S3G1/dxNuP8h4GhZzDEvDI3T1g/tbiuSoPBTkbQUoncg7Bs+i74xsh1XgT8Wyosr4/exa0+CwSfdzcH+qjKf5hawuUaYdhTktOJirgCWrX2ZjqYHZb1bg8XqfGIhnQzLZo69/3JA1T7aT2345Gk5s30bJC4BJC5B/k1Cvqoys6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117636; c=relaxed/simple;
	bh=sx3ONKBdQT+snsvSu7+BlY0fBmOZLtJ5dGd8Wtk9Toc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sefESm9gI2TAJHZuYjbDJdURB0GDMslFfJX7+UcgJkm4Bb64kksMqvkHRrJBRLNRJTnWVuAoeAq6zp1NfCmpSFZFrZhu6jaSXuYJZEg1HskrnDqYBkmeaq+MvxqH5vrKwML46924dVWrfJwY51pCquSuc/qOIyaKMTOGpBWpj9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQrBO9Iw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQrBO9Iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635D11F000E9;
	Fri,  7 Aug 2026 15:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117635;
	bh=8Z8CMuEKRUwzH5DFgGbRSgE/UMmXshQ9VnhCUrGK5XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQrBO9IwybZuLS8Wj37ezS/rmi93dyRaHSzFiGBgGsLT0uMGC4gPUGeVl4Z4BUhQx
	 /Hz7GY5h0GauznOyTTVgGoGrPTZzex/UmsemCsCOBTVR97OwqVrZNLR0l+kFR4AwUy
	 H6bVELWvCQF3Clq3U26uPFOnrKVEEK295OUt7WTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH 7.1 387/438] drm/panthor: validate firmware interface structure sizes
Date: Fri,  7 Aug 2026 16:39:43 +0200
Message-ID: <20260807143436.217142036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -859,18 +859,24 @@ out:
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
@@ -892,8 +898,10 @@ static int panthor_init_cs_iface(struct
 
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
@@ -943,8 +951,10 @@ static int panthor_init_csg_iface(struct
 
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
@@ -1001,8 +1011,10 @@ static int panthor_fw_init_ifaces(struct
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


