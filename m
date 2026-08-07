Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075992E762C;
	Fri,  7 Aug 2026 14:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114395; cv=none; b=mDeGfkYWftcIbUvgt4c5O+F79I647/sUvoT4lKdHp+C/wBh9OksOd+ApHv/pqQmL2smJSh8bHpFgILsGeDWXdDpEeNWOb5GeVF4CLaT/DzzTrN6M+okZugUh79GIBD474+avSUGeEZAaNQEW5Q1fE0M5yW5485wET3b8V3V0ORs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114395; c=relaxed/simple;
	bh=ODtRcp2q6BabhFHPvRGlxJGolYuUNuZBDaKsY02KMtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NDv86fEc0E5+9jinA7Md4MBwED5Otmx6bMzdcjo9pnGrxhM2RHvIsWHO6EICb+iFPr/1YEsQ+V/xXuRUUGs/vPxbJGCQ0713ILgX3o4Bx+1H3n4D4C6rhKPl//bi5jC5mwTSnDw4KyfkWEUg5Huxt8qQND633RkramuPLHoOPik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=At9BO17a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="At9BO17a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630C61F000E9;
	Fri,  7 Aug 2026 14:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114393;
	bh=GAUVhNxGH7uqMwlcEJwPifRHbwHtutus/xsryk7iNQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=At9BO17aKNAndzX1HOXeBp3McJoMO2AUOb1rfOMjFvPKSKPTYt1wZl9HBGlNuIjJQ
	 JjCtVPI9BFhGKLjaYTUKNyB0PwdGffJ0ZGkQfNKGSt5eMYixpQov2Ee1xj8KA/f5oC
	 scVoxl8swW0VLNeL/dYhUNywOWO2XLeiI87N+agY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Osama Abdelkader <osama.abdelkader@gmail.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 6.12 247/337] drm/panthor: reject firmware sections with oversized data
Date: Fri,  7 Aug 2026 16:37:30 +0200
Message-ID: <20260807143423.902470593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -491,6 +491,7 @@ static int panthor_fw_load_section_entry
 	struct panthor_fw_binary_section_entry_hdr hdr;
 	struct panthor_fw_section *section;
 	u32 section_size;
+	u32 data_size;
 	u32 name_len;
 	int ret;
 
@@ -541,6 +542,13 @@ static int panthor_fw_load_section_entry
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
@@ -549,7 +557,7 @@ static int panthor_fw_load_section_entry
 
 	list_add_tail(&section->node, &ptdev->fw->sections);
 	section->flags = hdr.flags;
-	section->data.size = hdr.data.end - hdr.data.start;
+	section->data.size = data_size;
 
 	if (section->data.size > 0) {
 		void *data = drmm_kmalloc(&ptdev->base, section->data.size, GFP_KERNEL);
@@ -572,7 +580,6 @@ static int panthor_fw_load_section_entry
 		section->name = name;
 	}
 
-	section_size = hdr.va.end - hdr.va.start;
 	if (section_size) {
 		u32 cache_mode = hdr.flags & CSF_FW_BINARY_IFACE_ENTRY_RD_CACHE_MODE_MASK;
 		struct panthor_gem_object *bo;


