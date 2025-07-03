Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F1A2EA49E;
	Thu,  3 Jul 2025 14:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554711; cv=none; b=TFt4SasrLUEGbaB7vuaBdSgH6jryodT+Erekg9LRdRbFNCoRbmacEUjyMQpINeOXORfHVLCPJBW3R/giMHL2d/+8kG8WCEk/ZB7r67T3/fq2RHc4v9D5rdOZ+Wt4oPS4QyeDZOFjO/IEccDtVS96+cQT1uxBvqSDreEJtasmXzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554711; c=relaxed/simple;
	bh=nD3SFQsx00FBrCG9MOqfyUp7nt0NJOmj/OPlQ/gGnZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/H7CljAi5ere7dpReeuUheDrtbwGYBLy7V9c30GmOOhrcyrGjykEf0zCGM7FEgKvZuGB/k6zMS617NgRUCfDmTYXZI2bOF+l0hMiU1tQxtZZzcV6ToS8WGl8Pi4nWIaGmTdlV5S6qzSzClIWQSJBCtXyaM0Qoi0HNhlhPIV4m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbCnt2MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbCnt2MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7464AC4CEE3;
	Thu,  3 Jul 2025 14:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554710;
	bh=nD3SFQsx00FBrCG9MOqfyUp7nt0NJOmj/OPlQ/gGnZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbCnt2MMfhGD2dXfsa6KjEUmFT4d1qjFM2xlhMcgP8hg+ZMjLeI7G5x0nu8Fl/qn+
	 NkwwQ8b6haMmSucsOoX95WXa/2sK27Pl9fcRBRvCwjH3rle/gysnFwKATCZlIeyW9P
	 JXOOu2kprTL98npD7GZhmxVUVVFp096/OZSkU4Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 027/263] dmaengine: idxd: Check availability of workqueue allocated by idxd wq driver before using
Date: Thu,  3 Jul 2025 16:39:07 +0200
Message-ID: <20250703144005.388806015@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6d12033649f81..bc934bc249df1 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -349,7 +349,9 @@ static void idxd_cdev_evl_drain_pasid(struct idxd_wq *wq, u32 pasid)
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



