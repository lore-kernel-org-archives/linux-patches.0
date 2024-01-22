Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62186169E;
	Tue, 23 Jan 2024 00:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971168; cv=none; b=lLuAUY/D+9gP3did0LuPcwV5yAm1D+6uO9YCaJ+TnCreXaZL3OC963uGOR57ec7azozozO/Fc7do/bwdOehBaP0Acn8nzwgBv2ZQ31y1ZgG5fch+UaJB0316XlOWc+6wlFpwREsqB5MMMnq0oyNPayjU1NrzjBfC0Jnd8mf5XDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971168; c=relaxed/simple;
	bh=TZyJYNXCg5MY94bKbOKH8D7XAsLvDWOaBAsvRHwj1a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7CrqNSHw/mP0fTKm7wp1JAB/NfUUjfHpcIAvvw95iyv8CUto3y9EkmwOaKUMLaKl7wbU9m6DuWXrlYPfTbVlK3w9kQAdEt54b0r8KwvhVGBsf+GcJhAC7lwCvmemJGJDmvXXp5aQyJ0SLr6qLuyq8jIDz6xbVHZg3Ieau10NVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xg/qAp+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xg/qAp+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277A8C43394;
	Tue, 23 Jan 2024 00:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971168;
	bh=TZyJYNXCg5MY94bKbOKH8D7XAsLvDWOaBAsvRHwj1a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xg/qAp+0aS2adgfLyquZatO1b2xiv4R4zZygWwLzlj5qeBeZRAFYQUmfjrzTu7dgO
	 XVOOGBOaGH//rif2gzELmkU+ZugwsT/mhtsePovptX4m4Uum7Y1fId9UeMnvDQzlgh
	 iVx9b7MHqw6kb4CATedo7lKyidJNiTmVvyGJlAhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/286] crypto: sahara - fix processing hash requests with req->nbytes < sg->length
Date: Mon, 22 Jan 2024 15:56:49 -0800
Message-ID: <20240122235736.048889782@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 0ac793f03e28..cdf16e2a81d1 100644
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



