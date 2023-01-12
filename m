Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E42579C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD3CC433F0;
	Thu, 12 Jan 2023 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533733;
	bh=nYp7fHz+MrFD9u5kRhzMRuqjDTT2lAMtB1oTj+8ZXcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljD22oVHFoV1Uiqn8AOZmzgVZ9X5MlkudLx6FmZ4GpeSKxUJUtvxxnMgCQglZjriC
	 bgBp8cVF48YvOMu/D3jmTGZHcd3iVJFYVrDCCp4TQTzQbNR+KwwdeF87wE4xTi1EwX
	 41lIk6E2RB30n5b0C3AQIRXaZ9BpOIoKhN0BjRY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 575/783] nvme-pci: fix mempool alloc size
Date: Thu, 12 Jan 2023 14:54:51 +0100
Message-Id: <20230112135550.906285137@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit c89a529e823d51dd23c7ec0c047c7a454a428541 ]

Convert the max size to bytes to match the units of the divisor that
calculates the worst-case number of PRP entries.

The result is used to determine how many PRP Lists are required. The
code was previously rounding this to 1 list, but we can require 2 in the
worst case. In that scenario, the driver would corrupt memory beyond the
size provided by the mempool.

While unlikely to occur (you'd need a 4MB in exactly 127 phys segments
on a queue that doesn't support SGLs), this memory corruption has been
observed by kfence.

Cc: Jens Axboe <axboe@kernel.dk>
Fixes: 943e942e6266f ("nvme-pci: limit max IO size and segments to avoid high order allocations")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 948b027a75d3..0452fb96df69 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -372,8 +372,8 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, __le32 *dbbuf_db,
  */
 static int nvme_pci_npages_prp(void)
 {
-	unsigned nprps = DIV_ROUND_UP(NVME_MAX_KB_SZ + NVME_CTRL_PAGE_SIZE,
-				      NVME_CTRL_PAGE_SIZE);
+	unsigned max_bytes = (NVME_MAX_KB_SZ * 1024) + NVME_CTRL_PAGE_SIZE;
+	unsigned nprps = DIV_ROUND_UP(max_bytes, NVME_CTRL_PAGE_SIZE);
 	return DIV_ROUND_UP(8 * nprps, PAGE_SIZE - 8);
 }
 
-- 
2.35.1



