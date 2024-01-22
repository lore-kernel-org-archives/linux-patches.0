Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F071487F4;
	Tue, 23 Jan 2024 00:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969175; cv=none; b=Houa7ouDMQAyiWuWf2hMgVBJjVz9ZfdTxqswlY0rVU5JZD/uGk+09pgREYwIPW6cW6YABIjUGpz2bAiJIpK34OxgQdviB84LeCRt8llmVHI4ih973DN1LgQizL2nnJRTl4JcX0F4OLGvYZ6T5wdOn5ga9xwAfh1sBX4vDPx3Z/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969175; c=relaxed/simple;
	bh=qQ2EhTLJch29+MOms4JvHosrueS5Q8X2Qwn+cGqStEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVNiesvuX3TI4MgwGXRRnBTJax2f2o3qh3TuH6PKy/d9rnmrya36hXOUU+Z2KnMkz3CpeNHwjcit36f4/2V4DblqzbIwS7FtsD2bNj6pYMdLQP6Cn1YOMcp7VRMITj8zb1ahiZQV93jRJumM5ZFM/wGXmEfT/lWIQZL9b40PqVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHjNf81s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHjNf81s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64A9C433C7;
	Tue, 23 Jan 2024 00:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969175;
	bh=qQ2EhTLJch29+MOms4JvHosrueS5Q8X2Qwn+cGqStEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BHjNf81sIezqmW9xr/wPOE2rrLTYBvFbQuedZ3mBcdGIgoW6vqyXLt4M+nFphwu6m
	 BTnPJtX118bwwIdG3+0j23INYlVVLvb/N6a4A/M/Ui36FBChzZt70iy2Idqbi7v4qO
	 Lrjq76VtIwaT48q3l83KaEIN4j7fFOwTKvPMlELE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangyangxin <wangyangxin1@huawei.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 074/641] crypto: virtio - Wait for tasklet to complete on device remove
Date: Mon, 22 Jan 2024 15:49:38 -0800
Message-ID: <20240122235820.353736823@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 428d76562447..b909c6a2bf1c 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -500,12 +500,15 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
 static void virtcrypto_remove(struct virtio_device *vdev)
 {
 	struct virtio_crypto *vcrypto = vdev->priv;
+	int i;
 
 	dev_info(&vdev->dev, "Start virtcrypto_remove.\n");
 
 	flush_work(&vcrypto->config_work);
 	if (virtcrypto_dev_started(vcrypto))
 		virtcrypto_dev_stop(vcrypto);
+	for (i = 0; i < vcrypto->max_data_queues; i++)
+		tasklet_kill(&vcrypto->data_vq[i].done_task);
 	virtio_reset_device(vdev);
 	virtcrypto_free_unused_reqs(vcrypto);
 	virtcrypto_clear_crypto_engines(vcrypto);
-- 
2.43.0



