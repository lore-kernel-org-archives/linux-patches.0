Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FF724BBFB;
	Tue, 20 May 2025 14:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750633; cv=none; b=eboMnVPdr+4dZuMeb29bwkvXgWsUEnmo0H5gM7Z3cHi1mrnDCOkWTG+gmQE6MifEoEJxLlpizb62316/DUM6WcVSidiDFmLK40YmONxWGLz7ndUm0J78JE5jyUNXFUHQi4Is3nhXdah+MmJqGC43BpDOm2JrzeYC6M8Ppn4X6Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750633; c=relaxed/simple;
	bh=lOPGASBPMePfakbbnYhiCIy3/lp4R+oi2nAuG4E2JmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaI2o15ikGYspokk9Iwp8XR20c3RPGW8fzCcHT09rgm4vljqAPIxSAsNncPXSioquurLBVVnO+IwVpqyRUb7QjvmKuYHGUVK7rD7ORSAlxfHtkmIUGteM7OQvUFdclrcFYfhkgy6pu3XSb7TBpcRA+bZwsUxbhsgfqc6p7CEy9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9/2or0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9/2or0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA10DC4CEE9;
	Tue, 20 May 2025 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750633;
	bh=lOPGASBPMePfakbbnYhiCIy3/lp4R+oi2nAuG4E2JmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9/2or0Ynj2a/QGxYph5QMvJL8bCduzOnVJH2HV3Vj+diaCe6ocbct3jacH8M+W3A
	 2T9cUsCTCJ6GTN2RQcr4Ng6FQB8oOSVl7LsE0FnlTSpUI5p5BmIlNtycqDAWbKZacE
	 urB3l7+sDwXrHO45jhMWYa/i/1B7Be+etYkRx/Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianglai Li <lixianglai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 071/145] LoongArch: Save and restore CSR.CNTC for hibernation
Date: Tue, 20 May 2025 15:50:41 +0200
Message-ID: <20250520125813.369647118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -111,7 +111,7 @@ static unsigned long __init get_loops_pe
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


