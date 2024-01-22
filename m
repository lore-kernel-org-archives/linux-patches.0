Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDFD62800;
	Tue, 23 Jan 2024 00:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971111; cv=none; b=Fvoikh8z8+S3TgfmeG60EtJ1n5ne/H7y/382pApEukmRxh8QMjk2t3qIaf6rBg6JEPjaQyenOdPSxFK3sps0jN7LrqSOchQhoC0qxb3L3pMLi7+QWUwFJfdrzB5SHe3ICJROVsRliL0MWdv4P9d94GN5YNv4nN1sbozh0RPvR8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971111; c=relaxed/simple;
	bh=phKcP3kRgQkNpTFPw6GL7GGIg7LyK9ZWqgG/icySZ30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUXOSS7XMOepYqhfz0QNrRfr2Nlh3u/RZBWM26LRFCyRx3sQA/6ARIRHw30Imsnrgi/wStSCTqScbKCu5tZm1MywQ6Fy2B4CUV7fVENiF2cYbgxo9uTO/Wc7FgZTIk8/YA9AumwbSUSumwpwePfahISaMCBkNPn9I9sPweizbO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=El22qeEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="El22qeEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72444C433F1;
	Tue, 23 Jan 2024 00:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971111;
	bh=phKcP3kRgQkNpTFPw6GL7GGIg7LyK9ZWqgG/icySZ30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=El22qeEopDSxt5O5bYhDDaLGmYSEfdckBWHzT4tH6SXp6FbaoRrKlB+NriAUpTIYC
	 03wyoiWUHxNtrjlxaLrR7m+AwrqPPQk3SreUaMVEt8TrJ0hrsM2ZfabWkYFA2P90N3
	 THydZn2fDOrqQR/Pg0XPfZyN05ep67q0Jve/1mXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/286] crypto: sahara - fix processing requests with cryptlen < sg->length
Date: Mon, 22 Jan 2024 15:56:36 -0800
Message-ID: <20240122235735.493483151@linuxfoundation.org>
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
index 2ef177680b2f..855c232d66a2 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -444,6 +444,7 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
 	int ret;
 	int i, j;
 	int idx = 0;
+	u32 len;
 
 	memcpy(dev->key_base, ctx->key, ctx->keylen);
 
@@ -494,12 +495,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
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
@@ -508,12 +511,14 @@ static int sahara_hw_descriptor_create(struct sahara_dev *dev)
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



