Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21B5626;
	Tue, 23 Jan 2024 00:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970675; cv=none; b=FY0Y4Ua3ErctoDqWxleE/GrDU5694V7e2jHW8rXAdpsA7srAiZoAPRKQ/IDGyC1mE5aRkkw3IvI1/Brqjss/rvgwokcmcQWxZ481E8GcmYpboPuys25tvArSSgHCMIwCkeV3q2kKaqGHZa3QR5pQNA00FGSIzVYuw+C67nknp4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970675; c=relaxed/simple;
	bh=nwaGyICvmlgYl3V58uOghi8r2ry9ikIa0uDsGkvbgCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXU6L/T2M0IpJWcWtSHRzPa4UJOjNpsh3X+YCX4WAF50s2dcKgI9cTC3a9BJ0vTe+s0guRqX2fIHbCalsgvcsDGsNacnApTJ4bTysmRyOQq9kI7Wp6klU9uHIWYNgIq+HyZO6eJxWwLSwuXPuNV8OUmu/K9VYD8u9BSKpsgULrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDzW/WUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDzW/WUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB027C433C7;
	Tue, 23 Jan 2024 00:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970675;
	bh=nwaGyICvmlgYl3V58uOghi8r2ry9ikIa0uDsGkvbgCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDzW/WUESNZJNkPMwSLgkIWtSGZupD22vWdODrrFm5MHpCTi1ASJAvkKFRSnPQ+xE
	 NqnWUYSeyPkPoW7fH3vGHdu+slM8bUsfKzgytGxDlwvmayHuzFUnm1u9Rbg1Jojd3g
	 5pKH9P+WeVeFf09g86Q651s7CqJxdKHIDqbKW3PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/417] crypto: sahara - fix processing hash requests with req->nbytes < sg->length
Date: Mon, 22 Jan 2024 15:53:48 -0800
Message-ID: <20240122235753.790918663@linuxfoundation.org>
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
index 6e112e41a0c7..b167f92279ad 100644
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



