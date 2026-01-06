Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F62D2D8762;
	Tue,  6 Jan 2026 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720791; cv=none; b=CSx1nfx3a74Aef5f0NfFfqmPoELnkFl3HpKm+mhXJfNyLEhPS7F/otyKmugjE/+BTQOHZ8kawPHhQ5y3P8BOu2ZwQ2+yiO3NGWzLuIsNlUb3yaf/iL8QMUfyIeVNnn+XeEVhRO0hy4/b8RUUDE7joT+S/qiM5PUd3kqOhlj+XzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720791; c=relaxed/simple;
	bh=2HqYaLeSNaHg+jIE3VPHyvZv7RgcdD2wzabG/FQ93E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7KkWJmk+Z0TUiJFmnkbIFfS9P8fNmN+ygrLQyfWPF05f2+fhe9dCAsOKXR+JkegC4siFNCKIN4uABY+RoTwPJsCBcshizKsHgkD60/e3+8FOsXCKnp7Sj6t7ftjNhj3Aby4tUIhfA5apMT0FmtsU0mzVFMq8gfg+Gt43hhlXL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brJYuvbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brJYuvbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958D7C116C6;
	Tue,  6 Jan 2026 17:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720791;
	bh=2HqYaLeSNaHg+jIE3VPHyvZv7RgcdD2wzabG/FQ93E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brJYuvbiZmBObSgTqAJBhQxMa1jZwinnYohBHJm59C72QNppXf/oigr1f/nxtZIbt
	 dQGrUovDdtdAQDaYd/nFik+FUwQhxZdmdr1h/nXUGTZrdGZsx9r+asuO9Jb6Mkt0aY
	 W3zfm0TG2wNaNcKLjJZJW9ZceSI+/vo07lKhE1uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 342/567] blk-mq: skip CPU offline notify on unmapped hctx
Date: Tue,  6 Jan 2026 18:02:04 +0100
Message-ID: <20260106170503.978357162@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
index db72779760d5..1891863dcba1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3658,7 +3658,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 			struct blk_mq_hw_ctx, cpuhp_online);
 	int ret = 0;
 
-	if (blk_mq_hctx_has_online_cpu(hctx, cpu))
+	if (!hctx->nr_ctx || blk_mq_hctx_has_online_cpu(hctx, cpu))
 		return 0;
 
 	/*
-- 
2.51.0



