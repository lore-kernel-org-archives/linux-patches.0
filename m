Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA94335F8A4;
	Fri, 13 Feb 2026 13:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990724; cv=none; b=YFe6x7xmDGqO9x7C5DHg0ZT1Gn5T3tD2kWVUsgMR1jlVYrr6hBgQiV39RAEYqrL0hVqXREwF/8vg5nUN4aCQDJd8nh07TGReAyN0/SSXh3g6JHjY5iRlTPZHg+j1BffiULn08xUfyYcybl9OpSK92UTS/GNuJPj3eE3s9QwKlGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990724; c=relaxed/simple;
	bh=SXuSZXnDpYoVDRpNkxE0kgpFs3lbAzqTGjsovkQD0Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnQKjooGKVVoCvH0kqhgwhsUp60zihHEr2s4+jX0Jdlva/GpDjALBHQqx7HXQMGY7lWqjnljQ0aX/Zf/jcYZuj3jfF69Y0xzw/QyuUzl6LiBUfgH3pSr+Qwju/KCMkTOb0Xm6QN8rnnx24s15lu504DdaQY6EiayjC8myfaEWWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zr21+9dG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zr21+9dG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF50C16AAE;
	Fri, 13 Feb 2026 13:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990724;
	bh=SXuSZXnDpYoVDRpNkxE0kgpFs3lbAzqTGjsovkQD0Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zr21+9dGRXOzOPE1OxNe7ogC045qdLO1G8QO5HVCSSxDCf1TwQM7cGaKkwNCvyJXB
	 4DWtXCi1m/Q58BwMnwGbiPQi6yDf4ELrjWOINGRjx7ChFjUBauwGUkIMhaVYJgaH65
	 K2RWk3BNCodmoj4CC8pkkNJo8dvXJ8VeIVXJvsko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.19 34/49] crypto: virtio - Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req
Date: Fri, 13 Feb 2026 14:47:53 +0100
Message-ID: <20260213134709.973740753@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 14f86a1155cca1176abf55987b2fce7f7fcb2455 upstream.

With function virtio_crypto_skcipher_crypt_req(), there is already
virtqueue_kick() call with spinlock held in function
__virtio_crypto_skcipher_do_req(). Remove duplicated virtqueue_kick()
function call here.

Fixes: d79b5d0bbf2e ("crypto: virtio - support crypto engine framework")
Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_skcipher_algs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_skcipher_algs.c
@@ -541,8 +541,6 @@ int virtio_crypto_skcipher_crypt_req(
 	if (ret < 0)
 		return ret;
 
-	virtqueue_kick(data_vq->vq);
-
 	return 0;
 }
 


