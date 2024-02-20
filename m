Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9112114A4E6;
	Tue, 20 Feb 2024 21:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463995; cv=none; b=ng2XgvPtmdqiGsMOefGjTqjex7r80D74jbMulp6aRDh+QgDNn8EjiXf8CoS37dV05kJZw+SczswLAFqPbeQqFL8Z944bdRdFe+k36P4JhonDn41Ckwaokj2HR8zfhDEhYWY8h6lQs9qqHaIqZ7il1qplfsxz3p1gWptyVnug/wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463995; c=relaxed/simple;
	bh=5PsApUwjSD+1tVzqkM8JNYNh1cGChn6U5blNyOrjkRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJI8WWK//KrdXj6KVSoVXTXccKye0RKYvYU3QLile7lHmEnXou6uTEFBUczpYpt0e8xYnuVI1RTFoM/g2tG5ycyexoQTldCceUzH7t+c1R4J2T9kw1caY2YL6NXSSwmlrgEU/htBxp/PFNzJjNOgFBgK/yv/+v1axBO901WvQEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmhaZmoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmhaZmoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ABAC433C7;
	Tue, 20 Feb 2024 21:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463995;
	bh=5PsApUwjSD+1tVzqkM8JNYNh1cGChn6U5blNyOrjkRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmhaZmoRqdIvgQAjYGQ6U5UVD6vJzwl5YT1tsrv4N3zJe5nhmzBouxyaEGDC1iwtX
	 RXKcznKcOPWoNy59YpXXBJmx1O0ExCs5z7+mpUT+apg0zZj79N3GKCL2pc4/UbbH3F
	 tQn59Z8KWPZhbGP0Jqab6hd6nCeunLOuZfWdHehM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.6 219/331] arm64/signal: Dont assume that TIF_SVE means we saved SVE state
Date: Tue, 20 Feb 2024 21:55:35 +0100
Message-ID: <20240220205644.619961877@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit 61da7c8e2a602f66be578cbbcebe8638c10e0f48 upstream.

When we are in a syscall we will only save the FPSIMD subset even though
the task still has access to the full register set, and on context switch
we will only remove TIF_SVE when loading the register state. This means
that the signal handling code should not assume that TIF_SVE means that
the register state is stored in SVE format, it should instead check the
format that was recorded during save.

Fixes: 8c845e273104 ("arm64/sve: Leave SVE enabled on syscall if we don't context switch")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240130-arm64-sve-signal-regs-v2-1-9fc6f9502782@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |    2 +-
 arch/arm64/kernel/signal.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1686,7 +1686,7 @@ void fpsimd_preserve_current_state(void)
 void fpsimd_signal_preserve_current_state(void)
 {
 	fpsimd_preserve_current_state();
-	if (test_thread_flag(TIF_SVE))
+	if (current->thread.fp_type == FP_STATE_SVE)
 		sve_to_fpsimd(current);
 }
 
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -242,7 +242,7 @@ static int preserve_sve_context(struct s
 		vl = task_get_sme_vl(current);
 		vq = sve_vq_from_vl(vl);
 		flags |= SVE_SIG_FLAG_SM;
-	} else if (test_thread_flag(TIF_SVE)) {
+	} else if (current->thread.fp_type == FP_STATE_SVE) {
 		vq = sve_vq_from_vl(vl);
 	}
 
@@ -878,7 +878,7 @@ static int setup_sigframe_layout(struct
 	if (system_supports_sve() || system_supports_sme()) {
 		unsigned int vq = 0;
 
-		if (add_all || test_thread_flag(TIF_SVE) ||
+		if (add_all || current->thread.fp_type == FP_STATE_SVE ||
 		    thread_sm_enabled(&current->thread)) {
 			int vl = max(sve_max_vl(), sme_max_vl());
 


