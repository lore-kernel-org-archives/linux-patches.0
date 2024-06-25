Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C2B1465A8;
	Tue, 25 Jun 2024 09:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309450; cv=none; b=oW3UsGeRwiBxlyQRL/vi6hnXFDmOLZjA6mjik/tnJFduAw2zQlimcspCpa/V1Z8o0XDplKd/eA68Nap6rBfuafAZ5BM9ig7tAZDkMFC1ns8sQ+LXXo/5e/lGriAtSdOppPrQ7KhnKhXz/X4ThwNOjirDULFe1OfYNKxETb2sX0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309450; c=relaxed/simple;
	bh=k0K1vyI8dCW/DFRB1atGzRdQS7BUZW7rEc2pCEL7fD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rgo7roG/vTYGxGBBIsKQGP4fagzZOZDHjp9JejlJkDZwR+ssDSuV3/cS/AljN5oFtTdV8Z9KCsrXRgeV7zyWHMHl+6FQz3x8VcEt5XPteguKgF5QuWDauQvNUO/iI+Q9WZ71wlvRoccc4McD8Kpt+help1PeumNaIbbQysdWiIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4tMG1b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4tMG1b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80493C32781;
	Tue, 25 Jun 2024 09:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309449;
	bh=k0K1vyI8dCW/DFRB1atGzRdQS7BUZW7rEc2pCEL7fD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4tMG1b0Nw2Z3XRLOtPXGH2DSDKhqPsvtS0dInn204MVjFANYYVvSPIE2C+d4MA2H
	 VY/n+HufStccUP3kX+9yfnGcEMczE3T/1dXhi41UF1fhKXHPEv4xEMIC/Zy+XCQFbe
	 +qoYbZsOEsR3QS4FUGlDjH/lDhlEGPzO06wv2V8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/131] crypto: hisilicon/sec - Fix memory leak for sec resource release
Date: Tue, 25 Jun 2024 11:32:37 +0200
Message-ID: <20240625085526.027328922@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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
index cae7c414bdaf4..09a20307d01e3 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -479,8 +479,10 @@ static void sec_alg_resource_free(struct sec_ctx *ctx,
 
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



