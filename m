Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA971C7B63;
	Tue, 27 Aug 2024 15:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772574; cv=none; b=i3wOl9AEI6IWcxJiiBAK3NNm32AoY1cije9V6d6BvsqIo9zTHxRx9gIGf8C0+SvTf3+YpPULjZh8FTARUIXZ2TZ19h5jo4AXvCF014grOSkxqpN+jO7TsAoIGULVUSrRZOl0hYS8WH7fUns9MjIoqBmxTfk6vD/g4Xtb0Y7cUvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772574; c=relaxed/simple;
	bh=7C5DcqVDokNErgjZ8N66k6BD2Nb2xn1js6o7nXCU3Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKQxi/+SCgEp8CyCNdpwG55uy0UqrL0ed0qGMuoXlhh9lr6wIG8FirEl0FH8YSCnRMIFJvT8eDWtUZeHbGiFLo+KWdWEilRWFqNUrwC6Cz8/70o8fNzv62BFOnBksZOcL99Hu39MhjF5DoPG8YNXyt0y2lSosgs9iAl6yMcT61Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPKXovcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPKXovcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F74C6107E;
	Tue, 27 Aug 2024 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772574;
	bh=7C5DcqVDokNErgjZ8N66k6BD2Nb2xn1js6o7nXCU3Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPKXovcbiHQY/rznWocFqyO8ncewHYuG8PStTzRjizDEdLUnHqoUHRXKJ8SRW+q/T
	 InWreCUkRdDS3WxjbTc1u888cHv1hT0T2Niedb0g6YHER4JBwuF3rlKlXzsbDpo47x
	 yGKHuK1MlSkQrExpHelKPKUkBe+6Rtg6gvnpgK6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 255/321] octeontx2-af: Fix CPT AF register offset calculation
Date: Tue, 27 Aug 2024 16:39:23 +0200
Message-ID: <20240827143847.951077360@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharat Bhushan <bbhushan2@marvell.com>

[ Upstream commit af688a99eb1fc7ef69774665d61e6be51cea627a ]

Some CPT AF registers are per LF and others are global. Translation
of PF/VF local LF slot number to actual LF slot number is required
only for accessing perf LF registers. CPT AF global registers access
do not require any LF slot number. Also, there is no reason CPT
PF/VF to know actual lf's register offset.

Without this fix microcode loading will fail, VFs cannot be created
and hardware is not usable.

Fixes: bc35e28af789 ("octeontx2-af: replace cpt slot with lf id on reg write")
Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240821070558.1020101-1-bbhushan2@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 23 +++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index b226a4d376aab..160e044c25c24 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -632,7 +632,9 @@ int rvu_mbox_handler_cpt_inline_ipsec_cfg(struct rvu *rvu,
 	return ret;
 }
 
-static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
+static bool validate_and_update_reg_offset(struct rvu *rvu,
+					   struct cpt_rd_wr_reg_msg *req,
+					   u64 *reg_offset)
 {
 	u64 offset = req->reg_offset;
 	int blkaddr, num_lfs, lf;
@@ -663,6 +665,11 @@ static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
 		if (lf < 0)
 			return false;
 
+		/* Translate local LF's offset to global CPT LF's offset to
+		 * access LFX register.
+		 */
+		*reg_offset = (req->reg_offset & 0xFF000) + (lf << 3);
+
 		return true;
 	} else if (!(req->hdr.pcifunc & RVU_PFVF_FUNC_MASK)) {
 		/* Registers that can be accessed from PF */
@@ -697,7 +704,7 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 					struct cpt_rd_wr_reg_msg *rsp)
 {
 	u64 offset = req->reg_offset;
-	int blkaddr, lf;
+	int blkaddr;
 
 	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
 	if (blkaddr < 0)
@@ -708,18 +715,10 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 	    !is_cpt_vf(rvu, req->hdr.pcifunc))
 		return CPT_AF_ERR_ACCESS_DENIED;
 
-	if (!is_valid_offset(rvu, req))
+	if (!validate_and_update_reg_offset(rvu, req, &offset))
 		return CPT_AF_ERR_ACCESS_DENIED;
 
-	/* Translate local LF used by VFs to global CPT LF */
-	lf = rvu_get_lf(rvu, &rvu->hw->block[blkaddr], req->hdr.pcifunc,
-			(offset & 0xFFF) >> 3);
-
-	/* Translate local LF's offset to global CPT LF's offset */
-	offset &= 0xFF000;
-	offset += lf << 3;
-
-	rsp->reg_offset = offset;
+	rsp->reg_offset = req->reg_offset;
 	rsp->ret_val = req->ret_val;
 	rsp->is_write = req->is_write;
 
-- 
2.43.0



