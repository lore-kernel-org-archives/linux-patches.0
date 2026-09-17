Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97204DAF85;
	Thu, 17 Sep 2026 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659529; cv=none; b=UL/eMt0Oaugx5V2RFZlEYkuyc9v/hz1K/ZZ5g8u8wub+B8yJwO2iIztQ9+6C+SA6GxdVhdS8SfKshDi1UmGcRGmQh8A6RWJ+nYzIZGS9fLM/5efscNdHsU/AxgdKApWqPXYomLNQ67F6zWuEqz3kjCTtEvGxsJ0rWh0JArx5UVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659529; c=relaxed/simple;
	bh=OFkdzJ7deq+LAF6a855h79aLdkkcuL5/ZkygQt0ClOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jd9ALoA8wbuVF7zl66Q+OIeTz+j3GiezgbdLxqKJMNt08pFFddUYKCCMvfrUMX4Q7jOu5Pg1AwtGLdqYPnjuzixQ0PTRbhDlX6HnYi6m4LfjCKz27grAZJzK+m/6Mj0LjNCgat/dIO6xZ55ted76U2u7uhZQ6dD94sExsJgfMpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqkdqIBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqkdqIBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103B41F0089C;
	Thu, 17 Sep 2026 15:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659519;
	bh=/2ND6ZA4aZlJypp+gs4vW55whJ/Trfovama9j9IDAKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqkdqIBKKkBHQ22YahYJFTGbgqzwbBdducxo3nP7BH3GNbi9/GNlD6F3UbXR6bPlD
	 RGaq+SAp4b0EessNWOdv3YdL6BSZt7Ftt134dYNOxfJebcLbL3Sxr8yjwJVQDQ19s+
	 PiK5CQdGKqgqvXT9+8HU3TKdcSWJnuBqRKnXoCgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 283/733] s390/ism: folio_put() after error
Date: Thu, 17 Sep 2026 16:09:51 +0100
Message-ID: <20260917151358.433415909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 907a56ab3eb8a58500a58daa76087f17bb2b6826 ]

dmb->cpu_addr was allocated via folio_alloc(). Use folio_put() instead of
kfree() in the error exit of ism_alloc_dmb() to avoid slab allocator
corruption.

While at it, reset dmb->cpu_addr after folio_put to avoid unintentional UAF
by future callers.

Fixes: 83781384a96b ("s390/ism: Properly fix receive message buffer allocation")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Link: https://patch.msgid.link/20260902143733.433574-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 242da20f27e0e..035b233abb4e9 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -231,6 +231,7 @@ static void ism_free_dmb(struct ism_dev *ism, struct dibs_dmb *dmb)
 	dma_unmap_page(&ism->pdev->dev, dmb->dma_addr, dmb->dmb_len,
 		       DMA_FROM_DEVICE);
 	folio_put(virt_to_folio(dmb->cpu_addr));
+	dmb->cpu_addr = NULL;
 }
 
 static int ism_alloc_dmb(struct ism_dev *ism, struct dibs_dmb *dmb)
@@ -274,7 +275,8 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct dibs_dmb *dmb)
 	return 0;
 
 out_free:
-	kfree(dmb->cpu_addr);
+	folio_put(folio);
+	dmb->cpu_addr = NULL;
 out_bit:
 	clear_bit(dmb->idx, ism->sba_bitmap);
 	return rc;
-- 
2.53.0



