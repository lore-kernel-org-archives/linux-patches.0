Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65B72D9798;
	Tue, 11 Nov 2025 01:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824935; cv=none; b=kaRbsUlt9U4nFoOurXUhOd9f9P9GcyKKfeym9akN7liqmCLYpGm4c151ATNG4SXTXnuoKu/cvInnCM6mSCRyKKlGFKOiCcedJZiu2hJS9h2jgMf1ufPejeECVF4R9znn0kiCD8v2wXbDPNRfM7tNxJmXlevAxip7y6lPNr6o9Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824935; c=relaxed/simple;
	bh=AztoaQPR3MA4gGW3mfRfB5DsyL746fZvvygBoYo/8Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aYY0RW6juRwhS5Eljc2Q7DSZcDpoFNA7TVdVPn3hJnt3YjyJr4WBzI0QpfUVHhFvcQFihiMa6AwudIKhMKFu3aN9lhhbU6nXBEebTk7BSMc95W2/PVo3LmsEYnY7CKlutAGKTPHtFvYTBqubTJup07bmTLpU3ptZ+hTjd81Qi+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BiQQD2mN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BiQQD2mN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45580C16AAE;
	Tue, 11 Nov 2025 01:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824935;
	bh=AztoaQPR3MA4gGW3mfRfB5DsyL746fZvvygBoYo/8Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BiQQD2mNj4xWMYAtZWnD6fy+3+cm6HBqjrp5wTrZxsI+0jTUahVv6Tgf4yenWqsCl
	 T3ya9fxOGC6LqEQO4pdKj6tK7aiFgYQ+4sLsP+8o8KouMjqHjqwtvoFxLhOQPOp1dO
	 TqXrV+Jwl8TbBmn9n+pT5a494SrUyTTVQ7Ooh0NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongguang Gao <hongguang.gao@broadcom.com>,
	Shruti Parab <shruti.parab@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>
Subject: [PATCH 6.12 530/565] bnxt_en: Add mem_valid bit to struct bnxt_ctx_mem_type
Date: Tue, 11 Nov 2025 09:46:26 +0900
Message-ID: <20251111004538.892041139@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Shruti Parab <shruti.parab@broadcom.com>

[ Upstream commit 0b350b4927e69d66629099dbb32cad8d2d56a26d ]

Add a new bit to struct bnxt_ctx_mem_type to indicate that host
memory has been successfully allocated for this context memory type.
In the next patches, we'll be adding some additional context memory
types for FW debugging/logging.  If memory cannot be allocated for
any of these new types, we will not abort and the cleared mem_valid
bit will indicate to skip configuring the memory type.

Reviewed-by: Hongguang Gao <hongguang.gao@broadcom.com>
Signed-off-by: Shruti Parab <shruti.parab@broadcom.com>
Signed-of-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20241115151438.550106-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5204943a4c6e ("bnxt_en: Fix warning in bnxt_dl_reload_down()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 30d8e8b34dfb9..abf8984ac5e20 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8791,6 +8791,8 @@ static int bnxt_setup_ctxm_pg_tbls(struct bnxt *bp,
 		rc = bnxt_alloc_ctx_pg_tbls(bp, &ctx_pg[i], mem_size, pg_lvl,
 					    ctxm->init_value ? ctxm : NULL);
 	}
+	if (!rc)
+		ctxm->mem_valid = 1;
 	return rc;
 }
 
@@ -8861,6 +8863,8 @@ static int bnxt_backing_store_cfg_v2(struct bnxt *bp, u32 ena)
 	for (type = 0 ; type < BNXT_CTX_V2_MAX; type++) {
 		ctxm = &ctx->ctx_arr[type];
 
+		if (!ctxm->mem_valid)
+			continue;
 		rc = bnxt_hwrm_func_backing_store_cfg_v2(bp, ctxm, ctxm->last);
 		if (rc)
 			return rc;
@@ -8890,6 +8894,7 @@ void bnxt_free_ctx_mem(struct bnxt *bp)
 
 		kfree(ctx_pg);
 		ctxm->pg_info = NULL;
+		ctxm->mem_valid = 0;
 	}
 
 	ctx->flags &= ~BNXT_CTX_FLAG_INITED;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index cb934f175a3e4..d4e63bf599666 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1892,6 +1892,7 @@ struct bnxt_ctx_mem_type {
 	u32	max_entries;
 	u32	min_entries;
 	u8	last:1;
+	u8	mem_valid:1;
 	u8	split_entry_cnt;
 #define BNXT_MAX_SPLIT_ENTRY	4
 	union {
-- 
2.51.0



