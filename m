Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DE9359F8C;
	Fri,  9 Jan 2026 12:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960917; cv=none; b=RHbosrj8UnqIhT61Yaw5h3Q9qj2aZpy9LJ63pyZAaKyPQdiH5ARUjlmSPKYlU5vYINWD2cUnV6eFE/gW3ZtM+LNtxTRalm/l2wNsSB7LY00qEYXyUgbP/djC0qJdMnHXEZrwDgeT4ysDVLsb0kblVbGwJqcp5mHmRIAzNqFfBJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960917; c=relaxed/simple;
	bh=1Oytcy73WiC/q3q8ykX/htCYbISixIMyqXP+htpuRXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjrgRCZWgKmq+fceGzfuy+o16b47SOytcIXPubd2tuuhrFuWsrYZ3VZiUO/PlgbaSKvU/DjWH1o1zZWzmE9oXxs0glO9ruNo6Y86vm+E6K+B4mpwbLrfEGN8CvarIciLuZJ2RJxNo/CrOVY1cs8fRriH1aJeEvrYL3LsUrmJI0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqFdWZ5M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqFdWZ5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0A04C4CEF1;
	Fri,  9 Jan 2026 12:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960917;
	bh=1Oytcy73WiC/q3q8ykX/htCYbISixIMyqXP+htpuRXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqFdWZ5MJ+SWK8HlccO6MuRz9PzuQSShsG5LE8SAvaoB0hfMdYLxRtR9rxp0ECiym
	 zl1itkVh4YmkW3+zPOhIRXpcQtyH72CKJL4FBp6BJ/Pep3cPKAjFVjSDQ+rBdnzqI8
	 6l5ljj3cKb9bgBMrisJll/PLC9IOOhTd/vIQRqh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 537/737] RDMA/bnxt_re: fix dma_free_coherent() pointer
Date: Fri,  9 Jan 2026 12:41:16 +0100
Message-ID: <20260109112154.196659722@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c56a0107d1e..d2c8f21468dc 100644
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



