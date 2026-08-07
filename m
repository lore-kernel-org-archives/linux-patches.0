Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4823AEF21;
	Fri,  7 Aug 2026 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115557; cv=none; b=ulCQytLpZUoCCTFJTp8pApfoSgVp+Eayl4LyWJZa08UZvGfRWntbDtATTIYY9eLtohNfW13rM1ag+7P2VrYqwK4AOWVTGyVN6EDeswwfUmAEToedBsj1XEjYhKKvdf0//BP+4BV/UCypOXb3XRy2JfFagJrKq6wLRVyLJs390J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115557; c=relaxed/simple;
	bh=WK9H7WQriWFG32pOCv7r8CF7rfFuCPphP8LkuMZY4WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzcRT3769/vpihCSshsgOiihDZNt2LmP1qpAIbns7M62NHRRiNpLhoSpj/Td3fHyzSapM2shF3+PjbFN0GcNRvN5XyQJhkXJB25aQHaNO3z6rjY+EqqO75WD1izE77jLKn3LKI6h4zeSdlpNFBQmaUWe6YQG/P99m8M9aYzF3zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJbabLBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJbabLBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE431F00A3E;
	Fri,  7 Aug 2026 15:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115554;
	bh=Nkthe4kX5bb/uLx6tDdCW9rH8+x3JxK5L3MiVWAAvCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJbabLBWcqFNIdzibAnRnqpQLfBzE7dqMsRZtupQeLJyN5KBiPbmUXX67cpHxp+os
	 V2Ni2IpAj7OyeLEhdSIp7DZbczVjSo/KiKpjkW7kqWaew4e6/9ob1FE1mtsRcLu76H
	 BzPkJL9ERgcbwHBnxvP6efW301NvjvGNjdgVsSnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 6.18 316/396] drm/panthor: reject firmware sections with oversized data
Date: Fri,  7 Aug 2026 16:37:56 +0200
Message-ID: <20260807143431.079995648@linuxfoundation.org>
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

commit a3caaa06809248b996254be5b47e10804a3494e2 upstream.

In panthor_fw_load_section_entry(), the data size to copy is calculated
without validating it against the allocated section_size:

    section->data.size = hdr.data.end - hdr.data.start;

If a crafted firmware sets data.size larger than the allocated memory,
this could cause a heap buffer overflow in panthor_fw_init_section_mem()

    memcpy(section->mem->kmap, section->data.buf, section->data.size);

Additionally, if the section->data.size exceeds the BO size, could this
memset underflow the size calculation, leading to a massive out-of-bounds
zeroing of kernel memory?

    memset(section->mem->kmap + section->data.size, 0,
           panthor_kernel_bo_size(section->mem) - section->data.size);

Reject section entries whose initial data is larger than the section size.

Fixes: 2718d91816ee ("drm/panthor: Add the FW logical block")
Cc: stable@vger.kernel.org
Signed-off-by: Osama Abdelkader <osama.abdelkader@gmail.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260716143939.21903-1-osama.abdelkader@gmail.com
Signed-off-by: Steven Price <steven.price@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panthor/panthor_fw.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/panthor/panthor_fw.c
+++ b/drivers/gpu/drm/panthor/panthor_fw.c
@@ -495,6 +495,7 @@ static int panthor_fw_load_section_entry
 	struct panthor_fw_binary_section_entry_hdr hdr;
 	struct panthor_fw_section *section;
 	u32 section_size;
+	u32 data_size;
 	u32 name_len;
 	int ret;
 
@@ -545,6 +546,13 @@ static int panthor_fw_load_section_entry
 		return -EINVAL;
 	}
 
+	section_size = hdr.va.end - hdr.va.start;
+	data_size = hdr.data.end - hdr.data.start;
+	if (data_size > section_size) {
+		drm_err(&ptdev->base, "Firmware corrupted, section data exceeds section size\n");
+		return -EINVAL;
+	}
+
 	name_len = iter->size - iter->offset;
 
 	section = drmm_kzalloc(&ptdev->base, sizeof(*section), GFP_KERNEL);
@@ -553,7 +561,7 @@ static int panthor_fw_load_section_entry
 
 	list_add_tail(&section->node, &ptdev->fw->sections);
 	section->flags = hdr.flags;
-	section->data.size = hdr.data.end - hdr.data.start;
+	section->data.size = data_size;
 
 	if (section->data.size > 0) {
 		void *data = drmm_kmalloc(&ptdev->base, section->data.size, GFP_KERNEL);
@@ -576,7 +584,6 @@ static int panthor_fw_load_section_entry
 		section->name = name;
 	}
 
-	section_size = hdr.va.end - hdr.va.start;
 	if (section_size) {
 		u32 cache_mode = hdr.flags & CSF_FW_BINARY_IFACE_ENTRY_CACHE_MODE_MASK;
 		struct panthor_gem_object *bo;


