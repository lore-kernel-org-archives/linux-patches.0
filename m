Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515E247125D;
	Tue, 21 Jul 2026 18:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658921; cv=none; b=EeiPA1s1hLqCYK1+4qbCXMO3+Kny7rkbzTilCRjnNFyhB1xsisN8Ngn3zJv5ugrnvIKwlW+MYWHx+Hyb2b/NIxCA57atLm5eIgaCS09viZ2ffOGqA2tfGQUTtoDxQysZu81ba59etJsW0TeoOyACsGcdQO89UMj36j+7beAZjCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658921; c=relaxed/simple;
	bh=8mj0UiOo50Ca3sTkPiQcRYiXxGjkgpSEaTZ3Wt07Gg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BU9+FJRtMkIOIxgKhG/mlm1U+/oESTSHOvUTGXUWT1OFtawSW2zkeIMDzvBa3ZTPGl2VCuDw5eEzzkQtu4f3/wz/nq+BUbaRAJBqN9T8aqFYhjPDhh9aOinhEQgewrHNBs0Lw+dAARtn8SxtPuQehQtbJNE5zDd6onv6njcwmSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjjCyGwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjjCyGwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BE21F000E9;
	Tue, 21 Jul 2026 18:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658920;
	bh=bplZi3mAxSb39Ohkn6hh1cxXQ1FQtK+Jo3k+aJ7h3u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjjCyGwlgo7SQhs1NpGHaJTL0DWCJUW8r663aPhe46WfhFoWj64epaCwXB8trGodg
	 NG7+O+Xb7moPb4w5klswtxjTUJZGe7AEfAPDnZF2eo4O18JB3Htq/wiTcAlps89b0G
	 2t04u09Itdv4NeZTBp17glKMxhhmU+/kDrbfD/NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Nick Chan <towinchenmi@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 1326/1611] nvme-apple: Prevent shared tags across queues on Apple A11
Date: Tue, 21 Jul 2026 17:24:02 +0200
Message-ID: <20260721152545.279531712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Chan <towinchenmi@gmail.com>

commit 6fe0687245e8406bf26143bd45eb16441bbe5280 upstream.

On Apple A11, tags of pending commands must be unique across the admin
and IO queues, else the firmware crashes with
"duplicate tag error for tag N", with N being the tag.

Apply the existing workaround for M1 of reserving two tags for the admin
queue to A11.

Cc: stable@vger.kernel.org
Fixes: 04d8ecf37b5e ("nvme: apple: Add Apple A11 support")
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Nick Chan <towinchenmi@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/apple.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -225,7 +225,7 @@ static unsigned int apple_nvme_queue_dep
 {
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
-	if (q->is_adminq && anv->hw->has_lsq_nvmmu)
+	if (q->is_adminq)
 		return APPLE_NVME_AQ_DEPTH;
 
 	return anv->hw->max_queue_depth;
@@ -303,7 +303,7 @@ static void apple_nvme_submit_cmd_t8015(
 		memcpy((void *)q->sqes + (q->sq_tail << APPLE_NVME_IOSQES),
 			cmd, sizeof(*cmd));
 
-	if (++q->sq_tail == anv->hw->max_queue_depth)
+	if (++q->sq_tail == apple_nvme_queue_depth(q))
 		q->sq_tail = 0;
 
 	writel(q->sq_tail, q->sq_db);
@@ -1139,10 +1139,7 @@ static void apple_nvme_reset_work(struct
 	}
 
 	/* Setup the admin queue */
-	if (anv->hw->has_lsq_nvmmu)
-		aqa = APPLE_NVME_AQ_DEPTH - 1;
-	else
-		aqa = anv->hw->max_queue_depth - 1;
+	aqa = APPLE_NVME_AQ_DEPTH - 1;
 	aqa |= aqa << 16;
 	writel(aqa, anv->mmio_nvme + NVME_REG_AQA);
 	writeq(anv->adminq.sq_dma_addr, anv->mmio_nvme + NVME_REG_ASQ);
@@ -1324,8 +1321,7 @@ static int apple_nvme_alloc_tagsets(stru
 	 * both queues. The admin queue gets the first APPLE_NVME_AQ_DEPTH which
 	 * must be marked as reserved in the IO queue.
 	 */
-	if (anv->hw->has_lsq_nvmmu)
-		anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
+	anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
 	anv->tagset.queue_depth = anv->hw->max_queue_depth - 1;
 	anv->tagset.timeout = NVME_IO_TIMEOUT;
 	anv->tagset.numa_node = NUMA_NO_NODE;


