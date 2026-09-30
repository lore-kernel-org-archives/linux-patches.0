Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DCE4E50B5;
	Wed, 30 Sep 2026 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785584; cv=none; b=UnfRBiXgB1o2cLONgetQwKY7bcfoYVtRZHAyXd1V3ANjHwBlDKs1G8URCPrGOS/yPb3ML/U4hVW/W1kiH4cKd19atDpLiVCY4TVxSAYQLsxMoBg8cCh+6sO8mGb9HdftKUtorqEQh9HeFYo3eozQnqXaJxkVZx26TFSRJ9Ng3zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785584; c=relaxed/simple;
	bh=0gDaNW2pBHDAhe5kTxsfl0Mj5XSZTyZAIqDsDWbw3EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmZhw19RRtqc+VO2zmswWO56dnsaI20FGdpR0vcuaTWcY5II6VmsaXi7D6tzJvRms3nXFZwNYMAHAuCaVl6sxObMTBTAPNsDh/tjvg6lJWbsb7pgTMpYuo1lnKX05Aada8gszwFS789cBmi15gGNULYbfn9EmjtF/ET7oyRkLXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J64fViYg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J64fViYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D531F0089B;
	Wed, 30 Sep 2026 16:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785571;
	bh=ocNqDYCs2sA6/yN3h0+NCvcTvWKF35ELC3FzSO6X6tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J64fViYg7U5LZjTnArum0VehmDXswGYFK6MZ4pW+jLzVuNjy8azD4HW/L7mxGdl6x
	 sqv70fyWp9BQhBkndPoOYADoDinsXc5krXTnHFuEHQfFFGdUca2SkoecAkqYNWrL29
	 G26bP+8tNO8Cq/IMy3rLot9iTC1JRQwcYlhsg8ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 557/982] Revert "nvme-apple: Prevent shared tags across queues on Apple A11"
Date: Wed, 30 Sep 2026 17:21:33 +0200
Message-ID: <20260930152428.737909816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

This reverts commit 91d3b243bffe5c94503c9a8ea478a080f79ec58e.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 060f80c5ebeda..6fb881f3807c5 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -239,7 +239,7 @@ static unsigned int apple_nvme_queue_depth(struct apple_nvme_queue *q)
 {
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
-	if (q->is_adminq)
+	if (q->is_adminq && anv->hw->has_lsq_nvmmu)
 		return APPLE_NVME_AQ_DEPTH;
 
 	return anv->hw->max_queue_depth;
@@ -317,7 +317,7 @@ static void apple_nvme_submit_cmd_t8015(struct apple_nvme_queue *q,
 		memcpy((void *)q->sqes + (q->sq_tail << APPLE_NVME_IOSQES),
 			cmd, sizeof(*cmd));
 
-	if (++q->sq_tail == apple_nvme_queue_depth(q))
+	if (++q->sq_tail == anv->hw->max_queue_depth)
 		q->sq_tail = 0;
 
 	writel(q->sq_tail, q->sq_db);
@@ -1114,7 +1114,10 @@ static void apple_nvme_reset_work(struct work_struct *work)
 	}
 
 	/* Setup the admin queue */
-	aqa = APPLE_NVME_AQ_DEPTH - 1;
+	if (anv->hw->has_lsq_nvmmu)
+		aqa = APPLE_NVME_AQ_DEPTH - 1;
+	else
+		aqa = anv->hw->max_queue_depth - 1;
 	aqa |= aqa << 16;
 	writel(aqa, anv->mmio_nvme + NVME_REG_AQA);
 	writeq(anv->adminq.sq_dma_addr, anv->mmio_nvme + NVME_REG_ASQ);
@@ -1297,7 +1300,8 @@ static int apple_nvme_alloc_tagsets(struct apple_nvme *anv)
 	 * both queues. The admin queue gets the first APPLE_NVME_AQ_DEPTH which
 	 * must be marked as reserved in the IO queue.
 	 */
-	anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
+	if (anv->hw->has_lsq_nvmmu)
+		anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
 	anv->tagset.queue_depth = anv->hw->max_queue_depth - 1;
 	anv->tagset.timeout = NVME_IO_TIMEOUT;
 	anv->tagset.numa_node = NUMA_NO_NODE;
-- 
2.53.0



