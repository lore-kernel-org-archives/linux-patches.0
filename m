Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285424E3241;
	Thu, 17 Sep 2026 16:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664346; cv=none; b=N5O7LxbPOp2UEom/Zpif30UXXD3xryUabYI5ASIUbGGsN3lAMmOBgbkV2wYfipcjG/v2pCWvhJrPQreNzY61QrQO+jaaQ+k6BTtVagq9XHSqCy0qovtw9FsLEZiu8nu3GRqfxivlr722mjP0mr3XdQaBB7c0ySn60h1wMVjey1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664346; c=relaxed/simple;
	bh=6zbFJRLJAwKBCJ7diZgBmsfDQXaeM6Bv28yNsIpkhRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lckm/kqzS1OLI1tbEjQj1GswyOvBxI4kHRNWqWmagZquS4jYjwOT9jYbQ7/3QodxNjgV7jTzDz9Ncffh07id43JbHGgVOn3TmsAdUDwH9PAh+uwQZaCNKcjgjfWqDZFu35Zqn21l+D9SNYU/H8pwSPkaaNsuSBK7anyM8tM1x/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phqBKPbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phqBKPbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2631F000FF;
	Thu, 17 Sep 2026 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664345;
	bh=v6GBpBn9pB7T8DLs4vUpaYN1DYkvNJ5SzLQw9h050Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phqBKPbwnJzd22xzLkLduInhMouKhjVFR3m5RD2yfpMbGsc4pM3fdmke0JiMZ0kUs
	 SAOPxYKj2tkEfaR5rWCMzLPXErAMBT6hGC2uWm/HjMCfzZdEeT/ejyIx6I6pVUzogG
	 MPzF58fhsJBNijpe/MUgPWAPztJOCFq+zN4kZUWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yao Sang <sangyao@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0292/1250] nvme: refresh multipath head zoned limits from path limits
Date: Thu, 17 Sep 2026 16:01:27 +0100
Message-ID: <20260917151600.041808870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Yao Sang <sangyao@kylinos.cn>

[ Upstream commit 59c0517123f2757c41d7795f841bc4c836577d17 ]

queue_limits_stack_bdev() updates the multipath head limits from the
path queue, but it does not propagate max_open_zones or
max_active_zones. As a result, a zoned multipath namespace head can
keep stale 0/0 values even after a ready path reports finite zoned
resource limits.

When refreshing the head limits in nvme_update_ns_info(), stack the
zoned resource limits directly after stacking the path queue limits.
Use min_not_zero() so the block layer's 0 value keeps its "no limit"
meaning while finite limits are combined conservatively.

This avoids advertising "no limit" on the multipath head while keeping
the zoned-limit handling local to the NVMe multipath update path.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yao Sang <sangyao@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f370dce6f91dd..fd4f9cd445075 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2465,6 +2465,14 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
 	return ret;
 }
 
+static void nvme_stack_zone_resources(struct queue_limits *t,
+				      const struct queue_limits *b)
+{
+	t->max_open_zones = min_not_zero(t->max_open_zones, b->max_open_zones);
+	t->max_active_zones =
+		min_not_zero(t->max_active_zones, b->max_active_zones);
+}
+
 static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 {
 	bool unsupported = false;
@@ -2531,6 +2539,8 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
 		lim.io_opt = ns_lim->io_opt;
 		queue_limits_stack_bdev(&lim, ns->disk->part0, 0,
 					ns->head->disk->disk_name);
+		if (lim.features & BLK_FEAT_ZONED)
+			nvme_stack_zone_resources(&lim, ns_lim);
 		if (unsupported)
 			ns->head->disk->flags |= GENHD_FL_HIDDEN;
 		else
-- 
2.53.0



