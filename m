Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037912D8762;
	Tue,  6 Jan 2026 17:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720788; cv=none; b=ZWOFbShWv8LaVdzz+bCVMzi2/QZ3itPkhbFsbJItWdRxalXqKAaa2by1Pdsn9iPnwYXqiOAQ+0rU90g6B+rW4e1+eCVBua7GfOSfqqNIwT4MdVxwFgpDT+Nt2xPc30lHQjBJYBUlKNwLMdQwrAt3GEa7U2G5wcpkzMvKL9FVBkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720788; c=relaxed/simple;
	bh=JBvFIMRlUxFXX8ZazNKCAtBv4StMySC7OpCUHJ2ZGr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YarZ2oILrLXIhRi/fziWOGT2MHJ1mKeC+EkHEMriJUgQBGpLTz2CiTHW6HGhjy/2IXc4x+mCnnTWznlc7PvIuxh46QAGk3tN6mIzpGl/X4uSmWceQWTYHVgCUbvpPesIRH0qx3QGzSlFqRHX8HzA6Sy5GEI4s0L4bVmlBcRFmrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBewmeuD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBewmeuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EE8C116C6;
	Tue,  6 Jan 2026 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720787;
	bh=JBvFIMRlUxFXX8ZazNKCAtBv4StMySC7OpCUHJ2ZGr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBewmeuDCWrKS62UVFms7Jyx1JCIUzrLoSEgqucZfpFaH8Q9dYHGZLpIKSEwZ54Zn
	 9Ulv1QVWHmDwJVA2VNkkLR1AJuCEPQaX3N06RfwIjDyCqLKfzLUOZFD1zHav8lzBD1
	 7g6j6DlRR5zRepcnzQb34cW2WANYq6bjotH8904g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/567] RDMA/bnxt_re: fix dma_free_coherent() pointer
Date: Tue,  6 Jan 2026 18:02:03 +0100
Message-ID: <20260106170503.940886685@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
index f1a4bce6ce64..dfb72a5adc91 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -70,9 +70,7 @@ static void __free_pbl(struct bnxt_qplib_res *res, struct bnxt_qplib_pbl *pbl,
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



