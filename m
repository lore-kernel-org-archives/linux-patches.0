Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2F6328B77;
	Mon, 27 Oct 2025 19:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592821; cv=none; b=NDz6twjT7iJ123FnfmSLrgpLZcgpo5+BgRKxnptP+/aiuzzuSBf/aNIkH1NDDeoCDJkz5IT4FgJUE9iJ3RX25F8Cbv2fdSMxfE7Ayjxh0J5xArtr2LCe5cyBnEwMsmcyh8PJ8p37M09jX9D4P3fpluIn7DjCAW6ofltUZIwGVV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592821; c=relaxed/simple;
	bh=WAQ/zXruu2dh4HPozWe16gIZ/iEFmzYUM5YBm1GJemo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVQsUMdj2VYfzr4GokcQxUA/cQbmnH6bjw1iwxOue8r5hU90P3vTx+lPQvEC5linTpw+mAx2gU13U5CzmhZXyqQCJlYUQ1RyJA/02Z34XSfR2jJOakXO5bXWXzQY7YaHJZHt74Dh083R4F0az30vhKw73ujKmTdPhBkS+EHQScc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XuQGenbX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XuQGenbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC23C4CEF1;
	Mon, 27 Oct 2025 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592821;
	bh=WAQ/zXruu2dh4HPozWe16gIZ/iEFmzYUM5YBm1GJemo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XuQGenbXPE3my9x+cSFcs15rJP58WaTeguRh2xd6CqoevvTwvH6fIAc0W3wwLNZOo
	 oY5Y0zQeEJO1dqC2x0PNdOGCun5EPA0FvQTGJW4yENOUVu3DtAekuBU84Dn8ZcWC1A
	 VWfQU6QOv4gIBUW9F2SdC/PceQYIA+Sou6zxBkco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Crudup <kenneth.crudup@gmail.com>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/117] PM: EM: Fix late boot with holes in CPU topology
Date: Mon, 27 Oct 2025 19:35:50 +0100
Message-ID: <20251027183454.618014172@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 1ebe8f7e782523e62cd1fa8237f7afba5d1dae83 ]

Commit e3f1164fc9ee ("PM: EM: Support late CPUs booting and capacity
adjustment") added a mechanism to handle CPUs that come up late by
retrying when any of the `cpufreq_cpu_get()` call fails.

However, if there are holes in the CPU topology (offline CPUs, e.g.
nosmt), the first missing CPU causes the loop to break, preventing
subsequent online CPUs from being updated.

Instead of aborting on the first missing CPU policy, loop through all
and retry if any were missing.

Fixes: e3f1164fc9ee ("PM: EM: Support late CPUs booting and capacity adjustment")
Suggested-by: Kenneth Crudup <kenneth.crudup@gmail.com>
Reported-by: Kenneth Crudup <kenneth.crudup@gmail.com>
Link: https://lore.kernel.org/linux-pm/40212796-734c-4140-8a85-854f72b8144d@panix.com/
Cc: 6.9+ <stable@vger.kernel.org> # 6.9+
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20250831214357.2020076-1-christian.loehle@arm.com
[ rjw: Drop the new pr_debug() message which is not very useful ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/energy_model.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -755,7 +755,7 @@ static void em_adjust_new_capacity(unsig
 static void em_check_capacity_update(void)
 {
 	cpumask_var_t cpu_done_mask;
-	int cpu;
+	int cpu, failed_cpus = 0;
 
 	if (!zalloc_cpumask_var(&cpu_done_mask, GFP_KERNEL)) {
 		pr_warn("no free memory\n");
@@ -773,10 +773,8 @@ static void em_check_capacity_update(voi
 
 		policy = cpufreq_cpu_get(cpu);
 		if (!policy) {
-			pr_debug("Accessing cpu%d policy failed\n", cpu);
-			schedule_delayed_work(&em_update_work,
-					      msecs_to_jiffies(1000));
-			break;
+			failed_cpus++;
+			continue;
 		}
 		cpufreq_cpu_put(policy);
 
@@ -791,6 +789,9 @@ static void em_check_capacity_update(voi
 		em_adjust_new_capacity(cpu, dev, pd);
 	}
 
+	if (failed_cpus)
+		schedule_delayed_work(&em_update_work, msecs_to_jiffies(1000));
+
 	free_cpumask_var(cpu_done_mask);
 }
 


