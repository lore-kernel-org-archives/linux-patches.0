Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4E33769FD;
	Thu, 30 Jul 2026 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426731; cv=none; b=tkeA+cFCLTI3zwQ1jzOsVoABytFoOMJQl7BDk2tv9EQ0TZk4Oau9RvTl0+px9AWmZpDPqVqfycY+ow6qOflUuBlHwKGrdn9m/y8PFCk1V23mFHtcTeqGe/ZExpzHrpzPco1ROiYBDwx0NRK1k42b+S7mqYdvVsX8lwr6Zjdu2K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426731; c=relaxed/simple;
	bh=6uG7gH6LbL1gdHKGpBjy0yJyST+p9MpYxMKPWwySaig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdRSPYz7DSqSjuZOsR4w54QV/f9c6pRqWL6PRLDYQwcCRaqCQj42rx36mH47NOWgstn1cvIVXtk123WcxgQZmLmD9Hrb/tpJlCScuNjDeURyThbIE6o1lwghYOJpnz2z4t9wdNOaEONFYVBa3LKl1slu1yLnHAMSHDf5hRyEGh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdL8VcZH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdL8VcZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854C21F000E9;
	Thu, 30 Jul 2026 15:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426730;
	bh=tv3y0shM4ZWBviOeiKyMhrSNVoZ5nKpvNMmixCnDuME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdL8VcZHjJ++5+QCAMezLO83VR5fehy5mL+q2bUfLt6/68IR5Ryw8pvmQ5+uXbm4J
	 A/uprlWnzvI7qlBMlJPVRhaFrB2WZVqa6fDmfosTvb/i1ODIFt+2CG9uh3R2FKx8tw
	 zwAo9lR8ewsoAcPcbMwWNrLF4R/mFJlclE6mXRkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 468/602] fpga: dfl-afu: validate DMA mapping length in afu_dma_map_region()
Date: Thu, 30 Jul 2026 16:14:20 +0200
Message-ID: <20260730141445.797146610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Sebastian Alba Vives <sebasjosue84@gmail.com>

[ Upstream commit fc3b071a7c8dc0f5d56defddf6e6fd5aaa3e1e27 ]

afu_ioctl_dma_map() accepts a 64-bit length from userspace via
DFL_FPGA_PORT_DMA_MAP ioctl without an upper bound check. The value
is passed to afu_dma_pin_pages() where npages is derived as
length >> PAGE_SHIFT and passed to pin_user_pages_fast() which takes
int nr_pages, causing implicit truncation if length is very large.

Validate map.length at the ioctl entry point before calling
afu_dma_map_region(), rejecting values whose page count exceeds
INT_MAX.

Fixes: fa8dda1edef9 ("fpga: dfl: afu: add DFL_FPGA_PORT_DMA_MAP/UNMAP ioctls support")
Cc: stable@vger.kernel.org
Signed-off-by: Sebastian Alba Vives <sebasjosue84@gmail.com>
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260518190742.61426-3-sebasjosue84@gmail.com
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/dfl-afu-main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/fpga/dfl-afu-main.c
+++ b/drivers/fpga/dfl-afu-main.c
@@ -720,6 +720,9 @@ afu_ioctl_dma_map(struct dfl_feature_pla
 	if (map.argsz < minsz || map.flags)
 		return -EINVAL;
 
+	if (map.length >> PAGE_SHIFT > (u64)INT_MAX)
+		return -EINVAL;
+
 	ret = afu_dma_map_region(pdata, map.user_addr, map.length, &map.iova);
 	if (ret)
 		return ret;


