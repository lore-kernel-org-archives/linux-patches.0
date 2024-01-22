Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0968520EE;
	Tue, 23 Jan 2024 00:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968240; cv=none; b=Xqe4pF7ayHDPwsqBMdSUGZDl/thBRJUgU4J0BUSsnZXHbZOq4oBS7rbbLtZq/niMbIa77DCNO0s26w4pd1iP33vE7OHNYC5qdbY+4utGNZOUNNpSsg4imxhFYokCnoXFcTa7LJwPmmG5aAVkAashBdU642kZskat5p7+qA+emHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968240; c=relaxed/simple;
	bh=5pKTpgZuUOSh8BKcR0h0LeW/SKIrWC2dD3aBquslxZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fe1gCZmgmoHcWF5qsu6984fCphKkYtjvpcfxNF1uJ13+Nr/LATT5zxGiXAEc9SjARBSovEsN4lZ3AlmzxJmoUdwbNOtTplz7QCn3H83pSW7qe/sHXo2oHTLLbC6dO9VDzF1hteBjPNsmAKULZMbgjfGkn44be38YslG7IswI7O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bc5Jhrn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bc5Jhrn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C42C43394;
	Tue, 23 Jan 2024 00:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968239;
	bh=5pKTpgZuUOSh8BKcR0h0LeW/SKIrWC2dD3aBquslxZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bc5Jhrn/eAoTyURQ0DgYYEZeVXG9hScW2L+KjeS0G2BsPACEkYGXp1dloTouL6Roi
	 gkZ+I37HC6tcoVN20HIyFwkYe1PuXKZ6RbBqad7WsBg86EWJpoQ1QJOwZX2LpKJOZe
	 fFT6gwDogkQ4Ugkwt6QRL7SllmYhQRvtpHx+vHyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangyangxin <wangyangxin1@huawei.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/148] crypto: virtio - Wait for tasklet to complete on device remove
Date: Mon, 22 Jan 2024 15:56:49 -0800
Message-ID: <20240122235714.566702828@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index c21770345f5f..2515a141c67b 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -446,11 +446,14 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
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



