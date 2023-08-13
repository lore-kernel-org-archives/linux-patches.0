Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122819443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B080C433C8;
	Sun, 13 Aug 2023 21:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962241;
	bh=OJg+T5Lg0O13AYYT+gVUpj2iBVGnVhWRj3qhBybT/bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BNDuHvw8h/cGDvqZD7a3FGrEPLeEIXw+5VxYdv0KhR6SnHkQ1jakkhSUMQRo4jZ/A
	 NRr3FyYNW0KbQ3CnCwbj9UZBvMkl/ApYlZiuD2JJkClWfQ+jszrrkDfl20f8PljL/w
	 BMto7ZoAPgecU6XslT9iFC5GPAfNbmsRSWBKJJH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Zhu <tony.zhu@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.4 165/206] dmaengine: idxd: Clear PRS disable flag when disabling IDXD device
Date: Sun, 13 Aug 2023 23:18:55 +0200
Message-ID: <20230813211729.748277072@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fenghua Yu <fenghua.yu@intel.com>

commit 863676fe1ac1b82fc9eb56c242e80acfbfc18b76 upstream.

Disabling IDXD device doesn't reset Page Request Service (PRS)
disable flag to its initial value 0. This may cause user confusion
because once PRS is disabled user will see PRS still remains the
previous setting (i.e. disabled) via sysfs interface even after the
device is disabled.

To eliminate user confusion, reset PRS disable flag to ensure that
the PRS flag bit reflects correct state after the device is disabled.

Additionally, simplify the code by setting wq->flags to 0, which clears
all flag bits, including any future additions.

Fixes: f2dc327131b5 ("dmaengine: idxd: add per wq PRS disable")
Tested-by: Tony Zhu <tony.zhu@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20230712193505.3440752-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/device.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 5abbcc61c528..9a15f0d12c79 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -384,9 +384,7 @@ static void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	wq->threshold = 0;
 	wq->priority = 0;
 	wq->enqcmds_retries = IDXD_ENQCMDS_RETRIES;
-	clear_bit(WQ_FLAG_DEDICATED, &wq->flags);
-	clear_bit(WQ_FLAG_BLOCK_ON_FAULT, &wq->flags);
-	clear_bit(WQ_FLAG_ATS_DISABLE, &wq->flags);
+	wq->flags = 0;
 	memset(wq->name, 0, WQ_NAME_SIZE);
 	wq->max_xfer_bytes = WQ_DEFAULT_MAX_XFER;
 	idxd_wq_set_max_batch_size(idxd->data->type, wq, WQ_DEFAULT_MAX_BATCH);
-- 
2.41.0



