Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8462403AFB;
	Tue, 21 Jul 2026 17:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655851; cv=none; b=WFxbHcPZvs+jP1qLnf0g+dAPx054/di/4561eLXC0MWt49N+eh2QPTSTNLWtNIHcz4T+mWmDNUpPdxlZta07KfAeD8tsu6izJA7NFBkSBpH3H/fsCbMbbr+BT0ZXvXB2dsjwm9PB6VCVFkywVtMELmkJvXNqx5H5sK1I+qReHSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655851; c=relaxed/simple;
	bh=6omWyBy0Bu2t3TALSJpihLk4fudmKGbwByrG1nYa4fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEiClOZP6wLN0i528FaeHqgjP8ASMv7SmArvSHezcV8p+jhqVkKxu/RfE+1rPip+5NFOvPYphhxBcwUDtKSM4Nig+Nrc9RbdpcBPQE+fafmiugN2ichstyVcxJ1KQKJys/6+y4cOcZ/P5mza+VEduLm6jyQxxS8O1KfB8pW47+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMyhkGOG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMyhkGOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77461F00A3A;
	Tue, 21 Jul 2026 17:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655850;
	bh=uW6VHk/0s0W5o/VwKnTXPZmCYXjtBEEi6yqHFRV8eBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SMyhkGOG3KpxJSpPsXYKIlu6tb8fLv7Of3RvklCSNv2/ZE/YL5yUcpCLn93N/SCLW
	 0pqhnSBn0Lg/JGjtNxfJKwpNAaHfufVZqKoi0pE23qomWOhnEcd+FrBIYcGSFqsjSm
	 d44bLPDAll0RLVUiDaZlDPNTPuxCq/DMg+njXZUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Jamie Nguyen <jamien@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0165/1611] firmware: arm_ffa: Honor partition info descriptor size
Date: Tue, 21 Jul 2026 17:04:41 +0200
Message-ID: <20260721152518.597200085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jamie Nguyen <jamien@nvidia.com>

[ Upstream commit 01b9cae706161a39452a2cce0f281d4369344c51 ]

FFA_PARTITION_INFO_GET_REGS reports the size of each partition
information descriptor in x2[63:48]. However, __ffa_partition_info_get_regs()
walks the returned register payload with a hardcoded 24-byte stride
(regs += 3), even though the size is already read into buf_sz.

That works for the FF-A v1.1/v1.2 24-byte descriptor layout, where each
descriptor consumes three registers. Newer FF-A revisions can extend the
descriptor while keeping the existing fields at the front. For example, a
48-byte descriptor consumes six registers, so advancing by only three
registers desynchronises the parser and can make it read subsequent entries
from the middle of a descriptor.

Use the advertised descriptor size to derive the register stride. Validate
that the size is register-aligned, large enough for the fields parsed by the
driver, and that the requested number of descriptors fits in the returned
x3..x17 register window. The driver still copies only the fields it
understands, but now skips over any trailing descriptor fields correctly.

Fixes: ba85c644ac8d ("firmware: arm_ffa: Add support for FFA_PARTITION_INFO_GET_REGS")
Suggested-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Jamie Nguyen <jamien@nvidia.com>
Link: https://patch.msgid.link/20260518203116.42624-1-jamien@nvidia.com
(sudeep.holla: Minor rewordng of the commit message and subject)
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 827aac08a8e9e4..3fbc75caf0c506 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -320,11 +320,9 @@ __ffa_partition_info_get(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 #define PART_INFO_EXEC_CXT_MASK	GENMASK(31, 16)
 #define PART_INFO_PROPS_MASK	GENMASK(63, 32)
 #define FFA_PART_INFO_GET_REGS_FIRST_REG	3
-#define FFA_PART_INFO_GET_REGS_REGS_PER_DESC	3
-#define FFA_PART_INFO_GET_REGS_MAX_DESC \
-	(((sizeof(ffa_value_t) / sizeof_field(ffa_value_t, a0)) - \
-	  FFA_PART_INFO_GET_REGS_FIRST_REG) / \
-	 FFA_PART_INFO_GET_REGS_REGS_PER_DESC)
+#define FFA_PART_INFO_GET_REGS_MIN_REGS_PER_DESC	3
+#define FFA_PART_INFO_GET_REGS_NUM_REGS \
+	(sizeof(ffa_value_t) / sizeof_field(ffa_value_t, a0))
 #define PART_INFO_ID(x)		((u16)(FIELD_GET(PART_INFO_ID_MASK, (x))))
 #define PART_INFO_EXEC_CXT(x)	((u16)(FIELD_GET(PART_INFO_EXEC_CXT_MASK, (x))))
 #define PART_INFO_PROPERTIES(x)	((u32)(FIELD_GET(PART_INFO_PROPS_MASK, (x))))
@@ -338,7 +336,7 @@ __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 
 	do {
 		__le64 *regs;
-		int idx, nr_desc, buf_idx;
+		int idx, nr_desc, buf_idx, regs_per_desc, max_desc;
 
 		invoke_ffa_fn((ffa_value_t){
 			      .a0 = FFA_PARTITION_INFO_GET_REGS,
@@ -361,8 +359,18 @@ __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 		if (cur_idx < start_idx || cur_idx >= count)
 			return -EINVAL;
 
+		buf_sz = PARTITION_INFO_SZ(partition_info.a2);
+		if (buf_sz % sizeof(*regs))
+			return -EINVAL;
+
+		regs_per_desc = buf_sz / sizeof(*regs);
+		if (regs_per_desc < FFA_PART_INFO_GET_REGS_MIN_REGS_PER_DESC)
+			return -EINVAL;
+
 		nr_desc = cur_idx - start_idx + 1;
-		if (nr_desc > FFA_PART_INFO_GET_REGS_MAX_DESC)
+		max_desc = (FFA_PART_INFO_GET_REGS_NUM_REGS -
+			    FFA_PART_INFO_GET_REGS_FIRST_REG) / regs_per_desc;
+		if (nr_desc > max_desc)
 			return -EINVAL;
 
 		buf_idx = buf - buffer;
@@ -370,9 +378,6 @@ __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 			return -EINVAL;
 
 		tag = UUID_INFO_TAG(partition_info.a2);
-		buf_sz = PARTITION_INFO_SZ(partition_info.a2);
-		if (buf_sz > sizeof(*buffer))
-			buf_sz = sizeof(*buffer);
 
 		regs = (void *)&partition_info.a3;
 		for (idx = 0; idx < nr_desc; idx++, buf++) {
@@ -391,7 +396,7 @@ __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 			buf->exec_ctxt = PART_INFO_EXEC_CXT(val);
 			buf->properties = PART_INFO_PROPERTIES(val);
 			uuid_copy(&buf->uuid, &uuid_regs.uuid);
-			regs += 3;
+			regs += regs_per_desc;
 		}
 		start_idx = cur_idx + 1;
 
-- 
2.53.0



