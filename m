Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FD2242913;
	Tue, 20 May 2025 14:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749798; cv=none; b=GJE55G+u7/hTTitsHac8hlN1HJgKcrKyXw/LpCJJFWrkwd63rtRbwo4z+oMzmwZlyzeuC7XmuXYsmsZoe2oJJKoHKCdiqiXVPzipK0KgKIOra/jLzoYCu5+J6OXtEzOAv+ATAjEIOxjkc9AgzoR+puqApl/PiLMBmOm06AtA2FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749798; c=relaxed/simple;
	bh=UyqHl3/6vfYJ1QdAMMWpOpGMdqWNIGu4usyqYXwPq4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG68cunXNaFx21KE+sM/j2tY8i0mj5NHSH+P1K1tNUvcXEg7pDi03t0pCS0dYpvon4DPPyXQhiJ0nkwcyQ18YdC/1J5FcEDehnrVfR/03vKAWvW5MZoMWdf0hpg476cPYc+vUThfHY5yWVIaOTZ82XXkzWSFfHSxnBSFwAwyWZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yOhGvbsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yOhGvbsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BF8C4CEE9;
	Tue, 20 May 2025 14:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749798;
	bh=UyqHl3/6vfYJ1QdAMMWpOpGMdqWNIGu4usyqYXwPq4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yOhGvbsOwnbgueaC5tTbPCb59kK0G/dyFAgpgOqhNdkMRixQflNUUAdZsROX8ABo7
	 M4xfmBcnju/0RM6BHEd0KKSbV2bi85h0ZcK5XpdsCdQXsWmbLyVSNHj3N32j0bXv2d
	 KzsBtfeVd7/gRJUxAIk7QuQ/389GSzBgxA7mJrk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianglai Li <lixianglai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 064/117] LoongArch: Save and restore CSR.CNTC for hibernation
Date: Tue, 20 May 2025 15:50:29 +0200
Message-ID: <20250520125806.533413283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit ceb9155d058a11242aa0572875c44e9713b1a2be upstream.

Save and restore CSR.CNTC for hibernation which is similar to suspend.

For host this is unnecessary because sched clock is ensured continuous,
but for kvm guest sched clock isn't enough because rdtime.d should also
be continuous.

Host::rdtime.d = Host::CSR.CNTC + counter
Guest::rdtime.d = Host::CSR.CNTC + Host::CSR.GCNTC + Guest::CSR.CNTC + counter

so,

Guest::rdtime.d = Host::rdtime.d + Host::CSR.GCNTC + Guest::CSR.CNTC

To ensure Guest::rdtime.d continuous, Host::rdtime.d should be at first
continuous, while Host::CSR.GCNTC / Guest::CSR.CNTC is maintained by KVM.

Cc: stable@vger.kernel.org
Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/time.c     |    2 +-
 arch/loongarch/power/hibernate.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/loongarch/kernel/time.c
+++ b/arch/loongarch/kernel/time.c
@@ -110,7 +110,7 @@ static unsigned long __init get_loops_pe
 	return lpj;
 }
 
-static long init_offset __nosavedata;
+static long init_offset;
 
 void save_counter(void)
 {
--- a/arch/loongarch/power/hibernate.c
+++ b/arch/loongarch/power/hibernate.c
@@ -2,6 +2,7 @@
 #include <asm/fpu.h>
 #include <asm/loongson.h>
 #include <asm/sections.h>
+#include <asm/time.h>
 #include <asm/tlbflush.h>
 #include <linux/suspend.h>
 
@@ -14,6 +15,7 @@ struct pt_regs saved_regs;
 
 void save_processor_state(void)
 {
+	save_counter();
 	saved_crmd = csr_read32(LOONGARCH_CSR_CRMD);
 	saved_prmd = csr_read32(LOONGARCH_CSR_PRMD);
 	saved_euen = csr_read32(LOONGARCH_CSR_EUEN);
@@ -26,6 +28,7 @@ void save_processor_state(void)
 
 void restore_processor_state(void)
 {
+	sync_counter();
 	csr_write32(saved_crmd, LOONGARCH_CSR_CRMD);
 	csr_write32(saved_prmd, LOONGARCH_CSR_PRMD);
 	csr_write32(saved_euen, LOONGARCH_CSR_EUEN);


