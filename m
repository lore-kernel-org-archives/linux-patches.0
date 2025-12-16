Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1035B346791;
	Tue, 16 Dec 2025 12:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888434; cv=none; b=E8tXaFj1djtjQB94VUrK/Y/LttaFqSL7kxc/hpvm7+uwqpQYBJI/mhmUXtPDWh0P6lvYFY8eB1ypxXUqVTw6HlUOYRCHQCmyVlVsLmVBqMkSyByMKhUmotrsXHBViDcALNw3jGf5hIworARGjOdB33oV2pqdNpRdgeU2gjPPbtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888434; c=relaxed/simple;
	bh=D1wgWFI+ap8r2vXv2wkqzs194vQA1NRPchbZKQD5vLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foE3JnmkxudCq7WM4PjJo7EjQmYxC3Vl1ZOFTg7JA/B2L2F5wGbLuyMx4IzsM9jT15sXSdqC5VI7Jgok0bgiSyUdVhP72U0LgSTvjBSlThmoGC5aNn8ZzZCp+ayQpOAGqoCM+EKGembPRLGlq6j83Vz8i/DsxRxbgYAtXDbtP8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQ4+RUrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQ4+RUrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710D4C4CEF1;
	Tue, 16 Dec 2025 12:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888433;
	bh=D1wgWFI+ap8r2vXv2wkqzs194vQA1NRPchbZKQD5vLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQ4+RUrZmdRoZ0mPNy+FyQxSKLrd0x2n9lfITB10g1UquZniw41tN7Bh6LMAXs2ln
	 bE4q66A8A1VNhhasIleyj2hGyYiwe1w/+J5bK6/zfmXHlzB4wBftFjgOhIOHH5CRnv
	 L0BHH+/85ntqS+kj+nV164Ue/DUrSFHjFb2fF4M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xupengbo <xupengbo@oppo.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 534/614] sched/fair: Fix unfairness caused by stalled tg_load_avg_contrib when the last task migrates out
Date: Tue, 16 Dec 2025 12:15:01 +0100
Message-ID: <20251216111420.726282032@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: xupengbo <xupengbo@oppo.com>

[ Upstream commit ca125231dd29fc0678dd3622e9cdea80a51dffe4 ]

When a task is migrated out, there is a probability that the tg->load_avg
value will become abnormal. The reason is as follows:

1. Due to the 1ms update period limitation in update_tg_load_avg(), there
   is a possibility that the reduced load_avg is not updated to tg->load_avg
   when a task migrates out.

2. Even though __update_blocked_fair() traverses the leaf_cfs_rq_list and
   calls update_tg_load_avg() for cfs_rqs that are not fully decayed, the key
   function cfs_rq_is_decayed() does not check whether
   cfs->tg_load_avg_contrib is null. Consequently, in some cases,
   __update_blocked_fair() removes cfs_rqs whose avg.load_avg has not been
   updated to tg->load_avg.

Add a check of cfs_rq->tg_load_avg_contrib in cfs_rq_is_decayed(),
which fixes the case (2.) mentioned above.

Fixes: 1528c661c24b ("sched/fair: Ratelimit update to tg->load_avg")
Signed-off-by: xupengbo <xupengbo@oppo.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Aaron Lu <ziqianlu@bytedance.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Aaron Lu <ziqianlu@bytedance.com>
Link: https://patch.msgid.link/20250827022208.14487-1-xupengbo@oppo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2a4a1c6e25da0..71d3f4125b0e7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4059,6 +4059,9 @@ static inline bool cfs_rq_is_decayed(struct cfs_rq *cfs_rq)
 	if (child_cfs_rq_on_list(cfs_rq))
 		return false;
 
+	if (cfs_rq->tg_load_avg_contrib)
+		return false;
+
 	return true;
 }
 
-- 
2.51.0



