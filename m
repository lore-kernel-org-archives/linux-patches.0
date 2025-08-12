Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071BE2FABFC;
	Tue, 12 Aug 2025 18:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024864; cv=none; b=OLHjugJDflNGTBmUXlPV2LEoz+jfHjXsDTOIRcF4MIAMPSQdCwyhLCgAmbowuMvHnNFAkrgaIH70C0piSpEqexuQKMmcpXHCTAiJaKJAoXiwm4Hg6n4eJCsGgK6RXPEgRfw9odecpX+L9AzrHUWMkPH59b5kta3NVWqL1obhaEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024864; c=relaxed/simple;
	bh=1XVmGCmElCiOPPIZXTlEMEeagWBGKRL0GUBV/3NKP2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lemARlFtaW/Y6BMGvX/OznuNjT6974TYJCBoIp+Q9UP0pu5tCJefIEjkOrMLVIum+8nph9XHWpoiHDD0ucO+QydTRPLuD3cC8KGBbtjIsPCZ8MKBRg/8xmLlnMMIpywUhNmzZgO3bXCQivAFPEPxFZyeK8BbTaVi/VQH9qzqYH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DLydht8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLydht8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EF5C4CEF0;
	Tue, 12 Aug 2025 18:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024863;
	bh=1XVmGCmElCiOPPIZXTlEMEeagWBGKRL0GUBV/3NKP2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLydht8+ksHIGy6UGepaepMbWRNLdK3YzeNt/Iq+ptZcbxcZgZmJmj1LvRpE1dhMn
	 KZOB4flerC6oPKZ7Bp+DzWEFIXP6q1JaD8+C0tjEFPTqNY/RfptsQ23tc5TovR5Oux
	 Ma/T2VUq/ZgEtk+XsN1H5S0JxhIUdE65x8ElAj00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Beata Michalska <beata.michalska@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 500/627] sched/psi: Fix psi_seq initialization
Date: Tue, 12 Aug 2025 19:33:15 +0200
Message-ID: <20250812173447.140930304@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 99b773d720aeea1ef2170dce5fcfa80649e26b78 ]

With the seqcount moved out of the group into a global psi_seq,
re-initializing the seqcount on group creation is causing seqcount
corruption.

Fixes: 570c8efd5eb7 ("sched/psi: Optimize psi_group_change() cpu_clock() usage")
Reported-by: Chris Mason <clm@meta.com>
Suggested-by: Beata Michalska <beata.michalska@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 5f7c023c4cca..3f9f0a39e858 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -172,7 +172,7 @@ struct psi_group psi_system = {
 	.pcpu = &system_group_pcpu,
 };
 
-static DEFINE_PER_CPU(seqcount_t, psi_seq);
+static DEFINE_PER_CPU(seqcount_t, psi_seq) = SEQCNT_ZERO(psi_seq);
 
 static inline void psi_write_begin(int cpu)
 {
@@ -200,11 +200,7 @@ static void poll_timer_fn(struct timer_list *t);
 
 static void group_init(struct psi_group *group)
 {
-	int cpu;
-
 	group->enabled = true;
-	for_each_possible_cpu(cpu)
-		seqcount_init(per_cpu_ptr(&psi_seq, cpu));
 	group->avg_last_update = sched_clock();
 	group->avg_next_update = group->avg_last_update + psi_period;
 	mutex_init(&group->avgs_lock);
-- 
2.39.5



