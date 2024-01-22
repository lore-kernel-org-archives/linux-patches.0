Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DD24E1D2;
	Tue, 23 Jan 2024 00:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970569; cv=none; b=GmFQOl6SPdPY3PXKle04q949sfh1aVPYF0IvH5xbx3n2BIQdwOtINZKNZE2/TrPirxufwBK/46fMZ+slZJZHuC2RA02c4XuhDTETAFwSLNCqDD26iCe3I6AnSPvon9H62mflrP+ZG96uVjFR6YeFfuMdNq6OCT2BlVQBWsLibig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970569; c=relaxed/simple;
	bh=4gouKHmTiaB0ZGERAHMo3wcBmx6umnqi+I4ZmJ4Ntl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSGyR1hukf0yQZ6d/ksS0tkghwyQ+goSACkpyKv8bV7hQwlzwbeqoOEU0CWZOdv/k6kht+nkINKLyXvpDMe60Nz5vHOiWWxXUqqAv3RQRtVSL2sDR83XQMp7begsxAbgKihK4FeG6gMFksHDw0R1dieoixZ6hLQrpGEBFwXnttk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fb3GtBm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fb3GtBm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37743C433F1;
	Tue, 23 Jan 2024 00:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970568;
	bh=4gouKHmTiaB0ZGERAHMo3wcBmx6umnqi+I4ZmJ4Ntl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fb3GtBm/BaoKBRXPn0RddV0RKxyWjqOPO6u2FNvbvsCr9meZsvQrRATM6LPrZx5Hy
	 IXeFrutattryVfrxa0GMzYMMouoUrisrFvA/35wSH+q1bZ0lamT8hWD3FalZtGsy70
	 +0klrF1S4g2F7QNXRIkv9wqiq3US0CctL3JUJfCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangyangxin <wangyangxin1@huawei.com>,
	Gonglei <arei.gonglei@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/417] crypto: virtio - Wait for tasklet to complete on device remove
Date: Mon, 22 Jan 2024 15:53:42 -0800
Message-ID: <20240122235753.548981054@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 856daf05341c..56dc0935c774 100644
--- a/drivers/crypto/virtio/virtio_crypto_core.c
+++ b/drivers/crypto/virtio/virtio_crypto_core.c
@@ -499,12 +499,15 @@ static void virtcrypto_free_unused_reqs(struct virtio_crypto *vcrypto)
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



