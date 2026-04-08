Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EF53D9041;
	Wed,  8 Apr 2026 18:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674407; cv=none; b=p+ReksMb46smfVhBUkUcdhCbQxQc2lzPTkJHYKUVRbwi2zzMdGytCCzTC6W0Ihar7wAV1ypN4mcV+xi+ITaSthPAsvPsGO+NP71TbKjcJ/pe7PNP8oAawmwBrpIu5ALMs4ZjgVKGONlP3Mh0WVgQVGQJe7fKWRCL5gUOA8eK4fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674407; c=relaxed/simple;
	bh=Pcc5OVXKMdhBk5SXAgVE7lebM/k3CGYio3+ECa7zDkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIWUo5K9/TIJeBUe9kW1+Jna54o6BQ9Y6DnrxMub6UHypPcS5IGq4q9XIY+/dzJdFrwDE9bqTGfDMoqclzYg6HHuImMremJFaVUhuP05/x2GfUj3gnVHjUBcWsGZ8Nq7SObsm7UWlnUcK+9kzMr7VeEGNKCbscPxU4CvKgT+2G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mt7Fg01j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mt7Fg01j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A58EC19421;
	Wed,  8 Apr 2026 18:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674407;
	bh=Pcc5OVXKMdhBk5SXAgVE7lebM/k3CGYio3+ECa7zDkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mt7Fg01jTHYhBrFi9rIXsA4yzxzCxvwT8Tmv/zNJqyZfBz/wAWtP3dk3/rQgMal4+
	 pf+GaS2YEsIh8jGCnX0P8+WzDApSC9etAdf8Y0njZ19U7PVJh4YtfZqlIz8hfM3J77
	 1XLuzlbDyKsVl53OEfQPmb2tEFXLSCaWOccqSJP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 068/311] bnxt_en: set backing store type from query type
Date: Wed,  8 Apr 2026 20:01:08 +0200
Message-ID: <20260408175941.955606536@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2dadc7c668587..300324ea1e8aa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8623,7 +8623,7 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
 	struct hwrm_func_backing_store_qcaps_v2_output *resp;
 	struct hwrm_func_backing_store_qcaps_v2_input *req;
 	struct bnxt_ctx_mem_info *ctx = bp->ctx;
-	u16 type;
+	u16 type, next_type = 0;
 	int rc;
 
 	rc = hwrm_req_init(bp, req, HWRM_FUNC_BACKING_STORE_QCAPS_V2);
@@ -8639,7 +8639,7 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
 
 	resp = hwrm_req_hold(bp, req);
 
-	for (type = 0; type < BNXT_CTX_V2_MAX; ) {
+	for (type = 0; type < BNXT_CTX_V2_MAX; type = next_type) {
 		struct bnxt_ctx_mem_type *ctxm = &ctx->ctx_arr[type];
 		u8 init_val, init_off, i;
 		u32 max_entries;
@@ -8652,7 +8652,7 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
 		if (rc)
 			goto ctx_done;
 		flags = le32_to_cpu(resp->flags);
-		type = le16_to_cpu(resp->next_valid_type);
+		next_type = le16_to_cpu(resp->next_valid_type);
 		if (!(flags & BNXT_CTX_MEM_TYPE_VALID)) {
 			bnxt_free_one_ctx_mem(bp, ctxm, true);
 			continue;
@@ -8667,7 +8667,7 @@ static int bnxt_hwrm_func_backing_store_qcaps_v2(struct bnxt *bp)
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



