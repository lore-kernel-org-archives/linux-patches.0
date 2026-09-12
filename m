Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D1E2F531B;
	Sat, 12 Sep 2026 12:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215587; cv=none; b=K0lIXD221YebCWSg8BnI02UPZGAmLpcIG8AMdkLLWx9qssEWpEQ2SQ2GxtRyCPaOWZTw/2UuU0KiHzpnKrF6UmNpJf3yUO5/yuF3ikqfLj+qc2S593BEU6gvULrPjZKJ0tPzGLN4JrqanDHX1JIeOgQnJpnEGMujRwypxHu8rYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215587; c=relaxed/simple;
	bh=wRpq5ktC1ksMOwUgpoGjseJIm8kXITHguFfeFW+sBnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INcZTUcIHcWgxMRtBCJmLdS56CPixYssUUwlUUa/Uuj0aotY60X/obnuQ0LMp8l378Ov3VAT3qbtPageagDI4FOiXWKBm2TblXWrHpZPcoMO0ajf2vTAXyyenIkSPinx9FlVJ7Ef1Skd2+OrGYlDyP335GliUmFXrinzmSUsfOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jloFUv2m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jloFUv2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB481F000FF;
	Sat, 12 Sep 2026 12:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215585;
	bh=i3LPzW+v5Bkga8aR/J33IqZj/i6YURdZakuHCDWeI1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jloFUv2mW226WKCIxWci0mpBSNxMiNfeRpYbMp0g35up0qqMcLc9xmQQufMTKewn0
	 63bVF+v1ptnnQnrR2Ze5oHuomvbiFXfLq5eXBchKdKFNhSQCi2tpRvpL2hx06LpDGL
	 Cmnr7Wa97mT7S558ETLgLqu6MBsvl7kq3KbY/U8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Moelius <sam.moelius@trailofbits.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0519/1376] iommufd/selftest: Avoid selftest dirty bitmap size wrap
Date: Sat, 12 Sep 2026 08:49:05 +0200
Message-ID: <20260912065619.104521932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index aed260d4a93cc..8ec251acd9238 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -10,6 +10,7 @@
 #include <linux/iommu.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/sizes.h>
 #include <linux/xarray.h>
 #include <uapi/linux/iommufd.h>
 
@@ -1359,6 +1360,9 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 	if (!page_size || !length || iova % page_size || length % page_size ||
 	    !uptr)
 		return -EINVAL;
+	max = length / page_size;
+	if (max > SZ_16M * BITS_PER_BYTE)
+		return -EOVERFLOW;
 
 	hwpt = get_md_pagetable(ucmd, mockpt_id, &mock);
 	if (IS_ERR(hwpt))
@@ -1369,7 +1373,6 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
 		goto out_put;
 	}
 
-	max = length / page_size;
 	tmp = kvzalloc(DIV_ROUND_UP(max, BITS_PER_LONG) * sizeof(unsigned long),
 		       GFP_KERNEL_ACCOUNT);
 	if (!tmp) {
-- 
2.53.0



