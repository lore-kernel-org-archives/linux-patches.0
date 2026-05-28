Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2260E22652D;
	Thu, 28 May 2026 20:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999782; cv=none; b=bOSX9Mr2lzt7077RqGBIQTPDRr3/8puE1sTBxxUgSpdFTkKqxnlLXh0AubL/+GDh+papGROCf/fuVOVuFyCBmbPkJHgIfoGZg0sIQnjwoOh06Mz5N0M6MseNxPhpY0s0iJgszHWNFrEXGLBxKT1PHDo1J+y0MbsqwZdKTLSpsnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999782; c=relaxed/simple;
	bh=hcJb2f4/7n6lUkiyOl2ZAkd36BC10ly9WOjw3+MfDiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlmklTNB3GcGD1oi2oVb36JucEDiYWMtHEN2K2tWRZjIWMutjhXc1TFantEq0AKFNAIc5FauyVkzFVzON6lQpRw3a8oLmJ98vp0DzkEJ2tg80AUibiu3+/yUTTebF4TjvQoRuStIvy2CmRK5GKemTL5JPHgqsBeqRoSJzSUCaSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JWBHrtKC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JWBHrtKC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2D61F000E9;
	Thu, 28 May 2026 20:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999781;
	bh=iKLCSlJ1yeaz3ahaYXiCbh5Ij/w6S10Z/Gywg0cSGhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JWBHrtKCDw7fkTuIr/4xC9KDLAYemId2LOyxTZNU5NP7pBRkbV40q2M8Q4thCwsIU
	 wF2PuZaRTzqNETve88pn6drNsK7TKQy4LfKiz1LDXEyAgT1SXG4Pg+5qunVk0OBGXj
	 5lW/9kPNMVnoNJCh0cU2dZM8cNytGrcRPiW5R9jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/377] firmware: arm_ffa: Bound PARTITION_INFO_GET_REGS copies
Date: Thu, 28 May 2026 21:47:06 +0200
Message-ID: <20260528194643.859314194@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
index 287db85286106..e597a9cf64dc9 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -319,6 +319,12 @@ __ffa_partition_info_get(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
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
@@ -326,15 +332,13 @@ static int
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
@@ -350,15 +354,28 @@ __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
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
@@ -376,7 +393,7 @@ __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 			uuid_copy(&buf->uuid, &uuid_regs.uuid);
 			regs += 3;
 		}
-		prev_idx = cur_idx;
+		start_idx = cur_idx + 1;
 
 	} while (cur_idx < (count - 1));
 
-- 
2.53.0



