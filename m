Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4AA4437B;
	Mon, 11 Dec 2023 18:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/dMEiDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D7BC433C8;
	Mon, 11 Dec 2023 18:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320386;
	bh=m+4kv/uDgGFCsjGA9XpAtSBwliljge3kJUYL/L5OqkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/dMEiDDcZkkDYIK8sp5XouZxfrYKkNMSGXn3o9WvlonJbcCFMujnjRtULEw/m6lf
	 ssHnx3FlHpxEwURPdXhe5S0DhdT6wzsNIG1p5lvfJFR7fW5Se3dhEc7+Cju3Lv15ze
	 nBrmPOmA3JOzJ0Rj5TD1YoNbL4xAKI0bulpBdmSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/194] ionic: Fix dim work handling in split interrupt mode
Date: Mon, 11 Dec 2023 19:20:32 +0100
Message-ID: <20231211182038.459698529@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit 4115ba677c35f694b62298e55f0e04ce84eed469 ]

Currently ionic_dim_work() is incorrect when in
split interrupt mode. This is because the interrupt
rate is only being changed for the Rx side even for
dim running on Tx. Fix this by using the qcq from
the container_of macro. Also, introduce some local
variables for a bit of cleanup.

Fixes: a6ff85e0a2d9 ("ionic: remove intr coalesce update from napi")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20231204192234.21017-3-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index a89ab455af67d..f7634884c7508 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -46,24 +46,24 @@ static void ionic_lif_queue_identify(struct ionic_lif *lif);
 static void ionic_dim_work(struct work_struct *work)
 {
 	struct dim *dim = container_of(work, struct dim, work);
+	struct ionic_intr_info *intr;
 	struct dim_cq_moder cur_moder;
 	struct ionic_qcq *qcq;
+	struct ionic_lif *lif;
 	u32 new_coal;
 
 	cur_moder = net_dim_get_rx_moderation(dim->mode, dim->profile_ix);
 	qcq = container_of(dim, struct ionic_qcq, dim);
-	new_coal = ionic_coal_usec_to_hw(qcq->q.lif->ionic, cur_moder.usec);
+	lif = qcq->q.lif;
+	new_coal = ionic_coal_usec_to_hw(lif->ionic, cur_moder.usec);
 	new_coal = new_coal ? new_coal : 1;
 
-	if (qcq->intr.dim_coal_hw != new_coal) {
-		unsigned int qi = qcq->cq.bound_q->index;
-		struct ionic_lif *lif = qcq->q.lif;
-
-		qcq->intr.dim_coal_hw = new_coal;
+	intr = &qcq->intr;
+	if (intr->dim_coal_hw != new_coal) {
+		intr->dim_coal_hw = new_coal;
 
 		ionic_intr_coal_init(lif->ionic->idev.intr_ctrl,
-				     lif->rxqcqs[qi]->intr.index,
-				     qcq->intr.dim_coal_hw);
+				     intr->index, intr->dim_coal_hw);
 	}
 
 	dim->state = DIM_START_MEASURE;
-- 
2.42.0



