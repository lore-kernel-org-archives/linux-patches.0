Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC4C3016E1;
	Sat, 30 May 2026 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161043; cv=none; b=OVp0yMlLnqFYbRU938Qh0k9/4QGTIIjdfIr8P4MMpXhA4gYaEpAecVhSSTfCu0SuATNlzVLNJbVxqtks5VrGcauA3htvbZ0EkwUDxeCBOz9suMajQ3goGC75IAeGhx3STj1NjomHCjdh+RXGbA3Bx7pEF9k4Xd1PMJbVBSU5DS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161043; c=relaxed/simple;
	bh=dKCaGzy1SOrJM0qvHnLdPRyBD71gnvq7xe6VGLTwEgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAKorIhMYJ0edLfkiEVxc27Z4GZgFpicM2xZN8Bib7aFnT81UQrmRC2uLlk9PdWTnmzdPeFWTNFPX/Vl3ZbXVyG9tjABRqI5EvXYj0kH1MzDfD383FUwv2XheehFmqSBC8oDNNRKSwaEySXru2Jj0rtId7leecAqVMVTHVWRN6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0U/TS9oo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0U/TS9oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B07E1F00893;
	Sat, 30 May 2026 17:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161042;
	bh=Uc3/MBS9DNBRThmdLByuK5eX/OKVtbMCtvMrmm9R9rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0U/TS9oood31BV+h4Hf8jPJDlfrz6VSZnTnms4BP46Q3VJcpJNobZypAkgtGFQ1/C
	 r13MsquVvpWN2xpRDfuXHaN3JTUujtwnDhv2Zi+bpldZ02sFdWre9GQ7h9y/N9DWUt
	 A98yka/whxYxVas/h69I4RHEUv2vKax2AWBR0w+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuyi Zhou <zhouchuyi@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 509/969] padata: Remove cpu online check from cpu add and removal
Date: Sat, 30 May 2026 18:00:33 +0200
Message-ID: <20260530160314.387322443@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 93e288dc373ee..d4298c0c747ce 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -737,32 +737,22 @@ EXPORT_SYMBOL(padata_set_cpumask);
 
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



