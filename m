Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4637381BD;
	Sun,  1 Sep 2024 17:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210239; cv=none; b=RmjVKDuXhu7Syados0kCT/8w0rARGl8eEEvIpOE7ESzI0eFKYXFNyPudRm75mpp3g61FxOcGAYAOEi9tjIIT8I74fzTb+nA8y2gjIajLb0bEF2zHF0GhxWwki1xAYzr3wuE3An8fk0/njQNdTpZ0pOen9lSAByjxijmDueUzq9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210239; c=relaxed/simple;
	bh=Lmy0nG9+wQnhBvk318t14FrTA+BYdaC+PVVFzpkKFZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQeeKRcciOKzfmSayJtvs5X85eNDMUMvFhQOI7hfSSuhdkejmnWBXOpObx09Sf2J09IAH7Uss29Op0DBp60Lqkxc4FP7YQKQzgLkYDm1yriOKgvFcsdqsy6UWF0zjOSz4JH5HtVoGU2kNemJAf9AhilLOZyrb0JSSCQ0PN+cic8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAGlyfyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAGlyfyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DBDC4CEC3;
	Sun,  1 Sep 2024 17:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210239;
	bh=Lmy0nG9+wQnhBvk318t14FrTA+BYdaC+PVVFzpkKFZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAGlyfyFfKOJLBQTd/orCnG+UUhh4CRypTdCLFtvPwG2tpKOMQfYZzYtdSG8fdwfP
	 mq7XgoSFOqJrK51IaE0pVLMuJealmfFjeqfqATOfMh7+dddyeXlna9ESkjGzQLLL0f
	 irrzbVx75zUIzJY7xHh9H1dWMyEj9xDel0YOX9bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/215] net: mana: Fix doorbell out of order violation and avoid unnecessary doorbell rings
Date: Sun,  1 Sep 2024 18:17:22 +0200
Message-ID: <20240901160828.280305435@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit 58a63729c957621f1990c3494c702711188ca347 ]

After napi_complete_done() is called when NAPI is polling in the current
process context, another NAPI may be scheduled and start running in
softirq on another CPU and may ring the doorbell before the current CPU
does. When combined with unnecessary rings when there is no need to arm
the CQ, it triggers error paths in the hardware.

This patch fixes this by calling napi_complete_done() after doorbell
rings. It limits the number of unnecessary rings when there is
no need to arm. MANA hardware specifies that there must be one doorbell
ring every 8 CQ wraparounds. This driver guarantees one doorbell ring as
soon as the number of consumed CQEs exceeds 4 CQ wraparounds. In practical
workloads, the 4 CQ wraparounds proves to be big enough that it rarely
exceeds this limit before all the napi weight is consumed.

To implement this, add a per-CQ counter cq->work_done_since_doorbell,
and make sure the CQ is armed as soon as passing 4 wraparounds of the CQ.

Cc: stable@vger.kernel.org
Fixes: e1b5683ff62e ("net: mana: Move NAPI from EQ to CQ")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/1723219138-29887-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana.h    |  1 +
 drivers/net/ethernet/microsoft/mana/mana_en.c | 24 ++++++++++++-------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index fc98a5ba5ed07..35e937a7079c0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -252,6 +252,7 @@ struct mana_cq {
 	/* NAPI data */
 	struct napi_struct napi;
 	int work_done;
+	int work_done_since_doorbell;
 	int budget;
 };
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 6224b7c21e0af..b0963fda4d9fd 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1074,7 +1074,6 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 static int mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 {
 	struct mana_cq *cq = context;
-	u8 arm_bit;
 	int w;
 
 	WARN_ON_ONCE(cq->gdma_cq != gdma_queue);
@@ -1085,16 +1084,23 @@ static int mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 		mana_poll_tx_cq(cq);
 
 	w = cq->work_done;
-
-	if (w < cq->budget &&
-	    napi_complete_done(&cq->napi, w)) {
-		arm_bit = SET_ARM_BIT;
-	} else {
-		arm_bit = 0;
+	cq->work_done_since_doorbell += w;
+
+	if (w < cq->budget) {
+		mana_gd_ring_cq(gdma_queue, SET_ARM_BIT);
+		cq->work_done_since_doorbell = 0;
+		napi_complete_done(&cq->napi, w);
+	} else if (cq->work_done_since_doorbell >
+		   cq->gdma_cq->queue_size / COMP_ENTRY_SIZE * 4) {
+		/* MANA hardware requires at least one doorbell ring every 8
+		 * wraparounds of CQ even if there is no need to arm the CQ.
+		 * This driver rings the doorbell as soon as we have exceeded
+		 * 4 wraparounds.
+		 */
+		mana_gd_ring_cq(gdma_queue, 0);
+		cq->work_done_since_doorbell = 0;
 	}
 
-	mana_gd_ring_cq(gdma_queue, arm_bit);
-
 	return w;
 }
 
-- 
2.43.0



