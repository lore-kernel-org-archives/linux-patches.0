Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8870D2686BC;
	Tue,  8 Apr 2025 12:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114271; cv=none; b=njrnpChOqiIK0LLfS3RrLdhoZM/5xdu4UnAROv2DccPa6rqB4yQOHpX7gGonhzV/ShT0w7F/VHvHxcEDKWSonrvodX9DCOGRB+5prQntOkx+AlImDDKOuueFT4lRO096krb1NcHVPBCdxnEnN9xZ1jeOaXcWCaLRo3BS3vaPSRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114271; c=relaxed/simple;
	bh=P9IVT8teLDiA57HHPW6Amy1wGTJV5ZRrpOQzEGjy4bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWYZ3h2l2kG3fXuZz/W7/ZmQFzEq075o5MWiElkuGDSU6Amckk4KgMhqAi4r2pfPP1ClDiR5KNPMHWcakRfQ5fDbOaGBNakOvIFucHK/h87hnInL5yht4XUTbNToUJyrsBEw5ovXS88VYYjrfE/GdnenRH9Ded15T2bsulPj/6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTanU6zD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTanU6zD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1131AC4CEE5;
	Tue,  8 Apr 2025 12:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114271;
	bh=P9IVT8teLDiA57HHPW6Amy1wGTJV5ZRrpOQzEGjy4bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTanU6zDLobxYRhx5ZaGyfrQbXnoy5RWpJBTn5LY9BLaCUWAJGlggtH5JVhiHT5iY
	 YEofjwJpqnF5IFf7sdhEyF7B7bGkNtGR6XiobICHUqrOEhyoNwoU/Iivq47dMx1MGP
	 WxVUX3XtOxvdRSMlW9DT2e6375eao8g2Z+4eohTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 009/499] sched/eevdf: Force propagating min_slice of cfs_rq when {en,de}queue tasks
Date: Tue,  8 Apr 2025 12:43:41 +0200
Message-ID: <20250408104851.486294296@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit 563bc2161b94571ea425bbe2cf69fd38e24cdedf ]

When a task is enqueued and its parent cgroup se is already on_rq, this
parent cgroup se will not be enqueued again, and hence the root->min_slice
leaves unchanged. The same issue happens when a task is dequeued and its
parent cgroup se has other runnable entities, and the parent cgroup se
will not be dequeued.

Force propagating min_slice when se doesn't need to be enqueued or
dequeued. Ensure the se hierarchy always get the latest min_slice.

Fixes: aef6987d8954 ("sched/eevdf: Propagate min_slice up the cgroup hierarchy")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250211063659.7180-1-dtcccc@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9110f95adc8e3..054a7c45fc43a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6988,6 +6988,8 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 		update_cfs_group(se);
 
 		se->slice = slice;
+		if (se != cfs_rq->curr)
+			min_vruntime_cb_propagate(&se->run_node, NULL);
 		slice = cfs_rq_min_slice(cfs_rq);
 
 		cfs_rq->h_nr_running++;
@@ -7117,6 +7119,8 @@ static int dequeue_entities(struct rq *rq, struct sched_entity *se, int flags)
 		update_cfs_group(se);
 
 		se->slice = slice;
+		if (se != cfs_rq->curr)
+			min_vruntime_cb_propagate(&se->run_node, NULL);
 		slice = cfs_rq_min_slice(cfs_rq);
 
 		cfs_rq->h_nr_running -= h_nr_running;
-- 
2.39.5



