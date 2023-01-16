Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4116FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3199AC433EF;
	Mon, 16 Jan 2023 17:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888799;
	bh=MfkyjF7c/oy2gimJJfJ+HRtCwaK8Fr/GDNoGImjPYck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJbKztIp6RgXQlW0RgOINDRkqE4Rcl2ThSWPuw/R7C3ZP1ZljNQYRn9t99JcXq5/p
	 A08MQoN/Eqr7yx4DJ4xyA0ozKzOeFmBUYFualCUyI4f3L1I9Xo87t0EkEocI94rWmU
	 S3d9ip6Hfvj67dpF48ES++HmS+Jtg1ojajLcxSx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 142/338] PCI: Check for alloc failure in pci_request_irq()
Date: Mon, 16 Jan 2023 16:50:15 +0100
Message-Id: <20230116154827.036399316@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit 2d9cd957d40c3ac491b358e7cff0515bb07a3a9c ]

When kvasprintf() fails to allocate memory, it returns a NULL pointer.
Return error from pci_request_irq() so we don't dereference it.

[bhelgaas: commit log]
Fixes: 704e8953d3e9 ("PCI/irq: Add pci_request_irq() and pci_free_irq() helpers")
Link: https://lore.kernel.org/r/20221121020029.3759444-1-zengheng4@huawei.com
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/irq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/irq.c b/drivers/pci/irq.c
index 10929cd43d5d..a40e65ee4839 100644
--- a/drivers/pci/irq.c
+++ b/drivers/pci/irq.c
@@ -91,6 +91,8 @@ int pci_request_irq(struct pci_dev *dev, unsigned int nr, irq_handler_t handler,
 	va_start(ap, fmt);
 	devname = kvasprintf(GFP_KERNEL, fmt, ap);
 	va_end(ap);
+	if (!devname)
+		return -ENOMEM;
 
 	ret = request_threaded_irq(pci_irq_vector(dev, nr), handler, thread_fn,
 			IRQF_SHARED, devname, dev_id);
-- 
2.35.1



