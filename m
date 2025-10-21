Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBD21A3029;
	Tue, 21 Oct 2025 20:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077540; cv=none; b=RHcXn/TTnw84Ic2xjhKuM9P+AELUjKffvUE9qw/MNvpIoIAqhaZi4UTpra/VLC4//5hZDHM4JARcWR+HQnpm3Uu9lQ7czfdkSz6nHyARJ1JWawUGoD9xBitzq0KGgs16kmzrGyNbaELkeSG9je0FKHS38f0RCUCIjft9TULP0o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077540; c=relaxed/simple;
	bh=sEeCvCTC7jrF/5HJ+H2UrF8oFzl0LLy5TMyENHQWBAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9P4KQ5QREvcTaQzg/YjgYHRGcS8MtXOih3J+SMrl9X3/IvfCmUX2fV18xUTY9JKnOz184xUcc0fSUVX+dMVgUC6yk0wC1d9pmkMrNtaMGxVT6zyLEWGfyUx2GgJoZnLJf7GfR/vhu5ptfRr+UK3uOE3oNz+SzFzat7Vj68Wjbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRZZa3/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRZZa3/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C842C4CEF1;
	Tue, 21 Oct 2025 20:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077540;
	bh=sEeCvCTC7jrF/5HJ+H2UrF8oFzl0LLy5TMyENHQWBAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRZZa3/gCjjtPS5b+0K6rJlCn2QkQAQNl4L/+ES8hPlVavbvo5JsIFR0UAhJDOcSU
	 SmCw1wPRhYRZii41mv26QGILGrE18TpYRCoHvN/f8DtzcblTFQRgfxbPfRmh6gLoci
	 A0KVGP10fzEc3ofJsyd78bImibKzy+Azd/qz7bVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Chaudhary <achaudhary@purestorage.com>,
	Randy Jennings <randyj@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 093/159] nvme-multipath: Skip nr_active increments in RETRY disposition
Date: Tue, 21 Oct 2025 21:51:10 +0200
Message-ID: <20251021195045.422479779@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Chaudhary <achaudhary@purestorage.com>

[ Upstream commit bb642e2d300ee27dcede65cda7ffc47a7047bd69 ]

For queue-depth I/O policy, this patch fixes unbalanced I/Os across
nvme multipaths.

Issue Description:

The RETRY disposition incorrectly increments ns->ctrl->nr_active
counter and reinitializes iostat start-time. In such cases nr_active
counter never goes back to zero until that path disconnects and
reconnects.

Such a path is not chosen for new I/Os if multiple RETRY cases on a given
a path cause its queue-depth counter to be artificially higher compared
to other paths. This leads to unbalanced I/Os across paths.

The patch skips incrementing nr_active if NVME_MPATH_CNT_ACTIVE is already
set. And it skips restarting io stats if NVME_MPATH_IO_STATS is already set.

base-commit: e989a3da2d371a4b6597ee8dee5c72e407b4db7a
Fixes: d4d957b53d91eeb ("nvme-multipath: support io stats on the mpath device")
Signed-off-by: Amit Chaudhary <achaudhary@purestorage.com>
Reviewed-by: Randy Jennings <randyj@purestorage.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 3da980dc60d91..543e17aead12b 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -182,12 +182,14 @@ void nvme_mpath_start_request(struct request *rq)
 	struct nvme_ns *ns = rq->q->queuedata;
 	struct gendisk *disk = ns->head->disk;
 
-	if (READ_ONCE(ns->head->subsys->iopolicy) == NVME_IOPOLICY_QD) {
+	if ((READ_ONCE(ns->head->subsys->iopolicy) == NVME_IOPOLICY_QD) &&
+	    !(nvme_req(rq)->flags & NVME_MPATH_CNT_ACTIVE)) {
 		atomic_inc(&ns->ctrl->nr_active);
 		nvme_req(rq)->flags |= NVME_MPATH_CNT_ACTIVE;
 	}
 
-	if (!blk_queue_io_stat(disk->queue) || blk_rq_is_passthrough(rq))
+	if (!blk_queue_io_stat(disk->queue) || blk_rq_is_passthrough(rq) ||
+	    (nvme_req(rq)->flags & NVME_MPATH_IO_STATS))
 		return;
 
 	nvme_req(rq)->flags |= NVME_MPATH_IO_STATS;
-- 
2.51.0



