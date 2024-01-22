Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D581852;
	Tue, 23 Jan 2024 01:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972183; cv=none; b=q+p40eume5oHFAkO4VezUDcXa5g+CGlHqXOpRnKRW5Ye2hrR/COfw2Teh7gdFGeFOTBwsiQcfnsaeUUCr+2NkHejEyc668Hf6y0lg5sh2Ek9Somne0cLA6foicSBcnG1a15XhXg0oeDae1TdY9APwRnM3E8yUUCxDrBLNJBnkVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972183; c=relaxed/simple;
	bh=hXzZqAAm1H9qONsOWqhgt3rR5C+InTDPDibeI65ppyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJLJAGRs4JnBNYcECSgz0pzkwePieRSPIBCwKoCkBGjmo5q9Qld40IwzkS4QTzwn/h3pGPkzpoRIJorZ1I5RdljpWZmMPvmit+KhRlYr3sHYA9AhefAp2+fxdw4QkyHBytFXZDyZvyVHQx+PAB9zYFDt9Jq5pN7CQntH5XS4WIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ik8jh44y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ik8jh44y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEBFC43390;
	Tue, 23 Jan 2024 01:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972183;
	bh=hXzZqAAm1H9qONsOWqhgt3rR5C+InTDPDibeI65ppyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ik8jh44y/cOuCA78696y89UiGSM8xRdwf5mEH3iW9NW9wxyO4YDM12S4SzXhrwpK9
	 lMEzrPOKOaVtWXp/LHJDg/pvpEtshCE583ZMWuU4nJNALuwPSjTkFQ82/XYg9vsCQf
	 rEv67Gs3aasZsuCoTem+AOApbuYMbbFODroTeN58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangyangxin <wangyangxin1@huawei.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/374] crypto: virtio - Wait for tasklet to complete on device remove
Date: Mon, 22 Jan 2024 15:56:02 -0800
Message-ID: <20240122235748.307769726@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 370c47c8a67a..f1eff8f752cd 100644
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



