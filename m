Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFFD248BCB;
	Wed, 15 Jan 2025 10:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938184; cv=none; b=bccpHzpByyehUllL6x/IcmyV2O52zpacM9fVBybQJObo6zDEDcRqXri0pQLmElwfBrgmbnukDtYtyRA9ayS4mu2ZeyZ8Za+nNso8LbFIm25MpOSRaBx3JNYPOeLfynKTM2X44cqkA2D7bkU2hkD6EHglRBK4cgOICivHuFkjRbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938184; c=relaxed/simple;
	bh=kendwWK4MEyc+P0r6rqzKR+FImK8i9ZdmFdaTDB7osY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g05a54yKhoYl5KwGXCXWfNzQkTXMUpV8HgtED9X9Jzxz6/r/RP9NIXrURSvwjkZ0kgIDaVQPZPMXWmqEfiFYdaf3tT6ykti1niknzOKxYr1C+5s9pqKCRI3EvS4s7HkKsmbcbWBP8DffAYeGrnMzbxdcp5nd+fdIJ/Au+cHGSEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBlspq8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBlspq8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAA2C4CEDF;
	Wed, 15 Jan 2025 10:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938184;
	bh=kendwWK4MEyc+P0r6rqzKR+FImK8i9ZdmFdaTDB7osY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBlspq8mUN6qk3U5gj3fmqIw/LQ0swtMTE8RIdeY2dJfAW8akO15UFQyAyRrLKWF4
	 OdBtnfkaaKbFDQoWVQ/kgvZUYvGPEdwGBLIZTGP4DHGNkAoOaVWvg2nYLkyn7zpLgj
	 kwiFadD459XBKMKTUWXMUes1zda5mbDLUyuVDEVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Honglei Wang <jameshongleiwang@126.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/189] sched_ext: switch class when preempted by higher priority scheduler
Date: Wed, 15 Jan 2025 11:36:45 +0100
Message-ID: <20250115103610.800160691@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honglei Wang <jameshongleiwang@126.com>

[ Upstream commit 68e449d849fd50bd5e61d8bd32b3458dbd3a3df6 ]

ops.cpu_release() function, if defined, must be invoked when preempted by
a higher priority scheduler class task. This scenario was skipped in
commit f422316d7466 ("sched_ext: Remove switch_class_scx()"). Let's fix
it.

Fixes: f422316d7466 ("sched_ext: Remove switch_class_scx()")
Signed-off-by: Honglei Wang <jameshongleiwang@126.com>
Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 81235942555a..f3ca1a88375c 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -2917,7 +2917,7 @@ static void put_prev_task_scx(struct rq *rq, struct task_struct *p,
 		 */
 		if (p->scx.slice && !scx_rq_bypassing(rq)) {
 			dispatch_enqueue(&rq->scx.local_dsq, p, SCX_ENQ_HEAD);
-			return;
+			goto switch_class;
 		}
 
 		/*
@@ -2934,6 +2934,7 @@ static void put_prev_task_scx(struct rq *rq, struct task_struct *p,
 		}
 	}
 
+switch_class:
 	if (next && next->sched_class != &ext_sched_class)
 		switch_class(rq, next);
 }
-- 
2.39.5



