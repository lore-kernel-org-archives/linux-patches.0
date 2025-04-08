Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776F328137C;
	Tue,  8 Apr 2025 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116827; cv=none; b=Xzo8ji0jZufA0zBh4vaIcs2jZXTyAabXJ5o1TmHzHEAbum0NVwoOGpXFMFpmI+QE3OwHVIXxx5fENoiWuWcfzotxVoZtSYSWGHEnpLSEIO9yYGwE9+S4anFJc79FusqVp6TSuWIYc4Q0G9c2mkfqbnBUbw9ZepZ0b0wpEm+GM34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116827; c=relaxed/simple;
	bh=+MvRtiy4KxyfItYVfsMeZwjOhxW0bj2kGKcbYGes5v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrzK9reSMeQpeRuV4ZdWLlRe3ZKJgfolDSOswCC0mQ0XKiIp9EhzjeGCgUvjinxHBY29lHhTobhuStCAZ22/Va979RiKuZIjsAuTYrFATjZoVy/8Y/Tr2kvSEx/htMGVZbMFECZifb3+prbCahIiLkIXni20kdhNqEi1/GjhKwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGm7mOhL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGm7mOhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3002C4CEE7;
	Tue,  8 Apr 2025 12:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116827;
	bh=+MvRtiy4KxyfItYVfsMeZwjOhxW0bj2kGKcbYGes5v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGm7mOhLpouQHT3kv5ovCLrtpZbD9rw/ukrenKpaN8P5J6QfWnzYmRXNtg2fBYkKn
	 +OXO6df38OlxwoJyTl7NRQa6EkBojg3SrgcyRww8SnynVburxJMWGyLQZhQC48DtP7
	 /FkYEIyUY+Xj4jyo27VxfPikwmm9ycfOGD6r8u84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/423] sched/deadline: Use online cpus for validating runtime
Date: Tue,  8 Apr 2025 12:50:09 +0200
Message-ID: <20250408104852.368734193@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Shrikanth Hegde <sshegde@linux.ibm.com>

[ Upstream commit 14672f059d83f591afb2ee1fff56858efe055e5a ]

The ftrace selftest reported a failure because writing -1 to
sched_rt_runtime_us returns -EBUSY. This happens when the possible
CPUs are different from active CPUs.

Active CPUs are part of one root domain, while remaining CPUs are part
of def_root_domain. Since active cpumask is being used, this results in
cpus=0 when a non active CPUs is used in the loop.

Fix it by looping over the online CPUs instead for validating the
bandwidth calculations.

Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/r/20250306052954.452005-2-sshegde@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index a17c23b53049c..5e7ae404c8d2a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3179,7 +3179,7 @@ int sched_dl_global_validate(void)
 	 * value smaller than the currently allocated bandwidth in
 	 * any of the root_domains.
 	 */
-	for_each_possible_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		rcu_read_lock_sched();
 
 		if (dl_bw_visited(cpu, gen))
-- 
2.39.5



