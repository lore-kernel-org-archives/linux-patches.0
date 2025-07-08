Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDB12045B5;
	Tue,  8 Jul 2025 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993134; cv=none; b=FpV4q7xxy30DJIYN652/IKp4v0pmheqHNLvaCekpAjBJf1whJ5eUz5Ad/1q9be018r1tSWjwg6eCw2uKEKxDLB4hu2vl6RAvi+iXe4OOXt0DjKqo1HxVCMpU/tA1u0rkLCBx6U0XchSvVthS4Xq4+7rdFg2Hhj3qIgK9vk7HngE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993134; c=relaxed/simple;
	bh=/+LLy9603YYyOztqkzIvFGeQL/zGD/rnlXLuygDIrLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MOLDfO45ygs0b63nEffSk8qFUhO/F9j9owu5d11WMwpz2/DtCnKVBPxY7YZgGuJcGSaoYtpYUIQKOmwQqa+3hyeK+k7K3NnmlBknuFvjqD9HTd3CCIzerU3THEnC0ANMCHEnK9iFSUp8KkqviDfoya/5FGhMXRbGRFv0/zVSeaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iz0KyPdQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iz0KyPdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289FAC4CEED;
	Tue,  8 Jul 2025 16:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993134;
	bh=/+LLy9603YYyOztqkzIvFGeQL/zGD/rnlXLuygDIrLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iz0KyPdQfZzckKixvf856ktFPkZz8e1meVoGXRLg4fR8ca5WOj+2YPNQStmCUFunb
	 uUS9rjgfZ23o56QzImDvzs5BvzoSDLHo+puggT6CFuD7x4qzQvPy9GNQIpsSXe2oBu
	 dFZwIDqL6Qfk26lJZ25Sn233h6ogb3sxco6d8gvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/232] sched_ext: Make scx_group_set_weight() always update tg->scx.weight
Date: Tue,  8 Jul 2025 18:22:45 +0200
Message-ID: <20250708162245.860467274@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit c50784e99f0e7199cdb12dbddf02229b102744ef ]

Otherwise, tg->scx.weight can go out of sync while scx_cgroup is not enabled
and ops.cgroup_init() may be called with a stale weight value.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 819513666966 ("sched_ext: Add cgroup support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index ddd4fa785264e..c801dd20c63d9 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4058,12 +4058,12 @@ void scx_group_set_weight(struct task_group *tg, unsigned long weight)
 {
 	percpu_down_read(&scx_cgroup_rwsem);
 
-	if (scx_cgroup_enabled && tg->scx_weight != weight) {
-		if (SCX_HAS_OP(cgroup_set_weight))
-			SCX_CALL_OP(SCX_KF_UNLOCKED, cgroup_set_weight,
-				    tg_cgrp(tg), weight);
-		tg->scx_weight = weight;
-	}
+	if (scx_cgroup_enabled && SCX_HAS_OP(cgroup_set_weight) &&
+	    tg->scx_weight != weight)
+		SCX_CALL_OP(SCX_KF_UNLOCKED, cgroup_set_weight,
+			    tg_cgrp(tg), weight);
+
+	tg->scx_weight = weight;
 
 	percpu_up_read(&scx_cgroup_rwsem);
 }
-- 
2.39.5



