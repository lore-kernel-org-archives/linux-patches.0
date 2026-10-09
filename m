Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4066A2DEA6B;
	Fri,  9 Oct 2026 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557627; cv=none; b=ZUuV1EHrZ18LtUslNOypNTsMKKmnKi5t3W/0xBHMdVkdtytQaMEl9dIHLGJNXjpUzan0YJJoa7irPGbmOVXC2EFGq2lH0T8ZPZhF5XSJoFa4BXm8Mhh1eC59kMRudUVEqe4d2hy5ghb+1DtlgwV4AvJuoRm7k5/akc9vTz+6JGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557627; c=relaxed/simple;
	bh=uPiTKiWix49Rn7shkvwTigKknSrE+9y7A9k9dUCCykI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdkaZfNm8uAMugsxHdqJEvjV0jzn2qBr9fOOkXIlFXhiHeSVraO19J5pLkqoixdauL8LcpROnA6jZxdlrmHZD6bISlq6uOphDGR2itrLVyFH+fBgkdLU1CjLjKkWIVQFu0FT/kZfz00sh5/nnQai6L6w+1wyXdQ2BGHt3/FB0AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRtUWWzN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRtUWWzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D94F1F000FF;
	Fri,  9 Oct 2026 14:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557626;
	bh=YSMZBH536TueXYqFLtPONJYCC3amXWM6lZrb3qVk3tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRtUWWzN0GX5uRf93YvKjKnyREjsM3TxDrPu6Nq1jzFoToC+EhlsoI0r++7ab11tK
	 kZak0IBSy9OeYLq0FXS4JBS2Kb9Hpv64B4k1FYnpaMtzfN911umrCoozjaO/vw7hxR
	 K32xjyJbL2LQc5NFqu8cOwulTOI+nHBKwclh4wzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beata Michalska <beata.michalska@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 424/428] arm64: errata: Add Cortex-A725 erratum 3821522 workaround
Date: Fri,  9 Oct 2026 16:12:41 +0200
Message-ID: <20261009140955.558264115@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beata Michalska <beata.michalska@arm.com>

[ Upstream commit 45f7304679875eb000d67e194090ee7abd05c89c ]

Cortex-A725 erratum 3821522 affects the CNT_CYCLES event, which can
incur a significant increment error when a CPU enters and subsequently
exits WFE or WFI, and may no longer track the system counter
frequency.

The AMEVCNTR01_EL0 counter is used as the AMU constant counter for
frequency invariance and CPPC FFH feedback counters. Wire the affected
Cortex-A725 range into the shared broken AMU constant-counter capability
so the affected counter is treated as unavailable by returning zero in
the AMU counter paths. This prevents the broken counter from being used
as a reference source.

The erratum can also affect PMUv3 users of the CNT_CYCLES event,
but this workaround intentionally does not change PMU event handling.
Hiding or rejecting the PMU event from the erratum code would change
the perf-visible PMU event interface, including raw event selection,
and would need a separate PMU-specific approach rather than being
folded into the AMU reference-counter workaround.

Cc: stable@vger.kernel.org
Signed-off-by: Beata Michalska <beata.michalska@arm.com>
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                          |   22 ++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c              |    4 ++++
 arch/arm64/kernel/topology.c                |    9 +++++----
 4 files changed, 33 insertions(+), 4 deletions(-)

--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -174,6 +174,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A725     | #3456106        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A725     | #3821522        | ARM64_ERRATUM_3821522       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1       | #1502854        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-X1       | #3324344        | ARM64_ERRATUM_3194386       |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1058,6 +1058,28 @@ config ARM64_ERRATUM_2645198
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_3821522
+	bool "Cortex-A725: 3821522: workaround for possible CNT_CYCLES increment error due to WFE/WFI"
+	depends on ARM64_AMU_EXTN
+	select ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT
+	default y
+	help
+	  This option adds the workaround for ARM Cortex-A725 erratum 3821522.
+
+	  On affected A725 cores, the CNT_CYCLES event may incur a significant
+	  increment error when entering and subsequently exiting WFx.
+	  As a result, the CNT_CYCLES may diverge from the system counter
+	  frequency at which it is expected to increment.
+	  This renders the AMU counter AMEVCNTR01, that implements CNT_CYCLES,
+	  being unreliable and unsuitable for use.
+
+	  Since there is no hardware workaround, reads of the affected CNT_CYCLES
+	  counter return 0 in the relevant paths. This causes users of the counter
+	  to treat it as unavailable and is functionally equivalent to firmware
+	  disabling the affected counter.
+
+	  If unsure, say Y.
+
 config ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 	bool
 
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -383,6 +383,10 @@ static const struct midr_range workaroun
 	/* Cortex-A510 r0p0-r1p1 */
 	MIDR_RANGE(MIDR_CORTEX_A510, 0, 0, 1, 1),
 #endif
+#ifdef CONFIG_ARM64_ERRATUM_3821522
+	/* Cortex-A725 r0p0 - r0p2 */
+	MIDR_RANGE(MIDR_CORTEX_A725, 0, 0, 0, 2),
+#endif
 	{}
 };
 #endif /* CONFIG_ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT */
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -385,10 +385,11 @@ static void cpu_read_corecnt(void *val)
 static void cpu_read_constcnt(void *val)
 {
 	/*
-	 * Return 0 if the current CPU is affected by erratum 2457168. A value
-	 * of 0 is also returned if the current CPU does not support AMUs or if
-	 * the counter is disabled. A return value of 0 at counter read is
-	 * properly handled as an error case by the users of the counter.
+	 * Return 0 if the current CPU is affected by a HW erratum.
+	 * A value of 0 is also returned if the current CPU does not
+	 * support AMUs or if the counter is disabled. A return
+	 * value of 0 at counter read is properly handled as an error
+	 * case by the users of the counter.
 	 */
 	*(u64 *)val = this_cpu_has_cap(ARM64_WORKAROUND_BROKEN_AMU_CONSTCNT) ?
 		      0UL : read_constcnt();


