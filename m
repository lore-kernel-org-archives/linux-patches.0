Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48924E2340;
	Mon, 31 Aug 2026 13:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183589; cv=none; b=UmVbZG++Jqe6C/JMO4JMFz2nAJ3dG0mjvgwQoRSulPsFmwiRO5qas1LsyKfEd0aUCD5hCUZT6d4/OX73OMqR/jixn1FaBHlxX9QbbphCn0heiZA3QVkPPwm0D5zuChmEz2BTWrigyIfjtc9ffn/A1akdWF7EiRSBu+lgO8aSM1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183589; c=relaxed/simple;
	bh=Jko7fGfflUoWWbUi0lna6/89RXRzJOErPGM8IbLmvbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWm68mYvGKQ0sbxQ27mjHSP+UZH8FLogzT2vzhBqFtJkSBNz7r9BMc4FMAyRoRBf+1bahhGhmfJ4C/eu54FArBt3wc23jjGZEvQbwKAi3afu5MpEitgnilo8x/O9r0KG1g7d+NMUnkRe1uFsEjT+yoG4gau73QyECrafxVG4UVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vW/X9x5T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vW/X9x5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B041F00A3D;
	Mon, 31 Aug 2026 13:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183587;
	bh=hCP91nn8COhDWT9wqhz3hHaYbzS8sWBPft9OX6vM89k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vW/X9x5TwFusJnlH3bf/XJeotAc4QKWMW3m5A3MQ+v+yusuNPr17nQA0xQRtPYbKu
	 F3kEgUcs0SN2eF0beC5Ffi5mZ9jXxXymr93p1PrE4Kt8AFd+0hSNFV5Zf1JVQlZJSM
	 anbamROhSwgEHre0KoW+9zM3lGFNacd5gaUVEHUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 7.2 49/71] crypto: virtio - bound the akcipher result length
Date: Mon, 31 Aug 2026 15:34:14 +0200
Message-ID: <20260831133401.778849154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


