Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282E23D1CC6;
	Wed, 20 May 2026 18:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301735; cv=none; b=BKTB3FAmOE/jY1ruhAw4XqdCcMTYwxZV8dMdgGQGgpgfImpYuEWQCPQw1UBmE7qslB43BOMtOhTKObskUMqWhc5h1G3gcpM9LD5H0Ur2Nl0PdXKxLdeANwLtRPWZ168INJLunFHsZgbHS0S4WMVejspvJiWciYKj28Q6vzuc7P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301735; c=relaxed/simple;
	bh=d8UZa0kKG+VsqoujEGTrh4op+mgODuzirfZGBbgUnps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lA42ar0n5pJ8ah+uMbARdRoLF9srZT1lIV1OKB2iTlY1I3wF9pd1ciNB/8D4vsVvVg9tPnBdJRN0yTO86C6HKHnrm+O0mCog8JNcled2cp4h1r/t/NjCqh8CdTJwb64u2II8r8pgUbk1uukLRT/Yhft4V055FmaaFOsXLp8QT6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulY1UbPD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulY1UbPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE7E1F000E9;
	Wed, 20 May 2026 18:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301734;
	bh=yFBv5OL5+3GB+Wn3a2OBpb8ALiJq9nLQmBNOahhesvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulY1UbPDlnweFqNew8zQydf9S12FJg9fzvNMmLjf2QsIwUCRuUxRtwaDgoZjdPSbL
	 MG1Wz3oVfhQLTYeqi4DzIteblepl0ixeYnvHMVfK7aR2ONIjOaWAYAi+Vom1QBi7fF
	 2I0SAAP4BRAf2EzAEQkf9sPeTKAcvzOe9YN/a7ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 656/666] sched_ext: Guard scx_dsq_move() against NULL kit->dsq after failed iter_new
Date: Wed, 20 May 2026 18:24:27 +0200
Message-ID: <20260520162125.504155804@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 4fda9f0e7c950da4fe03cedeb2ac818edf5d03e9 ]

bpf_iter_scx_dsq_new() clears kit->dsq on failure and
bpf_iter_scx_dsq_{next,destroy}() guard against that. scx_dsq_move() doesn't -
it dereferences kit->dsq immediately, so a BPF program that calls
scx_bpf_dsq_move[_vtime]() after a failed iter_new oopses the kernel.

Return false if kit->dsq is NULL.

Fixes: 4c30f5ce4f7a ("sched_ext: Implement scx_bpf_dispatch[_vtime]_from_dsq()")
Cc: stable@vger.kernel.org # v6.12+
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
[ dropped the `struct scx_sched *sch` declaration and `sch = src_dsq->sched` line ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -6346,6 +6346,14 @@ static bool scx_dispatch_from_dsq(struct
 	bool in_balance;
 	unsigned long flags;
 
+	/*
+	 * The verifier considers an iterator slot initialized on any
+	 * KF_ITER_NEW return, so a BPF program may legally reach here after
+	 * bpf_iter_scx_dsq_new() failed and left @kit->dsq NULL.
+	 */
+	if (unlikely(!src_dsq))
+		return false;
+
 	if (!scx_kf_allowed_if_unlocked() && !scx_kf_allowed(SCX_KF_DISPATCH))
 		return false;
 


