Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165C1263C83;
	Tue,  8 Apr 2025 11:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113495; cv=none; b=Fr4ippbdf1UG20sh7iru03GV7PLSmHQLQNr1RXoVmj7MwsO3yBHM9yPiIy3vCVd4juG1WKIrtSWS0y6UO+8jK1ghNssYJNugkVKiWtLyeLfpSGSRUkD1jIgu/ZVOmTZULcLlF3TMncnronw3KjF9aE3Cj1ztiroj9F3GxfBEIvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113495; c=relaxed/simple;
	bh=RgqUUKu4Oyvvu84y6QpGT7qbXEXaotzSBTfN5y2GNjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bY7FcT0chxQsqQX2760M/KDayo/4O6yaHg4hOPu1MLXRNkvgTlPac4tJggdF2U0aoN0pfYTTR/dmt/jsS7/8lQAODW9HT0l5vaUA9TTWxn9YKWSJKYYC5+VbYEXYmZ2JTG8nlfZLwuT2lczzwsNqe3ECtfmMQY8VDjcSZXIvjHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMeFkaZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMeFkaZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B54C4CEE5;
	Tue,  8 Apr 2025 11:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113494;
	bh=RgqUUKu4Oyvvu84y6QpGT7qbXEXaotzSBTfN5y2GNjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMeFkaZ4J5pfzlQHMIgzCBoBpBbLIHpuzbD9XwcOV/MYMmOZngSRUcXpPYAWYPcnK
	 yXnknT39O22N2bUUQpCOrEbnyHDWCy7/mQ8qE0+LAsd+lJt50Tn5L95A1Hna3C5g47
	 L2q0QI3hX6oldfs+sXQz2KIZQbkFdMC1slXusnkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/268] sched/deadline: Use online cpus for validating runtime
Date: Tue,  8 Apr 2025 12:49:50 +0200
Message-ID: <20250408104833.370701578@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b9e99bc3b1cf2..6c639e48e49a9 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2780,7 +2780,7 @@ int sched_dl_global_validate(void)
 	 * value smaller than the currently allocated bandwidth in
 	 * any of the root_domains.
 	 */
-	for_each_possible_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		rcu_read_lock_sched();
 
 		if (dl_bw_visited(cpu, gen))
-- 
2.39.5



