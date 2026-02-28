Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B404344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301735; cv=none; b=U+58eerky0VgEZ+3mxvzWscA5OAVRn0wcc+stTVntS4QYXkpCNVvaTb2lo6pY+e+OXS++TCJO2uY8y89Jk/P9OHAqH/3deaCMm9ylP+KHfPA3hV1jHU7Jw7TCCpvwKfCKU4+kg+A5KZeTalTfoZ5G2k3eQiuv4dDiyGH5UUitK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301735; c=relaxed/simple;
	bh=ipUczcXn9re+kdG/SxtEzOf7d/1T75v2q6DK19OUG/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBeJn6KB7UuZkUtpWE81g1KfuZ4QALoPqfH1pwP0AR8lxV3ZR5ut7x9AiYu7gxPmZGeh9ULgzhlCSBAJVcxbHKu6pFRUkb/V72MUCl1/r0Xxmhb6JFFJdjZaovdjD380geYxGl0iJdMWW41utl+gVLflmLuBzoOlU6nTWq4nArc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbw89f7H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbw89f7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB4FC19424;
	Sat, 28 Feb 2026 18:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301735;
	bh=ipUczcXn9re+kdG/SxtEzOf7d/1T75v2q6DK19OUG/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbw89f7Hx9isQ8MYyI9Nzq5ltfbCPKOAd3Retdd+ABluJs4Ke/H2YtZsEB79gFEGH
	 L2/PNnGaCkx5kyHn515skIVZQ/GFXIaIK99guk9KidfjGbiFhrU5/6QDnDRHkCmWpm
	 UsNVYCQGUgUJT7qz9bSs05UbIagFOQHH6DlEoDlwuw3LGEU0Ulzg0Rd5g8cxCx64Qk
	 ORHmYKktiu77Yoe+XCPvLrzExGMcmwC3m5pPjl2+DY8wX2+7He2fQnfF2jKFjwOK/1
	 sfdhjahFjPqSySLZsu9qcNvEDZlJW9l1RMrVfRA+L2lXfLnxzdBocUUwWZ7BhLQxdg
	 HPm3fKqRCy9GA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/385] workqueue: Only assign rescuer work when really needed
Date: Sat, 28 Feb 2026 12:55:57 -0500
Message-ID: <20260228180011.1568201-135-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 256d91aff181d..162b661057330 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3412,6 +3412,10 @@ static bool assign_rescuer_work(struct pool_workqueue *pwq, struct worker *rescu
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

