Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CC915AE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C650C43391;
	Wed, 20 Sep 2023 12:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212199;
	bh=yRb7UzAj27y7UzwdnSrnIchAVjb7a/Bh5m+12m8KUQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6uKzs5NLiTigDuq5+fo7zZXl8G5JWQMevwVlWPQF0v87UTnhJTl4hG3PA4t4sJzS
	 TtEg2zbcFvIDFq6tDiq/bY4buqrfmfUXbxt6l8UO4WbuWyVu0GITrZ4gnuXLCHOnCr
	 wul9bKzz4bNZPFPAg8vj2O/ep85yLiX8Kyivj7Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.19 187/273] crypto: stm32 - fix loop iterating through scatterlist for DMA
Date: Wed, 20 Sep 2023 13:30:27 +0200
Message-ID: <20230920112852.289383313@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bourgoin <thomas.bourgoin@foss.st.com>

commit d9c83f71eeceed2cb54bb78be84f2d4055fd9a1f upstream.

We were reading the length of the scatterlist sg after copying value of
tsg inside.
So we are using the size of the previous scatterlist and for the first
one we are using an unitialised value.
Fix this by copying tsg in sg[0] before reading the size.

Fixes : 8a1012d3f2ab ("crypto: stm32 - Support for STM32 HASH module")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Bourgoin <thomas.bourgoin@foss.st.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/stm32/stm32-hash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -578,9 +578,9 @@ static int stm32_hash_dma_send(struct st
 	}
 
 	for_each_sg(rctx->sg, tsg, rctx->nents, i) {
+		sg[0] = *tsg;
 		len = sg->length;
 
-		sg[0] = *tsg;
 		if (sg_is_last(sg)) {
 			if (hdev->dma_mode == 1) {
 				len = (ALIGN(sg->length, 16) - 16);


