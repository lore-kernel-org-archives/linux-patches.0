Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12431E8332;
	Tue, 17 Jun 2025 15:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174459; cv=none; b=dS64UHhkFLoRaRGL1K/AmMjkHzg61x09FQTYABlCSSMZ00b5aBvUtZBKMWAykkEvivxpbtHUEEFp6GTwIB1R96HShTghPNNHyE3MqwHT0/PxsuktLnWefjMD971yN3bodtq50MZoJIi8CWk5Jijsb/0D+Mi/f5+HQfi5Qp0r6sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174459; c=relaxed/simple;
	bh=Sz48beAtrTaV/fHyMCVyUx/QcGDmuVDgVDS+LRZQDxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo9tYgqHcN8HZ4Sd/uUs6Fx5vWsuLanJetnC4rqfKSJnWrcccKW6UWt9k2MiwXAP6vgxeSH8ielyFUnHYjl2vWo76Ncl2SixlKBTHVHEkbjmvINMnD2Nl9/rQ1fSiz5M+0xXeNgZ4s+7qJFn1nsLLAl+ybEtiJoZmBa29VZhs9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m7nVbBc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m7nVbBc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6045AC4CEE3;
	Tue, 17 Jun 2025 15:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174458;
	bh=Sz48beAtrTaV/fHyMCVyUx/QcGDmuVDgVDS+LRZQDxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7nVbBc8OCH/GV3uAf3ov0/FI6mEufPURN6wKazttUU5ZbMcYfLQZeBJxjFgFtLZY
	 wd1yWb5zuOyFGH1xHmWBKOBFuAKWfp9GM04b3HLdvLkc5l70dt85C2AcHATlmfdG6S
	 GVWCEeOZDyRakvqP6nvVc+eCvlxtOkneyMsZ0uhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/512] crypto: marvell/cesa - Handle zero-length skcipher requests
Date: Tue, 17 Jun 2025 17:19:48 +0200
Message-ID: <20250617152420.431835686@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 8a4e047c6cc07676f637608a9dd675349b5de0a7 ]

Do not access random memory for zero-length skcipher requests.
Just return 0.

Fixes: f63601fd616a ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/marvell/cesa/cipher.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 0f37dfd42d850..3876e3ce822f4 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -459,6 +459,9 @@ static int mv_cesa_skcipher_queue_req(struct skcipher_request *req,
 	struct mv_cesa_skcipher_req *creq = skcipher_request_ctx(req);
 	struct mv_cesa_engine *engine;
 
+	if (!req->cryptlen)
+		return 0;
+
 	ret = mv_cesa_skcipher_req_init(req, tmpl);
 	if (ret)
 		return ret;
-- 
2.39.5



