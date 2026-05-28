Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FFC3438AE;
	Thu, 28 May 2026 20:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000762; cv=none; b=BaBbrGHp4lW9qLyU9Ak3t9JAh1+T0wgm8RQQlBPnpa9R13YVGARlE7hIFEaN6CqCZVZDnfv84I/GsH4LRyPoAujF13FBOcVL9nS4t4A0NAqFyYwu4OezrPQdygyDRcXduIznluiVq5vWoGgpVJPExEsbN2m8G7Z1Ym1YSQsCEoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000762; c=relaxed/simple;
	bh=n0dG1b1mv4vL5qwFAuInD9Rf/pGVb63Ee8qLrnIRK2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8CKJNrs2iP9LhXiOOIte+KL9+GgGAxF7KtZwkxLgNBwjl5qZyxM0damxaCSH00PvqI/CnNwp4RGozRH8PZ6Som1D6DbcmVcYwrY21SELsb73P+M9DTdZ6iUN7KoYVGGx57asP6nXjDszc5w/Uz4l7iBD3JPqoBaK2EInNea5Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=beu0Koa/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="beu0Koa/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32A81F000E9;
	Thu, 28 May 2026 20:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000761;
	bh=W21x2FO0QXXQIL2BHGWwNhG5KtF7gDEqE/WSgkWU59k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=beu0Koa/MwAGhpPJqcvYUfrt9azYHRj2E9PG17M0pjRrvcIGyG/oF0ycLXZkme47z
	 OCAxiGqqr0EsS85P9dQ+fgt9BlaXkg/JdBEvcIl/Z12lNNP87Vmaz8yp6Hyxo7KiMF
	 Yq4eDx94Snx9up7VnCI/rVn+oklVMMfifHZe/aX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/272] firmware: arm_ffa: Fix big-endian support in __ffa_partition_info_regs_get()
Date: Thu, 28 May 2026 21:48:52 +0200
Message-ID: <20260528194633.773909176@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 7bc0f589c81d62bc95f9ed142847219fc5d8ef6c ]

Currently the FF-A driver doesn't support big-endian correctly. It is
hard to regularly test the setup due to lack of test infrastructure and
tools.

In order to support full stack, we need to take small steps in getting
the support for big-endian kernel added slowly. This change fixes the
support in __ffa_partition_info_regs_get() so that the response from the
firmware are converted correctly as required. With this change, we can
enumerate all the FF-A devices correctly in the big-endian kernel if the
FFA_PARTITION_INFO_REGS_GET is supported.

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-5-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 3974ea193840 ("firmware: arm_ffa: Bound PARTITION_INFO_GET_REGS copies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index a6c5f89476c06..f033bd8ee816d 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -304,14 +304,24 @@ __ffa_partition_info_get(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 #define CURRENT_INDEX(x)	((u16)(FIELD_GET(CURRENT_INDEX_MASK, (x))))
 #define UUID_INFO_TAG(x)	((u16)(FIELD_GET(UUID_INFO_TAG_MASK, (x))))
 #define PARTITION_INFO_SZ(x)	((u16)(FIELD_GET(PARTITION_INFO_SZ_MASK, (x))))
+#define PART_INFO_ID_MASK	GENMASK(15, 0)
+#define PART_INFO_EXEC_CXT_MASK	GENMASK(31, 16)
+#define PART_INFO_PROPS_MASK	GENMASK(63, 32)
+#define PART_INFO_ID(x)		((u16)(FIELD_GET(PART_INFO_ID_MASK, (x))))
+#define PART_INFO_EXEC_CXT(x)	((u16)(FIELD_GET(PART_INFO_EXEC_CXT_MASK, (x))))
+#define PART_INFO_PROPERTIES(x)	((u32)(FIELD_GET(PART_INFO_PROPS_MASK, (x))))
 static int
 __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 			      struct ffa_partition_info *buffer, int num_parts)
 {
 	u16 buf_sz, start_idx, cur_idx, count = 0, prev_idx = 0, tag = 0;
+	struct ffa_partition_info *buf = buffer;
 	ffa_value_t partition_info;
 
 	do {
+		__le64 *regs;
+		int idx;
+
 		start_idx = prev_idx ? prev_idx + 1 : 0;
 
 		invoke_ffa_fn((ffa_value_t){
@@ -335,8 +345,25 @@ __ffa_partition_info_get_regs(u32 uuid0, u32 uuid1, u32 uuid2, u32 uuid3,
 		if (buf_sz > sizeof(*buffer))
 			buf_sz = sizeof(*buffer);
 
-		memcpy(buffer + prev_idx * buf_sz, &partition_info.a3,
-		       (cur_idx - start_idx + 1) * buf_sz);
+		regs = (void *)&partition_info.a3;
+		for (idx = 0; idx < cur_idx - start_idx + 1; idx++, buf++) {
+			union {
+				uuid_t uuid;
+				u64 regs[2];
+			} uuid_regs = {
+				.regs = {
+					le64_to_cpu(*(regs + 1)),
+					le64_to_cpu(*(regs + 2)),
+					}
+			};
+			u64 val = *(u64 *)regs;
+
+			buf->id = PART_INFO_ID(val);
+			buf->exec_ctxt = PART_INFO_EXEC_CXT(val);
+			buf->properties = PART_INFO_PROPERTIES(val);
+			uuid_copy(&buf->uuid, &uuid_regs.uuid);
+			regs += 3;
+		}
 		prev_idx = cur_idx;
 
 	} while (cur_idx < (count - 1));
-- 
2.53.0



