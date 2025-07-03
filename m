Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F40F2F0020;
	Thu,  3 Jul 2025 15:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555450; cv=none; b=JWQ3UNlk2uqsyQamAFuY140y6qH7G2uZL0gW/ZbT4kohxlmTGQyFmNlFDuNCsZvuyW95/tkvkYDaPcA9nPctm0klwiIzu9s3geksWiuPezRiFVksTOBJaS4ftRD+RyKE6rAdZvK9Kkj52NOhZ2Wg4NMppqGRKiGURxoCI8p7jlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555450; c=relaxed/simple;
	bh=qQ9Tiq1zSg4qtsyP/XKe3IqAcQXiQKd+x5qkCc3sWxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thj6ky9wYrHDg4gtsY0A3srrh6BLED8LDpE3jAoXJ2BfMsKLir84sY7QBBf0u2LjHXaGUlsHupc6yjcipWqtZTxNylkFBDqlXm505G+nSyYd72dQ0ZRgG9vzQNrHoktNe6uqUV9I2vWveXbSW2+HgM/nI/NyoaAqnEdZtx0ymO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgx2sXeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgx2sXeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A28C4CEE3;
	Thu,  3 Jul 2025 15:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555450;
	bh=qQ9Tiq1zSg4qtsyP/XKe3IqAcQXiQKd+x5qkCc3sWxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgx2sXeYldhqCPE5yPb7vxZAS+sCArUF07lCAnHm3zrst/Wz9RBV7cOibvGMyOTLo
	 I+PmqBAFbWxcsYoy0IPIqV0vNUVO803MzZNygeWLouYcVowKlAuOaDcZgn3cnItiFc
	 n/8NI6McEnxlepI5Exmf8GjsR8jFJKaFPbSKOAH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/139] dmaengine: idxd: Check availability of workqueue allocated by idxd wq driver before using
Date: Thu,  3 Jul 2025 16:41:21 +0200
Message-ID: <20250703143941.888185923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7e3a67f9f0a65..aa39fcd389a94 100644
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



