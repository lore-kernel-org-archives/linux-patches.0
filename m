Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113463D411F;
	Wed,  8 Apr 2026 18:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672972; cv=none; b=r+NJ/5EfvCn7RPWs9EnokGbxiPxZ2ev1Kk/nYj+ISa/PguMLOQk1Fcul9ei3nIsipMqI9Jj99CFhZNNNaUgncKMHJ0CbnQASsdjmDahBLWkB9CDXxXC37LQf9/igDg4Tv9BZ2CGjHBJljKA2+QXhGNS4+qzOMOobiDUZOaePXSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672972; c=relaxed/simple;
	bh=4HMTr1SuL2uu4kJENCcJGboShPtj1dGsmIfysjlvEPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPNSYLsIO8RzKtyuwzOGkOQH98iNzpMmNoR5ZQn7pxiZ2JGcbqU9BmMyhz2zSI61JwQ4zsBHNS2oSnDbY2dWSQs3EtuuIqHXnSwnQrqZnf512UXVAqR2kwnqxPKpTmv3JtrWNzjzEhjbHCDcOidSasfJLJNfcoRBAqjRGyjpBJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOaC7LZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOaC7LZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97327C19421;
	Wed,  8 Apr 2026 18:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672971;
	bh=4HMTr1SuL2uu4kJENCcJGboShPtj1dGsmIfysjlvEPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nOaC7LZ3DgSoFctl9st6hC/xm7F8QFQp9LLFqfgTUo6opfRn2D9/uzC+c3zyBB67/
	 h5e8K2FzZ5JynCDPWSCkbhIxrSSqed/hhP96RnjzOJvbROrdZOk5p9USqUv8S7fPP+
	 fTYpYszN8/rFvpVto9JfLVjtifpuoPqFejfIiWzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/277] bnxt_en: set backing store type from query type
Date: Wed,  8 Apr 2026 20:00:37 +0200
Message-ID: <20260408175935.801867334@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 4ee937107d52f9e5c350e4b5e629760e328b3d9f ]

bnxt_hwrm_func_backing_store_qcaps_v2() stores resp->type from the
firmware response in ctxm->type and later uses that value to index
fixed backing-store metadata arrays such as ctx_arr[] and
bnxt_bstore_to_trace[].

ctxm->type is fixed by the current backing-store query type and matches
the array index of ctx->ctx_arr. Set ctxm->type from the current loop
variable instead of depending on resp->type.

Also update the loop to advance type from next_valid_type in the for
statement, which keeps the control flow simpler for non-valid and
unchanged entries.

Fixes: 6a4d0774f02d ("bnxt_en: Add support for new backing store query firmware API")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Tested-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260328234357.43669-1-pengpeng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e9f40ca8bb4fb..04aa5d9eb8513 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8607,7 +8607,7 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
 	struct hwrm_func_backing_store_qcaps_v2_output *resp;
 	struct hwrm_func_backing_store_qcaps_v2_input *req;
 	struct bnxt_ctx_mem_info *ctx = bp->ctx;
-	u16 type;
+	u16 type, next_type = 0;
 	int rc;
 
 	rc = hwrm_req_init(bp, req, HWRM_FUNC_BACKING_STORE_QCAPS_V2);
@@ -8623,7 +8623,7 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
 
 	resp = hwrm_req_hold(bp, req);
 
-	for (type = 0; type < BNXT_CTX_V2_MAX; ) {
+	for (type = 0; type < BNXT_CTX_V2_MAX; type = next_type) {
 		struct bnxt_ctx_mem_type *ctxm = &ctx->ctx_arr[type];
 		u8 init_val, init_off, i;
 		u32 max_entries;
@@ -8636,7 +8636,7 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
 		if (rc)
 			goto ctx_done;
 		flags = le32_to_cpu(resp->flags);
-		type = le16_to_cpu(resp->next_valid_type);
+		next_type = le16_to_cpu(resp->next_valid_type);
 		if (!(flags & BNXT_CTX_MEM_TYPE_VALID)) {
 			bnxt_free_one_ctx_mem(bp, ctxm, true);
 			continue;
@@ -8651,7 +8651,7 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
 			else
 				continue;
 		}
-		ctxm->type = le16_to_cpu(resp->type);
+		ctxm->type = type;
 		ctxm->entry_size = entry_size;
 		ctxm->flags = flags;
 		ctxm->instance_bmap = le32_to_cpu(resp->instance_bit_map);
-- 
2.53.0



