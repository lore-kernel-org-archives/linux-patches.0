Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352F3346772
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302097; cv=none; b=NDGV1cJ3sTAwEQHUHtO+GN/+E1QqiRgbedDL6dffVf3JLRScExTOp2S4tqQQvPauJn7F9Y2FN2WZ3O/a+F+myGfa/LEhK8rJe4fBx4KMtjWXplF146Zhe+G1K/mU1HnIDdISO1AxjvZJT/sNaM5isFSnRz1RiSHtDD1SHGpPcy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302097; c=relaxed/simple;
	bh=sjm05H9xFQ/BRAoPYkiY8fHh8kkMP8Z6XIV+2iJ+T6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOskQ7YacFtBqbS09/WuPW43WAxCr6d1J6A6u+o7l9faOYYtMniDPUwL9r8n5S72VwQX+Qs9WfM472lJGQJFcQi7BFvlj8bT4EgO7yrUgSNXFDwlSGLxjNwyoegFOShCigRd4bAMAwyBM1lc/mLqL82SSvOPRvIbBzXG0fLE0uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nL28pHYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nL28pHYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91911C19425;
	Sat, 28 Feb 2026 18:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302097;
	bh=sjm05H9xFQ/BRAoPYkiY8fHh8kkMP8Z6XIV+2iJ+T6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nL28pHYVJ8Vjr5UwP5mGYy+6udyTeVIu8Q7lqoOrmleVCST6iyDlOO6G1Vj2wRA16
	 k/0pvZst5JWWOaNu+7iMp8U41IBml/2657HqQFOzOagSGUMC5F69eFNF/bSkgjLAQ1
	 DrN81vo8DXsu6n+3SMelxMyUAosvwnMCMr2wyhEMR6Jsar3Bf9PO5hoxtNSPbTYkkz
	 x//j8naMD2V/0zn/AR5BEM0Fq01+NGZmxoqF6VheHD1XbIqv/brgF8rvZfJWwQNtil
	 Z2NCzPFkMM6ovzzfdLkZH158YVn0R9TFyd3iAxlA69WHHwmnvo2qWvChYu5P4Ev8oZ
	 33qX11jXRdBIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/283] workqueue: Only assign rescuer work when really needed
Date: Sat, 28 Feb 2026 13:03:44 -0500
Message-ID: <20260228180709.1583486-82-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

[ Upstream commit 7b05c90b3302cf3d830dfa6f8961376bcaf43b94 ]

If the pwq does not need rescue (normal workers have been created or
become available), the rescuer can immediately move on to other stalled
pwqs.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: e5a30c303b07 ("workqueue: Process rescuer work items one-by-one using a cursor")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9127d74643fef..181f97d70296f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2813,6 +2813,10 @@ static bool assign_rescuer_work(struct pool_workqueue *pwq, struct worker *rescu
 	struct worker_pool *pool = pwq->pool;
 	struct work_struct *work, *n;
 
+	/* need rescue? */
+	if (!pwq->nr_active || !need_to_create_worker(pool))
+		return false;
+
 	/*
 	 * Slurp in all works issued via this workqueue and
 	 * process'em.
-- 
2.51.0

