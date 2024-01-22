Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE8258AAC;
	Tue, 23 Jan 2024 01:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974070; cv=none; b=HqO50xX43F/jX6Zv0XsB8MGjaGHkK5Lf6hC5h2A2qQIVuyTOGSt77xyolOKPyZQ/ihmAV/BT3EAMqUuzMwrlSsiQb8KUtFjhw/QF1uWSbnM3GYoEJEYYCoLv8LaSAe+C8J8ixlhWQTb2to9/g2aHzOob+4d39u9ZEaz5Js/cWXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974070; c=relaxed/simple;
	bh=FfzmUb4cz1d/OhVGbzVaJ98VcFG9XoVaI+yh7lU4iU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkT43CkCsDIMZAhgWc5trPywSv9brnUk8t/1TUgEr3E3ZDoaxWSGmaIssxZ+roSet82vj4gb7BZUMcmuaSCCYetbK7TFUKDPZ3NflNhVmPyi2D5jmcjKqSI47laegK2cOvRs6dA370uQULWzoxldICBI2WTLhNkRqm1VUpwCmvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DciVqi45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DciVqi45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B2EC43399;
	Tue, 23 Jan 2024 01:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974068;
	bh=FfzmUb4cz1d/OhVGbzVaJ98VcFG9XoVaI+yh7lU4iU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DciVqi45l721egKBdlo3hjZ2PCvZlSrqn0TEWHqaawhQgbf9l0WAL1OQAYnQsb3YY
	 n0Y54tCKbvW+uWKFREr7uRyil4tJRzLqbInILqeV7nN0tVbgKE3fWl0YuZnj8oEEDk
	 vzEB0exQzqALhOf80gaRDVPvX52CAyWQaCguU588=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Zhang <joakim.zhang@cixtech.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/374] dma-mapping: clear dev->dma_mem to NULL after freeing it
Date: Mon, 22 Jan 2024 15:56:46 -0800
Message-ID: <20240122235749.846045273@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ca05989d9901..2df824fa40ef 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -133,8 +133,10 @@ int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 
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



