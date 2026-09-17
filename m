Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2397379C40;
	Thu, 17 Sep 2026 18:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671305; cv=none; b=QhCWdvSbzi0HwdtISFUx34HB0Fl6Yf4o8OTtWFCwKgq8gS1x8UPPCgY1C7SisH8dWuy1R3JsdDBOxMEMX5VA6bQSRrXEUr7VeyKmLOFxxFrgcAy3NGBXoRMw4d7btkjok2gIlkbUMDYFET0vp2jNSYRV71rmCtLuCmAyUC0S/O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671305; c=relaxed/simple;
	bh=okpH/TiHO1CqHt1yEJVbjuMGa3SdqlDNflge6SUY+hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjmXON1IKoCsiC3EHlo2S5rURUtjEMUX+6ARWXlFZpJYypIryXwC8VwAQMus6BnS0w/vKFpeLjh+Jmt+WrEoCZYflADQ0wF37AZi75tvmU4BTZj+LvB19B1yp0HFXHeLWqoH8j69ooRrbOBQcQZu4+luvvycyuClAeTiGROasqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVUSZ2cN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVUSZ2cN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D581F000FF;
	Thu, 17 Sep 2026 18:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671303;
	bh=XDy4uypLTZyjmBeNzMkJPnzpUy2KQUqItJ1J7Qph2xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVUSZ2cNQrvuFLQgHfyyhPY/+gN6LfsyIpX/ngRypB92fKo12AaadUQVjxLiv9Wl4
	 GEGqDv8nYGjIO+6rXlaH5V0KzbyRmRrqnsVYclGa93FoJ3uZixdVrn1+l/SJ3L58Og
	 Tcnw/RVaMm4kpbYANnT9vLAJFRFgZhWhRG+dcIYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0933/1102] Revert "nvme-apple: Prevent shared tags across queues on Apple A11"
Date: Thu, 17 Sep 2026 16:14:36 +0100
Message-ID: <20260917151604.062302658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit c6a1c94c6705e18e9718737be84d5e6e661f134c.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 1cc222fdbf22e..5f745bf615fe7 100644
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
@@ -1130,7 +1130,10 @@ static void apple_nvme_reset_work(struct work_struct *work)
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
@@ -1313,7 +1316,8 @@ static int apple_nvme_alloc_tagsets(struct apple_nvme *anv)
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



