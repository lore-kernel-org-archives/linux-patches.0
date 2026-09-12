Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6004078E8;
	Sat, 12 Sep 2026 09:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207197; cv=none; b=AzgDBJOcfBqURbXmJ+N3m8Zv79Ne0xiL3QxFaAFgzQS3smJEdDhQTQtXLZlL7Pntpe49MIdkt3CyYm8AGKTLc4W75exKJRyefK6jKvBT7zeNp3Ltxdb1+VJTbVwm8yxCr+CJVpdhtAhFuvftmzIyR8i1Ut8uhHYNEbsFS0R7W4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207197; c=relaxed/simple;
	bh=m4+VbrXmgaFNRTUPALRsw6w8wjI1HxNNVKPG1rjsWQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFV0rMTM44ALLVTfVPub5rXIeSNK7zc2qyRBGtbIP/3FufBC+uBiKbBozNrlr3fNue9l0bD6M2U8KrBUSh5n5O0xcRqd4xZxfW9WJRs0RHvjxeXAOiGYfD2wlvbYh2r2ZyEjvpKeFL/4kp/mzVZllRF5pYN30gZqFK814nTFumU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B34IYRHm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B34IYRHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB1E1F000FF;
	Sat, 12 Sep 2026 09:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207195;
	bh=naQMkpgSNMtQE6sHD/rHPpS0GSzJ+uE6ckBdDfpHMvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B34IYRHmUqO5O694zQMcFmXaVYozedzlX11aXnFyteu0TLuwU8Dvbn3D7FjpMVZu0
	 8Gypbd5KdoikdBOzBPU9SW+YQfKrjaBkcKDUC8z49XadrdWh0OhrnwcOe7nqlxwM53
	 S2KNc+ioO4urvu2KXR/QrDtNTYC4cgbLUOKG0Z18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0361/1518] iommufd/selftest: Avoid selftest dirty bitmap size wrap
Date: Sat, 12 Sep 2026 08:42:10 +0200
Message-ID: <20260912065631.637132107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Moelius <sam.moelius@trailofbits.com>

[ Upstream commit 4132ba2ae2cf14c289e3fabc1c95ac244d643356 ]

IOMMU_TEST_OP_DIRTY sizes its temporary dirty bitmap from length /
page_size.  Very large selftest ranges can make the DIV_ROUND_UP()
additions wrap before allocation, producing a zero-length allocation while
the later test_bit() loop still walks the original number of bits.

The selftest helper does not need to support unbounded dirty bitmap sizes.
Reject requests that would allocate more than SZ_16M for the temporary
buffer.

Fixes: 79ea4a496ab5 ("iommufd/selftest: Fix buffer read overrrun in the dirty test")
Link: https://patch.msgid.link/r/20260628152331.82122.408afd7b466c.iommufd-test-dirty-bitmap-size-wrap@trailofbits.com
Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/selftest.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index 35c42ff4355a7..cd3d1380cf6c5 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -10,6 +10,7 @@
 #include <linux/iommu.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/sizes.h>
 #include <linux/xarray.h>
 #include <uapi/linux/iommufd.h>
 
@@ -1806,6 +1807,9 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 	if (!page_size || !length || iova % page_size || length % page_size ||
 	    !uptr)
 		return -EINVAL;
+	max = length / page_size;
+	if (max > SZ_16M * BITS_PER_BYTE)
+		return -EOVERFLOW;
 
 	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
 	if (IS_ERR(hwpt))
@@ -1816,7 +1820,6 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 		goto out_put;
 	}
 
-	max = length / page_size;
 	tmp = kvzalloc(DIV_ROUND_UP(max, BITS_PER_LONG) * sizeof(unsigned long),
 		       GFP_KERNEL_ACCOUNT);
 	if (!tmp) {
-- 
2.53.0



