Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358B6145B1A;
	Thu, 11 Apr 2024 10:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831170; cv=none; b=rhpM9Mm9WSlqIRy1jxAGQbPc6jjypWFXhifExyuAhpWn7Hjt6cFWWv47nH1xvuOtITusxVElsG5V1OLsOuM/f7m5RBecSNvRaLsW901ZnDzbl9XNnUsf61/mQMVcKxCZsiwghcRFDEWCMo4J/dIjhjeFDqvGS3P+JQmw+euVLGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831170; c=relaxed/simple;
	bh=Drr91zl2HLfhbVbPW40byn7TpJSs7+iIudOKHssURHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iifLGmPbKn9dd6TQsNELI32QJcfMin84qYsyPnxl2/6khqW6CtCswNlUPiQQlchS2aIr3yKtRwvpM8j7/Xu27DWoaebn0rIjSfszclYFhXezLXU+c0v1sJJr6NvcZmqiLZ0EBr6COENAa2i9NMbYvCzU3RH0Q/BvXiOOKqvfGMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rc5ZiOeg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rc5ZiOeg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675EBC433F1;
	Thu, 11 Apr 2024 10:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831169;
	bh=Drr91zl2HLfhbVbPW40byn7TpJSs7+iIudOKHssURHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rc5ZiOegil1DHSqRbzeLKv42Fw1fj5AIwh/4UQZiLdy4xSvrCDW7LEz8YTQRjDMlC
	 tbjf18FxGtJrXwC8wBRHWIGxOFU/XcvbTbiDqSx8xjc6EMUMSoxq/3BR/h1gh/L9Rb
	 C3AzS2OC9fqEjqGVP+M2bjOi5v0FTFnlGgSyNDEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/114] dma-direct: Leak pages on dma_set_decrypted() failure
Date: Thu, 11 Apr 2024 11:55:59 +0200
Message-ID: <20240411095417.839622968@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9596ae1aa0dac..fc2d10b2aca6f 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -295,7 +295,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	} else {
 		ret = page_address(page);
 		if (dma_set_decrypted(dev, ret, size))
-			goto out_free_pages;
+			goto out_leak_pages;
 	}
 
 	memset(ret, 0, size);
@@ -316,6 +316,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 out_free_pages:
 	__dma_direct_free_pages(dev, page, size);
 	return NULL;
+out_leak_pages:
+	return NULL;
 }
 
 void dma_direct_free(struct device *dev, size_t size,
@@ -378,12 +380,11 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 
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



