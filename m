Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41014363C50;
	Tue,  6 Jan 2026 17:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721841; cv=none; b=mhCcSRcYw9LZQ8KIAbkQoNJrdkjchZtmvWxHayY3bp0bilpaYdPVwmTP5W+738sHoLiPuyR3nWncCoQxyIevxdXqjFmJAU1zcyNzDHg7J1wXdvHeyulbF0ZxnKNfHl9gC60SKEBqgvPegLR6amyqShEQRQHbprpHPELHK57wR34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721841; c=relaxed/simple;
	bh=cTEtGOK/YgxJEtMeck09tHtdMOtMuyxnl9H2v2zl1Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/eb3GzzbrRqv0SChN1f6JoPH2GwPE4rivELgIbKcGjLw8NC4Fshvx7cTJaEALdLPpwZXsEyYeg2SQ5GuQyF65OHAdZsLCTDVw1RHoGRwQclIYSJ37saSQlTLvnw/YQhv9xEmcFkTLfqEoxFxiubGQngK91Jv0Qr8m9hWK59PO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mf5K7/0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mf5K7/0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343DAC116C6;
	Tue,  6 Jan 2026 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721841;
	bh=cTEtGOK/YgxJEtMeck09tHtdMOtMuyxnl9H2v2zl1Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mf5K7/0eqdeqMAmzmhVrfAfne1bWOi5/YvDk5Hqs5sjIhtAZtgiyXsw6NpkYKDcij
	 nUrHElKGzCtDibRJJq3XMG5Hn6BGB+tPf+64k0EsnG3siW/4esSS0M1AmUEsYfUAqm
	 wB9tF8bzImZ3kVsB3KQvi1Lm1fWcv0lD8ZPvf1BQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/312] RDMA/bnxt_re: fix dma_free_coherent() pointer
Date: Tue,  6 Jan 2026 18:02:40 +0100
Message-ID: <20260106170550.950196480@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit fcd431a9627f272b4c0bec445eba365fe2232a94 ]

The dma_alloc_coherent() allocates a dma-mapped buffer, pbl->pg_arr[i].
The dma_free_coherent() should pass the same buffer to
dma_free_coherent() and not page-aligned.

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20251230085121.8023-2-fourier.thomas@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index d5c12a51aa43..4d674a3aee1a 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -64,9 +64,7 @@ static void __free_pbl(struct bnxt_qplib_res *res, struct bnxt_qplib_pbl *pbl,
 		for (i = 0; i < pbl->pg_count; i++) {
 			if (pbl->pg_arr[i])
 				dma_free_coherent(&pdev->dev, pbl->pg_size,
-						  (void *)((unsigned long)
-						   pbl->pg_arr[i] &
-						  PAGE_MASK),
+						  pbl->pg_arr[i],
 						  pbl->pg_map_arr[i]);
 			else
 				dev_warn(&pdev->dev,
-- 
2.51.0



