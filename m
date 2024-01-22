Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23774A26;
	Tue, 23 Jan 2024 00:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968294; cv=none; b=qdaTyVnRatUn+STZm2oEBHScQ1nC6712DjGmzo0y32v09gIkf0vBhZKbt/u5qlXZvHPWIzDoc6a2S5jajHZK7naU+wmmb6Ly/ndJYB6UQ9gv1v38UQAaPk9v38ouQdDkniE2IqiwD008mLOWMwuJThAgfm+U1R57ZrpXFrtWqNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968294; c=relaxed/simple;
	bh=8FhKXyhQC4kKJq/HrgpLsg9EVjr3LV0TPAYeIdpbxbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPXwyr3GpSqrdMUZp1S3IqF6xbnll4w8azxr1cOtieEWhZ994ST4SyBSJ8CRYXbjj0k8EYyJSh+ZHNp8kCjiVKph6QWZGk03a6m2rzTcrKLeHgo4xjlDJlwLNKnppLfuFursqEeEPg+2/vQEMk070QJPdxw3QSqZh7X3+8+i9gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRwpjeK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRwpjeK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D47C433C7;
	Tue, 23 Jan 2024 00:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968293;
	bh=8FhKXyhQC4kKJq/HrgpLsg9EVjr3LV0TPAYeIdpbxbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NRwpjeK5qDrsRz5kRneo8bkd6u2rizaqpFPlIZfb7D18xk3te7noDIbPymZ9H7Yxm
	 ezs5VLjoRpg2DERXT2Lut11iMLx6RAFR9A0bfTEZtNjGdWguQSVvSkmIcLLt2tOa3y
	 ylUQnQHr7P3Oj63lRwwL+YtD3lm7eexW1xgGk4cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/148] dma-mapping: clear dev->dma_mem to NULL after freeing it
Date: Mon, 22 Jan 2024 15:57:09 -0800
Message-ID: <20240122235715.357226218@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 597d40893862..4c7ffd094a57 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -369,8 +369,10 @@ static int rmem_dma_device_init(struct reserved_mem *rmem, struct device *dev)
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



