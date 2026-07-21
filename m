Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F391E46D088;
	Tue, 21 Jul 2026 17:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655173; cv=none; b=ogyyNt+IeA7nXB1Zge6Jy/Pcfjn0ncknFsq9ZpgtMr2ZY6FtuxVn4cKr0ktWUSqgQ1tWJFQiL8JxA27o4ZeOE/VPdlLgsdhDpYfU5flJFW6NPmXRu5QYSQTUEosvmKKA+j9Qu5sby3iZJmdhlsPozRXlZ5ZbNRARh6nMRffYnow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655173; c=relaxed/simple;
	bh=DEQhejK2Xa9VJT6yShzNls6FO2i2T7KuY8ZGdf4MMXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2KvWlmTwT7rHyaIBDkpWlSeiqMvM78wVuRxpCvJbg1rGbYMDLNcNpjh1CrH72ZIrl5ep+aPT0mr5yujcUGlHXlbm78yq0u8W5d0ZCkcttZg4OOWqnCVM25k5F8t5ok90P4l8bBt8zF43I1K9ObWFwbyGbwCrI2EgtEYW9AxgPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcnMZ+En; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcnMZ+En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652B21F000E9;
	Tue, 21 Jul 2026 17:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655171;
	bh=Gjy2QzZkeS5TRwFZkfa2yUz4Uuly2JMkBo5WqSBmCuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcnMZ+En/bYkTlD2gz70RBcxJ33KN1+GvOzanQDVVWZciK/de8HOc3MxrnTAvUQkw
	 0DAn/r7Leb4Vp4uyIv5SitNDBKxCK2sPlY1QWhBT47Z0qK5rk738E8IPCVCVvbsXre
	 nvfmdTsYSUrjd/4zDhPtGHwVOfAlLWHNsustJHQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <jic23@kernel.org>,
	James Morse <james.morse@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.1 1981/2077] arm64: smp: Fix hot-unplug tearing by forcing unregistration
Date: Tue, 21 Jul 2026 17:27:34 +0200
Message-ID: <20260721152639.435643707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


