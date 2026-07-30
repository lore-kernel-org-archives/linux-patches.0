Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12064446E6;
	Thu, 30 Jul 2026 15:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424006; cv=none; b=B4t690ZI0MAQyC0IdlSH3OQyctubVvqW+PzR9u8kO4lWEAn7p4odD4eDybHMFPcgSNQPN8n+UPGsp/nsZP8iOVulEkmp1IVAEWPz8AcU6G+gVjBxR2w+6ajW4UxiTwM3qAC2RU0ahLvy73+EyqYYoa8CAtQaaGY48gvncNBERWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424006; c=relaxed/simple;
	bh=dzNsj5ucWJvLwdTJL1weMHb9T9UQFndg9XD3NaT0Gcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eES/LOh3C5/AtV0EafGzKwr2NcPpQK1qhAyKOiKqiRf2zk8/naNZ/3iuXWtM6rlJ9JX8meB8/IAAZCWEzd9PvXTXEoYLv7h73LVCOQQZJIpaFDYWq9HbfT29EUxDB0ifwWZR2DjDbp6oxgEsVYs9TCGPX7U/IxbdVL88jwpE8XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xy7ZMRCi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xy7ZMRCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1181F000E9;
	Thu, 30 Jul 2026 15:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424004;
	bh=sLknK2vwmuNUgAVROFIHKfAO+lvuiG0NIaEo0Xe0fBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xy7ZMRCi0Hr+FH4sSncuTNtnPsUthTpJaOhj+Wlt5PNwMAssLbDwjtuujMX3MAlDn
	 LSDzukSOsVHQE/O/XjGIoTwsA5n9yQqNa9Xu2Dopngs/eaEKtKEISmh5rj5quPC4Yn
	 rqQd/3QdXY45Xu7OxXC7ID8qizKrTEHbbhUVzNlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 242/675] pds_core: order completion reads after the ownership check
Date: Thu, 30 Jul 2026 16:09:32 +0200
Message-ID: <20260730141450.277996120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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



