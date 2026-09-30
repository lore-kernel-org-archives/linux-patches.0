Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053A850B8B9;
	Wed, 30 Sep 2026 15:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782514; cv=none; b=YJlhF/vrdOxnDBf2Cr6SNdoUHv+cugbwUobMheJhvadYbBzKw6RMUJnRUl+UN5E163WfQkkt5AJGC2p8ipMUDHt7E12qPLIXMw/bPIdwHZBo7HrG/g5puCFDwZGh9mJu1ilKr4pyMqA8O/PbRjWYJoji4ndkVuHl4LAXsGbh9Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782514; c=relaxed/simple;
	bh=lfoY7ABgBYebNJPVnksUS/BV8vsE8x/QD1U5LLPmeos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/3v5C4aEXL9s1mgs2kq936I1UIgz5cBpVhqsQazVTQEh1QIfsCJLDkOKlF5w/4pXoYL/tDhCutjAQjXaJLJpQVOAWfLKM3qYCi/8jTXmR81GH3msQqgq27EhU7UFKAUpiznlnY8eO57hq531g8y9YNMzYoct3TXO4ax0ulBAAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAQHEVRc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAQHEVRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D6C71F00898;
	Wed, 30 Sep 2026 15:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782504;
	bh=G8fDJqj7tYfuMtQNVU+du5rHxj1nbvdltQ9MASmDfpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VAQHEVRcOBJHU9yOTKovVT8pKo6LUZQs74I1SQ1gQYS/1yMUIhscX2fqs1KI50xv2
	 9uxylCwxbfL5Ji1xRqDAXBNL+H7aANOPwCdReLRDmkwuO8IY6lO6vdeL/h6aKPgbR+
	 Fh9gAF2I9vR1cORQjRQSRyxzF0HiZw0TMYJox0Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaoyang Yu <2426767509@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/595] media: dm1105: fix missing error check for dma_alloc_coherent
Date: Wed, 30 Sep 2026 17:18:28 +0200
Message-ID: <20260930152348.048327458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f00ae8d3b5e37..db08652782ecd 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -769,6 +769,8 @@ static void dm1105_ir_exit(struct dm1105_dev *dm1105)
 
 static int dm1105_hw_init(struct dm1105_dev *dev)
 {
+	int ret;
+
 	dm1105_disable_irqs(dev);
 
 	dm_writeb(DM1105_HOST_CTR, 0);
@@ -779,7 +781,10 @@ static int dm1105_hw_init(struct dm1105_dev *dev)
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



