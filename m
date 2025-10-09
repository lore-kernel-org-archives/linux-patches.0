Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8457B205E25;
	Thu,  9 Oct 2025 15:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025495; cv=none; b=pUjtQD5OHRWjt7oaJPhv/wtXKkfpR3nqeh7YvKovIrkexYUS7pMPFw+/a1kA6tUdUAML2ZRKCEu5s7b5RtNrDCvq6D/Iz0o023M/cpethEeLMctdFErp03FYpdNlHYCQg08uEbUjYibY3MDxq6W3ZXhC+tXZfdNU79WLMLOLnhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025495; c=relaxed/simple;
	bh=vf9lXfhJkmvZ4gOreQJTZxAVrmsPZT8DFyk3EjXjbNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HCm+HS0Lb3w1SXVkPEI0aRJhDFTlJ3XlbDtuVySvc/4EHw8GbePrI64zFXgk9QwoV4S0c4SQx0e5UARLrOcsJJyHPBcSzMkuLHkLU8nFl/1Ys3x7NPQEqxK7U6Q0Q2kW8vM4XgsDFdSppfjd/I7kLWgeKYLu2Ij0hs5vs9LmOn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4J4K92O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4J4K92O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D82C4CEF7;
	Thu,  9 Oct 2025 15:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025494;
	bh=vf9lXfhJkmvZ4gOreQJTZxAVrmsPZT8DFyk3EjXjbNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4J4K92OS7w/TQsj9btR3Ld1XSZ8MeDWNisSbN09t3OXgIxNOP15YZWUxz+NLioFF
	 7ZIbA4c4NCy7gbs0dOqv05wIuGZHgXg2/fZppxTvSqSVc2eL9lQ3gdSVcTMeg5jYnJ
	 n0EAw6veYid6HQWMQvyBBU6uhkc8Gs03uhDgMXH0d+YhnRwGNeDuD45NtocWgAmluv
	 xialESWo7oCT1hmN4CBw4yZ3sF5OjmyxSs5YWUKjGpQr9Hjle/agCVUhhsjto4oH/H
	 f6tPiuoprkehBBmUgHoCrXQN/fL9fZkVX74ul8Tbw7Q8AyyOYWeqkTgE1EaCSh0DIq
	 5h59VxF7qqTsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Wagner <wagi@kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hannes Reinecke <hare@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	justin.tee@broadcom.com,
	nareshgottumukkala83@gmail.com,
	paul.ely@broadcom.com,
	sagi@grimberg.me,
	kch@nvidia.com,
	linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-5.15] nvmet-fc: avoid scheduling association deletion twice
Date: Thu,  9 Oct 2025 11:54:41 -0400
Message-ID: <20251009155752.773732-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES – this prevents a real use-after-free when an FC target port is torn
down through configfs.

- `nvmet_port_subsys_drop_link()` first calls `nvmet_port_del_ctrls()`
  and then `nvmet_disable_port()`
  (`drivers/nvme/target/configfs.c:1088`,
  `drivers/nvme/target/core.c:301`), and both paths funnel into
  `__nvmet_fc_free_assocs()` which queues `assoc->del_work`
  (`drivers/nvme/target/fc.c:1482`). So a forced shutdown schedules the
  same association cleanup twice.
- The guard that’s supposed to stop duplicates only runs inside
  `nvmet_fc_delete_target_assoc()` after the work executes
  (`drivers/nvme/target/fc.c:1201`), so the second caller can still re-
  queue the work once the first invocation has freed the association,
  hitting the race reported on the mailing list.
- The patch simply flips the `terminating` flag before queueing
  (`drivers/nvme/target/fc.c:1076` in the new code) and removes the
  redundant check from the worker. That keeps the work from ever being
  queued a second time, exactly matching the original intent with no
  behavioural side effects.
- Change is tiny, isolated to the nvmet-fc transport, and has no
  dependencies beyond the existing `assoc->terminating` infrastructure
  (already present in supported stable series), so the risk of
  regression is minimal while the bug being fixed can crash systems
  under administrative port removal.

If you’re carrying stable trees that include the fc target (v6.10 and
earlier back to when `assoc->terminating` was introduced), you should
pick this up; older branches without the later queue_work refcount patch
just need the same flag move applied to their local
`nvmet_fc_schedule_delete_assoc()`.

 drivers/nvme/target/fc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index a9b18c051f5bd..249adb2811420 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1075,6 +1075,14 @@ nvmet_fc_delete_assoc_work(struct work_struct *work)
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
@@ -1202,13 +1210,7 @@ nvmet_fc_delete_target_assoc(struct nvmet_fc_tgt_assoc *assoc)
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

