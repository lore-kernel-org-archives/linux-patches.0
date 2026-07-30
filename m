Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A408395266;
	Thu, 30 Jul 2026 16:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428003; cv=none; b=tjGvH0Xdstk4DoMyCF/gL6Ki44qTokAinzUe8/uvYQtvYVeJhCO2i0Hgd7dXVmHvIUO0lDMldGsjWYYW+REl6pVAWCV6ofQk/rFUaSaNwH8IEdLJMCPMRVBVtqaxpnXXr64r5ZBJ8P2hCU+3BMxtkAyO4FmNXyqVWvQGTFmzqR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428003; c=relaxed/simple;
	bh=nbBhY0BX+7TeZhbiPDCukHI/U/h/ARdmg9LbOuqJlVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FC1Ffqkwb2N3jja2XGPzfVqZyvve2NZ1HaOxrJauMllJ63UG+08WV3Z2zn5GkINRs1y6rTXcvphTnbKZJNlKPtioihtH3AjBQjrc9woZJ8qaaFq//fo8CTWrcaREPZjup8uhXgRjH0iy91vuTozikxMoq0SMD7xWvM/0QZYTqWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/wX2TKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/wX2TKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8654F1F000E9;
	Thu, 30 Jul 2026 16:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428002;
	bh=M7GIhE3291QNJJuY0xT/fwg8s9RM1f6/+j7oY10Vm3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P/wX2TKmrdTqjDvcxxtCr3wlCWXwZiGAfCRopXBtPYpP+daxFmdPSSfpZJ+mrswHs
	 Qm6ZyTlQ9wh+Z00yjxqd4HznGZsxBWpw0JQm70RPD+70zcDn+Zh0NC78aS3W6dPFMD
	 TXpHjOSvtcCbWfHXlrZPX4mBnYD9k81cgjtXJJRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 367/484] fpga: dfl-afu: validate DMA mapping length in afu_dma_map_region()
Date: Thu, 30 Jul 2026 16:14:24 +0200
Message-ID: <20260730141431.447952925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


