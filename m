Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FD41465A8;
	Tue, 25 Jun 2024 09:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308856; cv=none; b=Maufe5oz70zDgw6ebk1rgR0z+YkSkM9tUVmz7G0/Q1LoV8KQlOOKaskne6uMuBzaXKY16DgJhFaCN2cldEfTWYzE5EN1VIIZ/dh45CJhuP1nFkPtIZUir42GtSJh5MPJ79YkofWjgbG9104QkFOKH98kAIrsyfSZvu5qlBIswuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308856; c=relaxed/simple;
	bh=mM3rPnHEWFF1Yxh4MWFw002EJ7VV7lGz+gF42TasOTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcfo2VIwlsIoIBAj/2L5wo8i6fAyVh2ByCNGjK7Nwe5v+osj06qCeAHPy6+SsBht1nRDDWaazgeST83c9doc9FFVhWIwFqRCdppYqbONgZhGUNeDfQxxPzxlkACL9mOGzkn8OGaJ0p6863hPFrslr2vMYtL5bVvsA4jtRhih1FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRclb30y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRclb30y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDF3C32781;
	Tue, 25 Jun 2024 09:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308856;
	bh=mM3rPnHEWFF1Yxh4MWFw002EJ7VV7lGz+gF42TasOTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRclb30ymjpAL9HFEOuT8W6y/DdTn4Kn36m7bYEVIGfts1Gx5TkE4H4Tk5fUhz4yt
	 bdTw/mARkLHBh7okMuQpzZCO5i6NEIJD6wqvpHa8j3oaR8dTQjt769d6oK1WxkkMud
	 9cfvwKTUVID5qQdgVlkvVWIJrlYP/881YjzojWDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/192] crypto: hisilicon/sec - Fix memory leak for sec resource release
Date: Tue, 25 Jun 2024 11:31:15 +0200
Message-ID: <20240625085537.285820956@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit bba4250757b4ae1680fea435a358d8093f254094 ]

The AIV is one of the SEC resources. When releasing resources,
it need to release the AIV resources at the same time.
Otherwise, memory leakage occurs.

The aiv resource release is added to the sec resource release
function.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index c3a630cb27a62..932cc277eb3a5 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -478,8 +478,10 @@ static void sec_alg_resource_free(struct sec_ctx *ctx,
 
 	if (ctx->pbuf_supported)
 		sec_free_pbuf_resource(dev, qp_ctx->res);
-	if (ctx->alg_type == SEC_AEAD)
+	if (ctx->alg_type == SEC_AEAD) {
 		sec_free_mac_resource(dev, qp_ctx->res);
+		sec_free_aiv_resource(dev, qp_ctx->res);
+	}
 }
 
 static int sec_alloc_qp_ctx_resource(struct hisi_qm *qm, struct sec_ctx *ctx,
-- 
2.43.0



