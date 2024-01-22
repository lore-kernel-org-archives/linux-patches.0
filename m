Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABA06130;
	Tue, 23 Jan 2024 00:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968419; cv=none; b=b6vGSp7ihWQC9YgrUcAZjb1jAqVGaSL6/oOigFy352/oWiNvD1KraOf6jOHzUTME86ISQUWiPqjNQZRkbkO6e9SVl/8PO9QToKB6Jwi52p7kg3pqw9TJ5sxeav4ZjHdaazuuWWaeL+MayR2x6QXXmJYrF28MDsptIVXxGzu8ysM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968419; c=relaxed/simple;
	bh=66jBS7z8gwXTsYPtJz0SerDcxd/16Iemfcg/YLrS/Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZr9DfVvZ7BX91Si3+VJ64jNhK8V7O+GULlqTBQlyEyvZA2HiuQmVOyHD07taFitcxRgWlLB0OdsgHYfGb0olx64X+b7ctqy9ZWo2TzjT/aGMqxtSRtj6fb+JmGYvXWjYs1MAOK8e+QrgY8eyKa3SgJMtAGoym5jYErqBh+Oqdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/rIGs19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/rIGs19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C458BC433C7;
	Tue, 23 Jan 2024 00:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968419;
	bh=66jBS7z8gwXTsYPtJz0SerDcxd/16Iemfcg/YLrS/Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/rIGs19gAcJkqaxkJYtK5ZmarsFd9mJ4UH6r9H4y3kchq2eQhjy06iN7ywK9K6WL
	 pwP2qbi6CPeVx0W0lOXDP3P8DNA374DzbWppcmoxKZAtPSsyWxW5kvXNkNgbhLEjpM
	 4vyRwEffd4HXZB216IIFGy1CF5lKvYcCj36e8wxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/148] crypto: sahara - improve error handling in sahara_sha_process()
Date: Mon, 22 Jan 2024 15:56:52 -0800
Message-ID: <20240122235714.674381205@linuxfoundation.org>
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

[ Upstream commit 5deff027fca49a1eb3b20359333cf2ae562a2343 ]

sahara_sha_hw_data_descriptor_create() returns negative error codes on
failure, so make sure the errors are correctly handled / propagated.

Fixes: 5a2bb93f5992 ("crypto: sahara - add support for SHA1/256")
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/sahara.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 96cb77abbabb..c69016faff6f 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -1007,7 +1007,10 @@ static int sahara_sha_process(struct ahash_request *req)
 		return ret;
 
 	if (rctx->first) {
-		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		ret = sahara_sha_hw_data_descriptor_create(dev, rctx, req, 0);
+		if (ret)
+			return ret;
+
 		dev->hw_desc[0]->next = 0;
 		rctx->first = 0;
 	} else {
@@ -1015,7 +1018,10 @@ static int sahara_sha_process(struct ahash_request *req)
 
 		sahara_sha_hw_context_descriptor_create(dev, rctx, req, 0);
 		dev->hw_desc[0]->next = dev->hw_phys_desc[1];
-		sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		ret = sahara_sha_hw_data_descriptor_create(dev, rctx, req, 1);
+		if (ret)
+			return ret;
+
 		dev->hw_desc[1]->next = 0;
 	}
 
-- 
2.43.0



