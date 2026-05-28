Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBDE35C1B2;
	Thu, 28 May 2026 20:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000766; cv=none; b=k/zew1MqWRoxB4zl4m2ghKClQj6o6nA1RYAQzCf/MfODG+vSKUv7WChpdr8CvXC8TCp8sJ4UjEeZ7FN+WFBXZ0s9cou44nqqyW9LtGn0ZVjxmwBPCk0WH5jKRUH90sV75zZkxzBUoorykE/hcpGf+R0engcSWqrFjlUlXQuhRic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000766; c=relaxed/simple;
	bh=6NnDDXtCnOD+0wEWBDuH2c3T5ebEIH43OOanoQ+IAtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDyX/RcASv1V+ANSrHMubLyxhi/6RvOYS0BA2tC1KgQga/n49fymtI7D2jrndGNCIzMdDKDAMeUcwO4zAuqFB9AtdHcaxWaWDZ1ZJdPgEhVCK3TOlS5PorlHLcrAWr/CquuNYefUfYWuOUamKg8AzHjoAWWZvYsfuVW8qG2LFZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4lH8OZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4lH8OZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7C31F000E9;
	Thu, 28 May 2026 20:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000764;
	bh=G0bAvrV5mBP+5tcrvoGfq/T7j/7sQ2ZyD+Vbg3ltN6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4lH8OZ/742ELgcTsUdAGzzg235SAMkQRV6qjjSBN+otS2lLIOOUaH968cKPRg7mN
	 Lx8PrpinzSsx4LCQMIfCTnWYHTEUF+K6pz4Yk0lrCYEHyPpm916EXEmQ7MCioHO2VH
	 JM4SPvdErCHfy5XwFoxGXNK0cB5CwpdwlVc3dQjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/272] firmware: arm_ffa: Bound PARTITION_INFO_GET_REGS copies
Date: Thu, 28 May 2026 21:48:53 +0200
Message-ID: <20260528194633.799142902@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 3974ea1938406f9bfa7c1f48d4e43533f447bb08 ]

The register-based PARTITION_INFO_GET path trusted the firmware-provided
indices when copying partition descriptors into the caller buffer.
Reject inconsistent counts or index progressions so the copy loop cannot
write past the allocated array.

Fixes: ba85c644ac8d ("firmware: arm_ffa: Add support for FFA_PARTITION_INFO_GET_REGS")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-6-8595ae450034@kernel.org
(fixed cur_idx when exactly one descriptor in the first fragment)
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index f033bd8ee816d..521007bfa35a4 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -307,6 +307,12 @@ __ffa_partition_info_get(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 #define PART_INFO_ID_MASK	GENMASK(15, 0)
 #define PART_INFO_EXEC_CXT_MASK	GENMASK(31, 16)
 #define PART_INFO_PROPS_MASK	GENMASK(63, 32)
+#define FFA_PART_INFO_GET_REGS_FIRST_REG	3
+#define FFA_PART_INFO_GET_REGS_REGS_PER_DESC	3
+#define FFA_PART_INFO_GET_REGS_MAX_DESC \
+	(((sizeof(ffa_value_t) / sizeof_field(ffa_value_t, a0)) - \
+	  FFA_PART_INFO_GET_REGS_FIRST_REG) / \
+	 FFA_PART_INFO_GET_REGS_REGS_PER_DESC)
 #define PART_INFO_ID(x)		((u16)(FIELD_GET(PART_INFO_ID_MASK, (x))))
 #define PART_INFO_EXEC_CXT(x)	((u16)(FIELD_GET(PART_INFO_EXEC_CXT_MASK, (x))))
 #define PART_INFO_PROPERTIES(x)	((u32)(FIELD_GET(PART_INFO_PROPS_MASK, (x))))
@@ -314,15 +320,13 @@ static int
 __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 			      struct ffa_partition_info *buffer, int num_parts)
 {
-	u16 buf_sz, start_idx, cur_idx, count = 0, prev_idx = 0, tag = 0;
+	u16 buf_sz, start_idx = 0, cur_idx, count = 0, tag = 0;
 	struct ffa_partition_info *buf = buffer;
 	ffa_value_t partition_info;
 
 	do {
 		__le64 *regs;
-		int idx;
-
-		start_idx = prev_idx ? prev_idx + 1 : 0;
+		int idx, nr_desc, buf_idx;
 
 		invoke_ffa_fn((ffa_value_t){
 			      .a0 = FFA_PARTITION_INFO_GET_REGS,
@@ -338,15 +342,28 @@ __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 			count = PARTITION_COUNT(partition_info.a2);
 		if (!buffer || !num_parts) /* count only */
 			return count;
+		if (count > num_parts)
+			return -EINVAL;
 
 		cur_idx = CURRENT_INDEX(partition_info.a2);
+		if (cur_idx < start_idx || cur_idx >= count)
+			return -EINVAL;
+
+		nr_desc = cur_idx - start_idx + 1;
+		if (nr_desc > FFA_PART_INFO_GET_REGS_MAX_DESC)
+			return -EINVAL;
+
+		buf_idx = buf - buffer;
+		if (buf_idx + nr_desc > num_parts)
+			return -EINVAL;
+
 		tag = UUID_INFO_TAG(partition_info.a2);
 		buf_sz = PARTITION_INFO_SZ(partition_info.a2);
 		if (buf_sz > sizeof(*buffer))
 			buf_sz = sizeof(*buffer);
 
 		regs = (void *)&partition_info.a3;
-		for (idx = 0; idx < cur_idx - start_idx + 1; idx++, buf++) {
+		for (idx = 0; idx < nr_desc; idx++, buf++) {
 			union {
 				uuid_t uuid;
 				u64 regs[2];
@@ -364,7 +381,7 @@ __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 			uuid_copy(&buf->uuid, &uuid_regs.uuid);
 			regs += 3;
 		}
-		prev_idx = cur_idx;
+		start_idx = cur_idx + 1;
 
 	} while (cur_idx < (count - 1));
 
-- 
2.53.0



