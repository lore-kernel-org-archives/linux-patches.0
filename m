Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585945;
	b=vb1hAVEO2gOjUjicdySrE9UtZMrMfyDhyksXMRlIc95C/hBDGukMvYIuz6hYiBGDFW6s
	 kxc6KspYdrJvMzyPZf3Ow+6bOmiorxsSMJ6n9YKTDCSam5aUKsn1ckkPE8H4SU2qttI7i
	 1PfE7DDaUzHXpXMXg8zqAPw0Na4oHWTaIIR2rExpTyQtcGh4AgMtyI1mJIDrRnKk8iHAL
	 jfJVprVkV36/JOX1qSMou3HISzuA4131lFAzwsxEFwU2IWxOTzCL/hCkIlAChn0VhJx60
	 TrjRBZMfyO9PPTwQ2C10irQNlKoKmKFbnR8kfa40dCttD1ozmlcXjwPJ+g0FOS3q8tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m+yN35mQo71jvOa3h7F8ESwxw8m1p3SIbO0LtaG5mtY=;
	b=ZbbMOkwo825TlqF0+D+6L1G3u5uKQSbY3RaJ3fuDoB6PL3ymiv9aD9gcPy9+ZQbS19jg
	 j5E0I1JM40iDBsRYAF7Ido9jyjDUrvsleyXUxH3MqLbdmOJ/HUi2/el0JZYsCtSm2yY8M
	 FyawgMNCWXrkf06AryILgejyyFrxhwYu0qW5v0XldgbyUeouLGHiym0vjFJ22dp1l2Yqr
	 cYZGWPZAOCdO0kX6C7kJtajlsGEjJRALM6Xsf7O7sz/kQVPsQjD+0ll7UKlAEzcLiag8U
	 iuWlRw5L+VG24kl4u75NiN5KWAdNS3HJB2sdbTvrwNqau4qcQG8keGZqPBZcxFSxXaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B9PuScRZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA556070FC7;
	Fri, 13 Nov 2026 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B9PuScRZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490C81F000C4;
	Fri, 13 Nov 2026 16:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585945;
	bh=m+yN35mQo71jvOa3h7F8ESwxw8m1p3SIbO0LtaG5mtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B9PuScRZ/kzhCpgZFvtVYGiOTPFHpeHozhayJNLYmv93qfPUd+fZQ39h/dHvKAFSv
	 /2LjJ6O0zjtR/fo4pYLhPJqJQ981UKe+py5f5jQX3867fi0qi+hztz6ZHJ7n/wtnuM
	 fdgENF9QaoKjYr+8iDK2+A6E89G0cWHiTeRku+EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 499/507] iommufd/iova_bitmap: Ensure that iova_bitmap_set() handles the full IOVA
Date: Fri, 13 Nov 2026 10:53:23 -0500
Message-ID: <20261113153814.012525885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Added missing prerequisite error storage and propagation from the bitmap through the iterator to the ioctl. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/io_pagetable.c |  2 +-
 drivers/iommu/iommufd/iova_bitmap.c  | 19 ++++++++++++++++++-
 include/uapi/linux/iommufd.h         |  6 ++++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 283ab372e8da8..5ac736cf5bb5a 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -589,7 +589,7 @@ iommu_read_and_clear_dirty(struct iommu_domain *domain,
 	arg.iopt = iopt;
 	arg.domain = domain;
 	arg.dirty = &dirty;
-	iova_bitmap_for_each(iter, &arg, __iommu_read_and_clear_dirty);
+	ret = iova_bitmap_for_each(iter, &arg, __iommu_read_and_clear_dirty);
 
 	if (!(flags & IOMMU_DIRTY_NO_CLEAR))
 		iommu_iotlb_sync(domain, &gather);
diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
index dac3e657d498d..908c70f5362e0 100644
--- a/drivers/iommu/iommufd/iova_bitmap.c
+++ b/drivers/iommu/iommufd/iova_bitmap.c
@@ -116,6 +116,9 @@ struct iova_bitmap {
 
 	/* length of the IOVA range for the whole bitmap */
 	size_t length;
+
+	/* first error from recording an IOVA range */
+	int err;
 };
 
 /*
@@ -384,7 +387,9 @@ static int iova_bitmap_advance_to(struct iova_bitmap *bitmap,
 int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
 			 iova_bitmap_fn_t fn)
 {
-	return fn(bitmap, bitmap->iova, bitmap->length, opaque);
+	int ret = fn(bitmap, bitmap->iova, bitmap->length, opaque);
+
+	return ret ? ret : bitmap->err;
 }
 EXPORT_SYMBOL_NS_GPL(iova_bitmap_for_each, "IOMMUFD");
 
@@ -404,6 +409,18 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
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
index 5d47d1421c1fc..63a86354e822f 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -871,6 +871,12 @@ enum iommufd_hwpt_get_dirty_bitmap_flags {
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



