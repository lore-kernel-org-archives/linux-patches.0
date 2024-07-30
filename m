Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31981188017;
	Tue, 30 Jul 2024 17:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359091; cv=none; b=nFPtLPVmUO3C09GqjN12z+DeP5PkW1r/XCR/ztmXXtI2ZUhbRp53E44q8IebZFjcT3JsEnz8rAVCn72e5Dxqm9wz1kzeewbNY+B6yfO7CrHvjzEn1aMo8cheP4z4QDeIMjTo1DbcPrMboenhn98skM6gorgUMjZvg6wSOdSnYAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359091; c=relaxed/simple;
	bh=7Fn+ojY5+p+0A6AtYxa2SscUJbFn1UGh2TvHOtxgGPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+V8QX+XKu32B0VP5184UH1iIw0M/DOF4gZELFbfeOwWzcPbDAKR0PEj1ZJLiZK9mbwU0Ct8GDbEs2mgQeWtnV3P0F3RvuY54AeXlJ9ZUS08iNRzNdlFpoxXrewH84Cq/zF+VYkvM4rcfhKl3qniNxebquRSNR73uTMPJdj1LC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bz60Kii2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bz60Kii2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9043C32782;
	Tue, 30 Jul 2024 17:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359091;
	bh=7Fn+ojY5+p+0A6AtYxa2SscUJbFn1UGh2TvHOtxgGPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bz60Kii2g0TYz/LaJTjSlGdnA31tRSmYktFSd2Aiy6TA+5SkON3ThO0Jh4oOxcIQD
	 26Leo+H6d1b5o2+Q+1u2H2jdf+PWkuUzmhV//FgyJqR7mQuzSayVx8iGv30Xte7YUP
	 GlFF4+WhtU6LF+QuGnM1twQWWphyy27mI+E8PyyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Matt Ochs <mochs@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 432/809] iommufd/iova_bitmap: Check iova_bitmap_done() after set ahead
Date: Tue, 30 Jul 2024 17:45:08 +0200
Message-ID: <20240730151741.764499657@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit 792583656f554e35383d6b2325371c8fe056a56b ]

After iova_bitmap_set_ahead() returns it may be at the end of the range.
Move iova_bitmap_set_ahead() earlier to avoid unnecessary attempt in
trying to pin the next pages by reusing iova_bitmap_done() check.

Fixes: 2780025e01e2 ("iommufd/iova_bitmap: Handle recording beyond the mapped pages")
Link: https://lore.kernel.org/r/20240627110105.62325-7-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Matt Ochs <mochs@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/iova_bitmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index db8c46bee1559..e33ddfc239b5b 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -384,8 +384,6 @@ static int iova_bitmap_advance(struct iova_bitmap *bitmap)
 	bitmap->mapped_base_index += count;
 
 	iova_bitmap_put(bitmap);
-	if (iova_bitmap_done(bitmap))
-		return 0;
 
 	/* Iterate, set and skip any bits requested for next iteration */
 	if (bitmap->set_ahead_length) {
@@ -396,6 +394,9 @@ static int iova_bitmap_advance(struct iova_bitmap *bitmap)
 			return ret;
 	}
 
+	if (iova_bitmap_done(bitmap))
+		return 0;
+
 	/* When advancing the index we pin the next set of bitmap pages */
 	return iova_bitmap_get(bitmap);
 }
-- 
2.43.0



