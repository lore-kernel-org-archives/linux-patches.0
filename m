Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400E753E1D;
	Tue, 23 Jan 2024 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970521; cv=none; b=Qp7DJoGSOuBRz6rY8oMkhfqAkNgi2moqnqX/5x+EynVExrRuo+0UlYfOBOZ8bMbeoXfsZ73n1APjWyqU4V7X1UC3DERzWbSYKvgJDSvvoXGObTvpJiug1IDv4bKzAC4WflDGiWl+ofwaPq/lhOpBDWFYkF/Z9TLemTfVQOoQyOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970521; c=relaxed/simple;
	bh=KHfzVisP/Q8a3sqB8Z0bwmOt3rxiHje4ZPGniRPDo8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTaPyFfnPJbrwknzL7QMeR5Gxa6BCiiRv5ce/KnIdsEAZCjzsbRbFJJOi8lT79ljY3+ckOUE68BvlmOK8XeybTa4zzuDCkXIR3YBUZt/g7eBBhnrdYGhNJkz2H8rTjwbVCssqkXqVXveZPtp2AnA4HKnUQbwjYR6eCqqpshacnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtgPDHlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtgPDHlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D09C43399;
	Tue, 23 Jan 2024 00:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970521;
	bh=KHfzVisP/Q8a3sqB8Z0bwmOt3rxiHje4ZPGniRPDo8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtgPDHloQDebkw7GIAIAkD94fWZACP747NZoVyqv9za4Uq6zFcaoiq+JLCAs8GHXS
	 u0Ob0u5Q62d0nLNjYZhQKmiuL5ZkgycB0+PvyAbnJFnvN+lgHm8qz+qWVZnKHD6eMi
	 pLOFNbkW9taXK4dqPgr6yhEY44CHy6qJkrAQca9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/417] crypto: sahara - fix processing requests with cryptlen < sg->length
Date: Mon, 22 Jan 2024 15:53:30 -0800
Message-ID: <20240122235753.102236177@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit 5b8668ce3452827d27f8c34ff6ba080a8f983ed0 ]

It's not always the case that the entire sg entry needs to be processed.
Currently, when cryptlen is less than sg->legth, "Descriptor length" errors
are encountered.

The error was noticed when testing xts(sahara-ecb-aes) with arbitrary sized
input data. To fix this, take the actual request size into account when
populating the hw links.

Fixes: 5de8875281e1 ("crypto: sahara - Add driver for SAHARA2 accelerator.")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 5e0b26f36319..e25636904aca 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -445,6 +445,7 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	int ret;
 	int i, j;
 	int idx = 0;
+	u32 len;
 
 	memcpy(dev->key_base, ctx->key, ctx->keylen);
 
@@ -495,12 +496,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	/* Create input links */
 	dev->hw_desc[idx]->p1 = dev->hw_phys_link[0];
 	sg = dev->in_sg;
+	len = dev->total;
 	for (i = 0; i < dev->nb_in_sg; i++) {
-		dev->hw_link[i]->len = sg->length;
+		dev->hw_link[i]->len = min(len, sg->length);
 		dev->hw_link[i]->p = sg->dma_address;
 		if (i == (dev->nb_in_sg - 1)) {
 			dev->hw_link[i]->next = 0;
 		} else {
+			len -= min(len, sg->length);
 			dev->hw_link[i]->next = dev->hw_phys_link[i + 1];
 			sg = sg_next(sg);
 		}
@@ -509,12 +512,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	/* Create output links */
 	dev->hw_desc[idx]->p2 = dev->hw_phys_link[i];
 	sg = dev->out_sg;
+	len = dev->total;
 	for (j = i; j < dev->nb_out_sg + i; j++) {
-		dev->hw_link[j]->len = sg->length;
+		dev->hw_link[j]->len = min(len, sg->length);
 		dev->hw_link[j]->p = sg->dma_address;
 		if (j == (dev->nb_out_sg + i - 1)) {
 			dev->hw_link[j]->next = 0;
 		} else {
+			len -= min(len, sg->length);
 			dev->hw_link[j]->next = dev->hw_phys_link[j + 1];
 			sg = sg_next(sg);
 		}
-- 
2.43.0



