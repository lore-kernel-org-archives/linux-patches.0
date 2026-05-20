Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A758371CEA;
	Wed, 20 May 2026 18:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300402; cv=none; b=kk3MC2om8biXb/sHEcXu8BbYFrnfn/K5KMDmWcMwhngcNNPnPliLZ39IiwnDm8kID3VcC15VtlMRdYSidVpQVm1nU5oyaEEQRUgSt/7b07q0v5oHiT0ZvAWZFPoIyXX62ua5IFW0Ra/nsG9B8CkJwDVIce5FWmi+uUK8UokAJU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300402; c=relaxed/simple;
	bh=EO/80FK3EufDJ06+ziiIOjLFXUek7SI0SKdJISSowtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgqbPzQV0gu1KYu2dLepB/Tg7p86SRlKBNb/U6NmpA2WcthntHu788nQqYSya+7JOy41kQsskFY9fTh0hhfybqVswnzXipLQ8CTBLgeBE/c3cFS5Ii2iblsFPyMq7tRIdLdWRXSOC6FVvwesFuKZPAFePStLhzA3dNkD992d2qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQX3ZiZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQX3ZiZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC001F000E9;
	Wed, 20 May 2026 18:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300401;
	bh=jBDMyDmIPZI4IPMJ3hOpdF3YSEDzaGt/9vf6o0HarW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQX3ZiZmuzYQQ3OB06S2AY4jFNNPWf0QbX2wgw/wKDmcarad3NxxKPZIuuuVYxwkZ
	 D9o3EQrNIA3dbzUJjtmKFLHh0Waff1m2ySaR2iv5msil1XViFoIzwVObikt050Var8
	 eqZ7DU3vkGQFolxbG9ahfZQzvP1I5dXt/Z8439i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuyi Zhou <zhouchuyi@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/666] padata: Remove cpu online check from cpu add and removal
Date: Wed, 20 May 2026 18:16:10 +0200
Message-ID: <20260520162114.654025359@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Chuyi Zhou <zhouchuyi@bytedance.com>

[ Upstream commit 73117ea6470dca787f70f33c001f9faf437a1c0b ]

During the CPU offline process, the dying CPU is cleared from the
cpu_online_mask in takedown_cpu(). After this step, various CPUHP_*_DEAD
callbacks are executed to perform cleanup jobs for the dead CPU, so this
cpu online check in padata_cpu_dead() is unnecessary.

Similarly, when executing padata_cpu_online() during the
CPUHP_AP_ONLINE_DYN phase, the CPU has already been set in the
cpu_online_mask, the action even occurs earlier than the
CPUHP_AP_ONLINE_IDLE stage.

Remove this unnecessary cpu online check in __padata_add_cpu() and
__padata_remove_cpu().

Signed-off-by: Chuyi Zhou <zhouchuyi@bytedance.com>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: c8c4a2972f83 ("padata: Put CPU offline callback in ONLINE section to allow failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index e61bdc248551f..af10aff28ff68 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -755,32 +755,22 @@ EXPORT_SYMBOL(padata_set_cpumask);
 
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
-	int err = 0;
-
-	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
-		err = padata_replace(pinst);
+	int err = padata_replace(pinst);
 
-		if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
-		    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-			__padata_start(pinst);
-	}
+	if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
+	    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
+		__padata_start(pinst);
 
 	return err;
 }
 
 static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
-	int err = 0;
-
-	if (!cpumask_test_cpu(cpu, cpu_online_mask)) {
-		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
-		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
-			__padata_stop(pinst);
-
-		err = padata_replace(pinst);
-	}
+	if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
+	    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
+		__padata_stop(pinst);
 
-	return err;
+	return padata_replace(pinst);
 }
 
 static inline int pinst_has_cpu(struct padata_instance *pinst, int cpu)
-- 
2.53.0



