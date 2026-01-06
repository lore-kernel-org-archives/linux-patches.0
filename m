Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D993364029;
	Tue,  6 Jan 2026 17:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721844; cv=none; b=eUVXmfhx3JP5PTF9bZ5S12ymSXejgf12SZb5C8Koota/VsMrCSuzR/6m5KZ1XnSR68s+C4kIFvuLmFlVSo9S2afZmQx+st2v8N7Ey/SrG0tHrjyYrvYD83a24GJ10h4h3C2fcwR6IsGPeFE+CVfqdBn9TsHcdil/6mnHMF8nssU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721844; c=relaxed/simple;
	bh=lrfUfSNsVYEdvWy5Dy+Ip7fe58lc2uQBO+vDU5RXpZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhIbF06TAukvTSaOJaV/GUKBw6Aj69bIsuYp1VCH7g2Rlm0IMS8xRsOIxXPYf5ypADY0LujOhzHPOQiAB9F5PYAa78nyLHXN3vG56JCgXFFKvhkD3Sli+wZPpIOtseGwix+yqRWkmZCQIPYBU9eIiDqws70W4+VeqNLnQRzhW0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GMIwGfPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GMIwGfPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE03FC116C6;
	Tue,  6 Jan 2026 17:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721844;
	bh=lrfUfSNsVYEdvWy5Dy+Ip7fe58lc2uQBO+vDU5RXpZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GMIwGfPG9LPD918V7j2waCzZEvSidhd2ZCJgH29+4J70hjQS5pceHTZcuRKfrR3mM
	 EycJN/cmVt9xOHdPhhHu9myHu1xsF3dOgKqSG+VshYqdTFEmlZlP0hEjmE8DK4NSrO
	 PdWQkBSyO6bHQxfXGrA/P2grFbUN5Lzi40IL4nAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/312] blk-mq: skip CPU offline notify on unmapped hctx
Date: Tue,  6 Jan 2026 18:02:41 +0100
Message-ID: <20260106170550.985280882@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Cong Zhang <cong.zhang@oss.qualcomm.com>

[ Upstream commit 10845a105bbcb030647a729f1716c2309da71d33 ]

If an hctx has no software ctx mapped, blk_mq_map_swqueue() never
allocates tags and leaves hctx->tags NULL. The CPU hotplug offline
notifier can still run for that hctx, return early since hctx cannot
hold any requests.

Signed-off-by: Cong Zhang <cong.zhang@oss.qualcomm.com>
Fixes: bf0beec0607d ("blk-mq: drain I/O when all CPUs in a hctx are offline")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index ea5f948af7a4..a03f52ab87d6 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3710,7 +3710,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 			struct blk_mq_hw_ctx, cpuhp_online);
 	int ret = 0;
 
-	if (blk_mq_hctx_has_online_cpu(hctx, cpu))
+	if (!hctx->nr_ctx || blk_mq_hctx_has_online_cpu(hctx, cpu))
 		return 0;
 
 	/*
-- 
2.51.0



