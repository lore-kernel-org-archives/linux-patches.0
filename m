Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A4635AC18;
	Wed, 20 May 2026 17:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297589; cv=none; b=Fumvj0BrEgeAqnvh/79Dzq5tEtUOopMSx7EDsiBl3o1CcEZQjAwja3yz1Mnje5XxW1KSa8IDScO+YTNCB/xEQuHA7ixBw8eDZVJaFowpN18Mbzl6nMDr5xWv0EBuPXxXIy2R0S7Q99iy+2pruMmFFT0ad9r4Ei3c75zjk4taO6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297589; c=relaxed/simple;
	bh=bsr/NH7rgpLPs3TtnMHFQPagfKME4KAmTy3V5wpJc2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+L3V5ZeYwjqYJ2UavBCFanK+EMPpN3/1mk+yVQFXJ2btKTJe98RvIbAWKqfcN/fO9VXGxbNue8W9VVrqNTSbMNZPYy//sx7i7XcKHRlCAaafNgFQAKVIYnfDLZjD2F8xCXsPGM5CSSgfysBIsy+MFy+UTW/ngsgZO6XfKcrCJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ARk+s0Ys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ARk+s0Ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319461F000E9;
	Wed, 20 May 2026 17:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297587;
	bh=VSVtDNZdw1aoC9Gk6avhUoPde6frFXUyscZg45SBeIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARk+s0YsDRZkfniEZ/XMshGbZP9WYCcG4OwAIisz8aDMmwFf8p9lEfRX3dig3KYVF
	 B9aoWoOUiCWhaJLHff8/IhtYgrB2AuxO7GngC0iuq8B7r8aoTlfmwjNaf75xsTBmNJ
	 CWuJA3BvFefoZpw3a5brOVox8SpMpw08AMT+PYdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Chen Yu <yu.c.chen@intel.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 046/957] sched/topology: Fix sched_domain_span()
Date: Wed, 20 May 2026 18:08:49 +0200
Message-ID: <20260520162135.557884097@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e379dce8af11d8d6040b4348316a499bfd174bfb ]

Commit 8e8e23dea43e ("sched/topology: Compute sd_weight considering
cpuset partitions") ends up relying on the fact that structure
initialization should not touch the flexible array.

However, the official GCC specification for "Arrays of Length Zero"
[*] says:

  Although the size of a zero-length array is zero, an array member of
  this kind may increase the size of the enclosing type as a result of
  tail padding.

Additionally, structure initialization will zero tail padding. With
the end result that since offsetof(*type, member) < sizeof(*type),
array initialization will clobber the flex array.

Luckily, the way flexible array sizes are calculated is:

  sizeof(*type) + count * sizeof(*type->member)

This means we have the complete size of the flex array *outside* of
sizeof(*type), so use that instead of relying on the broken flex array
definition.

[*] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html

Fixes: 8e8e23dea43e ("sched/topology: Compute sd_weight considering cpuset partitions")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Debugged-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260323093627.GY3738010@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/topology.h | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index 45c0022b91ced..6f8a4ae860da8 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -141,18 +141,30 @@ struct sched_domain {
 
 	unsigned int span_weight;
 	/*
-	 * Span of all CPUs in this domain.
+	 * See sched_domain_span(), on why flex arrays are broken.
 	 *
-	 * NOTE: this field is variable length. (Allocated dynamically
-	 * by attaching extra space to the end of the structure,
-	 * depending on how many CPUs the kernel has booted up with)
-	 */
 	unsigned long span[];
+	 */
 };
 
 static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
 {
-	return to_cpumask(sd->span);
+	/*
+	 * Turns out that C flexible arrays are fundamentally broken since it
+	 * is allowed for offsetof(*sd, span) < sizeof(*sd), this means that
+	 * structure initialzation *sd = { ... }; which writes every byte
+	 * inside sizeof(*type), will over-write the start of the flexible
+	 * array.
+	 *
+	 * Luckily, the way we allocate sched_domain is by:
+	 *
+	 *   sizeof(*sd) + cpumask_size()
+	 *
+	 * this means that we have sufficient space for the whole flex array
+	 * *outside* of sizeof(*sd). So use that, and avoid using sd->span.
+	 */
+	unsigned long *bitmap = (void *)sd + sizeof(*sd);
+	return to_cpumask(bitmap);
 }
 
 extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
-- 
2.53.0



