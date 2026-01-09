Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4555233032C;
	Fri,  9 Jan 2026 12:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962654; cv=none; b=QGlne1Flu1pO5vMjddAwBOvMzorVEsYp9LrjJHrKO1iI3ZXr8ErvkwuF3R9sQrnQbMMPLmKeO3OGwlvm4s+iXEQXEaaBRz+mwxKHDsImuKHynQalDbnLSGToTLvPhlGY6yZgs7YsLhgheOiPXl7dEbjvtJcJpIRAqKd7ZMHDXJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962654; c=relaxed/simple;
	bh=T8GzhprRcow7CFTwl0JOfQmHbQgfl1bUehkxfhlU9jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZTygbvyyxQsLGBdNYvtmVfEGJUvzet6BTxJE+kLLTByoM1ljec6JgqzruQSh6O7UXyf90dFeDiy5QpAsHbkXq6KZf8+19cQe1QKdOtE3l1Ud8pJ7chONfjl/UpksRitOGq0auUslhZRiIq+z0S1y25EgfrJ+UV6711lOl45n48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BC3WSB8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BC3WSB8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18F0C4CEF1;
	Fri,  9 Jan 2026 12:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962654;
	bh=T8GzhprRcow7CFTwl0JOfQmHbQgfl1bUehkxfhlU9jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BC3WSB8lPNXMbpjX5N0KMgrW3vQfLLtVwhIdJjZwXs2JWKSG3MHzvzntPRow6lsje
	 yXoAXDqUcpq9yyOXd7dQL68M4g/WMwG+Pwu3yQ+7RrD/732kvm4b4diXC+4k90UFMg
	 II1miRpNo+ZIIMxvEGojnnAExxVCLZnUi4aXJ5lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Zhang <cong.zhang@oss.qualcomm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 441/634] blk-mq: skip CPU offline notify on unmapped hctx
Date: Fri,  9 Jan 2026 12:41:59 +0100
Message-ID: <20260109112134.134276051@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6cfbbe0d7792..2edad54b1788 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3540,7 +3540,7 @@ static int blk_mq_hctx_notify_offline(unsigned int cpu, struct hlist_node *node)
 			struct blk_mq_hw_ctx, cpuhp_online);
 	int ret = 0;
 
-	if (blk_mq_hctx_has_online_cpu(hctx, cpu))
+	if (!hctx->nr_ctx || blk_mq_hctx_has_online_cpu(hctx, cpu))
 		return 0;
 
 	/*
-- 
2.51.0



