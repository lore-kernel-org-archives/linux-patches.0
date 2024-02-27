Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DEF78B61;
	Tue, 27 Feb 2024 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043511; cv=none; b=YrRAf+3PsGOCEPg592f8Blnd4c4L3Qke/288J7FyPq+kgE+ZNMl/krBagy/NxBcP7qT7yNABZ7cHrM85aqOT7R/RgytLvBHftfJbTCMkx+K+HHOY2m4IzpE2LhVadLFgO/xejoSUN+F+Gjups8BehAqotx3PuJBC+9l8aFfNCUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043511; c=relaxed/simple;
	bh=NOHSWGr4Ic29x3+ulHbJ2FfxvyVAE6CJzhvPLVcBIhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnSsYiuUiQIhffatrhiMCtaR17dF7wFeReOv7oeItPJd1Ag4AFvnWQVLJaAL/vOcTSaD3cXy6eNcTUxZul/0f/Ufx4tWhvG6kY+FgBPxXqtctrgCt4SkglC8BlMf6MS/d+O5A8Cp7djg/z2iQAggUOzOuIE0RKQ9iVzs3lYGNe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5Zb0TW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5Zb0TW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8B4C43390;
	Tue, 27 Feb 2024 14:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043511;
	bh=NOHSWGr4Ic29x3+ulHbJ2FfxvyVAE6CJzhvPLVcBIhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v5Zb0TW6oBWKnYfdYBx3TzhWjLcRveVaTOmi9FwHDKdy/l7TtZFBKr9l3d8xXHqH5
	 nTRB+qARLeQOG/QU5brWnl0Qpb7ACev0bM8Dpv1jXDQhkj+FWdMS1CK+jnuohhQc3T
	 WL8gbrti2tFq0j74dwp68rWw4a5WD+OIAfDz1434=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhenwei pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 106/195] crypto: virtio/akcipher - Fix stack overflow on memcpy
Date: Tue, 27 Feb 2024 14:26:07 +0100
Message-ID: <20240227131613.965849715@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhenwei pi <pizhenwei@bytedance.com>

commit c0ec2a712daf133d9996a8a1b7ee2d4996080363 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/virtio/virtio_crypto_akcipher_algs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
+++ b/drivers/crypto/virtio/virtio_crypto_akcipher_algs.c
@@ -104,7 +104,8 @@ static void virtio_crypto_dataq_akcipher
 }
 
 static int virtio_crypto_alg_akcipher_init_session(struct virtio_crypto_akcipher_ctx *ctx,
-		struct virtio_crypto_ctrl_header *header, void *para,
+		struct virtio_crypto_ctrl_header *header,
+		struct virtio_crypto_akcipher_session_para *para,
 		const uint8_t *key, unsigned int keylen)
 {
 	struct scatterlist outhdr_sg, key_sg, inhdr_sg, *sgs[3];
@@ -128,7 +129,7 @@ static int virtio_crypto_alg_akcipher_in
 
 	ctrl = &vc_ctrl_req->ctrl;
 	memcpy(&ctrl->header, header, sizeof(ctrl->header));
-	memcpy(&ctrl->u, para, sizeof(ctrl->u));
+	memcpy(&ctrl->u.akcipher_create_session.para, para, sizeof(*para));
 	input = &vc_ctrl_req->input;
 	input->status = cpu_to_le32(VIRTIO_CRYPTO_ERR);
 


