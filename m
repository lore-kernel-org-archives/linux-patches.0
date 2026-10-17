Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012554CF477;
	Sat, 17 Oct 2026 16:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253741; cv=none; b=sgwGytD3ZWpQxHGyyb61WC98/iC2qALj0iGttYN41kMUy1Dr8Ic9Be6rcwFxsXAq6w4u8AE5+5eyH+JH2XfNkQh8ctzp+5Bijbon28qn/ZkFE8TW4fM8V+5IKw8yCY7D2FNTOfMNJZrhwCcTZsQsykfsf2282kF+McE0a02vQ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253741; c=relaxed/simple;
	bh=4Gr6xSNhATGj+e2yAU4lg2J2xvQE5V4YFz3FMXb9CyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmEoK+BkEiPZBMZTcQDL0f3eH0E5sr97BIKTUltLVHnRVuTGVan1XnWzi0ghTa4lau4XTxykv99GRvi+wK2w5eWLwJxiFD9lxlGdf9AOMiFN46veALsPCKIRJ2bEPVQ5A1+vpdxdsFGCXqHnkGDxsGuWLJHZx0GU0lIj1GIRdGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xi84uNrr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xi84uNrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BB71F000C4;
	Sat, 17 Oct 2026 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253739;
	bh=5VgyT5/2MeuTZfhi6FIJLAuXMP63l4fQz85+cFwX8Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xi84uNrrchtH668o4qbcO6pBEcgTAHJ+ybWyXdQyLdpgpXBmsN0D2tHZfckRu+Aht
	 GOkzxicykcfUx8xPkfm+gAN07572ZzKVNpiLH+/XYQCIGc9S2VagUJimHEAJHRZwoH
	 Yx9/BgRstdcGzWkhvnRDP7/2VNYL1yUUO0vigIUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/869] bnxt_en: set backing store type from query type
Date: Sat, 17 Oct 2026 17:50:59 +0200
Message-ID: <20261017160042.642547975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index ef2462e94b3f7..867be7b4142b2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8379,7 +8379,7 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
 	struct hwrm_func_backing_store_qcaps_v2_output *resp;
 	struct hwrm_func_backing_store_qcaps_v2_input *req;
 	struct bnxt_ctx_mem_info *ctx = bp->ctx;
-	u16 type;
+	u16 type, next_type = 0;
 	int rc;
 
 	rc = hwrm_req_init(bp, req, HWRM_FUNC_BACKING_STORE_QCAPS_V2);
@@ -8395,7 +8395,7 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
 
 	resp = hwrm_req_hold(bp, req);
 
-	for (type = 0; type < BNXT_CTX_V2_MAX; ) {
+	for (type = 0; type < BNXT_CTX_V2_MAX; type = next_type) {
 		struct bnxt_ctx_mem_type *ctxm = &ctx->ctx_arr[type];
 		u8 init_val, init_off, i;
 		__le32 *p;
@@ -8406,11 +8406,11 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
 		if (rc)
 			goto ctx_done;
 		flags = le32_to_cpu(resp->flags);
-		type = le16_to_cpu(resp->next_valid_type);
+		next_type = le16_to_cpu(resp->next_valid_type);
 		if (!(flags & FUNC_BACKING_STORE_QCAPS_V2_RESP_FLAGS_TYPE_VALID))
 			continue;
 
-		ctxm->type = le16_to_cpu(resp->type);
+		ctxm->type = type;
 		ctxm->entry_size = le16_to_cpu(resp->entry_size);
 		ctxm->flags = flags;
 		ctxm->instance_bmap = le32_to_cpu(resp->instance_bit_map);
-- 
2.53.0



