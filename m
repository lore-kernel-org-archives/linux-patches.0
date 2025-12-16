Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FADD366570;
	Tue, 16 Dec 2025 12:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887368; cv=none; b=JQMTETV1s8SajhTbjch9591T4DEJpJMpYKjtvQ75UoWP00yLmPoM+gpYx4CUFgeqQk9129UZKKHmzj3OMdZWM5GlmfDP+rDlq5ZaWTItg77HkywlXdVm1Ylp4JwhX6TMjd+6xMssay4TlEGNrOpb24wrjfA0PBjNPINokhmEnWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887368; c=relaxed/simple;
	bh=LIluhzBISfZXtwfNc87dtpFjAYMa16AexsxouggP3Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lODfQ6LW6EQvftZ91uXnL2f1RgRnL5RcoEremz7/UcPC7/ubVjBmQE9NRdZMcNPXsE08yl3joSkxdd/5pzJjIglJt36KIEHNFoZUGuUWEyAQZee+q/ohGIPbMirxsHj2yaJ+034GAVwX27VEywSVVGMptooV1h89FVkPQj5dPXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cpogb4Kq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cpogb4Kq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4853C4CEF1;
	Tue, 16 Dec 2025 12:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887368;
	bh=LIluhzBISfZXtwfNc87dtpFjAYMa16AexsxouggP3Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cpogb4KqoSdFQ6ESAEtKnZDVA066Zj8e4i+4YhF9l7dpWJhCTmiBsITOZP0TWZYSe
	 jHXH5fTPhEuTtQShUhuHeiy46yVuTEiKSXCYR/XVGIUGTb/DmMDiwAlRGGAGTL2dBG
	 nBeMDDmxEYG95pY+X9VxIxAXHDp49hasIwRpvCtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/614] timers/migration: Convert "while" loops to use "for"
Date: Tue, 16 Dec 2025 12:09:02 +0100
Message-ID: <20251216111407.702935511@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 6c181b5667eea3e6564d334443536a5974190e15 ]

Both the "do while" and "while" loops in tmigr_setup_groups() eventually
mimic the behaviour of "for" loops.

Simplify accordingly.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251024132536.39841-2-frederic@kernel.org
Stable-dep-of: 5eb579dfd46b ("timers/migration: Fix imbalanced NUMA trees")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer_migration.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index c0c54dc5314c3..1e371f1fdc86c 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -1642,22 +1642,23 @@ static void tmigr_connect_child_parent(struct tmigr_group *child,
 static int tmigr_setup_groups(unsigned int cpu, unsigned int node)
 {
 	struct tmigr_group *group, *child, **stack;
-	int top = 0, err = 0, i = 0;
+	int i, top = 0, err = 0;
 	struct list_head *lvllist;
 
 	stack = kcalloc(tmigr_hierarchy_levels, sizeof(*stack), GFP_KERNEL);
 	if (!stack)
 		return -ENOMEM;
 
-	do {
+	for (i = 0; i < tmigr_hierarchy_levels; i++) {
 		group = tmigr_get_group(cpu, node, i);
 		if (IS_ERR(group)) {
 			err = PTR_ERR(group);
+			i--;
 			break;
 		}
 
 		top = i;
-		stack[i++] = group;
+		stack[i] = group;
 
 		/*
 		 * When booting only less CPUs of a system than CPUs are
@@ -1667,16 +1668,18 @@ static int tmigr_setup_groups(unsigned int cpu, unsigned int node)
 		 * be different from tmigr_hierarchy_levels, contains only a
 		 * single group.
 		 */
-		if (group->parent || list_is_singular(&tmigr_level_list[i - 1]))
+		if (group->parent || list_is_singular(&tmigr_level_list[i]))
 			break;
+	}
 
-	} while (i < tmigr_hierarchy_levels);
-
-	/* Assert single root */
-	WARN_ON_ONCE(!err && !group->parent && !list_is_singular(&tmigr_level_list[top]));
+	/* Assert single root without parent */
+	if (WARN_ON_ONCE(i >= tmigr_hierarchy_levels))
+		return -EINVAL;
+	if (WARN_ON_ONCE(!err && !group->parent && !list_is_singular(&tmigr_level_list[top])))
+		return -EINVAL;
 
-	while (i > 0) {
-		group = stack[--i];
+	for (; i >= 0; i--) {
+		group = stack[i];
 
 		if (err < 0) {
 			list_del(&group->list);
-- 
2.51.0



