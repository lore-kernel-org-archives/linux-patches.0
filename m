Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39F42DC321;
	Sat, 12 Sep 2026 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226469; cv=none; b=ZY1rxF9sm+ZRFtPzLX5EX6dZKrbzDZnlpPLGA/AkhXXnJfa6PQBTb7w0TjFZHqqntJbeYB3/orlJjGhCOPNjC2SXRqpgweLySjyNr4p9WGrsVPAPqq40Vjs4vmX5Id8WhyZcmNO9gyYgKkoO4//d9u3AElySYRr3tqC1pJNOu4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226469; c=relaxed/simple;
	bh=LBJ1AY2gqxKWa0h6uxYLo8BYdzIhaQYX0TK8+ZrwQ6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWXEuohsML/IVand5ENGe0CjQll5ophZ4jowNxCauVUZ35qJrVFAjm7yJH4v4M9ifRXsD1OAlHgOfhjqAfKbG3GL0qHqIiPiSp8tZbiYo1PLBUizzWz3oKa1ONWf1AyvPpQlxF4ADWLexrx+0nQnH7co43fvNRwij/hF47V1PQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06Bn2yFb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06Bn2yFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A501F000FF;
	Sat, 12 Sep 2026 15:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226467;
	bh=DhwKnNe/+dj50LQTxcwIaulFzinDW6lPIM2sMeK6NEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=06Bn2yFbL7j6F7i3VVb4g0ZHFIPv8jFdHwFv4zKa++kvhm2MTcu3SSH4mH0ZcP4wM
	 TJ8sqwNBuXhPBfiooKSCNUfPVoYeNOHi/tmAubGdbDT5o61h4gMxvbVENZ8ANZX5Kc
	 B855tPFpeeHmePxxeHBCcWWNefNKcws90YQnmEHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Nick Chan <towinchenmi@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1406/1424] nvme-apple: Prevent shared tags across queues on Apple A11
Date: Sat, 12 Sep 2026 09:03:58 +0200
Message-ID: <20260912065638.746879383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Nick Chan <towinchenmi@gmail.com>

[ Upstream commit 6fe0687245e8406bf26143bd45eb16441bbe5280 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 6e9e0b6e00369..0470941e38988 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -239,7 +239,7 @@ static unsigned int apple_nvme_queue_depth(struct apple_nvme_queue *q)
 {
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
-	if (q->is_adminq && anv->hw->has_lsq_nvmmu)
+	if (q->is_adminq)
 		return APPLE_NVME_AQ_DEPTH;
 
 	return anv->hw->max_queue_depth;
@@ -317,7 +317,7 @@ static void apple_nvme_submit_cmd_t8015(struct apple_nvme_queue *q,
 		memcpy((void *)q->sqes + (q->sq_tail << APPLE_NVME_IOSQES),
 			cmd, sizeof(*cmd));
 
-	if (++q->sq_tail == anv->hw->max_queue_depth)
+	if (++q->sq_tail == apple_nvme_queue_depth(q))
 		q->sq_tail = 0;
 
 	writel(q->sq_tail, q->sq_db);
@@ -1128,10 +1128,7 @@ static void apple_nvme_reset_work(struct work_struct *work)
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
@@ -1314,8 +1311,7 @@ static int apple_nvme_alloc_tagsets(struct apple_nvme *anv)
 	 * both queues. The admin queue gets the first APPLE_NVME_AQ_DEPTH which
 	 * must be marked as reserved in the IO queue.
 	 */
-	if (anv->hw->has_lsq_nvmmu)
-		anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
+	anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
 	anv->tagset.queue_depth = anv->hw->max_queue_depth - 1;
 	anv->tagset.timeout = NVME_IO_TIMEOUT;
 	anv->tagset.numa_node = NUMA_NO_NODE;
-- 
2.53.0



