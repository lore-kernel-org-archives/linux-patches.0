Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334043F825C;
	Tue, 21 Jul 2026 17:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654721; cv=none; b=u+fAlb3EsQXP/HK10th5nakTxLi23ho1w4QnewiGjar8Dxp8uuXKNOGtCkBnsLnJy8NAX/C7cg+IgG5aH7+Dm1PgSaOat2dtKd7lX6V9995HBx1KtCtqufIHPZhvulN83kLIHHLQuy+rtiw4ovwcBIyNgO8mmrpeH0+282k1tuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654721; c=relaxed/simple;
	bh=vbjosK66EC6nQn22LXP6ZLCKWjUz5vuNuG97n8U38is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0FOmz0YXKMaRmOpUPj8SEWHzmcFKW1pMbbmxNUwmXEKNErAWpw0/7ovMFiOUy0t5m1Dw+a4VIwl2PwOMunwW5TmuxrHYYwagb3OhC47edkrVEHDu5ATxZCF1lqdDyi3+CKpp8wadfFZM2TNGrHF/sVRwtfauWuZCC1Ox8Oh5JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e209G2Dd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e209G2Dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F851F000E9;
	Tue, 21 Jul 2026 17:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654720;
	bh=0aLMLeJqbbBm5tlzVF0NjN7PrCOnv1tUjMBC8/sSOBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e209G2Dd63F/xhsABtNbyr57bIDVJMS7trg5pJpfGnYwQmiXCsLRjsJuGL+rc35pa
	 QehzgFhyDzGuYeIYTc/4ObH+AuO4L+t2AXFTOfg4WNzPOjZg1PfZ4OGVvDCOHCEJTi
	 1s+uOzi+LYXfiGd/ygxmxDOIBx7TNJWFKQ8zPbxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Peter <sven@kernel.org>,
	Nick Chan <towinchenmi@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.1 1813/2077] nvme-apple: Prevent shared tags across queues on Apple A11
Date: Tue, 21 Jul 2026 17:24:46 +0200
Message-ID: <20260721152635.509183267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1325,8 +1322,7 @@ static int apple_nvme_alloc_tagsets(stru
 	 * both queues. The admin queue gets the first APPLE_NVME_AQ_DEPTH which
 	 * must be marked as reserved in the IO queue.
 	 */
-	if (anv->hw->has_lsq_nvmmu)
-		anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
+	anv->tagset.reserved_tags = APPLE_NVME_AQ_DEPTH;
 	anv->tagset.queue_depth = anv->hw->max_queue_depth - 1;
 	anv->tagset.timeout = NVME_IO_TIMEOUT;
 	anv->tagset.numa_node = NUMA_NO_NODE;


