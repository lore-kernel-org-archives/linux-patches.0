Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC1612BF3D;
	Tue, 23 Jan 2024 00:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968929; cv=none; b=VSoh/VdvouiCpyPCHwN2pWl/H5QPhQM4tG5C9UyWzDRzd2mSEb0W89M2n08S8jndQfQf8VmeAsd8j02hX4vkFSddOV6VoURKn9XDexKWxqF0TM4rtMTEt3AnbGBQB8dyLsQ0sqh6grMA0jB8a4/ew2b6mT9P9KMB7bVAUP6UGJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968929; c=relaxed/simple;
	bh=L+uQorPjA+9cGjMgTrgP+N7g8gvBa0HdhIgB8upmWMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FD98GJL5fQIfp3nJA51yz7DMIfYJwuWAUviAhR4RdYTa08xSmtyY2XZv4CHPNAkZOOrN1tENQMQRqLQlnISHdRFB/W/P+LQaEhEl1Q0XqZFbdAnoRNrK7lMopYNca2L55tZJJcVSFNuruZndN+OSjzmBzTkDbUONCx/uMux7v6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2yCIZnn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2yCIZnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2EDC433F1;
	Tue, 23 Jan 2024 00:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968929;
	bh=L+uQorPjA+9cGjMgTrgP+N7g8gvBa0HdhIgB8upmWMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P2yCIZnnSjEH1qVkWxDuBr9abtjV36c34wxVM3Kel1qTpLS5dJut15lutc3bgeaHk
	 jwIGtNHjx+wjZfcIA+Qs6++Gf2NH+oP1jcUzFCr6tuRSLRX80DTFs9qlPwR5QWnUSj
	 bONJFt2wa3omVUOAdtMiR/OrU3rN4WXy6SdtChKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangyangxin <wangyangxin1@huawei.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/194] crypto: virtio - Wait for tasklet to complete on device remove
Date: Mon, 22 Jan 2024 15:56:41 -0800
Message-ID: <20240122235722.277630139@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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
index 7c64862f1194..469da86c4084 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -434,11 +434,14 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
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



