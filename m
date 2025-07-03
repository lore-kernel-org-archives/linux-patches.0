Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1D42EE29E;
	Thu,  3 Jul 2025 14:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553914; cv=none; b=HRc0L7dqh/ONqRh9FfuE6Xtr4KmsDWEMrk3cXp0Qgm4bFIQAvx/tfwnl87B/UDHZD8lvTqRAWa/wvg+3rVXEqbTtT4CsgcKAZy1oBxQLaGMdE4896FPcNjwYtAAR6OGA8mOeXBPcboSF5PQJhHH45n62sFfjTB6q8zM0Dh1t230=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553914; c=relaxed/simple;
	bh=BMcue9IOaRd/boDmKhVUzCAQEaRUT3DpLfgGiRcZjGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dagPC4lRr0ehL4ApJ2qmP08Vq2m5wzUD4zjqyS3JLytABMPhna31hJs9q9hvElivjxD+xMq7ASBseVv41bImsJ85WA++smhwmY3fqPSCvJ+BH2tk5kSR/yHQxIBJiCCdGB+v1kJuqszg+p9wwQ4eS2Jz1TaBwRnzf1l/Ts3Pr8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaQrezaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaQrezaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA57C4CEE3;
	Thu,  3 Jul 2025 14:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553913;
	bh=BMcue9IOaRd/boDmKhVUzCAQEaRUT3DpLfgGiRcZjGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaQrezaXAZInyMgC5W9qIqGBWP2LFcV2PQ0M6djfxcXoNAHjjH/Q7uPzYj0j6aCbR
	 Eu56FVzJDsl8IjRU44LiLdNg/+i/NpUunZO/BcbsbzFL5rMXcpdQHWZlV0R3rdIZX7
	 Dacp+SP14n8JrrUsT/uhooKmkeYi0ZX2utRqZfFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/218] dmaengine: idxd: Check availability of workqueue allocated by idxd wq driver before using
Date: Thu,  3 Jul 2025 16:39:29 +0200
Message-ID: <20250703143956.810827529@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yi Sun <yi.sun@intel.com>

[ Upstream commit 17502e7d7b7113346296f6758324798d536c31fd ]

Running IDXD workloads in a container with the /dev directory mounted can
trigger a call trace or even a kernel panic when the parent process of the
container is terminated.

This issue occurs because, under certain configurations, Docker does not
properly propagate the mount replica back to the original mount point.

In this case, when the user driver detaches, the WQ is destroyed but it
still calls destroy_workqueue() attempting to completes all pending work.
It's necessary to check wq->wq and skip the drain if it no longer exists.

Signed-off-by: Yi Sun <yi.sun@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

Link: https://lore.kernel.org/r/20250509000304.1402863-1-yi.sun@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 19a58c4ecef3f..8b27bd545685a 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -354,7 +354,9 @@ static void idxd_cdev_evl_drain_pasid(struct idxd_wq *wq, u32 pasid)
 			set_bit(h, evl->bmap);
 		h = (h + 1) % size;
 	}
-	drain_workqueue(wq->wq);
+	if (wq->wq)
+		drain_workqueue(wq->wq);
+
 	mutex_unlock(&evl->lock);
 }
 
-- 
2.39.5



