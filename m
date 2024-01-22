Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BBB12BF2C;
	Tue, 23 Jan 2024 00:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968911; cv=none; b=WgSJhHVrUqDVhRl+mJ8+IbFtnY24llfNK6jCmDn7LUiDKAC8RrA0kZZosFYHjEPY/hiNuryVCOAlgkHP93AAHBfyp6lnPgGfDK8paaOqCIWWq2nQ6zvpH6ZalQVBxqMt1MObd2pnsxWWJXg3NdpwHa4hHdz5texZ4fO4URXHI+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968911; c=relaxed/simple;
	bh=Ec5cK2ZQVDlMzVUC+8WUoawCz3bYDpWWR+2UO3OthdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TC6hdJH0TZDaP/LGsH4uvFa9cAbTjl01nNU2Ze3B1Um7HVqpuYLL+0zTYnCr9EwOKVecLswJRETL3m2RAcXPEkbRZAoK1cir770eyq0G+MKLVMaesdSD2WwK8gI1fTeKRE9ayhwA4fcagw+MAUeSuzsTnR4x7knCjqLn0hH6jOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pB7IQwNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pB7IQwNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164FFC43390;
	Tue, 23 Jan 2024 00:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968911;
	bh=Ec5cK2ZQVDlMzVUC+8WUoawCz3bYDpWWR+2UO3OthdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pB7IQwNVtcMvBzN7u/d0ZDnSz8/YEk/qPRFfYetviVtlacWMcAdSe0sx5FgNlFN/f
	 IBwEGfAuYnNe7R5Pz/+WRmesZZ69NHQ2XYIUMRwrlpjoCBAjX8JjJrMj/N3xNHcywh
	 b8WxRIbXGdqo1cmuhI7yFCq3z98Eq/SnVA5h8yTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/194] dma-mapping: clear dev->dma_mem to NULL after freeing it
Date: Mon, 22 Jan 2024 15:57:04 -0800
Message-ID: <20240122235723.273225807@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joakim Zhang <joakim.zhang@cixtech.com>

[ Upstream commit b07bc2347672cc8c7293c64499f1488278c5ca3d ]

Reproduced with below sequence:
dma_declare_coherent_memory()->dma_release_coherent_memory()
->dma_declare_coherent_memory()->"return -EBUSY" error

It will return -EBUSY from the dma_assign_coherent_memory()
in dma_declare_coherent_memory(), the reason is that dev->dma_mem
pointer has not been set to NULL after it's freed.

Fixes: cf65a0f6f6ff ("dma-mapping: move all DMA mapping code to kernel/dma")
Signed-off-by: Joakim Zhang <joakim.zhang@cixtech.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/coherent.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 2a0c4985f38e..d164b3dbcd93 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -323,8 +323,10 @@ static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
 static void rmem_dma_device_release(struct reserved_mem *rmem,
 				    struct device *dev)
 {
-	if (dev)
+	if (dev) {
 		dev->dma_mem = NULL;
+		dev->dma_mem = NULL;
+	}
 }
 
 static const struct reserved_mem_ops rmem_dma_ops = {
-- 
2.43.0



