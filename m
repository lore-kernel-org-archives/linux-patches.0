Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62D3246768;
	Tue, 11 Nov 2025 01:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822939; cv=none; b=O767DKuRHaXBEX8xvLJtFoSqSXod7x3pAFBppNA/sdwlVtQ3Du72V5zWIWyK2nQvvbbYkvy+aFEKIYWyAUd6pkb8dM+NYEcPTC0r86oxVGv+J4ZLyyoel6mL27RfPWKPwhgcMtIUTQOZf8qtT0gvgM75p6teUvJK96R0bKY1R8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822939; c=relaxed/simple;
	bh=TXaPvtFuAX4RngGoN4cI1nHkIQ6lxlRs+BAmEbRYh34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFrtpQRRzpAXFQ/mQ05SdQhGyzN24sPbR5eJWXUGibYEHi7fuyBayWgVvD7H1PBtj5PabLW03F+64sbFS1DTaz7ISXALph/DqV/OsGPVu1tGZvSYz4DfjGMKbwifBAn2gsZQw5OG49gapp/nYCrpor0oixAY2z3lt0G3tTB8zrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryz6tz01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryz6tz01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F185DC116B1;
	Tue, 11 Nov 2025 01:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822939;
	bh=TXaPvtFuAX4RngGoN4cI1nHkIQ6lxlRs+BAmEbRYh34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryz6tz01wnFZUFuVOgs+SyBc63deN1ElNHLx3yBM7YWpQGMqWWdCbB6eR4zBUB6uL
	 TB7xT0DyX2YOTWdsPVygfmu8sxqmJxviw0rCNeWAxmae3sMQID/8ATW4RcWEKBVhr4
	 neseBQfpp144c3z5y8go32iAYNQSkm9fhrdw4Vpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/565] nvmet-fc: avoid scheduling association deletion twice
Date: Tue, 11 Nov 2025 09:39:53 +0900
Message-ID: <20251111004530.027461868@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit f2537be4f8421f6495edfa0bc284d722f253841d ]

When forcefully shutting down a port via the configfs interface,
nvmet_port_subsys_drop_link() first calls nvmet_port_del_ctrls() and
then nvmet_disable_port(). Both functions will eventually schedule all
remaining associations for deletion.

The current implementation checks whether an association is about to be
removed, but only after the work item has already been scheduled. As a
result, it is possible for the first scheduled work item to free all
resources, and then for the same work item to be scheduled again for
deletion.

Because the association list is an RCU list, it is not possible to take
a lock and remove the list entry directly, so it cannot be looked up
again. Instead, a flag (terminating) must be used to determine whether
the association is already in the process of being deleted.

Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/all/rsdinhafrtlguauhesmrrzkybpnvwantwmyfq2ih5aregghax5@mhr7v3eryci3/
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 0ade23610ae64..67767e926b1bb 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1088,6 +1088,14 @@ nvmet_fc_delete_assoc_work(struct work_struct *work)
 static void
 nvmet_fc_schedule_delete_assoc(struct nvmet_fc_tgt_assoc *assoc)
 {
+	int terminating;
+
+	terminating = atomic_xchg(&assoc->terminating, 1);
+
+	/* if already terminating, do nothing */
+	if (terminating)
+		return;
+
 	nvmet_fc_tgtport_get(assoc->tgtport);
 	if (!queue_work(nvmet_wq, &assoc->del_work))
 		nvmet_fc_tgtport_put(assoc->tgtport);
@@ -1214,13 +1222,7 @@ nvmet_fc_delete_target_assoc(struct nvmet_fc_tgt_assoc *assoc)
 {
 	struct nvmet_fc_tgtport *tgtport = assoc->tgtport;
 	unsigned long flags;
-	int i, terminating;
-
-	terminating = atomic_xchg(&assoc->terminating, 1);
-
-	/* if already terminating, do nothing */
-	if (terminating)
-		return;
+	int i;
 
 	spin_lock_irqsave(&tgtport->lock, flags);
 	list_del_rcu(&assoc->a_list);
-- 
2.51.0



