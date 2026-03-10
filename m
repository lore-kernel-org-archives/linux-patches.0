Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A4338735B;
	Tue, 10 Mar 2026 11:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141274; cv=none; b=lJdWdvZACJHN49tdrQqjA6cdcp3uBhk68k+T1naeqtbbPy/uIwXbqzrfBETNn+aF5iHg1DPfXi9SOKRJKvLrjGgfT8oppsW7AbnH4alCibX7AzAosHTi34GU5Co1BqIEzKmh07NGR4WoEYRcK5r2SAwqQeWjGJMoKuAXXe/3dF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141274; c=relaxed/simple;
	bh=ZmM3+6bhJ6VNNNHkmREaSQY64BCKizSbY+p5iZgumm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXmwperVbgQF6HEuhZCUFXCuzZ2h7SBB9Vxve3v0tLcWCdeH0nVa46ZPHg0pVQ3eTXAp8zQep2CF+5XbqB82JTYl9nFiQB/A0wXqMGUUH6lfU+CSrEpCQ3HUKQucofi0IAHS/ujfh8SsAo87Zod0WyFuFXxiUk7fP8GSwjPYbtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqkd/JiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqkd/JiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A38C2BCAF;
	Tue, 10 Mar 2026 11:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141274;
	bh=ZmM3+6bhJ6VNNNHkmREaSQY64BCKizSbY+p5iZgumm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqkd/JiK038bSJSDR0hzZN0AvSFtwYp0mAO59IOG7PnBCll5kln7eq8wTlC307LAg
	 TyDIftMvA6Eak/1mlW4dHraoibgEpQknoD61Bw/vBPa+YsW4IQykviXFkD3U5HOcEW
	 LtFTYwYvmg5zGGVUPqY/aTp1/+fcrByrf8CX7OxhS5HMKVs5OOk5+NiT08XvByKIiK
	 Y6ksOWtv6NkVSef0FogJmL+UH4lE3groGt0i3Z0yzLvFamqzi+V0I4qVOpvU4asTR1
	 TrBOkys2ueHYo0H1+eEQm2GQRVhBu4YMOMU7jDIW16l+eJXuya9MdBNN/ZW4I2Tg6v
	 lpFOkJfxjFY5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 276/311] net_sched: sch_fq: clear q->band_pkt_count[] in fq_reset()
Date: Tue, 10 Mar 2026 07:05:23 -0400
Message-ID: <a7fa1ce78dd2bd83639717578ee90c0985345d92.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a4c2b8be2e5329e7fac6e8f64ddcb8958155cfcb ]

When/if a NIC resets, queues are deactivated by dev_deactivate_many(),
then reactivated when the reset operation completes.

fq_reset() removes all the skbs from various queues.

If we do not clear q->band_pkt_count[], these counters keep growing
and can eventually reach sch->limit, preventing new packets to be queued.

Many thanks to Praveen for discovering the root cause.

Fixes: 29f834aa326e ("net_sched: sch_fq: add 3 bands and WRR scheduling")
Diagnosed-by: Praveen Kaligineedi <pkaligineedi@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260304015640.961780-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 6e5f2f4f24154..b570128ae10a6 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -829,6 +829,7 @@ static void fq_reset(struct Qdisc *sch)
 	for (idx = 0; idx < FQ_BANDS; idx++) {
 		q->band_flows[idx].new_flows.first = NULL;
 		q->band_flows[idx].old_flows.first = NULL;
+		q->band_pkt_count[idx] = 0;
 	}
 	q->delayed		= RB_ROOT;
 	q->flows		= 0;
-- 
2.51.0

