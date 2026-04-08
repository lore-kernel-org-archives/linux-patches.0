Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026063446CA;
	Wed,  8 Apr 2026 18:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671665; cv=none; b=ozHjDs7zeJjnXam0ORmTNXHgwiOFYZtiRb6ArRIRFCY9W8ocVLmScEqmLGDMJEoWhiMcL06whDkUj/+8scmX65waKGKfK6Srfi4FT81hGlQ47sG2cSPu0IcgF/eBf1S30jGt+i5WI3q1aeQp+rLOXj6m8XAwqXzQkSHzGmus/2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671665; c=relaxed/simple;
	bh=oItfGdpAXeifl0Tprjgx8OSlciDqQ0pssLpfrqChVa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+hQC64XP6pGE3ysbonLifxz26L2i0VBstvjI/vYXLAQR7u4GoZsX35l0Cs2wKGzSUAuDteZ+TKNlj0DgOHGL6SoCxAaq7dz1S+J7VGmKpDTIMsn+AnwkkocaCF7aexDiMxFKopsU+quvHb5ljRD4Cazk0iFJNkovqrOgCI6A5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOcdd4ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOcdd4ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA83C19421;
	Wed,  8 Apr 2026 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671664;
	bh=oItfGdpAXeifl0Tprjgx8OSlciDqQ0pssLpfrqChVa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOcdd4zetEEnMivk6lpdHXLLUPdM/fR7f8VNi4gSNOdg0hOj29B5Kiau2b4zGLas+
	 EC5Y8KChnkmG5xw4zqBqYFFWThAUsIJfDyYcrqcxVKgPz/kOkJbe3Oytbrth+ZLfb4
	 tGqOcdmNykZS0i85kXptdGtAEx2v0RU4sQhE9zOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/312] nvme-pci: ensure were polling a polled queue
Date: Wed,  8 Apr 2026 19:58:46 +0200
Message-ID: <20260408175934.074251046@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 166e31d7dbf6aa44829b98aa446bda5c9580f12a ]

A user can change the polled queue count at run time. There's a brief
window during a reset where a hipri task may try to poll that queue
before the block layer has updated the queue maps, which would race with
the now interrupt driven queue and may cause double completions.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 509a788cc7350..15bc7d81df4bd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1167,7 +1167,8 @@ static int nvme_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 	struct nvme_queue *nvmeq = hctx->driver_data;
 	bool found;
 
-	if (!nvme_cqe_pending(nvmeq))
+	if (!test_bit(NVMEQ_POLLED, &nvmeq->flags) ||
+	    !nvme_cqe_pending(nvmeq))
 		return 0;
 
 	spin_lock(&nvmeq->cq_poll_lock);
-- 
2.51.0



