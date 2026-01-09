Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88E8335BCD;
	Fri,  9 Jan 2026 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962646; cv=none; b=GqtE31Jv+MLwGrkVtiRF7FeT2TfuaETe+C90FYJy4Yyaeqx7mli/tIwPJ4V52RAe1Y8iC7M2vExxUg0Nd8Xx5EkP91R0Nw+aPlfHuaMuq49EbT93Ch32pZXcnWwYdzejYHwlP1qIrw3H73dDeZs5DUnW28AedKVtdLhCkpQ7OaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962646; c=relaxed/simple;
	bh=LlP5bt+VFvGapv+w1QEBXs6yc6e5I/MKGA5U43uFTQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQMdvQR5NNnMVuR3sDSVkNo6h0/aDe1EIhAWLuwFiJkq2AiFkGpXVsP50zdZ6saI6zo9EjH25d53hhSUGHh11GOb33nHqxWp89R7+fOL/Hgh0wYINB1C/kY4d12HvF+/18OO9xGl+Y/lUU90Q56mqwjXHUgS+9TZKuXE3jTdIwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8DdI9ES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8DdI9ES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7819EC4CEF1;
	Fri,  9 Jan 2026 12:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962645;
	bh=LlP5bt+VFvGapv+w1QEBXs6yc6e5I/MKGA5U43uFTQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8DdI9ESHz8mVpt2ltRJNfRp8uGq5BLx1J5pYHb+XsJc79xOlTHhLXq5JYOTzHpsV
	 4bHnLr3zVhO03wnWRdrGJ1QdrgyfnvKvD0b5OW93QyTmIfUqUMP7gQM+JHuNx3wL2Y
	 zsf0SYx+oz2dgzhjsDwi/dP5VMCFjo4ipNAjhNJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 438/634] RDMA/bnxt_re: fix dma_free_coherent() pointer
Date: Fri,  9 Jan 2026 12:41:56 +0100
Message-ID: <20260109112134.022692812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5edad6a5a112..6d811f67934e 100644
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



