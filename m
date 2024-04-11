Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D32F6BB29;
	Thu, 11 Apr 2024 10:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832348; cv=none; b=i1vyxwn5VyTumgxdisw6Q0Rsoj6HHVIKPWOiwhR9DfeZgvFwO2hOj5gUgiSniCjWqn+6dDb81EY/kHznUHUv6BoLifc3azEMU1xW5Gmjib/aqPziC5RiVarNs16AXWytmrfNbFtguK+1wAwzEGYvaWRIckqzh88AeY22fzVMYTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832348; c=relaxed/simple;
	bh=ZqBize1qw6wZ2KoWFY8NjrgXdPR7g9kDWRIcRgozzfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KERoNBzKKUNv6o2jaQE4DSsWn8lmtYO2fcNdz5hCQXOSycpWZVc8K9DB5mAu7hV5RbUHDGdAfBi94iukYpud8VAOHq/v9P1AKHC/j06sCFvZVPYkX3JxcfRMCGKVyHZlZz8dPOm57YuC7zIXuAknLXC6dB9SU6FMfxgmamGqrWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMVTb2QB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMVTb2QB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BE0C433C7;
	Thu, 11 Apr 2024 10:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832348;
	bh=ZqBize1qw6wZ2KoWFY8NjrgXdPR7g9kDWRIcRgozzfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMVTb2QB2YJadgoblBxR1KOfce3OH3b7M6atHfmKlIyQf8N3yEk+iF2lqy+KqJ9+m
	 t0l+qnTHq7FxNue6kVmSnhBZtpkujsMFmWDzKvC9IKNjHYfUjrhPqDgaRZZ6/Zfl7V
	 DpHqfNMK2BPlBc4Aoipw54UleXlmHeNawPqqWSa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/83] dma-direct: Leak pages on dma_set_decrypted() failure
Date: Thu, 11 Apr 2024 11:56:51 +0200
Message-ID: <20240411095413.257007667@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

[ Upstream commit b9fa16949d18e06bdf728a560f5c8af56d2bdcaf ]

On TDX it is possible for the untrusted host to cause
set_memory_encrypted() or set_memory_decrypted() to fail such that an
error is returned and the resulting memory is shared. Callers need to
take care to handle these errors to avoid returning decrypted (shared)
memory to the page allocator, which could lead to functional or security
issues.

DMA could free decrypted/shared pages if dma_set_decrypted() fails. This
should be a rare case. Just leak the pages in this case instead of
freeing them.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 63859a101ed83..d4215739efc71 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -296,7 +296,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	} else {
 		ret = page_address(page);
 		if (dma_set_decrypted(dev, ret, size))
-			goto out_free_pages;
+			goto out_leak_pages;
 	}
 
 	memset(ret, 0, size);
@@ -317,6 +317,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 out_free_pages:
 	__dma_direct_free_pages(dev, page, size);
 	return NULL;
+out_leak_pages:
+	return NULL;
 }
 
 void dma_direct_free(struct device *dev, size_t size,
@@ -379,12 +381,11 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 
 	ret = page_address(page);
 	if (dma_set_decrypted(dev, ret, size))
-		goto out_free_pages;
+		goto out_leak_pages;
 	memset(ret, 0, size);
 	*dma_handle = phys_to_dma_direct(dev, page_to_phys(page));
 	return page;
-out_free_pages:
-	__dma_direct_free_pages(dev, page, size);
+out_leak_pages:
 	return NULL;
 }
 
-- 
2.43.0



