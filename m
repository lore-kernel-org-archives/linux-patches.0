Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD5A146E70;
	Tue, 27 Feb 2024 13:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041537; cv=none; b=kD2nXihMISrtUOg3DD1KISjUyrjN4/pHZrmhKF1ET3meqO2B6jTojlgNXgvG6Vw+Ij0t6J0DJj5vFl3tX8xxkmc10J96U/PoRAow/HSkdfamIFsYjA80SD4Z7ipJ11fzbVD/KQr7G2qN3BwS3VnMLleynqoPH3I+qaYRdI4jdSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041537; c=relaxed/simple;
	bh=+iNWs9tPWsusgfmXG8iH5t7aPdYPgSAMQUbL+TZuMzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1vLqAeTuyAMlUv9ER9eoSs5pTvvH9eaEOtdZQI/qC3y90KLwoeSvNMr0Spq999FUqEO185VQpv9TAkk0aai9gUXxacJphkhXK201n7bnQ+nL4CtvG/QoSayQ2TnBYUqnlBBBzSlzlUv9Da+zcLcbHUaknjNJ06XYIkHRM83nNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAfKK0fl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAfKK0fl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA009C43394;
	Tue, 27 Feb 2024 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041537;
	bh=+iNWs9tPWsusgfmXG8iH5t7aPdYPgSAMQUbL+TZuMzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAfKK0flKUBNIojEtaPG448jeMgoo+DnWGUpPPZodXT11bPSDW1Kp0EY7n3yOvxZp
	 +bRWEbcfOTD24KU3OgW4dJdefPg00Bnnta83fhyYc/gJjhm4koFN0ErhM96hjMhQoD
	 yt6nQSDzMrGN0K2wYLYHwqkeyGL7S9g2PdWVLybI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/52] RDMA/srpt: Make debug output more detailed
Date: Tue, 27 Feb 2024 14:26:26 +0100
Message-ID: <20240227131549.814206792@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d4ee7f3a4445ec1b0b88af216f4032c4d30abf5a ]

Since the session name by itself is not sufficient to uniquely identify a
queue pair, include the queue pair number. Show the ASCII channel state
name instead of the numeric value. This change makes the ib_srpt debug
output more consistent.

Link: https://lore.kernel.org/r/20200525172212.14413-3-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Stable-dep-of: eb5c7465c324 ("RDMA/srpt: fix function pointer cast warnings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index fd3d8da6a9db8..4a696bf280ef9 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -225,8 +225,9 @@ static const char *get_ch_state_name(enum rdma_ch_state s)
  */
 static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 {
-	pr_debug("QP event %d on ch=%p sess_name=%s state=%d\n",
-		 event->event, ch, ch->sess_name, ch->state);
+	pr_debug("QP event %d on ch=%p sess_name=%s-%d state=%s\n",
+		 event->event, ch, ch->sess_name, ch->qp->qp_num,
+		 get_ch_state_name(ch->state));
 
 	switch (event->event) {
 	case IB_EVENT_COMM_EST:
@@ -1967,8 +1968,8 @@ static void __srpt_close_all_ch(struct srpt_port *sport)
 	list_for_each_entry(nexus, &sport->nexus_list, entry) {
 		list_for_each_entry(ch, &nexus->ch_list, list) {
 			if (srpt_disconnect_ch(ch) >= 0)
-				pr_info("Closing channel %s because target %s_%d has been disabled\n",
-					ch->sess_name,
+				pr_info("Closing channel %s-%d because target %s_%d has been disabled\n",
+					ch->sess_name, ch->qp->qp_num,
 					dev_name(&sport->sdev->device->dev),
 					sport->port);
 			srpt_close_ch(ch);
-- 
2.43.0



