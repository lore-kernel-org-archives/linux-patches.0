Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDC31FFC69;
	Thu, 13 Feb 2025 14:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458565; cv=none; b=ltnBOtXrKTSCaficShsFzg8DjoZkgq6lHftqNXKFlNxMLzFpJaBHvUD0IScsaasdpJ0m59SuUshhGUiCv/nDjTSzDAk9L98xsoMJa48bgZAlLB0XuNkr7SMFpFl8JqULXhW6XlFGUwizpMtquMyIvnLbxSeLIV7V9zb2RyTERbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458565; c=relaxed/simple;
	bh=f51ENt12m/koaDj+iMlAkF2opNdCbPIHa7JvkE2p7b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8MNStkxfHdLF3RKFsaH7SyGlnpMhNren3mIN168gABOczCW+oxnZ0Cb+zVhUGWHtj9KBdLlGp/m28RYZTAd7T0qEU6aXx6hxqW1GekT7QddpyZzcZrC4hxIfu5IMgNBKQLspuJjbmTDNScvVP23nmOjJdXFaWGHthpL8TTTi1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5VY40tZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5VY40tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94CDC4CED1;
	Thu, 13 Feb 2025 14:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458565;
	bh=f51ENt12m/koaDj+iMlAkF2opNdCbPIHa7JvkE2p7b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y5VY40tZObxKPSI3UtD0uTtVwUc+/qyNA8MBUFGpwwjTtNVlIXhW0mzxZVAXW3O/B
	 OxGEa7P1ILSL7yTSCBk6TPF6MTRuTe6a+4/x/pidCvPIjNC6qQoIxOviUyCoRDHq4t
	 XWVbcJpqM9LLXIYctmg8Os3j9lkPee9G3QxjgYXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 015/443] x86: Convert unreachable() to BUG()
Date: Thu, 13 Feb 2025 15:23:00 +0100
Message-ID: <20250213142441.210879450@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 2190966fbc14ca2cd4ea76eefeb96a47d8e390df ]

Avoid unreachable() as it can (and will in the absence of UBSAN)
generate fallthrough code. Use BUG() so we get a UD2 trap (with
unreachable annotation).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20241128094312.028316261@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/process.c | 2 +-
 arch/x86/kernel/reboot.c  | 2 +-
 arch/x86/kvm/svm/sev.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f63f8fd00a91f..15507e739c255 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -838,7 +838,7 @@ void __noreturn stop_this_cpu(void *dummy)
 #ifdef CONFIG_SMP
 	if (smp_ops.stop_this_cpu) {
 		smp_ops.stop_this_cpu();
-		unreachable();
+		BUG();
 	}
 #endif
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 615922838c510..dc1dd3f3e67fc 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -883,7 +883,7 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 
 	if (smp_ops.stop_this_cpu) {
 		smp_ops.stop_this_cpu();
-		unreachable();
+		BUG();
 	}
 
 	/* Assume hlt works */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 943bd074a5d37..fe6cc763fd518 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3820,7 +3820,7 @@ static int snp_begin_psc(struct vcpu_svm *svm, struct psc_buffer *psc)
 		goto next_range;
 	}
 
-	unreachable();
+	BUG();
 }
 
 static int __sev_snp_update_protected_guest_state(struct kvm_vcpu *vcpu)
-- 
2.39.5



