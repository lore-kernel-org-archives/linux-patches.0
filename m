Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B158486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33633C43470;
	Thu, 27 Oct 2022 16:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889967;
	bh=hQi2nDg9gEA8pGowgl8ziuZ+P9uqPO1YRl50hIEDGWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BS7wD71OR+t/EFKr+/X9DB1zTKnboJ1TXoRojZFcKNvqljlZV4d6CWweGKYoGIk2o
	 gCQwN+wouma11g3PNQcvHtL9GB3LxzM/MmAEGtjkmoxZ7PZbRB4pAUvqIL1iLGMJNQ
	 foRyACE8D0KrwH/Yle/4pzwOwljNWfgJXvgmnXKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett@pensando.io>,
	Shannon Nelson <snelson@pensando.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 67/94] ionic: catch NULL pointer issue on reconfig
Date: Thu, 27 Oct 2022 18:55:09 +0200
Message-Id: <20221027165059.894342976@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brett Creeley <brett@pensando.io>

[ Upstream commit aa1d7e1267c12e07d979aa34c613716a89029db2 ]

It's possible that the driver will dereference a qcq that doesn't exist
when calling ionic_reconfigure_queues(), which causes a page fault BUG.

If a reduction in the number of queues is followed by a different
reconfig such as changing the ring size, the driver can hit a NULL
pointer when trying to clean up non-existent queues.

Fix this by checking to make sure both the qcqs array and qcq entry
exists bofore trying to use and free the entry.

Fixes: 101b40a0171f ("ionic: change queue count with no reset")
Signed-off-by: Brett Creeley <brett@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Link: https://lore.kernel.org/r/20221017233123.15869-1-snelson@pensando.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0be79c516781..6ae6d79193a3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2820,11 +2820,15 @@ int ionic_reconfigure_queues(struct ionic_lif *lif,
 	 * than the full array, but leave the qcq shells in place
 	 */
 	for (i = lif->nxqs; i < lif->ionic->ntxqs_per_lif; i++) {
-		lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
-		ionic_qcq_free(lif, lif->txqcqs[i]);
+		if (lif->txqcqs && lif->txqcqs[i]) {
+			lif->txqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, lif->txqcqs[i]);
+		}
 
-		lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
-		ionic_qcq_free(lif, lif->rxqcqs[i]);
+		if (lif->rxqcqs && lif->rxqcqs[i]) {
+			lif->rxqcqs[i]->flags &= ~IONIC_QCQ_F_INTR;
+			ionic_qcq_free(lif, lif->rxqcqs[i]);
+		}
 	}
 
 	if (err)
-- 
2.35.1



