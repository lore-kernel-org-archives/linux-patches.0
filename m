Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF94312825;
	Wed,  3 Dec 2025 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777549; cv=none; b=Cdxs951fmlE6QfBYuyQUwVpZxPL8+vH4LI8R6UIQthJzAFDjwacIxWqUIJtZhWqtp0J2GaIgGKMd6XnaxZW1ImAWmTCfqoW6yhv+dRWCJ7+g39dF2H6etRY1ZXpxwL3Fo179ATHzSaFg6j2ww38MNPFHzZ/26pt0zNo2dHtMrDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777549; c=relaxed/simple;
	bh=L4cUnqNgiMsjAmDssr2fzaGADy72Iyr/upoexK8FI7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjBY3GJmRFuFMQqY+wUmNCXmxePewx1zZKRG68p3xNYEY2r2Clp9Lbhw4nJIgGhspfapwWfsQAi9IZs0VwN5cUXJ7AlMMm3WIhSAw5q2LMLtxNJW08DrUPp0HTYYd/B1uA2J6rxF0VQ0ssLeBRN8S9bqYmn/KzYzO1QNNbSvrMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8kzJYHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8kzJYHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9395EC4CEF5;
	Wed,  3 Dec 2025 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777549;
	bh=L4cUnqNgiMsjAmDssr2fzaGADy72Iyr/upoexK8FI7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8kzJYHPRANUZMXB/X3A/7pwc+2+HO0o+G3F70LjpyO7knCTqcgXkFYEN7wWyaVoG
	 E4kKk8iSTkePLMXbSyBbHjN2pD1mulGIxvAPa2P0jz/Nxmw6B0dIBZ4neqE5au3lJe
	 m53NiC+QwiKqrytLTv9SUgGlHfnQ3l3/uWaLqnK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/392] nvmet-fc: avoid scheduling association deletion twice
Date: Wed,  3 Dec 2025 16:23:44 +0100
Message-ID: <20251203152416.829179240@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c4b528b89ebe..80e0dc60a9205 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1090,6 +1090,14 @@ nvmet_fc_delete_assoc_work(struct work_struct *work)
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
@@ -1209,13 +1217,7 @@ nvmet_fc_delete_target_assoc(struct nvmet_fc_tgt_assoc *assoc)
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



