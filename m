Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D584E246BB7;
	Mon, 27 Oct 2025 19:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593509; cv=none; b=YANRf62pwk5/hx++UcQk4ANvHB2RgznZSwbUAudKx+QWapPkzv/zDJZnscAiAyhIB/+avbCp4mbbC2vqw8TLD1hoWzbWTHDhkM0Pl4gyL3jV3bUFnxihcRSuPDVwSPGYt5shx91NBgn8TBw3NjpamiL1QDd5sczYV2ExjKae3VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593509; c=relaxed/simple;
	bh=kEJJzGHETXJsYva09VPuI+NFZZEmccEJHRO4QFZ0VBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGqORjXZPl6y9CuhvISCViOKWO5d7ffhmlP1PiDqNH6t/8C3o8qf+fzGWEaJsU66vGteT1NMTC8rIveKCegItpP/ucOuZkpfxOQX/XXB8mumR2HH5QLmlN6Inujc/Zwq9q//EhNiUQ7xqmXHjEMKbtkgyM8zBd35HEx4WDxWnyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0h5J7MX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0h5J7MX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50EA0C116C6;
	Mon, 27 Oct 2025 19:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593509;
	bh=kEJJzGHETXJsYva09VPuI+NFZZEmccEJHRO4QFZ0VBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0h5J7MXNH40STCztqO6e6YM5iiIu5J2d1GW3ELiGoJKXKn0VMvbxDdAIxmOoAwDQ
	 muL0Y9GJDxM2HCcFD2DrqDvw0fB25wJXQU4NNIGmfONgYIHa6vjWm4QEzzR+rHD1g7
	 lkPyO7VW8xdN+ZVVV1gDSy+W/GInEJXAtVhqESXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lixiang Mao <liximao@qti.qualcomm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 115/184] firmware: arm_ffa: Add support for IMPDEF value in the memory access descriptor
Date: Mon, 27 Oct 2025 19:36:37 +0100
Message-ID: <20251027183518.035864654@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 11fb1a82aefa6f7fea6ac82334edb5639b9927df ]

FF-A v1.2 introduced 16 byte IMPLEMENTATION DEFINED value in the endpoint
memory access descriptor to allow any sender could to specify an its any
custom value for each receiver. Also this value must be specified by the
receiver when retrieving the memory region. The sender must ensure it
informs the receiver of this value via an IMPLEMENTATION DEFINED mechanism
such as a partition message.

So the FF-A driver can use the message interfaces to communicate the value
and set the same in the ffa_mem_region_attributes structures when using
the memory interfaces.

The driver ensure that the size of the endpoint memory access descriptors
is set correctly based on the FF-A version.

Fixes: 9fac08d9d985 ("firmware: arm_ffa: Upgrade FF-A version to v1.2 in the driver")
Reported-by: Lixiang Mao <liximao@qti.qualcomm.com>
Tested-by: Lixiang Mao <liximao@qti.qualcomm.com>
Message-Id: <20250923150927.1218364-1-sudeep.holla@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 37 ++++++++++++++++++++++---------
 include/linux/arm_ffa.h           | 21 ++++++++++++++++--
 2 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 65bf1685350a2..c72ee47565856 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -649,6 +649,26 @@ static u16 ffa_memory_attributes_get(u32 func_id)
 	return FFA_MEM_NORMAL | FFA_MEM_WRITE_BACK | FFA_MEM_INNER_SHAREABLE;
 }
 
+static void ffa_emad_impdef_value_init(u32 version, void *dst, void *src)
+{
+	struct ffa_mem_region_attributes *ep_mem_access;
+
+	if (FFA_EMAD_HAS_IMPDEF_FIELD(version))
+		memcpy(dst, src, sizeof(ep_mem_access->impdef_val));
+}
+
+static void
+ffa_mem_region_additional_setup(u32 version, struct ffa_mem_region *mem_region)
+{
+	if (!FFA_MEM_REGION_HAS_EP_MEM_OFFSET(version)) {
+		mem_region->ep_mem_size = 0;
+	} else {
+		mem_region->ep_mem_size = ffa_emad_size_get(version);
+		mem_region->ep_mem_offset = sizeof(*mem_region);
+		memset(mem_region->reserved, 0, 12);
+	}
+}
+
 static int
 ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 		       struct ffa_mem_ops_args *args)
@@ -667,27 +687,24 @@ ffa_setup_and_transmit(u32 func_id, void *buffer, u32 max_fragsize,
 	mem_region->flags = args->flags;
 	mem_region->sender_id = drv_info->vm_id;
 	mem_region->attributes = ffa_memory_attributes_get(func_id);
-	ep_mem_access = buffer +
-			ffa_mem_desc_offset(buffer, 0, drv_info->version);
 	composite_offset = ffa_mem_desc_offset(buffer, args->nattrs,
 					       drv_info->version);
 
-	for (idx = 0; idx < args->nattrs; idx++, ep_mem_access++) {
+	for (idx = 0; idx < args->nattrs; idx++) {
+		ep_mem_access = buffer +
+			ffa_mem_desc_offset(buffer, idx, drv_info->version);
 		ep_mem_access->receiver = args->attrs[idx].receiver;
 		ep_mem_access->attrs = args->attrs[idx].attrs;
 		ep_mem_access->composite_off = composite_offset;
 		ep_mem_access->flag = 0;
 		ep_mem_access->reserved = 0;
+		ffa_emad_impdef_value_init(drv_info->version,
+					   ep_mem_access->impdef_val,
+					   args->attrs[idx].impdef_val);
 	}
 	mem_region->handle = 0;
 	mem_region->ep_count = args->nattrs;
-	if (drv_info->version <= FFA_VERSION_1_0) {
-		mem_region->ep_mem_size = 0;
-	} else {
-		mem_region->ep_mem_size = sizeof(*ep_mem_access);
-		mem_region->ep_mem_offset = sizeof(*mem_region);
-		memset(mem_region->reserved, 0, 12);
-	}
+	ffa_mem_region_additional_setup(drv_info->version, mem_region);
 
 	composite = buffer + composite_offset;
 	composite->total_pg_cnt = ffa_get_num_pages_sg(args->sg);
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index e1634897e159c..effa4d5e0242d 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -337,6 +337,7 @@ struct ffa_mem_region_attributes {
 	 * an `struct ffa_mem_region_addr_range`.
 	 */
 	u32 composite_off;
+	u8 impdef_val[16];
 	u64 reserved;
 };
 
@@ -416,15 +417,31 @@ struct ffa_mem_region {
 #define CONSTITUENTS_OFFSET(x)	\
 	(offsetof(struct ffa_composite_mem_region, constituents[x]))
 
+#define FFA_EMAD_HAS_IMPDEF_FIELD(version)	((version) >= FFA_VERSION_1_2)
+#define FFA_MEM_REGION_HAS_EP_MEM_OFFSET(version) ((version) > FFA_VERSION_1_0)
+
+static inline u32 ffa_emad_size_get(u32 ffa_version)
+{
+	u32 sz;
+	struct ffa_mem_region_attributes *ep_mem_access;
+
+	if (FFA_EMAD_HAS_IMPDEF_FIELD(ffa_version))
+		sz = sizeof(*ep_mem_access);
+	else
+		sz = sizeof(*ep_mem_access) - sizeof(ep_mem_access->impdef_val);
+
+	return sz;
+}
+
 static inline u32
 ffa_mem_desc_offset(struct ffa_mem_region *buf, int count, u32 ffa_version)
 {
-	u32 offset = count * sizeof(struct ffa_mem_region_attributes);
+	u32 offset = count * ffa_emad_size_get(ffa_version);
 	/*
 	 * Earlier to v1.1, the endpoint memory descriptor array started at
 	 * offset 32(i.e. offset of ep_mem_offset in the current structure)
 	 */
-	if (ffa_version <= FFA_VERSION_1_0)
+	if (!FFA_MEM_REGION_HAS_EP_MEM_OFFSET(ffa_version))
 		offset += offsetof(struct ffa_mem_region, ep_mem_offset);
 	else
 		offset += sizeof(struct ffa_mem_region);
-- 
2.51.0



