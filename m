Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B92198E85;
	Thu,  5 Sep 2024 09:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529808; cv=none; b=oy/aFedosZCLU9/bSgumDWIncUgYg/Xr1UFr8kQmA8hXyXdPrNKcG3MWPTNvxWXf3eZ8DP90ap+t2FbMTVBpw7oG5nQyl2FMPv9P2biD7MWn6KmbOsatUXfrLnp6GhcQY6WHNME+SKmpo4IYN4BE0IGZrHd8WF4Mm1cnZ5cJOao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529808; c=relaxed/simple;
	bh=OLpbNGw35A6aIGGNI84Y8LIcdiyM02aXK4gvEnMtKx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqREyHjPzS/Sg5axZc9HDAC5jq+AsgpfBTfjIucQdvFk2/6uv5ZAko2fu6hb2zeRrYzwOtGOUIznecPFd/ArsJwGWh55drEF/lhPbLnXNu/CXkC2VYMGhIEBnfGSZNygSqZoydQR8sbAOkcEQWyLpF2cAIKvj9Qu/l5bcG4jeJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HKNITeAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HKNITeAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61639C4CEC3;
	Thu,  5 Sep 2024 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529807;
	bh=OLpbNGw35A6aIGGNI84Y8LIcdiyM02aXK4gvEnMtKx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HKNITeAipgKp1BCroEnVTscBvwz/u95UajI+vf4NLG305vUhMHarNcDP9S6f4lfiS
	 eOlrLB8OR/e4s1wrjOEZxFfhFF2j38avuMVrMQ5OvLuYk+0cg9rcFWJsL/Ehf78DrQ
	 LudVco99b3her8/nsM4rEB2clt6zTFOLIYMQKuEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Allen <john.allen@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 148/184] RAS/AMD/ATL: Validate address map when information is gathered
Date: Thu,  5 Sep 2024 11:41:01 +0200
Message-ID: <20240905093738.114235161@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Allen <john.allen@amd.com>

[ Upstream commit d5811a165caf63a69cd8ae11156b8587cc57d1d1 ]

Validate address maps at the time the information is gathered as the
address map will not change during translation.

Signed-off-by: John Allen <john.allen@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Link: https://lore.kernel.org/r/20240606203313.51197-5-john.allen@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ras/amd/atl/dehash.c | 43 --------------------
 drivers/ras/amd/atl/map.c    | 77 ++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 43 deletions(-)

diff --git a/drivers/ras/amd/atl/dehash.c b/drivers/ras/amd/atl/dehash.c
index 4ea46262c4f5..d4ee7ecabaee 100644
--- a/drivers/ras/amd/atl/dehash.c
+++ b/drivers/ras/amd/atl/dehash.c
@@ -12,41 +12,10 @@
 
 #include "internal.h"
 
-/*
- * Verify the interleave bits are correct in the different interleaving
- * settings.
- *
- * If @num_intlv_dies and/or @num_intlv_sockets are 1, it means the
- * respective interleaving is disabled.
- */
-static inline bool map_bits_valid(struct addr_ctx *ctx, u8 bit1, u8 bit2,
-				  u8 num_intlv_dies, u8 num_intlv_sockets)
-{
-	if (!(ctx->map.intlv_bit_pos == bit1 || ctx->map.intlv_bit_pos == bit2)) {
-		pr_debug("Invalid interleave bit: %u", ctx->map.intlv_bit_pos);
-		return false;
-	}
-
-	if (ctx->map.num_intlv_dies > num_intlv_dies) {
-		pr_debug("Invalid number of interleave dies: %u", ctx->map.num_intlv_dies);
-		return false;
-	}
-
-	if (ctx->map.num_intlv_sockets > num_intlv_sockets) {
-		pr_debug("Invalid number of interleave sockets: %u", ctx->map.num_intlv_sockets);
-		return false;
-	}
-
-	return true;
-}
-
 static int df2_dehash_addr(struct addr_ctx *ctx)
 {
 	u8 hashed_bit, intlv_bit, intlv_bit_pos;
 
-	if (!map_bits_valid(ctx, 8, 9, 1, 1))
-		return -EINVAL;
-
 	intlv_bit_pos = ctx->map.intlv_bit_pos;
 	intlv_bit = !!(BIT_ULL(intlv_bit_pos) & ctx->ret_addr);
 
@@ -67,9 +36,6 @@ static int df3_dehash_addr(struct addr_ctx *ctx)
 	bool hash_ctl_64k, hash_ctl_2M, hash_ctl_1G;
 	u8 hashed_bit, intlv_bit, intlv_bit_pos;
 
-	if (!map_bits_valid(ctx, 8, 9, 1, 1))
-		return -EINVAL;
-
 	hash_ctl_64k = FIELD_GET(DF3_HASH_CTL_64K, ctx->map.ctl);
 	hash_ctl_2M  = FIELD_GET(DF3_HASH_CTL_2M, ctx->map.ctl);
 	hash_ctl_1G  = FIELD_GET(DF3_HASH_CTL_1G, ctx->map.ctl);
@@ -171,9 +137,6 @@ static int df4_dehash_addr(struct addr_ctx *ctx)
 	bool hash_ctl_64k, hash_ctl_2M, hash_ctl_1G;
 	u8 hashed_bit, intlv_bit;
 
-	if (!map_bits_valid(ctx, 8, 8, 1, 2))
-		return -EINVAL;
-
 	hash_ctl_64k = FIELD_GET(DF4_HASH_CTL_64K, ctx->map.ctl);
 	hash_ctl_2M  = FIELD_GET(DF4_HASH_CTL_2M, ctx->map.ctl);
 	hash_ctl_1G  = FIELD_GET(DF4_HASH_CTL_1G, ctx->map.ctl);
@@ -247,9 +210,6 @@ static int df4p5_dehash_addr(struct addr_ctx *ctx)
 	u8 hashed_bit, intlv_bit;
 	u64 rehash_vector;
 
-	if (!map_bits_valid(ctx, 8, 8, 1, 2))
-		return -EINVAL;
-
 	hash_ctl_64k = FIELD_GET(DF4_HASH_CTL_64K, ctx->map.ctl);
 	hash_ctl_2M  = FIELD_GET(DF4_HASH_CTL_2M, ctx->map.ctl);
 	hash_ctl_1G  = FIELD_GET(DF4_HASH_CTL_1G, ctx->map.ctl);
@@ -360,9 +320,6 @@ static int mi300_dehash_addr(struct addr_ctx *ctx)
 	bool hashed_bit, intlv_bit, test_bit;
 	u8 num_intlv_bits, base_bit, i;
 
-	if (!map_bits_valid(ctx, 8, 8, 4, 1))
-		return -EINVAL;
-
 	hash_ctl_4k  = FIELD_GET(DF4p5_HASH_CTL_4K, ctx->map.ctl);
 	hash_ctl_64k = FIELD_GET(DF4_HASH_CTL_64K,  ctx->map.ctl);
 	hash_ctl_2M  = FIELD_GET(DF4_HASH_CTL_2M,   ctx->map.ctl);
diff --git a/drivers/ras/amd/atl/map.c b/drivers/ras/amd/atl/map.c
index 8b908e8d7495..04419923f088 100644
--- a/drivers/ras/amd/atl/map.c
+++ b/drivers/ras/amd/atl/map.c
@@ -642,6 +642,79 @@ static int get_global_map_data(struct addr_ctx *ctx)
 	return 0;
 }
 
+/*
+ * Verify the interleave bits are correct in the different interleaving
+ * settings.
+ *
+ * If @num_intlv_dies and/or @num_intlv_sockets are 1, it means the
+ * respective interleaving is disabled.
+ */
+static inline bool map_bits_valid(struct addr_ctx *ctx, u8 bit1, u8 bit2,
+				  u8 num_intlv_dies, u8 num_intlv_sockets)
+{
+	if (!(ctx->map.intlv_bit_pos == bit1 || ctx->map.intlv_bit_pos == bit2)) {
+		pr_debug("Invalid interleave bit: %u", ctx->map.intlv_bit_pos);
+		return false;
+	}
+
+	if (ctx->map.num_intlv_dies > num_intlv_dies) {
+		pr_debug("Invalid number of interleave dies: %u", ctx->map.num_intlv_dies);
+		return false;
+	}
+
+	if (ctx->map.num_intlv_sockets > num_intlv_sockets) {
+		pr_debug("Invalid number of interleave sockets: %u", ctx->map.num_intlv_sockets);
+		return false;
+	}
+
+	return true;
+}
+
+static int validate_address_map(struct addr_ctx *ctx)
+{
+	switch (ctx->map.intlv_mode) {
+	case DF2_2CHAN_HASH:
+	case DF3_COD4_2CHAN_HASH:
+	case DF3_COD2_4CHAN_HASH:
+	case DF3_COD1_8CHAN_HASH:
+		if (!map_bits_valid(ctx, 8, 9, 1, 1))
+			goto err;
+		break;
+
+	case DF4_NPS4_2CHAN_HASH:
+	case DF4_NPS2_4CHAN_HASH:
+	case DF4_NPS1_8CHAN_HASH:
+	case DF4p5_NPS4_2CHAN_1K_HASH:
+	case DF4p5_NPS4_2CHAN_2K_HASH:
+	case DF4p5_NPS2_4CHAN_1K_HASH:
+	case DF4p5_NPS2_4CHAN_2K_HASH:
+	case DF4p5_NPS1_8CHAN_1K_HASH:
+	case DF4p5_NPS1_8CHAN_2K_HASH:
+	case DF4p5_NPS1_16CHAN_1K_HASH:
+	case DF4p5_NPS1_16CHAN_2K_HASH:
+		if (!map_bits_valid(ctx, 8, 8, 1, 2))
+			goto err;
+		break;
+
+	case MI3_HASH_8CHAN:
+	case MI3_HASH_16CHAN:
+	case MI3_HASH_32CHAN:
+		if (!map_bits_valid(ctx, 8, 8, 4, 1))
+			goto err;
+		break;
+
+	/* Nothing to do for modes that don't need special validation checks. */
+	default:
+		break;
+	}
+
+	return 0;
+
+err:
+	atl_debug(ctx, "Inconsistent address map");
+	return -EINVAL;
+}
+
 static void dump_address_map(struct dram_addr_map *map)
 {
 	u8 i;
@@ -678,5 +751,9 @@ int get_address_map(struct addr_ctx *ctx)
 
 	dump_address_map(&ctx->map);
 
+	ret = validate_address_map(ctx);
+	if (ret)
+		return ret;
+
 	return ret;
 }
-- 
2.43.0



