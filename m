Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6B8664CD;
	Tue, 23 Jan 2024 01:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971679; cv=none; b=C5rfaejfG45uWNRNuqPeWI/pPwT09ahkSzrv2InSpmTo/3UZ+DELKy9XHxOXq6AJuodbocWkj/szmxSL6lLf24OBJAzKcEMdt8vKr3+nDYKAa5s58rAYyVv9KOd/zn7L/n4kh6cvmlQaJdcRigfdRl4FoiRe/OOleh7JyF/FJRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971679; c=relaxed/simple;
	bh=9kzvvZmQsCI43NU8mah4+p81lvbNVfPG5tWPJU3z1hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXZ+/9Wa1vvFsaEgAw+iB+egVX3fAkBaVMgDsSmDQMeFtsJvgvla7i0f9txLxx8RGNJYKcIeLotSPQYY7N/fQN+k+yEQ0EZojAA+s6J/5eqj81Wam0IuD6tyXyqfyIo9hIscbyKURpV/1BZgQONB6FpXiboMKTxGuAkYlb0cWfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZbNYV9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZbNYV9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3889C43394;
	Tue, 23 Jan 2024 01:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971679;
	bh=9kzvvZmQsCI43NU8mah4+p81lvbNVfPG5tWPJU3z1hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZbNYV9DTcn7AcIOmCyOZHFfRFczBjVla5fJuu7pUHE/UT2W+7mv2T4RNMG8RusFJ
	 EeZXcPuQhOsaYFocG41GBqQ7bvgkCN5wRNMPg+11mvukMjk4ZV7Fu7Yiu0FHW47ZjG
	 QfDDARIa0mZrtH58XTjSEt9DYfWMd547J3zRQuwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gonglei <arei.gonglei@huawei.com>,
	zhenwei pi <pizhenwei@bytedance.com>,
	Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.10 204/286] virtio-crypto: fix memory leak in virtio_crypto_alg_skcipher_close_session()
Date: Mon, 22 Jan 2024 15:58:30 -0800
Message-ID: <20240122235739.966085949@linuxfoundation.org>
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
 drivers/crypto/virtio/virtio_crypto_algs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -239,7 +239,8 @@ static int virtio_crypto_alg_skcipher_cl
 		pr_err("virtio_crypto: Close session failed status: %u, session_id: 0x%llx\n",
 			ctrl_status->status, destroy_session->session_id);
 
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	err = 0;


