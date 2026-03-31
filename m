Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EA1402BA9;
	Tue, 31 Mar 2026 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975493; cv=none; b=AGcU6m4iOn5kkZkxKMvEOdvVbrs9gZahY//Nzm7J5Zv6nkt5K3wSsz4urWlaX6bu9Xqz8iOtw/O6yxNuCTB2LcFcdozv8LiVBZoGdzUzAJ/kK0efaajruJCMxOQbyvRD1m8u7wJSVEA5/t+uvFdmHKvBIefsclmB7jnitmbRp68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975493; c=relaxed/simple;
	bh=OtAGHwZcUJbzChhpCgK4HysYJ1Mf6IziCuzouCidQ7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BP4D9mU9XKIgX33+o7pmx9/JY/RUttQ72hrMx6Gd4jfBqTtwWrI3DJj2tNGpILIkvHxsyctWkix0B/Es1N7y3amEB4XatfhHYn3s/24VWXtImevWIozogKpNuevsm3752TQw+7L0/aKHQhBrBKYQpyaPi546x2GPMu5S4DuGRQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v93QiXl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v93QiXl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9F9C19423;
	Tue, 31 Mar 2026 16:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975492;
	bh=OtAGHwZcUJbzChhpCgK4HysYJ1Mf6IziCuzouCidQ7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v93QiXl3V+/NPMdzfmfQCcGexcAM8eqJ6yHMI2yzsZcHqFRP2+1w5RvKPyLILUp22
	 tqpUcQmNiXpXHkqSq56DCjmesUxtad4fFWtEEGiZ2t2tl7Fz58urKdfnsdB7eOFCXU
	 2J+Xxm7s5OQY/Si5EyLzjaftbJy7Wq3V2bb9ktdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 317/342] dmaengine: idxd: Fix freeing the allocated ida too late
Date: Tue, 31 Mar 2026 18:22:30 +0200
Message-ID: <20260331161810.584284040@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit c311f5e9248471a950f0a524c2fd736414d98900 ]

It can happen that when the cdev .release() is called, the driver
already called ida_destroy(). Move ida_free() to the _del() path.

We see with DEBUG_KOBJECT_RELEASE enabled and forcing an early PCI
unbind.

Fixes: 04922b7445a1 ("dmaengine: idxd: fix cdev setup and free device lifetime issues")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-9-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 7e4715f927732..4105688cf3f06 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -158,11 +158,7 @@ static const struct device_type idxd_cdev_file_type = {
 static void idxd_cdev_dev_release(struct device *dev)
 {
 	struct idxd_cdev *idxd_cdev = dev_to_cdev(dev);
-	struct idxd_cdev_context *cdev_ctx;
-	struct idxd_wq *wq = idxd_cdev->wq;
 
-	cdev_ctx = &ictx[wq->idxd->data->type];
-	ida_free(&cdev_ctx->minor_ida, idxd_cdev->minor);
 	kfree(idxd_cdev);
 }
 
@@ -582,11 +578,15 @@ int idxd_wq_add_cdev(struct idxd_wq *wq)
 
 void idxd_wq_del_cdev(struct idxd_wq *wq)
 {
+	struct idxd_cdev_context *cdev_ctx;
 	struct idxd_cdev *idxd_cdev;
 
 	idxd_cdev = wq->idxd_cdev;
 	wq->idxd_cdev = NULL;
 	cdev_device_del(&idxd_cdev->cdev, cdev_dev(idxd_cdev));
+
+	cdev_ctx = &ictx[wq->idxd->data->type];
+	ida_free(&cdev_ctx->minor_ida, idxd_cdev->minor);
 	put_device(cdev_dev(idxd_cdev));
 }
 
-- 
2.53.0



