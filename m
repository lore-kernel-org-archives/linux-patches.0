Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8373A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3942FC433F0;
	Tue, 10 Jan 2023 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374531;
	bh=I5+E7RCwRQpQ6m2jnvmsVnbn2uXvIuJJeQCZx5A0CzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=181xCxKz0Hkdo5Gsz/KyWZ2tdQZKYxTYycHJBgOnUyJzlH1tckf0iScrZHLf2eyJ6
	 LZKcWaUO4s9Jn1Iv+0a8oFCwuXrdTP1ogRddJfT8A3If4tl7OfDdzfRxza7oAlj36u
	 6kPe7o8Q0TkqouZpEyhAb1+Jo7XFYnIEDpT4PJUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gonglei <arei.gonglei@huawei.com>,
	zhenwei pi <pizhenwei@bytedance.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/159] virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()
Date: Tue, 10 Jan 2023 19:03:16 +0100
Message-Id: <20230110180019.839104598@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit b1d65f717cd6305a396a8738e022c6f7c65cfbe8 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
index e553ccadbcbc..e5876286828b 100644
--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -239,7 +239,8 @@ static int virtio_crypto_alg_skcipher_close_session(
 		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
 			ctrl_status->status, destroy_session->session_id);
 
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	err = 0;
-- 
2.35.1



