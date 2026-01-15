Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBB33C00AC;
	Thu, 15 Jan 2026 17:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498255; cv=none; b=IaPrqzjT4Z1M3/vIPKUKgDHJxHVBjA17yq7KePZxi1W0wSk+O+uX4geB9M9nRtFIqk8kCTGQtv6AnFfaoFARBPfleJEDlIwqh/v0fdqn+CLkmG2t44HbSociVhzvxexE46OnPWFJXrErW6KhYPkzfHGckT5A4ue8EIIkn52PheQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498255; c=relaxed/simple;
	bh=fXjIEwNFt495WvzauHeW1JJf3JFKiyZSG1tF5SHRllA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjaOMoeURMpCQcqJEhsBtER6ety+TdZI4B3dg2V7JD3qcfL1+69PdTxHmie6TGi698zlgg2dC3RqMzU058lMZ6TkVS9snOcjKgi9TKWhOFxfE8yi+dRurqfLuiihxRHhMUzrQCv2WrbWq4c7ifp01m9NdK5nq33J77HOFgovM3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGgmzYbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGgmzYbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B105AC116D0;
	Thu, 15 Jan 2026 17:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498255;
	bh=fXjIEwNFt495WvzauHeW1JJf3JFKiyZSG1tF5SHRllA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGgmzYbdzcoWN7clFcck13xNcXkpgbvRW3zCWbYj9ZdOpwkT/ELzppE75NugEnwx4
	 L8n2fp1cSFZv3CnI0KYuCLmNdk6QLZty0/cLUDKLGl5Gs9gK9mTBZ4sJU7BUwlJF9R
	 KG53tRrULiUxZLnJcXcGikJkM7WcPP1i9iJiWmtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 367/554] RDMA/bnxt_re: fix dma_free_coherent() pointer
Date: Thu, 15 Jan 2026 17:47:13 +0100
Message-ID: <20260115164259.509076112@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 76fbe52a957c..2bdb428fd273 100644
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



