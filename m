Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22C143C7DA;
	Thu, 30 Jul 2026 14:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421987; cv=none; b=WzMHKQxkzjklAbFtU5soqmmrP/BA35Dgqt3zIG8NI1kL6RNSQrnmYY4N10bHM57B3WHDHJ+3Mng9SVIBrNsrJMxsz61sQMlTC63qH72jDaL3YtIjC6X8SHh1NsU50n59iZOaEbd0LJFamzpXd3pz1bGET1Da8YAoWIsEPcFVW4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421987; c=relaxed/simple;
	bh=oW57Tw9xgkFrWr+wJDbIkOFovqsgn90jNj7y/DhHvTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxnyyzYT3KrHdyd8fTBDbRD5fCI1/FNbKbp8eRpn3BrssQcSsPAeBYjJGddTy6DdZjGtkSI9EGNzqEZ5EQYZuyF1NqnEVGsNCBleB8e4xanz8/F9ExymiVjPg+uv0CZCxxWzX+mVhSt+oHAZFjDnfxtLJ6yLCBY+fqTTv30Vy9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSjwftOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSjwftOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985A51F000E9;
	Thu, 30 Jul 2026 14:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421985;
	bh=jAvKAwuQwx6CV/FTOmRzJVz6m2PmMfXUvf/Ptll1zbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sSjwftOuB4eclBykCEvCT+SCGesGZ1yLiSZ9mRCvI0BFfZGE2m04KLM9MMPMBDpKf
	 VGte0ZN/RtVRF6tzpLd514cDICiDDGAtWzl5IT6UyKCZQS5xdqZ+i61FSmePcddv5X
	 CW5MsCGtOSxyRjbg5UJ/Pj2NBHnaiYu9vWPcxZ9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 269/744] pds_core: order completion reads after the ownership check
Date: Thu, 30 Jul 2026 16:09:02 +0200
Message-ID: <20260730141450.010371019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit dd6b1cc748cd28147c113f9daa76393916ad9494 ]

pdsc_process_adminq() and pdsc_process_notifyq() decide a completion is
valid from its ownership field - the color bit for the adminq, the event
id for the notifyq - then read the rest of the descriptor, with no
barrier in between.

On a weakly ordered architecture the CPU may read the payload first. Add
dma_rmb() between the ownership read and the payload reads.

Fixes: 7e82a8745b95 ("pds_core: Prevent race issues involving the adminq")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260629200358.2626129-1-nikhil.rao%40amd.com?part=2
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Reviewed-by: Eric Joyner <eric.joyner@amd.com>
Link: https://patch.msgid.link/20260714204145.1782390-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/adminq.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
index 097bb092bdb8cd..eadb4b604fbe3c 100644
--- a/drivers/net/ethernet/amd/pds_core/adminq.c
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -18,7 +18,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
 	comp = cq_info->comp;
 	eid = le64_to_cpu(comp->event.eid);
 	while (eid > pdsc->last_eid) {
-		u16 ecode = le16_to_cpu(comp->event.ecode);
+		u16 ecode;
+
+		/* Order the payload read after the event id, the field the
+		 * driver uses to detect a new completion.
+		 */
+		dma_rmb();
+		ecode = le16_to_cpu(comp->event.ecode);
 
 		switch (ecode) {
 		case PDS_EVENT_LINK_CHANGE:
@@ -101,6 +107,10 @@ void pdsc_process_adminq(struct pdsc_qcq *qcq)
 	spin_lock_irqsave(&pdsc->adminq_lock, irqflags);
 	comp = cq->info[cq->tail_idx].comp;
 	while (pdsc_color_match(comp->color, cq->done_color)) {
+		/* Order the payload reads after the color bit, the field the
+		 * driver uses to detect a new completion.
+		 */
+		dma_rmb();
 		q_info = &q->info[q->tail_idx];
 		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
 
-- 
2.53.0



