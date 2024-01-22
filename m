Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33620629E2;
	Tue, 23 Jan 2024 00:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971144; cv=none; b=XEe9c1DSXHQuaK75BwKj3SHpLAhNLmLeo93fYp0v6QdEVGpk1JK5FZgzjXLBmINNQSl9HDMFfcUqRgrB7WhUU4aQitIk2SM2gDSR/CZ9O8WrwklFHznLzR9gxjzzUI7Nc6Xbp9s2AN4ZhTivEOAKS1IOqwA/mFtSWmxlYpG7t+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971144; c=relaxed/simple;
	bh=yMqOdIrFgOWqtR1n2DtCnG817Vsb2mj+M6pfEydbC0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfNDEwRNHg/zRBT2rJriZVmKvz+mf2M2VYNrd0X0YyH9/i8ZNFXwiFFt8jDWX6ONqyPPK3IQpjt6PZLATM/WVfgunR5UA+YXNxHLsP39w35eWT6riOw+gATmcOFlJjeUQxIEcow0MN4kWYKVY1DiRCJMztYy8tNt4GOCiITlavE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSsREJHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSsREJHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEAAC43390;
	Tue, 23 Jan 2024 00:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971142;
	bh=yMqOdIrFgOWqtR1n2DtCnG817Vsb2mj+M6pfEydbC0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSsREJHoy3RF6BYml8tOWRHAAUibEIbgzltFO5DAwGFI4JXLVQG/vsuyaccb4lgvr
	 4Z8Zcv5THVPLwvhYigLrLGD2quCLr/HNoU9Z8t2QQK80/p5jFNcfVg6txIYuNBLK0C
	 1Tfh1I8OnWcU3GTWW12ZcbfUYtSh7tp+5LICLBYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangyangxin <wangyangxin1@huawei.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/286] crypto: virtio - Wait for tasklet to complete on device remove
Date: Mon, 22 Jan 2024 15:56:43 -0800
Message-ID: <20240122235735.804963582@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

From: wangyangxin <wangyangxin1@huawei.com>

[ Upstream commit 67cc511e8d436456cc98033e6d4ba83ebfc8e672 ]

The scheduled tasklet needs to be executed on device remove.

Fixes: fed93fb62e05 ("crypto: virtio - Handle dataq logic with tasklet")
Signed-off-by: wangyangxin <wangyangxin1@huawei.com>
Signed-off-by: Gonglei <arei.gonglei@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/virtio/virtio_crypto_core.c b/drivers/crypto/virtio/virtio_crypto_core.c
index 630af33929ef..3da956145892 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -488,11 +488,14 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
 static void virtcrypto_remove(struct virtio_device *vdev)
 {
 	struct virtio_crypto *vcrypto = vdev->priv;
+	int i;
 
 	dev_info(&vdev->dev, "Start virtcrypto_remove.\n");
 
 	if (virtcrypto_dev_started(vcrypto))
 		virtcrypto_dev_stop(vcrypto);
+	for (i = 0; i < vcrypto->max_data_queues; i++)
+		tasklet_kill(&vcrypto->data_vq[i].done_task);
 	vdev->config->reset(vdev);
 	virtcrypto_free_unused_reqs(vcrypto);
 	virtcrypto_clear_crypto_engines(vcrypto);
-- 
2.43.0



