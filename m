Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B6C145B06;
	Thu, 11 Apr 2024 10:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830122; cv=none; b=LIWf1audFLhJ1YeyO1odeG+S/0jjmQoXp0hc8DKT8GhQ3LHD6DGp0gt13KOtsNJ7KpIeypZwLo3FP3t+LRIiNGf7xMeZVB2Q1VqD62kpoPpZ4LTt24yIT521J+dz3F8h4WmxHBtx0w0Uy5pOtwBju7Q1tFZnhajU2jeMbpGYvrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830122; c=relaxed/simple;
	bh=T/shWO9rjbUcN0o1wN16Gqc9tHFt84JMp7D0VZDnyp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJSoeqsCm2YIyjnDM32762DzkrWhiZQX6GWmKeO+wJ0uT6W3yaxb/Jj8zLgfgHDmD42YqSI25OfEv4qVKtN0k7gROLaXYEnetJnLhB82LqQ2PQhgGOAZvjbEYxJlS1YBDMlimOWoDk8IdtV1aP27IpahZfiJvrnYNpBl9KRbgL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCc3p2Ey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCc3p2Ey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45650C433F1;
	Thu, 11 Apr 2024 10:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830122;
	bh=T/shWO9rjbUcN0o1wN16Gqc9tHFt84JMp7D0VZDnyp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCc3p2Ey7GwR7jiGIYvXVke3Lx5zBJGzm0hw10t9c+6nbGInIl/veza/U1tXmbl+7
	 by7j9c/8Ox7tOdVnDVCTLXNIxghtwH56N4Ozhk8rRbKXXbiyCCX8pHDU+GEGdORBzb
	 hfC4in37LK+XCTpmMfsQEwjPVc+Nprg3DLUe6gWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 041/143] dma-direct: Leak pages on dma_set_decrypted() failure
Date: Thu, 11 Apr 2024 11:55:09 +0200
Message-ID: <20240411095422.150774099@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 98b2e192fd696..4d543b1e9d577 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -286,7 +286,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	} else {
 		ret = page_address(page);
 		if (dma_set_decrypted(dev, ret, size))
-			goto out_free_pages;
+			goto out_leak_pages;
 	}
 
 	memset(ret, 0, size);
@@ -307,6 +307,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 out_free_pages:
 	__dma_direct_free_pages(dev, page, size);
 	return NULL;
+out_leak_pages:
+	return NULL;
 }
 
 void dma_direct_free(struct device *dev, size_t size,
@@ -367,12 +369,11 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 
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



