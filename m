Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261D3627F3;
	Tue, 23 Jan 2024 00:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971291; cv=none; b=k7FGuQKF9wY3u21x9I8fE9ULzpqXdTPl3kSAEGc5mlxZ1yw2vLniUnZbXm/sZfAJzihfS6V+142gE1UBcCqOjfBPJWef+21WoOvgfL+yxaIrnFJSfTjUvkZJj1/oPJRgua4hC/3svrfjtrTU1KB7C4eTL2675EsEd9cmM56suuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971291; c=relaxed/simple;
	bh=iO9XmUNc0SdKjLptv89TAkS+DPXcbVWDt0yhTtYabuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDM7FmZARt59FWGyJKvKImlXbVl3lTtg3FaI7XVUEv7PFBu/4kyMpzgp4dSmmmB25eLrb0m2ILC88ejVIm6+WvkggJry7oQBSNz51dmhPNzL8JaERzIBTAOFUVfwRB7y134HoqqIbmds/uh+GNHBCl8YXJs3r6LzlXs6VoIkE1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HF1dTJRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HF1dTJRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D83EC433F1;
	Tue, 23 Jan 2024 00:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971291;
	bh=iO9XmUNc0SdKjLptv89TAkS+DPXcbVWDt0yhTtYabuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HF1dTJRCw0yANXFtyeKuZi8CXOuVq0JLz3b+8oDpPm5l9TVHH6KWnyRenxWa4LJxt
	 Wb1HdyuCagc0gEQJqajFVkaQ0y2+hCbqU6YYoSAt/0ugQ1Sn0uJ4oD5TFYyWRLWv63
	 fCKCFj8Np9tHm308Ac9f4lEKnqND4UD5jhXeT64M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/286] dma-mapping: clear dev->dma_mem to NULL after freeing it
Date: Mon, 22 Jan 2024 15:57:15 -0800
Message-ID: <20240122235737.105248612@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b79d8d0433dd..49aaad3936f1 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -142,8 +142,10 @@ int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 
 void dma_release_coherent_memory(struct device *dev)
 {
-	if (dev)
+	if (dev) {
 		_dma_release_coherent_memory(dev->dma_mem);
+		dev->dma_mem = NULL;
+	}
 }
 
 static void *__dma_alloc_from_coherent(struct device *dev,
-- 
2.43.0



