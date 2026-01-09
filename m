Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277322F0C7F;
	Fri,  9 Jan 2026 12:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960825; cv=none; b=NupaAaMReLRnNK1WyrGBrwYopagCkQ/f6yIogEfU0GntWNE7IGVqGD6KwL4bHWtf+pZEj+JV+j74JpNGsoEk99AHUies+Vm1qgAraSGgXkQBjwiebiUV6FMjlEkrnDd/Wo3JktTHVoEV8O7r0XXeTDHonqUVwZRXB9A44gV7u0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960825; c=relaxed/simple;
	bh=HhdNFjcHWiMWXAw6o+8KOn8sEdDLS5BbWXrkGJLn2cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6KLuHLEisHalxvXnmwX7cc3wT31BGc92GHlSLrN0PfJbeF2iZdO3aQ1bzxQZVqEcjzq2ot7xYxnYXj6KVZ5hml4MxMAZvtj6EyB4yPyGQxPwU+Wvo6sNUYqiOaqU82fuK3uo7GeNMvABc1NGosvEbJQ2K95bO7bpq425IuT4fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILmwcM79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILmwcM79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA042C4CEF1;
	Fri,  9 Jan 2026 12:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960825;
	bh=HhdNFjcHWiMWXAw6o+8KOn8sEdDLS5BbWXrkGJLn2cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILmwcM79BgtINqROqOeWEpGV4dp/dKIVAvFZl8gudsK1KtP5zUZh6AXC8azf6lxZY
	 rqAXi/GH7IOi2t70fZTHzRyeguf2beEzksqdr6AfKHrxhY0PhdgNGszdhjXT2lxFAp
	 JadaFfKNPMiB4c7EoBIxDFVAOrzshDvQk/yxEJgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 539/737] blk-mq: skip CPU offline notify on unmapped hctx
Date: Fri,  9 Jan 2026 12:41:18 +0100
Message-ID: <20260109112154.271028093@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a3cd5079557b..427a36237da3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3578,7 +3578,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 			struct blk_mq_hw_ctx, cpuhp_online);
 	int ret = 0;
 
-	if (blk_mq_hctx_has_online_cpu(hctx, cpu))
+	if (!hctx->nr_ctx || blk_mq_hctx_has_online_cpu(hctx, cpu))
 		return 0;
 
 	/*
-- 
2.51.0



