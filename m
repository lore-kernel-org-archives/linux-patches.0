Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0879A3EDE51;
	Tue, 12 May 2026 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609000; cv=none; b=J1SxRKYY0RqahVgu8scwbGGWXe+b+eVrRlc/NrPcIWq3ikPi3S0/OBJRpOjM+UxnzLNU2Fs9oFBKfp67jHzGPdtmGWAwZVDQj9O1ufY3HG5x6IcM4hK2YqIgmsyMKzmXYDyNT/GmTjQ04WvjxRS+v7p/e8UV3rCeed3elgYCRzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609000; c=relaxed/simple;
	bh=QsXOWGpcyb9hsQYC+y55BSR5QwxeTw1mUSeRzdYM2eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqYCiMe/zmEQcn95M1UFoBY4Ree3knkyYuoS9AD6fCNhefsioiXPnW89DDXDdI3UX0wJkOKkXsiyL9VN2BEdGSaQl7pTJ5cHzUYsdnXCYxMd8cJb1th5irXd6v0wT/KXlbZaPpnZjZacz7bT3C9EJIej4BHyMLY106JkTNEnENU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZwmjCb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZwmjCb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94804C2BCB0;
	Tue, 12 May 2026 18:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608999;
	bh=QsXOWGpcyb9hsQYC+y55BSR5QwxeTw1mUSeRzdYM2eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sZwmjCb7rO7yJFp6aFC3Lhe+V2Op1yS9nHydf49g9A32tYHUnwbu7L2BvPKm5H2vS
	 XL6AIVBNC6WwyTTd/Fekrnw0oIc3Wx5XYGZHSk9C7hZDfof2kDkGINX+1jzd6hiX0P
	 UWRKDh3AmC9FpOOE44CrxLaICFKQmDVklpPy8Bq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	Breno Leitao <leitao@debian.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.0 006/307] ACPI: arm64: cpuidle: Tolerate platforms with no deep PSCI idle states
Date: Tue, 12 May 2026 19:36:41 +0200
Message-ID: <20260512173940.257075688@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 3ea4415015d690a51a3fb1f98dfc9a02f88f7bc4 upstream.

Commit cac173bea57d ("ACPI: processor: idle: Rework the handling of
acpi_processor_ffh_lpi_probe()") moved the acpi_processor_ffh_lpi_probe()
call from acpi_processor_setup_cpuidle_dev(), where its return value was
ignored, to acpi_processor_get_power_info(), where it is now treated as
a hard failure. As a result, platforms where psci_acpi_cpu_init_idle()
returned -ENODEV stopped registering any cpuidle states, forcing CPUs to
busy-poll when idle.

On NVIDIA Grace (aarch64) systems with PSCIv1.1, pr->power.count is 1
(only WFI, no deep PSCI states beyond it), so the previous
"count = pr->power.count - 1; if (count <= 0) return -ENODEV;" check
returned -ENODEV for all 72 CPUs and disabled cpuidle entirely.

The lpi_states count is already validated in acpi_processor_get_lpi_info(),
so the check here is redundant. Simplify the loop to iterate over
lpi_states[1..power.count). When only WFI is present, the loop body
simply does not execute and the function returns 0, which is the correct
outcome: there is nothing to validate for FFH and no error to report.

Suggested-by: Huisong Li <lihuisong@huawei.com>
Cc: stable@vger.kernel.org
Fixes: cac173bea57d ("ACPI: processor: idle: Rework the handling of acpi_processor_ffh_lpi_probe()")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/arm64/cpuidle.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/arm64/cpuidle.c b/drivers/acpi/arm64/cpuidle.c
index 801f9c450142..c68a5db8ebba 100644
--- a/drivers/acpi/arm64/cpuidle.c
+++ b/drivers/acpi/arm64/cpuidle.c
@@ -16,7 +16,7 @@
 
 static int psci_acpi_cpu_init_idle(unsigned int cpu)
 {
-	int i, count;
+	int i;
 	struct acpi_lpi_state *lpi;
 	struct acpi_processor *pr = per_cpu(processors, cpu);
 
@@ -30,14 +30,10 @@ static int psci_acpi_cpu_init_idle(unsigned int cpu)
 	if (!psci_ops.cpu_suspend)
 		return -EOPNOTSUPP;
 
-	count = pr->power.count - 1;
-	if (count <= 0)
-		return -ENODEV;
-
-	for (i = 0; i < count; i++) {
+	for (i = 1; i < pr->power.count; i++) {
 		u32 state;
 
-		lpi = &pr->power.lpi_states[i + 1];
+		lpi = &pr->power.lpi_states[i];
 		/*
 		 * Only bits[31:0] represent a PSCI power_state while
 		 * bits[63:32] must be 0x0 as per ARM ACPI FFH Specification
-- 
2.54.0



