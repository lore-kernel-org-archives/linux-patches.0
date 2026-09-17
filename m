Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5BC4078D3;
	Thu, 17 Sep 2026 18:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671433; cv=none; b=Jo0klesXLS6KTz/BVL0WunlkRAoG5eSayFI5jFuBK0aMFqUVmIFK3L5rMyC70JUMrc0B094785ajFCP5qOT4Fs+GxtodsegqZdTE+zkVlBkZfYa/xUAwvKwxjBghyig82+2MGIdLPy+wP/oiaWq291Bt5tgODh3LD9/PNYU4ago=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671433; c=relaxed/simple;
	bh=cWkqaM/zHlDSt5xPKW0Ro9l4VQiWDi9wR4h+zNSgzrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYvJUIa7nRv3Ez6Q0LfUBc56yZ1awMkgxmjO3Y2hHeOLBfiBqLVktgFNj6xTW5D/V4TiITOEDQRQpxDdJe1zIFGsW0JYiEpald1IfcC4bhngL0OGAGbppdsjKN4MJNiTtUT/cFG8PA9gxy8i/zo2sx13hAYxaPmjYMzd9vhi9WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlvfQoRq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlvfQoRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37991F000FF;
	Thu, 17 Sep 2026 18:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671432;
	bh=oQDHrev4AErRqbdS71wFzfPUAoJ1F0XO106AJQd/4GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlvfQoRqnWxKyMoqbd4HNtDCLy891vsLcM8mSBIvuklniQxcaSvqesak3cEKVv7tw
	 TeA6DMxtxyzKPlmscELQ2om/ZUPTWvCKRmxM76EZt1Em6mjlJIUeEQ9hAv/8CKn+3q
	 By4UjheQOYuADApztSEYmHgjEa+dlaOVbUdryCbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0975/1102] crypto: virtio - bound the akcipher result length
Date: Thu, 17 Sep 2026 16:15:18 +0100
Message-ID: <20260917151605.170710681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


