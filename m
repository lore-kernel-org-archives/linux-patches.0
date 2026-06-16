Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A001E8320;
	Tue, 16 Jun 2026 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623439; cv=none; b=HT+IO9nQmYySnkkdxMEg5TEDs+unWIKoMT+CtzjDhP8rOed9MI5VyzoFu54MS+HjIJ2WG/p1W7fvuq1Jg//WUDErgLuoccs0kf2wjyYSOqEsQHOizDTaD/ojAh08/iVMe8hgz7ljjMOuikQbk2yFpcTEXNT1DdL4RAYoSNVPb/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623439; c=relaxed/simple;
	bh=y+/272BZKLprXG14fXgX6yO2FJfR2CMNIBQK5NoThAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQl4vxiVtMHLvrYjt8t7a41cMfS+FZd4c9vdqCOYot1wXjreV0G8pakFGrBZJAKOTedydU7sx+tN6K6rU/MUhG0dwHtr4dJnX3+5Xj07gNWLX0GVaLDtEkvYuMFIl+sdeNO9PmNqtge5wpEYmQpHkr9g/3I85vHfUGQLwBREz8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTDUCtY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTDUCtY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3961F000E9;
	Tue, 16 Jun 2026 15:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623438;
	bh=vBdfucXv0BSEc+51hsE67r6fmaIA4M3tfCTccI1UsOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTDUCtY4yAAFsvRfvoGfaU176TmNVbm7YqjNqy2kJXCt+FPv7FiibtzmUnq2u0aqt
	 +0naILjNcNKlbtb4oZE8YaEEzfKXHJptJ12olY9ir+sXX94+dA0lyr9a0047FmhkEB
	 XxmvDN+hLqQmSJhnWUMdewvcYQDYU8mAdmjzFWI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Dharmender Garg <dharmender.garg@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 105/378] bnge: fix context mem iteration
Date: Tue, 16 Jun 2026 20:25:36 +0530
Message-ID: <20260616145115.892901946@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 3847d94783c0b893c27ff0b26a3325796d9444c6 ]

The firmware advertises context memory (backing store) types
through a linked list, with BNGE_CTX_INV serving as the
end-of-list sentinel.
However, the driver incorrectly assumes that the list is strictly
ordered and prematurely terminates traversal when it encounters
an unrecognized type (>=BNGE_CTX_V2_MAX). As a result, any valid
context types that appear later in the chain are silently skipped,
leading to incomplete memory configuration and eventual driver load
failure.

Fix this by traversing the entire list until the BNGE_CTX_INV sentinel
is reached, while safely ignoring only those context types that fall
outside the supported range.

Fixes: 29c5b358f385 ("bng_en: Add backing store support")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Dharmender Garg <dharmender.garg@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c b/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c
index c46da34134179c..3f07311d065e24 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_hwrm_lib.c
@@ -259,7 +259,7 @@ int bnge_hwrm_func_backing_store_qcaps(struct bnge_dev *bd)
 	struct hwrm_func_backing_store_qcaps_v2_output *resp;
 	struct hwrm_func_backing_store_qcaps_v2_input *req;
 	struct bnge_ctx_mem_info *ctx;
-	u16 type;
+	u16 type, next_type;
 	int rc;
 
 	if (bd->ctx)
@@ -276,8 +276,8 @@ int bnge_hwrm_func_backing_store_qcaps(struct bnge_dev *bd)
 
 	resp = bnge_hwrm_req_hold(bd, req);
 
-	for (type = 0; type < BNGE_CTX_V2_MAX; ) {
-		struct bnge_ctx_mem_type *ctxm = &ctx->ctx_arr[type];
+	for (type = 0; type < BNGE_CTX_INV; type = next_type) {
+		struct bnge_ctx_mem_type *ctxm;
 		u8 init_val, init_off, i;
 		__le32 *p;
 		u32 flags;
@@ -286,8 +286,14 @@ int bnge_hwrm_func_backing_store_qcaps(struct bnge_dev *bd)
 		rc = bnge_hwrm_req_send(bd, req);
 		if (rc)
 			goto ctx_done;
+
+		next_type = le16_to_cpu(resp->next_valid_type);
+		if (type >= BNGE_CTX_V2_MAX)
+			continue;
+
+		ctxm = &ctx->ctx_arr[type];
 		flags = le32_to_cpu(resp->flags);
-		type = le16_to_cpu(resp->next_valid_type);
+
 		if (!(flags &
 		      FUNC_BACKING_STORE_QCAPS_V2_RESP_FLAGS_TYPE_VALID))
 			continue;
-- 
2.53.0



