Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4106C471264;
	Tue, 21 Jul 2026 18:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659278; cv=none; b=aErRknebCW/XwPmPwKX+suMkY8Xu1MjRv9AKasna4SYlatxTntpLFsBGkjBIOV1qX8FCyk6/zYPfxOHIgYpDWqIxAovcF26/zARbhINQieatpOW1e9zvolrlxIHuKmSIoURPcxswOyM44m7BmVDRFAYXJumbmYkfaYzPC+y7ijI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659278; c=relaxed/simple;
	bh=IsJfSH686NCm5AknF/D13U6NnTO9TANBrLS9xgGdvhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBltdklLSSTTXsqtahODrpmdc3P/1+Qy/VgLE7Ef3+pWeTH04EUEBFyzRE14fd+nnBwxa7Z9Xwtppltp7sVGSUZePfyq+rrFr4vz1ny2Dbpxyi9gpTkRQMx26vMevgu9psqQpvY4fW5H1tmay/yUZ+dCS+Ou1bUbOU91ke7nIr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEc/mkIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEc/mkIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78561F000E9;
	Tue, 21 Jul 2026 18:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659277;
	bh=51xjTiTgNkAgXh9aCUr3fDpLLbt0KzEn+kI3YozKgAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEc/mkIwDX1iuhh2sOjaKIVeSaYAQbhDba9p0JFFKgiCombNoavZNBQAOYMncA3MX
	 IDQU49jNNEE9y0AyKRcLdACnr/DJuav2CKGm79UyfMDhtEW7PdNAkWST9ZpuF++jL2
	 ei7UagcrbvOrL70GlzEmmXqrjyjuLUD9IFwl++Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <jic23@kernel.org>,
	James Morse <james.morse@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 1460/1611] arm64: smp: Fix hot-unplug tearing by forcing unregistration
Date: Tue, 21 Jul 2026 17:26:16 +0200
Message-ID: <20260721152548.285892877@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 18a4e5cf633fad5c40ac9d936c51bf38db68796d upstream.

Sashiko review pointed out the following issue[1].

Commit eba4675008a6 ("arm64: arch_register_cpu() variant to check if
an ACPI handle is now available.") introduced architectural safety
blocks inside arch_unregister_cpu(). If a hot-unplug operation is
determined to be a physical hardware removal (where _STA evaluates to
!ACPI_STA_DEVICE_PRESENT), or if firmware evaluation fails, it aborts
the unregistration transaction early to protect unreadied arm64
infrastructure.

However, returning early from arch_unregister_cpu() causes a catastrophic
state tearing because the generic ACPI layer (acpi_processor_post_eject())
unconditionally continues its cleanup flow. This leaves the stale sysfs
device leaked in the memory, deadlocking any subsequent hot-add attempts
on the same CPU.

Fix it by simplifying arch_unregister_cpu() to always proceed with
the unregistration, as a pr_err_once() warning is sufficient to make
it more visible for currently not supported physical CPU removal.
Also remove the redundant NULL check on acpi_handle as it cannot be
NULL when calling arch_unregister_cpu().

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260520022023.126670-1-ruanjinjie@huawei.com [1]
Fixes: eba4675008a6 ("arm64: arch_register_cpu() variant to check if an ACPI handle is now available.")
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/smp.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -535,23 +535,13 @@ void arch_unregister_cpu(int cpu)
 {
 	acpi_handle acpi_handle = acpi_get_processor_handle(cpu);
 	struct cpu *c = &per_cpu(cpu_devices, cpu);
-	acpi_status status;
 	unsigned long long sta;
-
-	if (!acpi_handle) {
-		pr_err_once("Removing a CPU without associated ACPI handle\n");
-		return;
-	}
+	acpi_status status;
 
 	status = acpi_evaluate_integer(acpi_handle, "_STA", NULL, &sta);
-	if (ACPI_FAILURE(status))
-		return;
-
-	/* For now do not allow anything that looks like physical CPU HP */
-	if (cpu_present(cpu) && !(sta & ACPI_STA_DEVICE_PRESENT)) {
+	if (!ACPI_FAILURE(status) &&
+	    cpu_present(cpu) && !(sta & ACPI_STA_DEVICE_PRESENT))
 		pr_err_once("Changing CPU present bit is not supported\n");
-		return;
-	}
 
 	unregister_cpu(c);
 }


