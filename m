Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7A31D26E3;
	Wed,  2 Oct 2024 14:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878484; cv=none; b=Y/rnJF5/FJVxFvv+mRs2glP5oy0UNljGdMjk7oTDj5NlaTStkCbV966iC2OOwnweAmSVvEGlxcGG7T3UtZXzQw8gVuH3oIO5BXnVTD/aIGlErLmb6pluIJsXineR5z9tHZ+v+PQch6QyXGcCra/S44Dus8Olpx0dFCKHYVIf5bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878484; c=relaxed/simple;
	bh=Nu2XMGq6YKS5WrHQkuAvkYmrffSt/RHLGls796CqHbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnCLu+MNcG8WjMiMnMnZlCzAA1DyJH6kKfumlUsGa0ihN+R9rtApdYZ5DCuiD1RuANFJ7vn0zXPabYABRd84SW8+PiGqL8/ELW8e7mMV+we/BD0p+qyAAVrmx0+RtTePgb+IX3tJmi66fG6vabUQsHUibeKz3ye3FgJlJnjruKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiiizT7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiiizT7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426EEC4CECD;
	Wed,  2 Oct 2024 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878484;
	bh=Nu2XMGq6YKS5WrHQkuAvkYmrffSt/RHLGls796CqHbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiiizT7gbX1artDUmPcV0yd/htKNWEa60y8A/iTPH8nsBS0ROZ/aPrC1AAuupPU3j
	 wliYOHSzw69M53j0U9LjJt/n3AWYoloo1Nd86JbeJNKOCWSBsDPWGCJ+0PBCU9+qH9
	 ALG9NvGpW2hSDMcK68ZurOal6ovTRV1pWVfCwkmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Yanfei Xu <yanfei.xu@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 429/634] cxl/pci: Fix to record only non-zero ranges
Date: Wed,  2 Oct 2024 14:58:49 +0200
Message-ID: <20241002125828.034721451@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Yanfei Xu <yanfei.xu@intel.com>

[ Upstream commit 55e268694e8b07026c88191f9b6949b6887d9ce3 ]

The function cxl_dvsec_rr_decode() retrieves and records DVSEC ranges
into info->dvsec_range[], regardless of whether it is non-zero range,
and the variable info->ranges indicates the number of non-zero ranges.
However, in cxl_hdm_decode_init(), the validation for
info->dvsec_range[] occurs in a for loop that iterates based on
info->ranges. It may result in zero range to be validated but non-zero
range not be validated, in turn, the number of allowed ranges is to be
0. Address it by only record non-zero ranges.

This fix is not urgent as it requires a configuration that zeroes out
the first dvsec range while populating the second. This has not been
observed, but it is theoretically possible. If this gets picked up for
-stable, no harm done, but there is no urgency to backport.

Fixes: 560f78559006 ("cxl/pci: Retrieve CXL DVSEC memory info")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20240828084231.1378789-2-yanfei.xu@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 8567dd11eaac7..205085ccf12c3 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -390,10 +390,6 @@ int cxl_dvsec_rr_decode(struct device *dev, int d,
 
 		size |= temp & CXL_DVSEC_MEM_SIZE_LOW_MASK;
 		if (!size) {
-			info->dvsec_range[i] = (struct range) {
-				.start = 0,
-				.end = CXL_RESOURCE_NONE,
-			};
 			continue;
 		}
 
@@ -411,12 +407,10 @@ int cxl_dvsec_rr_decode(struct device *dev, int d,
 
 		base |= temp & CXL_DVSEC_MEM_BASE_LOW_MASK;
 
-		info->dvsec_range[i] = (struct range) {
+		info->dvsec_range[ranges++] = (struct range) {
 			.start = base,
 			.end = base + size - 1
 		};
-
-		ranges++;
 	}
 
 	info->ranges = ranges;
-- 
2.43.0



