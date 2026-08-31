Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C6D4AD4DA;
	Mon, 31 Aug 2026 13:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184081; cv=none; b=T3GSoM1hLUy+3XLY4pstX7+xboyO7o7Tl+zFk3lnXScz8DzujPLX4BjEuhNyvMkkm57mA0iIiK6Z0Yrlqpv/cCQoD+hIS4tuvyCFFQOpjJLmxVevo13U3j+KnV8u5514phsWMUzpHQ0LZCf9r9QsN9OoWNv9A1q927lfx3Pj/q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184081; c=relaxed/simple;
	bh=Mm2EcNXKTXGHing/fUgzMpqyL/BE67WZwQ368XJAE8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpOPz5GKJL2A3ui7q9c4nYvF09GViwXgZp5Ic8OOz7Jq8YJZR4kY0uexRkSeRjdzRyPd8eEEYu2riuZfByFVVmvNSePrNj3AjsYVx6x/TS9FOfcP8oWcUrGKMCpiVZPORXbkg+QzlQ/LBz+GzygdCWxlFxJZOx31JCAmb9WZ0Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qK2tohij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qK2tohij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D021F00A3D;
	Mon, 31 Aug 2026 13:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184079;
	bh=fWKEGpAJpmFqz6l2dk6MFNwXhdvnfiKMCFuyxwekgP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qK2tohijtlKnnRXb1iZ2HJjKcpkgFKgR+RfrKi8EwoPxHbwWsUqt+5yjS4ISPs+wk
	 6WFuYTzEm/aU3Zl85wXZpLtWNjec1N2B5t7yu26qDCojVBAd4+nuhQtwfo1PGY22yo
	 Vtvl+3rr9CjIlha/IUsL27JEKDwTLJeMcjdFGOGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.18 65/83] crypto: virtio - bound the akcipher result length
Date: Mon, 31 Aug 2026 15:34:41 +0200
Message-ID: <20260831133402.815877776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit f77a956f6a19f9463ef1527c9d0cda50dded6b92 upstream.

virtio_crypto_dataq_akcipher_callback() sets the result length from the
device-reported response length without bounding it to the destination
buffer, which was allocated for the original request length.
sg_copy_from_buffer() then reads that many bytes from the destination
buffer; a backend reporting a larger length over-reads adjacent kernel
heap into the caller's scatterlist (an out-of-bounds read).

Clamp the reported length to the originally requested destination length.
A conforming device reports no more than that, so valid results are
unaffected.

Fixes: a36bd0ad9fbf ("virtio-crypto: adjust dst_len at ops callback")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Message-ID: <20260622-b4-disp-3a2c09a8-v2-1-d1a809281db4@proton.me>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -88,7 +88,8 @@ static void virtio_crypto_dataq_akcipher
 	}
 
 	/* actual length may be less than dst buffer */
-	akcipher_req->dst_len = len - sizeof(vc_req->status);
+	akcipher_req->dst_len = min_t(unsigned int, len - sizeof(vc_req->status),
+				      akcipher_req->dst_len);
 	sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
 			    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
 	virtio_crypto_akcipher_finalize_req(vc_akcipher_req, akcipher_req, error);


