Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F8F5C8FC;
	Tue, 23 Jan 2024 01:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974378; cv=none; b=gNHlQT5Dnbv/BG9jrtgWmr22+S0Q35TYvDi0/e+6qa14ClQ+/F9EAIIblZM4khKySjvxyOgJ74qAOQkyHmkPjHfg7Vrx6V7R2rqLABxIe5JRQdNVuVxH7lhScQfbeCxrJw+aypsyp1UV3eRydkv+HRQsK9f2TFoYR/Gplo80KXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974378; c=relaxed/simple;
	bh=zF6zwedgcHaBN1+aFzcwh/pOqmVXZmxksmYWNFV5CeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUfgTYxgeNm+bKj5fsvgtMbeBRG7ijVeUupgWuOPsiNHMgET7YBFj0ZekeBm8QvcTmcMoLAeO9HnkTFdn2DZIRIfaIpwW0HRVqFAFqwSC3l9eXalTuJzn+v4zh9O9D0pBmztOacKocXUIF8zBmt9b87dtGoSP1MHUXFHbt95Xkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ul+8AZda; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ul+8AZda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891D3C43390;
	Tue, 23 Jan 2024 01:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974378;
	bh=zF6zwedgcHaBN1+aFzcwh/pOqmVXZmxksmYWNFV5CeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ul+8AZdaczkYLjCiyQBuI4ySSfyjvy2hHR4GkoMLCQZdbTNvRxvdiw6GXpyDIySbr
	 Jo+dAMAWrf3FslGTrYW4sCWXdeKT2tWCSjCq0yO6ZWwjR26vsUrfs9fsWe/ffa+5Hc
	 oT43OWLaydsKrNJDy9huOpQwvPBBufJ56gs9VE5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/583] crypto: sahara - fix processing hash requests with req->nbytes < sg->length
Date: Mon, 22 Jan 2024 15:52:03 -0800
Message-ID: <20240122235814.357309253@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 117aa4296c2a..477b4d8b450d 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -776,6 +776,7 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
 				       int start)
 {
 	struct scatterlist *sg;
+	unsigned int len;
 	unsigned int i;
 	int ret;
 
@@ -797,12 +798,14 @@ static int sahara_sha_hw_links_create(struct sahara_dev *dev,
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



