Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E83200CD;
	Mon,  4 Mar 2024 21:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588088; cv=none; b=WcMBXlZ/WNhJSiovWBtinP1PuhKGYTsrr49E4dP067qPC/6UiFwGqS1r5RZijkzHGM3/zA9VZ3g+zCmeGmlPxriiso0c+M10HZlng38gC1saMrAiCzDHe5nejD3WtT3AJyvkGcm0zM80ugdiFokhSZXB/gNmzzU+BEu+p0NfipA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588088; c=relaxed/simple;
	bh=V+W/ET5jxPsIRvZaqtIUKJ8vS+ELraFj9ZVd++JO37A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKjbmggiJ6AdFzFCiFhbtoxBqM+NRBBd3T6CHvMPfDLxSSG7XxG0loaVnGvtNd66/k+RU7+wVjTdAFs/rLtWW+tVkyGoYB+2xsy6TvlrY/oCAFCZawOCj3JhYCaLVfzAoP+1Cs6y7NadySCEPXS7izvP2gwaTV868kEL8g4W5BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hz89ZUgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hz89ZUgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5E4C433C7;
	Mon,  4 Mar 2024 21:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588088;
	bh=V+W/ET5jxPsIRvZaqtIUKJ8vS+ELraFj9ZVd++JO37A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hz89ZUgoYAv0w5vYQmb8xsoMF1aFLF182k5/+6/XGpcl+eqnmJwtVDWN+hHRx75jw
	 AY5gxTDxnh1wKUy76WoUwWhpURPNwkce9Ra6BJU0OxxbGygrRmt9hXKaMzOwNf4+BA
	 Gd+y8v3mexIEdKWRfhRh/K7W84gaRBX0VJpsa+js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhenwei pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 02/42] crypto: virtio/akcipher - Fix stack overflow on memcpy
Date: Mon,  4 Mar 2024 21:23:29 +0000
Message-ID: <20240304211537.713350016@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

From: zhenwei pi <pizhenwei@bytedance.com>

[ Upstream commit c0ec2a712daf133d9996a8a1b7ee2d4996080363 ]

sizeof(struct virtio_crypto_akcipher_session_para) is less than
sizeof(struct virtio_crypto_op_ctrl_req::u), copying more bytes from
stack variable leads stack overflow. Clang reports this issue by
commands:
make -j CC=clang-14 mrproper >/dev/null 2>&1
make -j O=/tmp/crypto-build CC=clang-14 allmodconfig >/dev/null 2>&1
make -j O=/tmp/crypto-build W=1 CC=clang-14 drivers/crypto/virtio/
  virtio_crypto_akcipher_algs.o

Fixes: 59ca6c93387d ("virtio-crypto: implement RSA algorithm")
Link: https://lore.kernel.org/all/0a194a79-e3a3-45e7-be98-83abd3e1cb7e@roeck-us.net/
Cc: <stable@vger.kernel.org>
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
index 2cfc36d141c07..c58fac5748359 100644
--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -101,7 +101,8 @@ static void virtio_crypto_dataq_akcipher_callback(struct virtio_crypto_request *
 }
 
 static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher_ctx *ctx,
-		struct virtio_crypto_ctrl_header *header, void *para,
+		struct virtio_crypto_ctrl_header *header,
+		struct virtio_crypto_akcipher_session_para *para,
 		const uint8_t *key, unsigned int keylen)
 {
 	struct scatterlist outhdr_sg, key_sg, inhdr_sg, *sgs[3];
@@ -125,7 +126,7 @@ static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher
 
 	ctrl = &vc_ctrl_req->ctrl;
 	memcpy(&ctrl->header, header, sizeof(ctrl->header));
-	memcpy(&ctrl->u, para, sizeof(ctrl->u));
+	memcpy(&ctrl->u.akcipher_create_session.para, para, sizeof(*para));
 	input = &vc_ctrl_req->input;
 	input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
 
-- 
2.43.0



