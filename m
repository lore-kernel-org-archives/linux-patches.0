Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F1B1DDCE;
	Tue, 16 Jul 2024 16:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145676; cv=none; b=E5ulIz/oxpSosEg6TInwT87WQy+hwUXRJFycAVD7RgbRjcYNve4RCVRmq18F7xmXwVLSIffgzrA8SdCJZPsDqNZDYWflDsZrZ0ob+2EGH4JyeSviPkbtgnmfTJX3BMjJgJjdnGZRuic/x2XPpJdwRWbyGiAx4vusSuSUF+STNT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145676; c=relaxed/simple;
	bh=dNY6EhCdBMZxTXmqs2DvXT2pB2/hrOQ45Psw0nmzkEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSVtb+Bwzeilt16/4sOEnxcYYvwrjt07BgkBqFHNetvjaSqY5WNsiAV0A/cIDiHuxj8BtkQBp+rPmlITr+06csLYWiCK30wF6ofoXMvGVMqVaou3si2jfmHcvabuac+jT4CY25lgJF9DQH9w2vL9buVzm4nMwUGaFvWcg8fC0rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjP5yToh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjP5yToh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647BAC116B1;
	Tue, 16 Jul 2024 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145675;
	bh=dNY6EhCdBMZxTXmqs2DvXT2pB2/hrOQ45Psw0nmzkEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjP5yTohksEWV8QifTtosd5mmL9M/qopEZQQKE7lYaEyvJ2qhcBu99ovPSLDT/fgT
	 ds+oT43jHu44P7hpMHmxT6B17Ds9PfuA1LUxlHjmve7c7l+QPJWeTcqUHHujLfXwIT
	 5FaEHQGQH5ZhPVboG53I/JqutxicRqL9VJJGPcC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nithin Dabilpuram <ndabilpuram@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/121] octeontx2-af: replace cpt slot with lf id on reg write
Date: Tue, 16 Jul 2024 17:31:48 +0200
Message-ID: <20240716152753.096992952@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f047185f38e0f..3e09d22858147 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -696,7 +696,8 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
 					struct cpt_rd_wr_reg_msg *req,
 					struct cpt_rd_wr_reg_msg *rsp)
 {
-	int blkaddr;
+	u64 offset = req->reg_offset;
+	int blkaddr, lf;
 
 	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
 	if (blkaddr < 0)
@@ -707,17 +708,25 @@ int rvu_mbox_handler_cpt_rd_wr_register(struct rvu *rvu,
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



