Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC511D0DD7;
	Wed,  2 Oct 2024 14:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880185; cv=none; b=Q4seS420N/8/8+SW4dDGv5PO5rayu2cx9ugTrWOunI1at3ovYHrzUcjARBVlKU6M49SJWc7AxhiJZGgE+mXjGB2In91ojZ90I/qbwgWPNNvUSI8PhwS7b4lEYVS8/OP7p20JKdJUKfFzhd/HKZUTgILUQZ6KLUZjIWwW9Flmh+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880185; c=relaxed/simple;
	bh=QMSB7HXiafFRnF2HKMZEQZxDlgUDmGKHl1+VkXcawnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bfw0x66tKTKkdW0k974GdB/y1qOYxlTGWGdygXHhFT2Kk/Ykw5R6vGt0O72YBe95n+0zKnzItpIQmSwSLpSI72Hkyy4Gp4pH6G4S+spWUvuFnbfibpFltFMdCYHJEO44df/JK2voXxUclvz80B4nVtnl81o6Z/qp73eVTYjj8A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5EGuXOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5EGuXOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A84C4CEC5;
	Wed,  2 Oct 2024 14:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880184;
	bh=QMSB7HXiafFRnF2HKMZEQZxDlgUDmGKHl1+VkXcawnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5EGuXOg2bwpoM8AujimJfkG5/jqR1Ge7Sk8GUJ/YsZoGhf5pA5gXDQsCjCGWsj6l
	 uIiPHhbA327UjyeD84X59NFTD28TX0WhhY+gfI8vyyDl08AO0Ec84l/iumYQ92SPGh
	 rgjaX8/Dl7HH4zELtSAmblayuNESoxERL6Pfj5CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Yanfei Xu <yanfei.xu@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 365/538] cxl/pci: Fix to record only non-zero ranges
Date: Wed,  2 Oct 2024 15:00:04 +0200
Message-ID: <20241002125806.834472510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c963cd9e88d16..6edfd05466737 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -388,10 +388,6 @@ int cxl_dvsec_rr_decode(struct device *dev, int d,
 
 		size |= temp & CXL_DVSEC_MEM_SIZE_LOW_MASK;
 		if (!size) {
-			info->dvsec_range[i] = (struct range) {
-				.start = 0,
-				.end = CXL_RESOURCE_NONE,
-			};
 			continue;
 		}
 
@@ -409,12 +405,10 @@ int cxl_dvsec_rr_decode(struct device *dev, int d,
 
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



