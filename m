Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590771;
	b=cqnyKOvct/tSldZH8k5L/n7WWOqTZZfPsczH/Sx27zmbAsu2GqkynAKIghVLtWQ8tMOr
	 7b9IV7p43qMGJpUzfA/jTDXVM8Vh5LJjfPKBAf9f03ltE+b4CSs6P5dKiQ5315ZUKgDq5
	 XolPj3esPPepLy8g8Ds/89EaFbFwVYebO0PV17mr8Ub1OqeGS3gxieQtkFY2JY/P++Fvy
	 9q/kFZ0Kg83UDNUMHdUEfl0Xi558AFvtejVCyqrewsaDhB7OtF05DLDvuwnFEzU7oS2Q5
	 T8FahwlQQUFLtI4n6uCvIqhU1RDOGE3OGsILZKqa2WIrAsGtrj8CdfcXk6TYcpzsbRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u0eHMwTf6X+SFXWpzLef6/D6/Ktz9KLRKxYQaJjrWko=;
	b=wOzErhSaeoVPMtNVIcxt6+69GHBHABNXU29NCuOMVVBDpRcJ/dz14duIgo+eGFdwB/hM
	 NkEFZQJMx4P05lRujurfz9Nnm6lC5Y2zpi6uIWIv9S81C85Dies4HS7PnEs5wWJYlvcw+
	 kAkhcOc2HGCCd4aAV278TFcZgIRiAQ1nRAEMq7h8hcPBxw7pSpvDn5y4djBe6KeEidy/C
	 CXit4E+eUTRCxTVXqgi0CtO/5H7PfzT7Wuj+bBZfhXxWNmzYwDHLUYUKdtJ4DB8WfMjUe
	 q5fGZlHXQB6EN2QPSdaW90VCZIRYUNVAJkJEhihQmORhhC3awmMruI6LDWA3oUbuIIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pKKE9mBc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA43607C36B;
	Fri, 13 Nov 2026 17:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pKKE9mBc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7C91F000C5;
	Fri, 13 Nov 2026 17:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590771;
	bh=u0eHMwTf6X+SFXWpzLef6/D6/Ktz9KLRKxYQaJjrWko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pKKE9mBcuy8vbDf1gUPKSuRAI+x31MrGfuj6BZ5gMZUR2hUdPw2bsTL4Z2/4W6rA2
	 kHuRR9UOwRFVr7hheSb1vfW9fbnondqIxLFNB4I0vB/9YqdGqZ8nvSp8Xfs8suc/Bh
	 EK+fCgta22e+R1GoHkgtYvWcQ/IJCWHpPKgGC7+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 668/686] iommufd/iova_bitmap: Ensure that iova_bitmap_set() handles the full IOVA
Date: Fri, 13 Nov 2026 10:53:21 -0500
Message-ID: <20261113153844.328031924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit e21952d72b4740f08a272d694cca223b6b0099ca ]

Generally userspace is going to step the dirty bitmap through the IOVA
space. However if the bitmap ends in the middle of a large PTE this is
problematic. The first step will clear the dirty bit and report dirty to
the end of its bitmap while the second step will see the clear'd dirty and
report clean for the start of the bitmap. If it happens this ends up
losing dirties.

Further this function is missing bounds checking so if this does happen
ther is a good chance it will write memory beyond what the userspace was
expecting.

Return an error code if this illegal condition happens.

Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/20260925161142.189813-2-parri.andrea@gmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ sashal: Added missing prerequisite support for recording bitmap errors and propagating them through the iterator to the ioctl caller. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/io_pagetable.c |  2 +-
 drivers/iommu/iommufd/iova_bitmap.c  | 18 +++++++++++++++++-
 include/uapi/linux/iommufd.h         |  6 ++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 77891d4d65fb1..a6face8a46f58 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -552,7 +552,7 @@ iommu_read_and_clear_dirty(struct iommu_domain *domain,
 	arg.iopt = iopt;
 	arg.domain = domain;
 	arg.dirty = &dirty;
-	iova_bitmap_for_each(iter, &arg, __iommu_read_and_clear_dirty);
+	ret = iova_bitmap_for_each(iter, &arg, __iommu_read_and_clear_dirty);
 
 	if (!(flags & IOMMU_DIRTY_NO_CLEAR))
 		iommu_iotlb_sync(domain, &gather);
diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index b5b67a9d3fb35..3a7eca3c7d989 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -116,6 +116,8 @@ struct iova_bitmap {
 
 	/* length of the IOVA range for the whole bitmap */
 	size_t length;
+
+	int err;
 };
 
 /*
@@ -384,7 +386,9 @@ static int iova_bitmap_advance_to(struct iova_bitmap *bitmap,
 int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
 			 iova_bitmap_fn_t fn)
 {
-	return fn(bitmap, bitmap->iova, bitmap->length, opaque);
+	int ret = fn(bitmap, bitmap->iova, bitmap->length, opaque);
+
+	return ret ? ret : bitmap->err;
 }
 EXPORT_SYMBOL_NS_GPL(iova_bitmap_for_each, "IOMMUFD");
 
@@ -404,6 +408,18 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
 	struct iova_bitmap_map *mapped = &bitmap->mapped;
 	unsigned long cur_bit, last_bit, last_page_idx;
 
+	/*
+	 * If the range cannot be recorded then the system call returns failure.
+	 * This is to prevent loosing dirties if userspace is expecting to step
+	 * the bitmap through the IOVA space.
+	 */
+	if (!length || length > bitmap->length || iova < bitmap->iova ||
+	    iova - bitmap->iova > bitmap->length - length) {
+		if (!bitmap->err)
+			bitmap->err = -EPROTO;
+		return;
+	}
+
 update_indexes:
 	if (unlikely(!iova_bitmap_mapped_range(mapped, iova, length))) {
 		/*
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index bdd20666d1eb1..65e564965e98a 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -775,6 +775,12 @@ enum iommufd_hwpt_get_dirty_bitmap_flags {
  * Walk the IOMMU pagetables for a given IOVA range to return a bitmap
  * with the dirty IOVAs. In doing so it will also by default clear any
  * dirty bit metadata set in the IOPTE.
+ *
+ * The IOVA range given must fully enclose any IOPTE. If the range starts or
+ * ends inside a dirty IOPTE then the ioctl will fail. This avoids partially
+ * reporting a dirty range.
+ *
+ * On failure the dirty state becomes unknown and the userspace must restart.
  */
 struct iommu_hwpt_get_dirty_bitmap {
 	__u32 size;
-- 
2.53.0



