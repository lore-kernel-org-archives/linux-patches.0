Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9360A50257C;
	Thu, 17 Sep 2026 17:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667318; cv=none; b=hbER7fr1uWzQzUXry6K6s6jEl5Q7ZzBKck//Sq0kbWz5RCKahKPFCHTy8UFDXbI5l4tv7Y0/OOXdH37fdX9MbXfJO8nUCZnFeRLSnQtxNI1ZAqFnWn52cs2TmnwxHxeIan8zqtZBBcDqiL06Q6BTnn+dcmoeAlc4+CZpe3m2YPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667318; c=relaxed/simple;
	bh=yjOhdQDp2xSzsMQaVLA6yEWj4A6K3CSFkUk/2TSM/6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWhyYd9IEWZt90YVZr8tW58QbhwkQZQK1kdyCwyk6IcDNqso4OmjhNxEZt7wzDNmhBVMjvebz6euWVMAv56l/dq/L+yQVQO/Pv9kHvfwVohnT4wOcgn8+jItQcWJSRTFQGuv+V4bfS87Cc7eDybOS4+g0ODSbzPdU/On5TapT44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j8/cr8da; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j8/cr8da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E156E1F00893;
	Thu, 17 Sep 2026 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667316;
	bh=h8GL8BlEaCueQ54CaMMi4hgzLJaIXAtYTsP5wLxYamk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8/cr8daBQ7a+hJTH4y49XIG9ax+gtCWeIjUuj4YNb5Qz4VzxffM+uEtycXJaipW5
	 g2MiX6IccxckPbuDVwbnyxfcly/ULsBcrKefmMOOypNoh5tlqrcO3Tv9t9LsLT1BEL
	 MQx2UnSKvrJ/twDSAziNtztdi17UlpGqBwlBk2PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Yu <2426767509@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0045/1102] media: dm1105: fix missing error check for dma_alloc_coherent
Date: Thu, 17 Sep 2026 15:59:48 +0100
Message-ID: <20260917151540.579558023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Zhaoyang Yu <2426767509@qq.com>

[ Upstream commit 3eaac9e02d8591d3c790db572ef1c8fa5a841fdb ]

The return value of dm1105_dma_map(), which handles DMA memory allocation,
is ignored in dm1105_hw_init(). If dma_alloc_coherent() fails, the driver
will proceed using a NULL pointer for DMA transfers, leading to a kernel
oops or invalid hardware access.

Fix this by checking the return value and propagating -ENOMEM on failure.

Signed-off-by: Zhaoyang Yu <2426767509@qq.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/dm1105/dm1105.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index c1d55b9836744..abd86488064b5 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -768,6 +768,8 @@ static void dm1105_ir_exit(struct dm1105_dev *dm1105)
 
 static int dm1105_hw_init(struct dm1105_dev *dev)
 {
+	int ret;
+
 	dm1105_disable_irqs(dev);
 
 	dm_writeb(DM1105_HOST_CTR, 0);
@@ -778,7 +780,10 @@ static int dm1105_hw_init(struct dm1105_dev *dev)
 	dm_writew(DM1105_TSCTR, 0xc10a);
 
 	/* map DMA and set address */
-	dm1105_dma_map(dev);
+	ret = dm1105_dma_map(dev);
+	if (ret)
+		return -ENOMEM;
+
 	dm1105_set_dma_addr(dev);
 	/* big buffer */
 	dm_writel(DM1105_RLEN, 5 * DM1105_DMA_BYTES);
-- 
2.53.0



