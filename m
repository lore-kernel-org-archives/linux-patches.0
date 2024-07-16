Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD951DDCE;
	Tue, 16 Jul 2024 15:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145449; cv=none; b=R5B8+pPeN2bNCrIwBHg2Z4s9OwuTjx9cbB5deim+nWFRt2VFGUWiZyuEnFYBJO6Fnf00VrUKSEzW4pJhe3FWfUUr0mt29x9GFoyPI89eMQud7KlJ72idpQwnNpLOhmlguFAkNYfJE2zPdx6qU834lKnwHWQhoi4K1hymC7TB/KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145449; c=relaxed/simple;
	bh=GX2Xojg1ps3FTIR1Pwi4glw4HE9XeB37V2qXxYcZYIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQTd9tdklhaHBZU28YIiFiyZTxewahCgUgttLtWeqjnttIAc2nWkQRZvoYV/SZTulGsoA2xYQCJvxaazfHj5xAWvT05GWZfh5EXLbLYCECPIm37ddExOQmhPAPjS2fKAVyJnmM2SJPQf+snnPk3P8C0/VPYvbw+5fbEY4+T/GlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7qXAY1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7qXAY1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B5CC116B1;
	Tue, 16 Jul 2024 15:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145449;
	bh=GX2Xojg1ps3FTIR1Pwi4glw4HE9XeB37V2qXxYcZYIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7qXAY1qcGtzKuwEoe2116VWJZYZ7VMM0+tPdRDEEbCWPqmjnMYOMQxohtg1RY9T5
	 lPqwTkgEHEn6AyUGBnCHlu+/02lILpSCVjZMWnK13HLnMU1VWmRSVkrefLebHGp/d4
	 g3pbJjxbJH5u1OYARJfjbGIgAE2sVjRdXrUeAlfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nithin Dabilpuram <ndabilpuram@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/96] octeontx2-af: replace cpt slot with lf id on reg write
Date: Tue, 16 Jul 2024 17:31:48 +0200
Message-ID: <20240716152747.937812518@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

[ Upstream commit bc35e28af7890085dcbe5cc32373647dfb4d9af9 ]

Replace slot id with global CPT lf id on reg read/write as
CPTPF/VF driver would send slot number instead of global
lf id in the reg offset. And also update the mailbox response
with the global lf's register offset.

Fixes: ae454086e3c2 ("octeontx2-af: add mailbox interface for CPT")
Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 23 +++++++++++++------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 6fb02b93c1718..63a52cc8592a0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -692,7 +692,8 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 					struct cpt_rd_wr_reg_msg *req,
 					struct cpt_rd_wr_reg_msg *rsp)
 {
-	int blkaddr;
+	u64 offset = req->reg_offset;
+	int blkaddr, lf;
 
 	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
 	if (blkaddr < 0)
@@ -703,17 +704,25 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 	    !is_cpt_vf(rvu, req->hdr.pcifunc))
 		return CPT_AF_ERR_ACCESS_DENIED;
 
-	rsp->reg_offset = req->reg_offset;
-	rsp->ret_val = req->ret_val;
-	rsp->is_write = req->is_write;
-
 	if (!is_valid_offset(rvu, req))
 		return CPT_AF_ERR_ACCESS_DENIED;
 
+	/* Translate local LF used by VFs to global CPT LF */
+	lf = rvu_get_lf(rvu, &rvu->hw->block[blkaddr], req->hdr.pcifunc,
+			(offset & 0xFFF) >> 3);
+
+	/* Translate local LF's offset to global CPT LF's offset */
+	offset &= 0xFF000;
+	offset += lf << 3;
+
+	rsp->reg_offset = offset;
+	rsp->ret_val = req->ret_val;
+	rsp->is_write = req->is_write;
+
 	if (req->is_write)
-		rvu_write64(rvu, blkaddr, req->reg_offset, req->val);
+		rvu_write64(rvu, blkaddr, offset, req->val);
 	else
-		rsp->val = rvu_read64(rvu, blkaddr, req->reg_offset);
+		rsp->val = rvu_read64(rvu, blkaddr, offset);
 
 	return 0;
 }
-- 
2.43.0



