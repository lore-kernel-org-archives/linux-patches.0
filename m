Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEED361657;
	Thu, 20 Aug 2026 16:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243315; cv=none; b=r3W1eH/lIEB2K2PfhIlMCc08cVKkd4N7KVreWmZ9MVQAnWtSrMLtxqAQZ2qUVAc/xFMYaLbJIkMyJqCGfx8DM46rraNAhqy+Uqu4cOT/sLgJUjtAY3YCJ4OMMgptSnPh8KXDHlE7g2RjfPqQouDJh88FL/B6yuzdVTMzSMwWMaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243315; c=relaxed/simple;
	bh=z4UOGOtTmqm9dA6Q8nl6TeqtLI5JvGivh+Mn2kw6iLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAVLfSv13Ttf1Iy5zYgPcMazUT9WC1AuB/aMjSFSrfkq4chOGqcb8wvAsES2FFCCRT9fW71uYjiDZ328IjxTAHHDMssck57qEhSSNqPN8VP49UtaDDuz5eqs6CFf8tw15m5dmV+y0Q4XMmKPXwoVqwtnLETSe755JbuXcp1ilcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoDmt6+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoDmt6+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B321F000E9;
	Thu, 20 Aug 2026 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243314;
	bh=3bu2BBRwgclcqMmakwspMMHXmUIiGj1tR1ixd+jVUyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoDmt6+t2Viiox8ufp62LOeTGNTmhGTOCf90qPovRB9xg22J2aPaPEQThkusyu6ei
	 IxX+jqpaXM2dNFyjvQGZknFWqqkZyn7esuSDAAIhnoqwMYBEVaohYgZAA66HbIAasU
	 CwAIY8ejBibCEMhp8yuvtsIipsL6hlIaH1dlJne0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/272] fpga: dfl-afu: validate DMA mapping length in afu_dma_map_region()
Date: Thu, 20 Aug 2026 16:53:56 +0200
Message-ID: <20260820145232.776434323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


