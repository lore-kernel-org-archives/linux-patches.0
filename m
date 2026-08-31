Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFC05762B5;
	Mon, 31 Aug 2026 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184146; cv=none; b=EVgybfKyvY1fwsD9valMab/1x8jPx0ZFEReRHpIBTPvG+uKNQxovKEGZsZq5KRR49wRyRte74GVp8zsDZXwfYvKgEUrUr1N3Pd+/tHidtze1oFKNY3P5T1z4SlB5+Bj64j8Cez5O5YQP+fsJaywe2zYb2ROZKcgGLKGuZzp9h+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184146; c=relaxed/simple;
	bh=2ZGhUke2PEP6vlxzS7jb8mNiEdyquu06fTDx8FSFmVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IbPu/CMMON4gmIJTyp4ErOFcrY5iCQ/GffeuVHGc9yM5aHmtoMe+Rdd1bcDvSdYqAaqrvxEOkNmLqNK4Q9G+ko/Gb+T0JVUv8AkLEi7/eJ9h5WvYlXy3AMvO9Z4dDnx6dkG8VBmCeTtPGwrcCK3S+hupTFvvnQfZx3DL3BhpZRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/BCO+tW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/BCO+tW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DF71F00A3E;
	Mon, 31 Aug 2026 13:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184144;
	bh=ZD6YygNg9Pn50603e1dS0QGpNkDGVP0AuhXi1ZDDeIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/BCO+tWyAeWBTmvREia8CtO+LONh+GsQQTKfVsIwend/NokAsFiSUvz8AEZabzbX
	 ylY9M86Pk19aMhbpMiJdR3uRFxn/oYjbOYGQGiHz/0D19SB1XRvyqx5MKE47PLiWZe
	 1MHhJyickMd11vAyRN/4qYIoFfCfLv4BQCzC3geE9VsWUTQVL6RqXG+jx1VwFcSplp
	 Ni/WN0GqY6aI9NDpFM625GopLtmNVE8e/JzOQhV222/FTum1zApX4sm4JXWBy3//0c
	 n937TI6QGp311AtOZayiKtUygyttNVIayTtm9n8KW4nntiTu3m5aPt/P9YPrA8725I
	 9zyMY6dnK9NRg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-nvme@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] nvme-core: align fabrics_q teardown with admin_q in nvme_free_ctrl
Date: Mon, 31 Aug 2026 09:29:06 -0400
Message-ID: <20260831133314.4125787-518-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit f702badaf7d31dc3dea6c66da92b5f35fadd89dc ]

Currently, the final reference for the fabrics admin queue (fabrics_q)
is dropped inside nvme_remove_admin_tag_set(). However, the primary admin
queue (admin_q) defers dropping its final reference until
nvme_free_ctrl().

Move the blk_put_queue() call for fabrics_q from
nvme_remove_admin_tag_set() to nvme_free_ctrl(). This aligns the
lifecycle management of both admin queues, ensuring they are freed
symmetrically when the controller is finally torn down.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background git searches finished: all three lookups (`git log
--grep='align fabrics_q'` and `--grep='fabrics_q teardown'` on HEAD and
`stable/linux-6.18.y`) returned no matches. That confirms the fabrics_q
alignment fix is not in this `6.18.44` tree yet, which matches the
earlier analysis — the asymmetry from `03b3bcd319b3a` is still present,
and the backport recommendation remains **YES**.

 drivers/nvme/host/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 24a5ca35aeb25..8feb774616029 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4908,10 +4908,8 @@ void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl)
 	 */
 	nvme_stop_keep_alive(ctrl);
 	blk_mq_destroy_queue(ctrl->admin_q);
-	if (ctrl->ops->flags & NVME_F_FABRICS) {
+	if (ctrl->fabrics_q)
 		blk_mq_destroy_queue(ctrl->fabrics_q);
-		blk_put_queue(ctrl->fabrics_q);
-	}
 	blk_mq_free_tag_set(ctrl->admin_tagset);
 }
 EXPORT_SYMBOL_GPL(nvme_remove_admin_tag_set);
@@ -5053,6 +5051,8 @@ static void nvme_free_ctrl(struct device *dev)
 
 	if (ctrl->admin_q)
 		blk_put_queue(ctrl->admin_q);
+	if (ctrl->fabrics_q)
+		blk_put_queue(ctrl->fabrics_q);
 	if (!subsys || ctrl->instance != subsys->instance)
 		ida_free(&nvme_instance_ida, ctrl->instance);
 	nvme_free_cels(ctrl);
-- 
2.53.0

