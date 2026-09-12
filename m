Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDBC2E88A4;
	Sat, 12 Sep 2026 07:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198583; cv=none; b=o/9nuntaclfsddXymwqJQSylHo3BV8z/RuVxywciJGETknORk+3G3nTiRNzQDYMMzqv1xDtiwPH2HcMM1u/2ks11BnffcdmhUM0B2HaDRkT5su5Ra3ocj8Uo/XR/ZZidAASnhTcgUbkzAOZrNvBEhOszT5rJodX8Nec6HfT49L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198583; c=relaxed/simple;
	bh=bIEYWN6W2+n8jOuQ3t8+7DZ08XKvotS3xx8yWXF20HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Btf0cMxtJ1Zx6gvTaNNDhtAgbpTzrvY3dZP5kv4KgS1yBzmm5B59jIsuL2GFHoxqSKFM+dP3TswEwN3zq5v3vxpOcdCtrEsD6rjqRsC1jDo7jBVxUXDkUAPeL6P5pN1ZCh3znQfB48cePEUEBaZ/0hM6Hfsw2Bcuk9ITtOMwqGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIApYmUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIApYmUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16861F000FF;
	Sat, 12 Sep 2026 07:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198581;
	bh=l3Z90DKiPleblb1fXtnDOKA4L7HoSjw/+XcDkDHyHdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GIApYmUh4lvoCa0bo70KTVDzN/nDs5pH2g9KaeT6xbS6uODtnMQmDEUbw7ggsVo8U
	 FYUrKqNHlRjUKZY/Oq7E+ma5HHX9arNzZv79xuUbeU+FIMY9wEsCIj6Lk2RDgPbY/J
	 p92WNKq/dScu/cxJuA6RohHzL6plrFXFTvbxicS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0367/1815] iommufd/selftest: Avoid selftest dirty bitmap size wrap
Date: Sat, 12 Sep 2026 08:35:17 +0200
Message-ID: <20260912065657.516788736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 727b59799d5f0..55f21c799d8e6 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -12,6 +12,7 @@
 #include <linux/iommu.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/sizes.h>
 #include <linux/xarray.h>
 #include <uapi/linux/iommufd.h>
 #include <linux/generic_pt/iommu.h>
@@ -1705,6 +1706,9 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 	if (!page_size || !length || iova % page_size || length % page_size ||
 	    !uptr)
 		return -EINVAL;
+	max = length / page_size;
+	if (max > SZ_16M * BITS_PER_BYTE)
+		return -EOVERFLOW;
 
 	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
 	if (IS_ERR(hwpt))
@@ -1715,7 +1719,6 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 		goto out_put;
 	}
 
-	max = length / page_size;
 	tmp = kvzalloc(DIV_ROUND_UP(max, BITS_PER_LONG) * sizeof(unsigned long),
 		       GFP_KERNEL_ACCOUNT);
 	if (!tmp) {
-- 
2.53.0



