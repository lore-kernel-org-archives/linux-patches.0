Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DCE22424C;
	Tue,  8 Apr 2025 11:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112870; cv=none; b=m8mZ56ZbKaJgORlwq2Bw/Vr+HdqpVibVw4dsMvSLylkfY6aKjLt6op2Q4ow+rmNiR3kynGvEVewDjLJHgI3mkdF2Tl1mRu6abrnc9dIM0ErKuhWAEWyfjkLmQreT7oNIg/OBjU8VIo9S0s9WaRqPvzNs+Nik4rUTF/KgWlMwf5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112870; c=relaxed/simple;
	bh=fBic988iQBNB8M15aAG6C9ToaZ2noUoLpGPqHhCH+VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K77FmixaAPeRUI0crXjfE6HOXPpvMl/tRjGiq4DnO/EXH1U4ErH7y/OEdBVj/r2Qcwwn3h50Jdk5LnbgXW5YYzD0ZC7ei10prHK/OSP4kFE9QjOMyCY0mEfJQYIXhgxLNDR2hT/pciJOUJOuK0mA+P8IfTIV30A8+kALjrP+U3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cf1IYbF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cf1IYbF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA906C4CEE5;
	Tue,  8 Apr 2025 11:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112870;
	bh=fBic988iQBNB8M15aAG6C9ToaZ2noUoLpGPqHhCH+VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cf1IYbF4HW5hvtw/K+jz64Ue4h92yDlrT7FHWfCeqiIP2+sNSna8O/MeRr/prmzcH
	 dN7NaH6DV4FGbkWk+dShLz3Lrp9wpafziETZpq3tadiwuymqkhbC0yhcLxiwFlfQas
	 Dk5v/gUBgEpWzv9Nz2Mg8tVSCzFy9S6KIS/ScKYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/279] sched/deadline: Use online cpus for validating runtime
Date: Tue,  8 Apr 2025 12:50:11 +0200
Message-ID: <20250408104832.526885872@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0a6d6899be5bd..66eb68c59f0bb 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2610,7 +2610,7 @@ int sched_dl_global_validate(void)
 	 * value smaller than the currently allocated bandwidth in
 	 * any of the root_domains.
 	 */
-	for_each_possible_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		rcu_read_lock_sched();
 
 		if (dl_bw_visited(cpu, gen))
-- 
2.39.5



