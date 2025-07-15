Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9258F2E889C;
	Tue, 15 Jul 2025 13:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586197; cv=none; b=j0tqOABthAX3gx/QnZm2Gp7Z67hnQ6PGFlhPhmQquwUF24aJulU4KdyeI7bEhmbYK98c+VauUJQTW/1xRNbJO4oS1lfFKZfthDqjdI5O/wrUoEpGsNXr8Zdcyetj2Ms2sp0VIJkUwnBNhrQg4D1TbPUTayMbEWryD8wnjoEk1ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586197; c=relaxed/simple;
	bh=5MmRCZAMrJhYZBfXEVoa9YvLJWIWH6YJCFXQ33PDgfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jsGA2UFEL8GwjaKy/FGl8bfLzXxeoPunAZQ0trvVsfnjngyJVl+BhB5zzmTM3Rn1qO7Pw0JW9oa6v0k0id+AxDCBcQs2bh07Fe79gxR9VSlueN+3Gn49JS3tQh526HZq5ZnMDE4JmKE+bz5M0v54gPDQ4S6b9EATwM+vE6Db1YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmA8DJPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmA8DJPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203A6C4CEE3;
	Tue, 15 Jul 2025 13:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586197;
	bh=5MmRCZAMrJhYZBfXEVoa9YvLJWIWH6YJCFXQ33PDgfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmA8DJPfuNEh/2REsGSmmMXNXRBh2+C1Dmjlhs4UD8STRvA2Bk3huYCEEJKkC450g
	 GenW31flsf2IjQVWWbeF8xDSK1O5ep+ytb3ZGkPTf96XSNdHOx35gFawtShDTXjClI
	 sAEePVV/BrJVoLtyszk9weXohP6dhZ9CkXjoNOAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 52/77] dma-buf: fix timeout handling in dma_resv_wait_timeout v2
Date: Tue, 15 Jul 2025 15:13:51 +0200
Message-ID: <20250715130753.816338149@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 2b95a7db6e0f75587bffddbb490399cbb87e4985 ]

Even the kerneldoc says that with a zero timeout the function should not
wait for anything, but still return 1 to indicate that the fences are
signaled now.

Unfortunately that isn't what was implemented, instead of only returning
1 we also waited for at least one jiffies.

Fix that by adjusting the handling to what the function is actually
documented to do.

v2: improve code readability

Reported-by: Marek Olšák <marek.olsak@amd.com>
Reported-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20250129105841.1806-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-resv.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
index 8db368c7d35c3..cafaa54c3d9f1 100644
--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -619,11 +619,13 @@ long dma_resv_wait_timeout(struct dma_resv *obj, bool wait_all, bool intr,
 	dma_resv_iter_begin(&cursor, obj, wait_all);
 	dma_resv_for_each_fence_unlocked(&cursor, fence) {
 
-		ret = dma_fence_wait_timeout(fence, intr, ret);
-		if (ret <= 0) {
-			dma_resv_iter_end(&cursor);
-			return ret;
-		}
+		ret = dma_fence_wait_timeout(fence, intr, timeout);
+		if (ret <= 0)
+			break;
+
+		/* Even for zero timeout the return value is 1 */
+		if (timeout)
+			timeout = ret;
 	}
 	dma_resv_iter_end(&cursor);
 
-- 
2.39.5



