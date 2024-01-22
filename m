Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB7E37C;
	Tue, 23 Jan 2024 01:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972190; cv=none; b=rjLXar4kLChtyvs17wVNqij029e6dcOl7A9XXPU7UhZElAKR1d12LwBc971nnSgu8z1ZiZc3x/36aiVg/dwkpoaJy8WcI9pKtrNM1l5Kjvw0Y0DadT2gkIUN5/lnhoKdxcESVXfg4ZoxJSy7TR+7vmsWt29wpZ7ANNGsdezw6WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972190; c=relaxed/simple;
	bh=wfOMFeVIMd9UGfWYhKTlyVKOwVtq4UkX0vP7NdBTH0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWLgt6Yc2gs4i1Z7ehbgXpDEWIqYQAQ06gvm1ncnbHQAiw42YE/IzVxNIlwDxPDR4OKfLwvBTKQTsPm6SmrhPJb2YXj9TQX5H3ViDFzryCw+W6IpFbrwxThSsWOZFsaLUvvCicbiEN51WU293NdwnwhovtpM3p2nkTN41yp59gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkps+yTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkps+yTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E33C43394;
	Tue, 23 Jan 2024 01:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972190;
	bh=wfOMFeVIMd9UGfWYhKTlyVKOwVtq4UkX0vP7NdBTH0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkps+yTM/yFqvs8AVcKRxygjWGCKEaMIV4jAzN467y9jpSSYk2lJTwH944edhuSgE
	 tnnViSNmZpgHiQrz8N4SzxJ8A2Cc7QOBAJEv2M9PQ0iMx16vk2JLAR0OhDITpU0XLq
	 4vdHeDgg6ts7x6+pQwzoj06gCLZu6skPaC0kdDsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 112/374] crypto: sahara - fix processing hash requests with req->nbytes < sg->length
Date: Mon, 22 Jan 2024 15:56:08 -0800
Message-ID: <20240122235748.535688278@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 434c7e17d273..538beec3b062 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -777,6 +777,7 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 				       int start)
 {
 	struct scatterlist *sg;
+	unsigned int len;
 	unsigned int i;
 	int ret;
 
@@ -798,12 +799,14 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
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



