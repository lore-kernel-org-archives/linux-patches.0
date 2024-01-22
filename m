Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E423C3C;
	Tue, 23 Jan 2024 00:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968268; cv=none; b=YM1gFkDp9viphP5g29BrnQ7ItBTqV7Cyts6l3y5YPc72/VKetADytNbSW5uRsZACdJtqWxQNGooAvL8rAPljrzmtzjdCNeT5EQtnf3e0PFxHpE8qlVDtCOxvcr5UBHSj1DfE3OGV7haXAURB12uGMSUY7EFHZjKU2qVSU14Zyrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968268; c=relaxed/simple;
	bh=EYU7hvOrk1lUyuuA0DQhB+Dfuyz4HqFZuSOQlDBLOPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLVY/dQDcBar//Auraw0xAQljqs8j8tDulkxLR//WhyXM4BSWG1CJ3ks4mh6wwhSUhg+uj9LWxq4fY4E0gHkI0i9KbBaq6o+qtqwIbl7ipBaOTbAjrAuGTN8HzaFUyLBBQmZHLwIgue1uCSamqqL9EoJfwR8FCQoiReHd/XZzqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJlzAqXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJlzAqXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6164DC433F1;
	Tue, 23 Jan 2024 00:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968268;
	bh=EYU7hvOrk1lUyuuA0DQhB+Dfuyz4HqFZuSOQlDBLOPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJlzAqXu7HPMosv2Bz8ilsyR0B5FBVaDMqv/hTxzuOrN5znMJ/eUMd4/mJMVW+dc/
	 cVfsmom2yfBMg+co+M6L61LR1qO1om2xPjkS08WXcr80mmkUchFosml6EGJR8luykX
	 lxlhbPpP0Rdw2RCC5TtKKhfb2AJrx3qp3n5JKTig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 057/148] crypto: sahara - fix processing hash requests with req->nbytes < sg->length
Date: Mon, 22 Jan 2024 15:56:53 -0800
Message-ID: <20240122235714.717613136@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

From: Ovidiu Panait <ovidiu.panait@windriver.com>

[ Upstream commit 7bafa74d1ba35dcc173e1ce915e983d65905f77e ]

It's not always the case that the entire sg entry needs to be processed.
Currently, when nbytes is less than sg->length, "Descriptor length" errors
are encountered.

To fix this, take the actual request size into account when populating the
hw links.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index c69016faff6f..79e0ad0f7d26 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -796,6 +796,7 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 				       int start)
 {
 	struct scatterlist *sg;
+	unsigned int len;
 	unsigned int i;
 	int ret;
 
@@ -817,12 +818,14 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 	if (!ret)
 		return -EFAULT;
 
+	len = rctx->total;
 	for (i = start; i < dev->nb_in_sg + start; i++) {
-		dev->hw_link[i]->len = sg->length;
+		dev->hw_link[i]->len = min(len, sg->length);
 		dev->hw_link[i]->p = sg->dma_address;
 		if (i == (dev->nb_in_sg + start - 1)) {
 			dev->hw_link[i]->next = 0;
 		} else {
+			len -= min(len, sg->length);
 			dev->hw_link[i]->next = dev->hw_phys_link[i + 1];
 			sg = sg_next(sg);
 		}
-- 
2.43.0



