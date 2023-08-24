Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F4314A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB394C433C7;
	Thu, 24 Aug 2023 17:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897518;
	bh=ENcFX3X9WhN/Tz04teIKl8iXvCf8Zy974sb0wDQuhcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SD0dIGcOOhhQZUJBu0z9C0TxG5uA7uHrvebGA/4hDk3wmw2B6Ab3C+CjkRXDUSnAd
	 mVoeNa5iOoFE7He+hVWpTHSmQAOyVMLDN7GTDo0oFYtQFS5KT8nF8C7OdEYZ4FA/5X
	 Oezd5+KQb+aPnr9wfSwMRIyctz3oXPa/GCfDtCKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/135] virtio-mmio: dont break lifecycle of vm_dev
Date: Thu, 24 Aug 2023 19:09:00 +0200
Message-ID: <20230824170620.142770478@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 55c91fedd03d7b9cf0c5199b2eb12b9b8e95281a ]

vm_dev has a separate lifecycle because it has a 'struct device'
embedded. Thus, having a release callback for it is correct.

Allocating the vm_dev struct with devres totally breaks this protection,
though. Instead of waiting for the vm_dev release callback, the memory
is freed when the platform_device is removed. Resulting in a
use-after-free when finally the callback is to be called.

To easily see the problem, compile the kernel with
CONFIG_DEBUG_KOBJECT_RELEASE and unbind with sysfs.

The fix is easy, don't use devres in this case.

Found during my research about object lifetime problems.

Fixes: 7eb781b1bbb7 ("virtio_mmio: add cleanup for virtio_mmio_probe")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Message-Id: <20230629120526.7184-1-wsa+renesas@sang-engineering.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 844b949b45c96..136f90dbad831 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -572,9 +572,8 @@ static void virtio_mmio_release_dev(struct device *_d)
 	struct virtio_device *vdev =
 			container_of(_d, struct virtio_device, dev);
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
-	struct platform_device *pdev = vm_dev->pdev;
 
-	devm_kfree(&pdev->dev, vm_dev);
+	kfree(vm_dev);
 }
 
 /* Platform device */
@@ -585,7 +584,7 @@ static int virtio_mmio_probe(struct platform_device *pdev)
 	unsigned long magic;
 	int rc;
 
-	vm_dev = devm_kzalloc(&pdev->dev, sizeof(*vm_dev), GFP_KERNEL);
+	vm_dev = kzalloc(sizeof(*vm_dev), GFP_KERNEL);
 	if (!vm_dev)
 		return -ENOMEM;
 
-- 
2.40.1



