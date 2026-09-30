Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F1B3B813A;
	Wed, 30 Sep 2026 19:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795789; cv=none; b=k+egwNoUR4fI7e3YnAuvpiJS15s2b9H/PTtcQuPtk8ao+rjXhWZzj3Ff8OH2tqIGg7tf2Bf2ItXN2KINfRTMIyuE5qYpICgEI0UaM0lEJF3BsrQnBtBRRZpiWcMAER2skI9xuXmVLsfWQ4qW1LfKJQocY/DmJ+uMh7rPt6IhmOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795789; c=relaxed/simple;
	bh=6UNMSaraGH+wQwZj8ITf++G2izbKj9buyniEYzOb9b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nH1CnASraNn+7SGeAMMmh/yGcv2rjfUZAPexJBZc3QTb+S4wj4pp6UWXSwR5zOaXzhxlhh1muutjlIvdRznuTQfqgS5BgnJL/D73aeTbnE0R93Rmp2f8Zw4wbaLKok6QhX8JMeiPZx0jzt1NHjzi7rZ0/LBktEssqsgkPjjjZEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7HGuK8k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7HGuK8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECBF1F000FF;
	Wed, 30 Sep 2026 19:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795787;
	bh=pLoAWblv81TdcnZBMKXQM6DomNuv5o+erNY5ypBTBgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7HGuK8khEY5knsCDAtNBAtE6DrBfUx/qrHvcrHMoBbkozV8DDPj8FvMc1mOo30NT
	 Q2JfRZSk5lEQdfoTXspohrEZ6ARr8ZTERmg/B9BNHV4dlruYAzHqOSyfp/T14E4kNf
	 Lax055rWGGWw/6p6ztIEXIXNEo/utOoLys1ffpBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0684/1193] Revert "nvme-apple: Prevent shared tags across queues on Apple A11"
Date: Wed, 30 Sep 2026 17:22:48 +0200
Message-ID: <20260930152449.445760156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

This reverts commit 073b9238fac4d1c7727c1d05e3fafad0fd40d451.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 0470941e38988..6e9e0b6e00369 100644
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
@@ -1128,7 +1128,10 @@ static void apple_nvme_reset_work(struct work_struct *work)
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
@@ -1311,7 +1314,8 @@ static int apple_nvme_alloc_tagsets(struct apple_nvme *anv)
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



