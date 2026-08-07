Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3A92F8E8B;
	Fri,  7 Aug 2026 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114697; cv=none; b=P4UOaF83ZAK3oQOPpQxdtEPwbj7F2Tm8CILdO5siC1Me5KfnmwEX2Quec+ARl8JzO3gc3vt95IYici8ySHT6AupxWor9BjEnq7mNE2x/Ps/ewc309SN6SP6IoMqdMxHrp9wjZ5BxAxKf+mvhH0qgGr3fkfhF64jBGKvi4/AF1uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114697; c=relaxed/simple;
	bh=D9AFjOld01ePjv2zEFWZ+SF9SOnV8TlW2quoreCEiZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7+gYPCSUu0YhZc1Men5acx4tWVfNOt/i9miycT2EgCpkKe2tnXa3DxOCguk/yYWsxSCbUu5435KSNXvfOHNs3MdrEn4ngxWbuB110hGqLMsurge03VPjf79Q2uXMFAHHH2LzKAnkqANWHIcclcc1FNGLX5qs451xKesy1NqAys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xttLb1u5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xttLb1u5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69AB1F000E9;
	Fri,  7 Aug 2026 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114696;
	bh=poiu6XiF+B9KTHM7hsp+HaZkzB4NyRu88X7Jq8MLR80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xttLb1u5//QxJRE5FBbjwBHhhd24dLN5BZcoXPyfYsA7IGFg3w2MJHWAJP0S80F2c
	 +UN37qKTG7TFoj+z1sciw44uvTkIthQfQrI0BCn0/vgBJ6zQQq6TBUqYCmAClFTBIs
	 j4SGFfv2SUTwBQmsXCcnGCfBVLJjxrYmF3GpPULE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/396] dmaengine: idxd: fix fdev setup failure cleanup in idxd_cdev_open()
Date: Fri,  7 Aug 2026 16:32:57 +0200
Message-ID: <20260807143424.648404826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit ee1d7274102285d78a53161fc705a8d8cd40b066 ]

The failed_dev_add and failed_dev_name paths drop the file-device
reference while wq->wq_lock is still held. If put_device(fdev) drops the
last reference, idxd_file_dev_release() runs synchronously and tries to
take wq->wq_lock again, deadlocking.

Those paths also fall through into the later ctx cleanup labels even
though idxd_file_dev_release() owns that cleanup and frees ctx. This can
make idxd_xa_pasid_remove(ctx) and kfree(ctx) operate on a freed context.

Move idxd_wq_get() before file-device setup can fail, since the release
callback always calls idxd_wq_put(). Then unlock wq->wq_lock before
put_device(fdev) and return directly from the file-device setup failure
path, leaving ctx cleanup to the release callback.

Fixes: e6fd6d7e5f0fe ("dmaengine: idxd: add a device to represent the file opened")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260525141550.1385581-1-dbgh9129@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 4105688cf3f06..37addcdc10bc2 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -288,6 +288,7 @@ static int idxd_cdev_open(struct inode *inode, struct file *filp)
 	fdev->parent = cdev_dev(idxd_cdev);
 	fdev->bus = &dsa_bus_type;
 	fdev->type = &idxd_cdev_file_type;
+	idxd_wq_get(wq);
 
 	rc = dev_set_name(fdev, "file%d", ctx->id);
 	if (rc < 0) {
@@ -301,13 +302,14 @@ static int idxd_cdev_open(struct inode *inode, struct file *filp)
 		goto failed_dev_add;
 	}
 
-	idxd_wq_get(wq);
 	mutex_unlock(&wq->wq_lock);
 	return 0;
 
 failed_dev_add:
 failed_dev_name:
+	mutex_unlock(&wq->wq_lock);
 	put_device(fdev);
+	return rc;
 failed_ida:
 failed_set_pasid:
 	if (device_user_pasid_enabled(idxd))
-- 
2.53.0



