Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C53618EFD6;
	Mon, 28 Oct 2024 06:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098151; cv=none; b=U99zd89rcqxeCRs7+3QGPFiETAtmnuDl1Q885HFA3o/2vcbjI1TXhm7JEkGiUu8YWslclP/4oHK2FhaHkNlwNZMeyv1+E/xfszsusN2XmfEYOPkTo49olCEOTyiKXAg+0oNLMOfp1wpLFyKJjH/hc2a5tk8t/m/ZM0H9CFIexkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098151; c=relaxed/simple;
	bh=3xxyeSgNR5lb68Mn6vyMFP//A+BiyiwPoZej5esfIZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoSvRLZ5hLQNIJWlbb78in7+aDDivZadA1gPjCRgmwd1Jm/EVEj9HaeYXMpOsrjKOPf7bc7mOa6n86y8N8XtM3hVeXGTL3vipZbjqIxRppFeVRXnpsRBFthR2DGDge1O/Ut/Xa9Nddk8/Fq793/HEFS4wyDkjE5QzjfTMOAl+kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFsJcwyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFsJcwyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDF8C4AF0B;
	Mon, 28 Oct 2024 06:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098151;
	bh=3xxyeSgNR5lb68Mn6vyMFP//A+BiyiwPoZej5esfIZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFsJcwyrxrbLQKopjNiGHquF7LS2XCfklwN0MdBSmvw7PDoOwMCiq9/BIur1/C2ZZ
	 Cm5tRnV0DPX9HCs6uV0F77/GEhsB6mb0DsVyOHageIXVi5i0ASbL14CmPb96jIlTZZ
	 T+KOhSINvksa8NVQq0RiGngMWTec2tcpGcaPHkgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 062/261] octeontx2-af: Fix potential integer overflows on integer shifts
Date: Mon, 28 Oct 2024 07:23:24 +0100
Message-ID: <20241028062313.584126118@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 637c4f6fe40befa04f19c38b5d15429cbb9191d9 ]

The left shift int 32 bit integer constants 1 is evaluated using 32 bit
arithmetic and then assigned to a 64 bit unsigned integer. In the case
where the shift is 32 or more this can lead to an overflow. Avoid this
by shifting using the BIT_ULL macro instead.

Fixes: 019aba04f08c ("octeontx2-af: Modify SMQ flush sequence to drop packets")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20241010154519.768785-1-colin.i.king@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 82832a24fbd86..da69350c6f765 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2411,7 +2411,7 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 				 NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link));
 		if (!(cfg & BIT_ULL(12)))
 			continue;
-		bmap |= (1 << i);
+		bmap |= BIT_ULL(i);
 		cfg &= ~BIT_ULL(12);
 		rvu_write64(rvu, blkaddr,
 			    NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link), cfg);
@@ -2432,7 +2432,7 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 
 	/* Set NIX_AF_TL3_TL2_LINKX_CFG[ENA] for the TL3/TL2 queue */
 	for (i = 0; i < (rvu->hw->cgx_links + rvu->hw->lbk_links); i++) {
-		if (!(bmap & (1 << i)))
+		if (!(bmap & BIT_ULL(i)))
 			continue;
 		cfg = rvu_read64(rvu, blkaddr,
 				 NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link));
-- 
2.43.0



