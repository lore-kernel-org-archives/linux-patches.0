Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90B937757F;
	Tue, 17 Feb 2026 20:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361041; cv=none; b=FlVcDsKSKN+dSVbnB4JrP9wr/eXU9BtDUEMwzloCrxCQYeovGm96bFCR5naEEI7UDzcSuj8KNnU2UESU+9SrTAbd0txU2uC8S71thvRD1vp6rsrpi6vGYWGA7XPdYvGPcKZkY3a5S95zpJW46q3C1pj/aS7icHJzpNOhTJou2gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361041; c=relaxed/simple;
	bh=Qn8E5KX2TvLdgtGkUXWgB6X+hYRU7J48mq9vnoGj1Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQl9Fv76ctvsYfHEBTPKOhBM7LP3QOjmyQl3pCo69jI7UuWXHfnhnw/s6U5WL78J7xsYWqOYXsdtJQaemS7Ww9VlxnZk3Q/R9Z3I7YbghLYlHMVky7t/roPwfBQX07pdzjkyQ5bOU4i+L1+mClJ9uRiOiVp3qwTVj29/HKD8FvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLSDgbJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLSDgbJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAEAC4CEF7;
	Tue, 17 Feb 2026 20:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361041;
	bh=Qn8E5KX2TvLdgtGkUXWgB6X+hYRU7J48mq9vnoGj1Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLSDgbJO9r1dBnNgFwnfekwGuTHfHsGBdUD9RGzlN4J7YwH3DB1aQMt5xtFtpGgAD
	 1U3BsZLeU55o+NpdqiZ+2kyaDa5YzBYcoQjhYP6fzxNrOlBiCiLj1nkBxbm13LfM5p
	 KWJOI8BOz+wWxgf2ohWkfA1z1EjPdH6tfZuuKqOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/39] crypto: virtio - Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req
Date: Tue, 17 Feb 2026 21:31:32 +0100
Message-ID: <20260217200003.823512382@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 14f86a1155cca1176abf55987b2fce7f7fcb2455 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_algs.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/crypto/virtio/virtio_crypto_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_algs.c
@@ -569,8 +569,6 @@ int virtio_crypto_skcipher_crypt_req(
 	if (ret < 0)
 		return ret;
 
-	virtqueue_kick(data_vq->vq);
-
 	return 0;
 }
 


