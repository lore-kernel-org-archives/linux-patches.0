Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB3C13B2B8;
	Tue, 27 Feb 2024 13:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041256; cv=none; b=FSoxTfQpKXkiUr/8mOKnzfrkXhTjS5iqev+G2XNsb/AacxbK4ZE0W1QuW6LorfPFpu+Ykwl6Z4XjX+PUW4tikQ8V9z1Bbm/UbQKo8Ng+XNa5rXtcxQ9iYa6nCXSesUbrt6GiQDjsdfE/Jph7A+m//CsiMiLBJydX7/BpGgb+t5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041256; c=relaxed/simple;
	bh=lm0+2W/2ecFckhTsGc+OCB+g8BjMF0BwUsg98aOMBuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjUJmdmaRqTLuMwCTpi/inyWZ6M7qHj5B8cJlK9Va0ErxZMwbDyGDCoOulxnvkOCYtqwoKFoYhbZyWU/FOhr2Ezh3M0eyviu8sOlnzm8XSARNtXeMSlA/GfWPO8EnOrPoBwnuJcvHkcw2ms8G5hKlxpzi7MV+YvXq/cHwtVARXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaPe9YQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaPe9YQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E90BC433F1;
	Tue, 27 Feb 2024 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041255;
	bh=lm0+2W/2ecFckhTsGc+OCB+g8BjMF0BwUsg98aOMBuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iaPe9YQcr1QQ4zG2hK+1okXw6zVAUiVYuVE50WOPpZszHoS7dsZXkQj3mxumW9uOn
	 3vrHa3jEPyvjyr+HF7giNHF2nQmUVaGz8Vje6HjF8jAG6uyrBQdnWfgtAk4tiuIN4X
	 60dZAJ5jbFZIe+LBl85Z53TX0heT5rKw7+AweyGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avihai Horon <avihaih@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 246/334] iommufd/iova_bitmap: Handle recording beyond the mapped pages
Date: Tue, 27 Feb 2024 14:21:44 +0100
Message-ID: <20240227131638.838119284@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit 2780025e01e2e1c92f83ee7da91d9727c2e58a3e ]

IOVA bitmap is a zero-copy scheme of recording dirty bits that iterate the
different bitmap user pages at chunks of a maximum of
PAGE_SIZE/sizeof(struct page*) pages.

When the iterations are split up into 64G, the end of the range may be
broken up in a way that's aligned with a non base page PTE size. This
leads to only part of the huge page being recorded in the bitmap. Note
that in pratice this is only a problem for IOMMU dirty tracking i.e. when
the backing PTEs are in IOMMU hugepages and the bitmap is in base page
granularity. So far this not something that affects VF dirty trackers
(which reports and records at the same granularity).

To fix that, if there is a remainder of bits left to set in which the
current IOVA bitmap doesn't cover, make a copy of the bitmap structure and
iterate-and-set the rest of the bits remaining. Finally, when advancing
the iterator, skip all the bits that were set ahead.

Link: https://lore.kernel.org/r/20240202133415.23819-5-joao.m.martins@oracle.com
Reported-by: Avihai Horon <avihaih@nvidia.com>
Fixes: f35f22cc760e ("iommu/vt-d: Access/Dirty bit support for SS domains")
Fixes: 421a511a293f ("iommu/amd: Access/Dirty bit support in IOPTEs")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Tested-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/iova_bitmap.c | 43 +++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index 9d42ab51a6bb3..b370e8ee88665 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -113,6 +113,9 @@ struct iova_bitmap {
 
 	/* length of the IOVA range for the whole bitmap */
 	size_t length;
+
+	/* length of the IOVA range set ahead the pinned pages */
+	unsigned long set_ahead_length;
 };
 
 /*
@@ -341,6 +344,32 @@ static bool iova_bitmap_done(struct iova_bitmap *bitmap)
 	return bitmap->mapped_base_index >= bitmap->mapped_total_index;
 }
 
+static int iova_bitmap_set_ahead(struct iova_bitmap *bitmap,
+				 size_t set_ahead_length)
+{
+	int ret = 0;
+
+	while (set_ahead_length > 0 && !iova_bitmap_done(bitmap)) {
+		unsigned long length = iova_bitmap_mapped_length(bitmap);
+		unsigned long iova = iova_bitmap_mapped_iova(bitmap);
+
+		ret = iova_bitmap_get(bitmap);
+		if (ret)
+			break;
+
+		length = min(length, set_ahead_length);
+		iova_bitmap_set(bitmap, iova, length);
+
+		set_ahead_length -= length;
+		bitmap->mapped_base_index +=
+			iova_bitmap_offset_to_index(bitmap, length - 1) + 1;
+		iova_bitmap_put(bitmap);
+	}
+
+	bitmap->set_ahead_length = 0;
+	return ret;
+}
+
 /*
  * Advances to the next range, releases the current pinned
  * pages and pins the next set of bitmap pages.
@@ -357,6 +386,15 @@ static int iova_bitmap_advance(struct iova_bitmap *bitmap)
 	if (iova_bitmap_done(bitmap))
 		return 0;
 
+	/* Iterate, set and skip any bits requested for next iteration */
+	if (bitmap->set_ahead_length) {
+		int ret;
+
+		ret = iova_bitmap_set_ahead(bitmap, bitmap->set_ahead_length);
+		if (ret)
+			return ret;
+	}
+
 	/* When advancing the index we pin the next set of bitmap pages */
 	return iova_bitmap_get(bitmap);
 }
@@ -426,5 +464,10 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
 		kunmap_local(kaddr);
 		cur_bit += nbits;
 	} while (cur_bit <= last_bit);
+
+	if (unlikely(cur_bit <= last_bit)) {
+		bitmap->set_ahead_length =
+			((last_bit - cur_bit + 1) << bitmap->mapped.pgshift);
+	}
 }
 EXPORT_SYMBOL_NS_GPL(iova_bitmap_set, IOMMUFD);
-- 
2.43.0



