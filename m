Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90121B5831;
	Tue, 30 Jul 2024 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355041; cv=none; b=jdNgfpigDqqSaMBeh1KRFpUKa+Sse2rrtdzM1ev47zlLL2rDEnsev/tACltG5Im59mkxjK3SLjxEiZwxoQEu3iIbCPDDJWknMAH2oI8obSbDmzX7zzLe6njAvZCDIz0HbACpT7zlegk6xSn4ObP7U7U/wn1JPJdKEm6hBg6OhxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355041; c=relaxed/simple;
	bh=Lx7Mpa9h1DnsYMwWsgpnun6UiW8wEt8Q2uRzTFmmgDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUofJci8OXnyaaIFpn6UER+syg6RwshxWSoNs+tq7JdEsbpoEbcLbXfmK4LNtIL1qE0Z7t7uGyeGDUOnvXKp7TZRJb0Yys/tdOPsoaDlpg+8JymZ9dcWF2cc2j7GF1KebEy2oHG0p7Wq5Q/nfCGKPRP+Uo6kPLuio4SzlpvqdqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDEKbTNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDEKbTNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72D1C32782;
	Tue, 30 Jul 2024 15:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355041;
	bh=Lx7Mpa9h1DnsYMwWsgpnun6UiW8wEt8Q2uRzTFmmgDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDEKbTNJzRi9hmXokaY8H7ZKGTsjDMywOTmcdsKEifzHrODemdz+5JvlIRFDXsF0P
	 87V1GWyiyUnGmBie/vuJCpLPXa3jB55aubIgK9bPeaGWike0ElAw8SY87+9Gk+DyN1
	 +y9KeTZbNkgW2UCyGEOwkFLih6QPcWYnrwXs+Ay8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 014/809] cgroup/cpuset: Optimize isolated partition only generate_sched_domains() calls
Date: Tue, 30 Jul 2024 17:38:10 +0200
Message-ID: <20240730151725.222060259@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 1805c1729f52edaa021288473b09f9c7f74fb1ca ]

If only isolated partitions are being created underneath the cgroup root,
there will only be one sched domain with top_cpuset.effective_cpus. We can
skip the unnecessary sched domains scanning code and save some cycles.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: ccac8e8de99c ("cgroup/cpuset: Fix remote root partition creation problem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index c12b9fdb22a4e..73ab45b04c000 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -964,6 +964,7 @@ static int generate_sched_domains(cpumask_var_t **domains,
 
 	/* Special case for the 99% of systems with one, full, sched domain */
 	if (root_load_balance && !top_cpuset.nr_subparts) {
+single_root_domain:
 		ndoms = 1;
 		doms = alloc_sched_domains(ndoms);
 		if (!doms)
@@ -1022,6 +1023,13 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	}
 	rcu_read_unlock();
 
+	/*
+	 * If there are only isolated partitions underneath the cgroup root,
+	 * we can optimize out unneeded sched domains scanning.
+	 */
+	if (root_load_balance && (csn == 1))
+		goto single_root_domain;
+
 	for (i = 0; i < csn; i++)
 		csa[i]->pn = i;
 	ndoms = csn;
-- 
2.43.0



