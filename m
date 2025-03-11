Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF6525E83F;
	Tue, 11 Mar 2025 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707111; cv=none; b=py9bK6stPRm/ZbUG6M+cADMF42aiSaC1A1Mm1rcu9EHRwHMdEIGahfP3yWz4gsqJTvcUxIKxGPnatrFT9LxTGaAcGZX6fzMXbeOPsKbAivbpJwhC5VbZmMVFDgc4zUIAXr/MCKX6k1bgjxy++80vEZp7l2nZiDlayAJe4klJ15o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707111; c=relaxed/simple;
	bh=nJJx84pIg1EefgjoGX+YbswZLVsoekO6dr+uKUL1MwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dF7J8F4uaFDSQ02e3yuEWD9FcIqA/IT/M5l52bI6RAA8eDAgt9fjR0DcjteAiHEYOjKNC5CT/SaaReAeivcdIbwPBESDneKkRFNCe1oMwP1XA9Q7/LCy//d+u4U511T2FvWiH8THPhHc4xzEb8T4wh8rWxbWJ0WypV3GiK+eRCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vtE+oeg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vtE+oeg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EF4C4CEE9;
	Tue, 11 Mar 2025 15:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707111;
	bh=nJJx84pIg1EefgjoGX+YbswZLVsoekO6dr+uKUL1MwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vtE+oeg1PvKQrm+ryMrb32J6l0LFDzSZV0NzO7Bx+yI6BGosSCRpUhKcVN6Tg0G9/
	 w43yU/v84/P/nRqV79Z5UvHnxPRo8P36SYoBgHiOi4XvtJXjLzBPhGRKDdCULwqYKu
	 SEechokxaCa1uygfBlAt997jQj/MRUS/hKKFjHuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <yury.norov@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/462] clocksource: Replace cpumask_weight() with cpumask_empty()
Date: Tue, 11 Mar 2025 15:59:02 +0100
Message-ID: <20250311145809.269877729@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yury Norov <yury.norov@gmail.com>

[ Upstream commit 8afbcaf8690dac19ebf570a4e4fef9c59c75bf8e ]

clocksource_verify_percpu() calls cpumask_weight() to check if any bit of a
given cpumask is set.

This can be done more efficiently with cpumask_empty() because
cpumask_empty() stops traversing the cpumask as soon as it finds first set
bit, while cpumask_weight() counts all bits unconditionally.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20220210224933.379149-24-yury.norov@gmail.com
Stable-dep-of: 6bb05a33337b ("clocksource: Use migrate_disable() to avoid calling get_random_u32() in atomic context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/clocksource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e44fb1e12a281..658b90755dd72 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -338,7 +338,7 @@ static void clocksource_verify_percpu(struct clocksource *cs)
 	cpus_read_lock();
 	preempt_disable();
 	clocksource_verify_choose_cpus();
-	if (cpumask_weight(&cpus_chosen) == 0) {
+	if (cpumask_empty(&cpus_chosen)) {
 		preempt_enable();
 		cpus_read_unlock();
 		pr_warn("Not enough CPUs to check clocksource '%s'.\n", cs->name);
-- 
2.39.5



