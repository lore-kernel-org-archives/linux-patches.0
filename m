Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC12931717E;
	Thu, 16 Jul 2026 13:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210183; cv=none; b=INg+oJ0/zYenrxqOROIh2FmzFFsVPc2VHYfxW0Gyd/ANvV0FmkQTn72JOKd9LkOAMReT7Q2a9e/7t7yUG6/Bc++et+f1UhaQPlgjILZd8XAD2173yqRzsYgrmUoOLDWYbjtETHWLhWHSByEKyRa4l0YDA8siH6Xn+Rhau4s9fFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210183; c=relaxed/simple;
	bh=2d1FY031txHO1/RvR9b6uIo27/pxiyJ1tNjWn/ePYBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgbQd1Q2i3N65RanqjRo6Zf7fC0rI/9a8YZZnP8qKAD77YmAadvajJfBmA9geIweVmPkm7I8VRNN8lbOjNVoEQ5g7mHo/Us7mOer8j4mSf/5JTyxvwSkUyONIHt4Bhj+muhk+014W4wEP/yViR6lT9kBk0//Hanmt8y/37L4utQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOgQ7Zii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOgQ7Zii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCDE1F000E9;
	Thu, 16 Jul 2026 13:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210182;
	bh=VpjUPtlgIM2JM1PCSBqLenqfxnJyRAU7zHNDTxHqYPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XOgQ7ZiiOB+FOnMZrgETwwvdv30kCeXLJ7KekU0vPvUhDXVo/wyjMvbxevnWZh2cE
	 emHNlU2FZuZM/vjBlyYgE2t0U5c2dzBde9UEBjlQTaM2A3QOV/ijpU33Lrx/kDUVR6
	 KJd8BiwTYR9tauVoGNWCzm7FdLYJjEeqAiDX/irI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Alba Vives <sebasjosue84@gmail.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 7.1 469/518] fpga: dfl-afu: validate DMA mapping length in afu_dma_map_region()
Date: Thu, 16 Jul 2026 15:32:17 +0200
Message-ID: <20260716133058.106370850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Alba Vives <sebasjosue84@gmail.com>

commit fc3b071a7c8dc0f5d56defddf6e6fd5aaa3e1e27 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/dfl-afu-main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/fpga/dfl-afu-main.c
+++ b/drivers/fpga/dfl-afu-main.c
@@ -723,6 +723,9 @@ afu_ioctl_dma_map(struct dfl_feature_dev
 	if (map.argsz < minsz || map.flags)
 		return -EINVAL;
 
+	if (map.length >> PAGE_SHIFT > (u64)INT_MAX)
+		return -EINVAL;
+
 	ret = afu_dma_map_region(fdata, map.user_addr, map.length, &map.iova);
 	if (ret)
 		return ret;


