Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D22524EF96;
	Tue, 20 May 2025 14:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750294; cv=none; b=A6ZsoUYja7WeU/MfkeJxZ5IL1TQ3dwsScFSlmxtFJvN2mjX9S+G/diyPh1GY1sOMTHRvBPCmWYnN6XgKmZSroJAWMBoAo1Oa9J9YfrpiSA6+f9f1vu2oyc+U9WdrfEULVIs0oHZwT17cP2RVWC3WmxBSfHsPRjt3rQX5CxA77H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750294; c=relaxed/simple;
	bh=G1nF4hw05CLTysRvk8298vcrSgvuo1UKMfaRbcVk+zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXJ3ZEKKIu55sYS5hTGV4GGjphFsT5e8eE9k38KQaXfi1pD27/l9r1WmluxJPk7WMbvP34A8QBNdEIAfs0HbtcxaIf29voSEc2Bu/uNtQVHDw5hgo7kOri1550K3M/lCm1SsfD7YuFKJeqKx0B/UCLiemJAXXxwyY1ai/LC+MDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVdXIhj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVdXIhj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB8FC4CEEF;
	Tue, 20 May 2025 14:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750294;
	bh=G1nF4hw05CLTysRvk8298vcrSgvuo1UKMfaRbcVk+zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVdXIhj0Y83Qbh0zY84hjcG8LpGphokuFDsrTadDDiHbwqZMenFcANrAwyjg30lCB
	 xRPs/JywtgeJM9zbR0M2JnDGiVwH3yKNbVyTYeUrCpznG9crooCRXdsHlavh6zptz1
	 zdD7sveveJzqBbM7rZ7uCF/zEV/uwEU4KCguc9ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianglai Li <lixianglai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 075/143] LoongArch: Save and restore CSR.CNTC for hibernation
Date: Tue, 20 May 2025 15:50:30 +0200
Message-ID: <20250520125813.017652160@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


