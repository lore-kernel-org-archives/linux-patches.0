Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2A01C3F17;
	Tue, 27 Aug 2024 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772433; cv=none; b=G5aHfj4+9RE+BLJnzW2UAGQHCPKAmK1mDW7iK3xJtHcRoUuVh3Fi4GaEk79pllVQEx7AOr150i0Wnxq3XSDLTTf7jAPnUHcgU9zu4AGUUk7qD1avnmoKj+dzcDiShYw+T1RUGLuRQn7ahFWHFenDa5mnH6bm7kyAdWzxxZqbugA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772433; c=relaxed/simple;
	bh=dbyKoEikQANwG/2IJbjQLgvRfb0WoJp2Ra9IU/tq+VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rc8Vmk+1GxwW8wyH4d5LvCF3EcECOdKY/Lfb0++PyfeQSa9bYeG75/u88Y8/bvRlwoM2KoGN/njeSHhcC82LsPcwFiHugkNUdAWf6ncE9qLG1BZ/mlre3Kfz+GueyaFzUrR2cH2ocqHeBbuPNfbPaSKaGUrKFIqM32NLkQUUJoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ua03tLK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ua03tLK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080F5C4DE14;
	Tue, 27 Aug 2024 15:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772432;
	bh=dbyKoEikQANwG/2IJbjQLgvRfb0WoJp2Ra9IU/tq+VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ua03tLK+cf9iJLt0WvzIUw46Z28HoEMTBin6Ls8jRoajA5Rf0aiX/RNQ43QtE1CNN
	 jY5Ls3sm+F7tEPExKOUiyXCf4LsVSfe2QGtrYtMk89jIA4AyquHD+K26dR3AHa5gcU
	 OoNq56lcOjr/HURcZM0t9Fnj5F2KAzmZNHJEdDvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 214/321] net: mana: Fix doorbell out of order violation and avoid unnecessary doorbell rings
Date: Tue, 27 Aug 2024 16:38:42 +0200
Message-ID: <20240827143846.379315559@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d58be64374c84..41c99eabf40a0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -262,6 +262,7 @@ struct mana_cq {
 	/* NAPI data */
 	struct napi_struct napi;
 	int work_done;
+	int work_done_since_doorbell;
 	int budget;
 };
 
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index b751b03eddfb1..e7d1ce68f05e3 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1311,7 +1311,6 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 static int mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 {
 	struct mana_cq *cq = context;
-	u8 arm_bit;
 	int w;
 
 	WARN_ON_ONCE(cq->gdma_cq != gdma_queue);
@@ -1322,16 +1321,23 @@ static int mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
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



