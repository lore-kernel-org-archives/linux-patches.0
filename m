Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABEF33FE27
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301257; cv=none; b=TZlU3sSHWri7byhmVwB/dg3XYamVpRYhTLlQ2ftGFXaWm4DSH3FTfyFjCrnXK6amx10pGNp/QB6EYAS9cerempa2SuJiXSL9ldvTur6dNY0k3fTcoCCw/gqDWxYGLjXNX6jMWbeETfgXndw72NYUoKGgCuPDglKU6I48jGTgjfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301257; c=relaxed/simple;
	bh=cA0iyVRujC2xfGltGqfFBfS7ZxxYDuTQ0L0yzi6eVWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NecmDIMh2kLcY/bz5jjX80bQtlriQ357dK9BjJr3HtgZg+8Qo9Z2BsS5hDe8jxgcvEAboL0qpBrnr8FO9MNAnIk35n/8f5A7zn9ltQwuOCtgcZ6z1t9m2SD1zkB/Xln3a7dT6PizKJRTc/gsBBX4rphUaioLOFFgatexBjUX99k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gaXinb/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaXinb/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE07C19425;
	Sat, 28 Feb 2026 17:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301256;
	bh=cA0iyVRujC2xfGltGqfFBfS7ZxxYDuTQ0L0yzi6eVWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaXinb/iXYgZ3KfHP4AwbpRt0fJMQyDjPcsvzAPjeX/WFpSkctDvYore0/QhFhBBb
	 feBRwaEyjqpOtt4jlJSQBChZtWBQDk0elpit7o2e0mwA4CIGz2gYmuYSVj5xZqBtsI
	 b17uZowxmeZrKinmF3IwN3eurpX9kg2MrdNW3PmdnHWm0UYRsQB0iqrAnSsjwcTaEb
	 sG0g2Ryi8WfBBXEwCznKopzPMoTZUtvaALrgQUAUE52BYEFtcszeB0tAkzM/lSC52h
	 I7cijEX0EuckWb9yAx/hSXXr6BmWP7jwqLD3AuwLh8K1TZ3bvWib/yDHuL4zzJIZQX
	 bZBuWCfVg2v5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 440/752] RDMA/umem: Fix double dma_buf_unpin in failure path
Date: Sat, 28 Feb 2026 12:42:31 -0500
Message-ID: <20260228174750.1542406-440-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 104016eb671e19709721c1b0048dd912dc2e96be ]

In ib_umem_dmabuf_get_pinned_with_dma_device(), the call to
ib_umem_dmabuf_map_pages() can fail. If this occurs, the dmabuf
is immediately unpinned but the umem_dmabuf->pinned flag is still
set. Then, when ib_umem_release() is called, it calls
ib_umem_dmabuf_revoke() which will call dma_buf_unpin() again.

Fix this by removing the immediate unpin upon failure and just let
the ib_umem_release/revoke path handle it. This also ensures the
proper unmap-unpin unwind ordering if the dmabuf_map_pages call
happened to fail due to dma_resv_wait_timeout (and therefore has
a non-NULL umem_dmabuf->sgt).

Fixes: 1e4df4a21c5a ("RDMA/umem: Allow pinned dmabuf umem usage")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260224234153.1207849-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/umem_dmabuf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/umem_dmabuf.c b/drivers/infiniband/core/umem_dmabuf.c
index 0ec2e4120cc94..17b16fe0e49d9 100644
--- a/drivers/infiniband/core/umem_dmabuf.c
+++ b/drivers/infiniband/core/umem_dmabuf.c
@@ -221,13 +221,11 @@ ib_umem_dmabuf_get_pinned_with_dma_device(struct ib_device *device,
 
 	err = ib_umem_dmabuf_map_pages(umem_dmabuf);
 	if (err)
-		goto err_unpin;
+		goto err_release;
 	dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
 
 	return umem_dmabuf;
 
-err_unpin:
-	dma_buf_unpin(umem_dmabuf->attach);
 err_release:
 	dma_resv_unlock(umem_dmabuf->attach->dmabuf->resv);
 	ib_umem_release(&umem_dmabuf->umem);
-- 
2.51.0

