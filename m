Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8B811C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C374C433C8;
	Mon, 28 Aug 2023 10:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219043;
	bh=5D4LuL5HJBViCIvfrHSp0M8zZBHlZRcvuPBMXRj6Iqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0GJwRlHGnGR5sZ62TKq3zZsS2zGy2HKHuEzRHJQk+OPECN9breNOWRxVJkYP0LhA
	 5FrAR/PDjVn1W+UNeM+oF0VwNqgK/rwl0FfNyFnw1Iox6a+ILtGyvhWflkPZ4TbFER
	 NgG9SfQp4qBaQR8KVoJoAkfPd7/VLWqPHBzmX2vU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <tiny.windzz@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/158] virtio-mmio: convert to devm_platform_ioremap_resource
Date: Mon, 28 Aug 2023 12:12:29 +0200
Message-ID: <20230828101159.090376422@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit c64eb62cfce242a57a7276ca8280ae0baab29d05 ]

Use devm_platform_ioremap_resource() to simplify code, which
contains platform_get_resource, devm_request_mem_region and
devm_ioremap.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 55c91fedd03d ("virtio-mmio: don't break lifecycle of vm_dev")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index e781e5e9215f0..dd8fec8738564 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -554,18 +554,9 @@ static void virtio_mmio_release_dev(struct device *_d)
 static int virtio_mmio_probe(struct platform_device *pdev)
 {
 	struct virtio_mmio_device *vm_dev;
-	struct resource *mem;
 	unsigned long magic;
 	int rc;
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!mem)
-		return -EINVAL;
-
-	if (!devm_request_mem_region(&pdev->dev, mem->start,
-			resource_size(mem), pdev->name))
-		return -EBUSY;
-
 	vm_dev = devm_kzalloc(&pdev->dev, sizeof(*vm_dev), GFP_KERNEL);
 	if (!vm_dev)
 		return -ENOMEM;
@@ -577,9 +568,9 @@ static int virtio_mmio_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&vm_dev->virtqueues);
 	spin_lock_init(&vm_dev->lock);
 
-	vm_dev->base = devm_ioremap(&pdev->dev, mem->start, resource_size(mem));
-	if (vm_dev->base == NULL)
-		return -EFAULT;
+	vm_dev->base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(vm_dev->base))
+		return PTR_ERR(vm_dev->base);
 
 	/* Check magic value */
 	magic = readl(vm_dev->base + VIRTIO_MMIO_MAGIC_VALUE);
-- 
2.40.1



