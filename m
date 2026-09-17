Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC4D49D590;
	Thu, 17 Sep 2026 17:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667923; cv=none; b=YsCMgP13EvTghEM21P87VybEKRd5ohMrYIoipxXbvyZ5QXmP2emuUW0vp67kMKgxrlPl40B3GNQI45SxKI5j7Y42OKO4yvZj+9BcfL+gKq4qwozNn5C3UB/IpD+g3aF/rLePDc9VP/X+ZJLCfLmIc6m/2YAiZeP4fuNT7gk692g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667923; c=relaxed/simple;
	bh=yBO5BJNesVOBgnKMJeOeysRwJjNQI6K8Dz5E/0D8hRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnHxBlC4d0mbEaFJ5UKCgHj5DiBnrBbOlVM0CE8aFl1ompgSSLrAkHyLhxdU2fJ/irqAjLhaxtp+1VnUgOcGjR1Pd8QTmkXULO0bHNRL/o0b6AqMFn+XAL80qggTn2WkhzsJVO1RbaoTYGtJumqLto20ADtmmsHJrowN2F7wOMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oArKFDA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oArKFDA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B741F000FF;
	Thu, 17 Sep 2026 17:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667922;
	bh=sRxucduFF5HlyWd7bdkD94tTGhV26ZIAvG40wvzzF0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oArKFDA2EDgzOyUFhRG83aWXEVGQfg8Uea+YMVEuAfBAcXKvzZ7pYFQqoltsGCus5
	 tH34EnYho7WDzrqbuS+js0zVxnEt1ekOynUNDcsM39H9HW+56Rhh2dgNtdYrCmHcEo
	 LRsM/k4DCmkMkaTH0uHuH/kzJ4N/J8m+0oTHpSJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yao Sang <sangyao@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0208/1102] nvme: refresh multipath head zoned limits from path limits
Date: Thu, 17 Sep 2026 16:02:31 +0100
Message-ID: <20260917151544.799222885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index cd1b1ae4930e9..7ab6799c193ac 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2247,6 +2247,14 @@ static int nvme_update_ns_info_block(struct nvme_ns *ns,
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
@@ -2312,6 +2320,8 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_ns_info *info)
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



