Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160F815445E;
	Tue, 23 Jan 2024 00:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969387; cv=none; b=qKFwi3zIgQxKoioJuzc5lriSZBtClv1cQdbCuW+goqOJ/QYneC1pPZUbdU3zUS6goPdEOvKATvM2Ky07/MFanUqW6t3yWwL13BO4ZFredbB6MBo9Em0JKWspg+U4/06N/XEMz3kMK+Rvsrtnhx/06PRTf9wJwp6M+0EgIW//d8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969387; c=relaxed/simple;
	bh=qNmO9Ijo6IgOzelHQLGjBzDLa2hhzcV595i5V5OJoeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sopiDO2rnv9IfAZFccQmANFYPdA75+Nb8KvYxfdKL3e7GExb9QPDrKE8T+keFb37+nhrv1GzEGAlVqj7a5gnvElK6uf9AwW2BI2IkCwsJnEmkOJWNJg0VONB3sxNTScf7bWMpGVF8mW3GGQzHPgCJB0+AHZzrGYHFLsuioGkkEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7iHkG5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7iHkG5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F0DC433F1;
	Tue, 23 Jan 2024 00:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969386;
	bh=qNmO9Ijo6IgOzelHQLGjBzDLa2hhzcV595i5V5OJoeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b7iHkG5RFc7kQQN8AuL5/0C0/RyO1BJ883e/prFV0TAq20UWmYxC4aRliKEkecfgz
	 k1ZOCqeAgt8YyrWrbVsmOcFk73Au9OtPLmvq4pOiw7Sb4nGQNgT2CQ69+DJImLuD/M
	 qSKNGJYQ4iQm+s3BAeYaWIClyBUgutL7NNXekxNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 188/641] dma-mapping: clear dev->dma_mem to NULL after freeing it
Date: Mon, 22 Jan 2024 15:51:32 -0800
Message-ID: <20240122235823.859199791@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index c21abc77c53e..ff5683a57f77 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -132,8 +132,10 @@ int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 
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



