Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B73318CC1F;
	Mon, 28 Oct 2024 06:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096856; cv=none; b=HtBWLtX0EQEF3IyOkLY4/D5Ctw8popAoIxhfITv4KpguVGdEK3ltQ7g7OAQm1zosfLWkH799g886miL2bMFlOW4ldsEJ5wNWr+Rdh9RxY64sGzfZTakIXPTdvex2oiCkVFB0taZLOdkEigYq4219Jv6rjx8fI94RT8suXKrIPpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096856; c=relaxed/simple;
	bh=zKwCDbSRVDjxwheDWQ5A44usDuy4ly0QMS57oStfrqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hco2s/oj1JgrfxukqczYitVRMlvyMMVzIV2DSnl9XlgTN4w2o6si5HbsFPYJ6mfZOSimo+xj7txrEBk02bRf2WWw8RwRrMQRHqPiwzurEshM0FDicEoqPZR2onqRmaQejiACf6Jbqc67RXfLJ94ZCuI8fUBeEzq1UiN/KvxxsqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14QcC3L9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14QcC3L9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B31C4CEC3;
	Mon, 28 Oct 2024 06:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096856;
	bh=zKwCDbSRVDjxwheDWQ5A44usDuy4ly0QMS57oStfrqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=14QcC3L9T0cE8CvUyNdCeMEn+e79fnqcDfyN6KjqI2XHjxXL65875uj6j59VRM0GY
	 fVwnmwqRcbH05K+q9Sn8PiU4F4fPKkWD1xy39M3kznfjiKq7jYjwex7eowOJc405/I
	 ml/nnhS4FXdtJKZhuJ3jmFHBA/Bvhp9+89Yg3AJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/80] octeontx2-af: Fix potential integer overflows on integer shifts
Date: Mon, 28 Oct 2024 07:24:57 +0100
Message-ID: <20241028062253.099938442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f2e1c63035e85..8bdde74b34b6d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2239,7 +2239,7 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 				 NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link));
 		if (!(cfg & BIT_ULL(12)))
 			continue;
-		bmap |= (1 << i);
+		bmap |= BIT_ULL(i);
 		cfg &= ~BIT_ULL(12);
 		rvu_write64(rvu, blkaddr,
 			    NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link), cfg);
@@ -2260,7 +2260,7 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 
 	/* Set NIX_AF_TL3_TL2_LINKX_CFG[ENA] for the TL3/TL2 queue */
 	for (i = 0; i < (rvu->hw->cgx_links + rvu->hw->lbk_links); i++) {
-		if (!(bmap & (1 << i)))
+		if (!(bmap & BIT_ULL(i)))
 			continue;
 		cfg = rvu_read64(rvu, blkaddr,
 				 NIX_AF_TL3_TL2X_LINKX_CFG(tl2_tl3_link_schq, link));
-- 
2.43.0



