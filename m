Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E5D2676FA;
	Tue,  8 Apr 2025 12:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115884; cv=none; b=Zjg1hq9xWREKk5/c2c3ehkJefRjB0xYbQLNecQ/v4PsF9+owqR8G/94ztzatKKObNAwNKrA81PqBp3nSeX/2tnANtXcQKmnvEgfp3qUvIdNDb1p6W7ruNhysQyOhAX6oEQ789ulZ+er8riLdpN08DMSjXVdBTyIZjhPCf5DQ7ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115884; c=relaxed/simple;
	bh=r9F65B0HjCEiADnAnfR0WtfT8RO56NEJrFqlNDkQRpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrVPpei8R9ec2WN6tcN8yZGxcVj2YzmfQ6x9Ys9pEwBPjK8+0DVlSeFNc0rkByTaUZ1BYsFr3LCnYMLn9OABox+kUen+SdNSeckZtjTmuJKvE780PEHnFEj5K/LOgpa9JLVOrvrTG5nJ0Kn0NU8PpBkgkKT02V2KqDFZepyN+zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1w55cEI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1w55cEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DD1C4CEE7;
	Tue,  8 Apr 2025 12:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115884;
	bh=r9F65B0HjCEiADnAnfR0WtfT8RO56NEJrFqlNDkQRpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1w55cEIVfOmvD6MbdmdlO/f7KGT98L4jErvivZ13QU4twl5yJXH9TYqSVuMibvTZ
	 59l5dxcgQtjLfmlZWfGy5O/2R4j6999EffH0meeB8+KeXEVpsc6f3+oHXaajRVzHiG
	 6fk8YK89S6U7V1rA7FedaSacUQWias3XZzU5GNIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Ingo Molnar <mingo@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/204] sched/deadline: Use online cpus for validating runtime
Date: Tue,  8 Apr 2025 12:51:10 +0200
Message-ID: <20250408104824.403850204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 389290e950bea..7f378fa0b6ed3 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2762,7 +2762,7 @@ int sched_dl_global_validate(void)
 	 * value smaller than the currently allocated bandwidth in
 	 * any of the root_domains.
 	 */
-	for_each_possible_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		rcu_read_lock_sched();
 
 		if (dl_bw_visited(cpu, gen))
-- 
2.39.5



