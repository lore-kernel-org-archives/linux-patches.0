Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A27C1D0E1A;
	Wed,  2 Oct 2024 14:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877878; cv=none; b=IyBK0S9rKJH7YBepV7qPemPBNJh1MZ944E0+33MVTPzL5PLAQTqxHsqnbPuFxJaxN5cjwjOKu7ibK8Jd3QAcGMPrM27/45Gbi5zmBrZLE3UOmGqn79oyE+wHq385YHrxP6MHwnebMFjwfn1G0jW8nLDEb4Zm3VwaQNrU+KK+SkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877878; c=relaxed/simple;
	bh=X2+KYgL4E7tW54xDwWfNIrIEGuD7hYXw/exO9Se+Pt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJ4XoMUsZC2lXmUiM2tghgPMu2vBgZepKa9KSUnpfPOh8D4HnEM+XF6pyOVnfG3/IVziDQ4vu/k/qzdX+NxCkJA6z3Z7xu2DAinP+kjElZmCGoUWKi1JA7NsxsCZT1ATUT9IcajKQqg5/EfCE53zgIV+elYt2iADbrIvu9TqUMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XR6GmH0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XR6GmH0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA82BC4CEC2;
	Wed,  2 Oct 2024 14:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877878;
	bh=X2+KYgL4E7tW54xDwWfNIrIEGuD7hYXw/exO9Se+Pt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XR6GmH0KLXbXI9jDs00/pcK/vvkWhlWTZ/xaMfOjOHzjqVdTArR1FO2PFxFjsYgMU
	 6VA8krWtApiSHC5n6sMQPC5D4wrPi/XAVgp8qrJcn1nFj+KAUHb93zJPTusl/AWQgk
	 7AJNeFFtzhjKcikQ+hRE+hcAi2EaG2EFGOD3JEEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 225/634] xen/swiotlb: fix allocated size
Date: Wed,  2 Oct 2024 14:55:25 +0200
Message-ID: <20241002125819.980522955@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit c3dea3d54f4d399f8044547f0f1abdccbdfb0fee ]

The allocated size in xen_swiotlb_alloc_coherent() and
xen_swiotlb_free_coherent() is calculated wrong for the case of
XEN_PAGE_SIZE not matching PAGE_SIZE. Fix that.

Fixes: 7250f422da04 ("xen-swiotlb: use actually allocated size on check physical continuous")
Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/swiotlb-xen.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 7a6f1f007527c..5e83d1e0bd184 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -146,7 +146,7 @@ xen_swiotlb_alloc_coherent(struct device *dev, size_t size,
 	void *ret;
 
 	/* Align the allocation to the Xen page size */
-	size = 1UL << (order + XEN_PAGE_SHIFT);
+	size = ALIGN(size, XEN_PAGE_SIZE);
 
 	ret = (void *)__get_free_pages(flags, get_order(size));
 	if (!ret)
@@ -178,7 +178,7 @@ xen_swiotlb_free_coherent(struct device *dev, size_t size, void *vaddr,
 	int order = get_order(size);
 
 	/* Convert the size to actually allocated. */
-	size = 1UL << (order + XEN_PAGE_SHIFT);
+	size = ALIGN(size, XEN_PAGE_SIZE);
 
 	if (WARN_ON_ONCE(dma_handle + size - 1 > dev->coherent_dma_mask) ||
 	    WARN_ON_ONCE(range_straddles_page_boundary(phys, size)))
-- 
2.43.0



