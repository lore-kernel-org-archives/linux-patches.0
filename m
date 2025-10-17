Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB4332C93A;
	Fri, 17 Oct 2025 15:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715744; cv=none; b=SREhyAlm8cjttomD/eXTXerXP6lQ0WfX21T5qFFfY85ROct2fAp5xooEIFSIIjn7WnP7Jmi1jJeIYE2Zj2z0unG9qY/mIxLh2XfvRU04PbbJUBC0GeeRjX2aId/agnO6Psv4k+d115TGpuZzSdxmR9XWzJgX3yq1sunop5fb0TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715744; c=relaxed/simple;
	bh=IwqtvAn0/5YxWJsMHMuDqpjLSG0DBgfswXotZ2JgOt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E909bGRhE0oow3XU5yji2WYJ7v94HvygiXs3oFeH77TnDpBgaPCm62Q64CqCk18TrF7ft076O6ACr/SKgAAFWoaX2uizYLp0k4y+X7VULV3yRNvzrxMIgO0XC+K8umZJ80qHtNStf55hwjP1T1HPidQB/UHloDzVdOu5lbcDES8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1NRyeLgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1NRyeLgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8BCC4CEE7;
	Fri, 17 Oct 2025 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715744;
	bh=IwqtvAn0/5YxWJsMHMuDqpjLSG0DBgfswXotZ2JgOt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1NRyeLguZp1Zwdo/O2OecTzMd6w3YCbz+Z4lg4dhDJAkjB/4D7Jo1sRkQFDEFBqxk
	 YF2YQa3G4dGoomT3/VmrPXJs02ARmsMyFj2cjNlrmZMCNzOUoqv77fgkl9ZMLFnw7C
	 XsOVHxEEEM8rnicuTwmb16SgWqW5Qzz7xoaJ11HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Haberland <sth@linux.ibm.com>,
	Jaehoon Kim <jhkim@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 305/371] s390/dasd: enforce dma_alignment to ensure proper buffer validation
Date: Fri, 17 Oct 2025 16:54:40 +0200
Message-ID: <20251017145213.111190873@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaehoon Kim <jhkim@linux.ibm.com>

commit 130e6de62107116eba124647116276266be0f84c upstream.

The block layer validates buffer alignment using the device's
dma_alignment value. If dma_alignment is smaller than
logical_block_size(bp_block) -1, misaligned buffer incorrectly pass
validation and propagate to the lower-level driver.

This patch adjusts dma_alignment to be at least logical_block_size -1,
ensuring that misalignment buffers are properly rejected at the block
layer and do not reach the DASD driver unnecessarily.

Fixes: 2a07bb64d801 ("s390/dasd: Remove DMA alignment")
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Cc: stable@vger.kernel.org #6.11+
Signed-off-by: Jaehoon Kim <jhkim@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -334,6 +334,11 @@ static int dasd_state_basic_to_ready(str
 	lim.max_dev_sectors = device->discipline->max_sectors(block);
 	lim.max_hw_sectors = lim.max_dev_sectors;
 	lim.logical_block_size = block->bp_block;
+	/*
+	 * Adjust dma_alignment to match block_size - 1
+	 * to ensure proper buffer alignment checks in the block layer.
+	 */
+	lim.dma_alignment = lim.logical_block_size - 1;
 
 	if (device->discipline->has_discard) {
 		unsigned int max_bytes;


