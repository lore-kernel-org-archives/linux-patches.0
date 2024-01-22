Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7484066B52;
	Tue, 23 Jan 2024 01:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971676; cv=none; b=urLQ12sSTCf9dPSYPxfFbjiLr+3TykXv/4YyyU9ZOOQGUIHTVs67uQTRuYijAph/2kXSU00ce3BJ3rD4WSp7ivKt/xbBkpKcvn51sRxh76NJOn9UonrbpWr6JSXyEJMXBs8MoAug3jfGrvgjAOme/7U6K82DYLmY1cq4TQtd/hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971676; c=relaxed/simple;
	bh=dUkZz05+ZX5lW6tS0AJPqeuK4XMjFSSqq58ywjKLLQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiNdQX77gMjfZluLX5ITiu0bpxILTJWg6sbT3LPvnbzsSz+gT1D0/WMxe8KLcaRRKTEAVI9QohKOekykBhKQuDQ6/Ol0Ro3geP7Z+cZteyS+haD/VQ8ubQnMlbhX6dlQ5FZWz72iDTH8e2JDE7qPEVqGrkcM/Z+eTuHhR1JIGug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FihFfpOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FihFfpOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2171AC433C7;
	Tue, 23 Jan 2024 01:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971676;
	bh=dUkZz05+ZX5lW6tS0AJPqeuK4XMjFSSqq58ywjKLLQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FihFfpOHkLBiV3J7CYWSaqB1WsEyOVyPOm4FMhC3RWF6NdX6CJF3FCpOxkC0/uARi
	 OukKN8wWno7GI1MUFa1QsbndEkI9HbQH3c8O8yGf6rmtvOu4gIDT2T5NjpXvDPKK47
	 gkuxqMLnBK6OuAAxZtilwmaGCRkU9lkZBox621V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei he <helei.sig11@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gonglei <arei.gonglei@huawei.com>
Subject: [PATCH 5.10 203/286] virtio-crypto: fix memory-leak
Date: Mon, 22 Jan 2024 15:58:29 -0800
Message-ID: <20240122235739.936869557@linuxfoundation.org>
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

From: lei he <helei.sig11@bytedance.com>

commit 1bedcf22c081a6e9943f09937b2da8d3ef52d20d upstream.

Fix memory-leak for virtio-crypto akcipher request, this problem is
introduced by 59ca6c93387d3(virtio-crypto: implement RSA algorithm).
The leak can be reproduced and tested with the following script
inside virtual machine:

#!/bin/bash

LOOP_TIMES=10000

# required module: pkcs8_key_parser, virtio_crypto
modprobe pkcs8_key_parser # if CONFIG_PKCS8_PRIVATE_KEY_PARSER=m
modprobe virtio_crypto # if CONFIG_CRYPTO_DEV_VIRTIO=m
rm -rf /tmp/data
dd if=/dev/random of=/tmp/data count=1 bs=230

# generate private key and self-signed cert
openssl req -nodes -x509 -newkey rsa:2048 -keyout key.pem \
		-outform der -out cert.der  \
		-subj "/C=CN/ST=GD/L=SZ/O=vihoo/OU=dev/CN=always.com/emailAddress=yy@always.com"
# convert private key from pem to der
openssl pkcs8 -in key.pem -topk8 -nocrypt -outform DER -out key.der

# add key
PRIV_KEY_ID=`cat key.der | keyctl padd asymmetric test_priv_key @s`
echo "priv key id = "$PRIV_KEY_ID
PUB_KEY_ID=`cat cert.der | keyctl padd asymmetric test_pub_key @s`
echo "pub key id = "$PUB_KEY_ID

# query key
keyctl pkey_query $PRIV_KEY_ID 0
keyctl pkey_query $PUB_KEY_ID 0

# here we only run pkey_encrypt becasuse it is the fastest interface
function bench_pub() {
	keyctl pkey_encrypt $PUB_KEY_ID 0 /tmp/data enc=pkcs1 >/tmp/enc.pub
}

# do bench_pub in loop to obtain the memory leak
for (( i = 0; i < ${LOOP_TIMES}; ++i )); do
	bench_pub
done

Signed-off-by: lei he <helei.sig11@bytedance.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gonglei <arei.gonglei@huawei.com>
Message-Id: <20220919075158.3625-1-helei.sig11@bytedance.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -56,6 +56,10 @@ static void virtio_crypto_akcipher_final
 	struct virtio_crypto_akcipher_request *vc_akcipher_req,
 	struct akcipher_request *req, int err)
 {
+	kfree(vc_akcipher_req->src_buf);
+	kfree(vc_akcipher_req->dst_buf);
+	vc_akcipher_req->src_buf = NULL;
+	vc_akcipher_req->dst_buf = NULL;
 	virtcrypto_clear_request(&vc_akcipher_req->base);
 
 	crypto_finalize_akcipher_request(vc_akcipher_req->base.dataq->engine, req, err);


