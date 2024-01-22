Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BD5604C8;
	Tue, 23 Jan 2024 01:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974684; cv=none; b=ug458bXAq1z0vQEsywyPE1fKogsqEXZC1TeAsBERcZyTQPWcD5h5d0DNfsn1V2E8WQJQuFd5sMycrZBttIqBs7AGvXy0h4a4lCVYlAzSmJQdhh54A4r8TAQXRauvg1z8hgKZNFzLEJW1F+JsFQ9Cz2Vtcd914FfDJH0EgHbAFUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974684; c=relaxed/simple;
	bh=KoEGDonQtc1WRBiAVRcEBd1FmMMEK+cXjgOgpaOJDok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXT8Ni7o4gVAJ15kwHVTAo1MmRxd0v1iFmouNe90TT/IFtvBOClYJmUzkuZG810yHZz2fc4NevwDraV2EDFSifeiGQBoHqYgNuqQPAsBKpwt3NhN+YPyETOzkimsmmL1nQ2kD1WcSqFeE/9T9JBmRLfjmvFa8UYJ/zF/S8T0qIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XjQ3mHPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XjQ3mHPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FFDC433C7;
	Tue, 23 Jan 2024 01:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974684;
	bh=KoEGDonQtc1WRBiAVRcEBd1FmMMEK+cXjgOgpaOJDok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XjQ3mHPAIue4+hfzdyllSH9DSdrh5IY/aOszoBbnVmx9/mxsybdLi0cEeRwOKybOP
	 WvWp2b6U+fqOAS8lUzQ+F/yml7TU6AG+osK/SutoQu/odnYpGPLVq8YT/enV66u8NX
	 bKI/OBMqt5PRB0YG+paxWOvZNo48W1irzGQVC8NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gonglei <arei.gonglei@huawei.com>,
	zhenwei pi <pizhenwei@bytedance.com>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.15 249/374] virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()
Date: Mon, 22 Jan 2024 15:58:25 -0800
Message-ID: <20240122235753.435385022@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

commit b1d65f717cd6305a396a8738e022c6f7c65cfbe8 upstream.

'vc_ctrl_req' is alloced in virtio_crypto_alg_skcipher_close_session(),
and should be freed in the invalid ctrl_status->status error handling
case. Otherwise there is a memory leak.

Fixes: 0756ad15b1fe ("virtio-crypto: use private buffer for control request")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Message-Id: <20221114110740.537276-1-weiyongjun@huaweicloud.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Acked-by: zhenwei pi<pizhenwei@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_algs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -255,7 +255,7 @@ static int virtio_crypto_alg_skcipher_cl
 			vcrypto->ctrl_status.status,
 			destroy_session->session_id);
 
-		return -EINVAL;
+		err = -EINVAL;
 	}
 	spin_unlock(&vcrypto->ctrl_lock);
 


