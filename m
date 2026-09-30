Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9503DA7DB;
	Wed, 30 Sep 2026 19:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797223; cv=none; b=DEH5aG4w20Gr8Uk5MB2SCqfnSeA+erTQCYniNAmNzFbyQvBZaWPTTR2EPe5yZ4wCQsIRoNKK2wxDI7qZp7xNUQF0eh2xluukmWdlVEhUgjaCLjfVwmylp4O8wrZ+GJxN9XthXy7TXQRhVmU4yESUlnPxwQmtCU1obJJnr3PObPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797223; c=relaxed/simple;
	bh=y4Cv4+1s4zB/6DOKCKEwBxpw9brGhrLvmtwd1MCQ0AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATcN9DvfM5Nk2HNrchuUPm76vckJ1abXQogYTkIRJjXsRF60C7QNWZS+MmYMHOc7m27hYUH4jZcRV/+gqf9+G4MfyKaPalQRPRYq80J3Oat/iR3Ro88BaGRU4/hDTk85VXcWQM7XSI5ESynYqCskqr6gaXM2QEGa8ky9fH0zIHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iGKHfOJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iGKHfOJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EB81F000FF;
	Wed, 30 Sep 2026 19:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797221;
	bh=5uEW8l1UHw7wCCDGVsWOvYwUBeH11rrhKpccKfVZHQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iGKHfOJJX15CMriNBeEs7iK88+ioPWLAmxbwMOye2Gtv7lfkSeSSvidYy/mDtaYQ+
	 HlfKa4Muut+j4tu3Ytc+ENLcv6Hq1Z6FqgF5a66EqHfq4fVMXc+7XF8b5TKKxfxVNt
	 BgxDxQyZwtP1mlg0Mg6HBwjrbyV8rjhfu4HotQis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1188/1193] crypto: virtio - bound the akcipher result length
Date: Wed, 30 Sep 2026 17:31:12 +0200
Message-ID: <20260930152500.639687738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit f77a956f6a19f9463ef1527c9d0cda50dded6b92 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -89,7 +89,8 @@ static void virtio_crypto_dataq_akcipher
 	}
 
 	/* actual length may be less than dst buffer */
-	akcipher_req->dst_len = len - sizeof(vc_req->status);
+	akcipher_req->dst_len = min_t(unsigned int, len - sizeof(vc_req->status),
+				      akcipher_req->dst_len);
 	sg_copy_from_buffer(akcipher_req->dst, sg_nents(akcipher_req->dst),
 			    vc_akcipher_req->dst_buf, akcipher_req->dst_len);
 	virtio_crypto_akcipher_finalize_req(vc_akcipher_req, akcipher_req, error);


