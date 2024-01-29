Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FE015B112;
	Mon, 29 Jan 2024 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548091; cv=none; b=VHyGd20K7b7V44GFoRYnVAQXFmI9b0gwp9F8CAdZf3+GzKRqqatN9QTIrgSKDtGb4FQs55Q/OF/t75qxJcv9fHaesmtcWAlDwcZtvU0rU+TNkdAqDlV6f5ajJQbwOkkPBr125LDDwdcPlxruAlffxDFUt64uR8Jf6NUVhye0Gwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548091; c=relaxed/simple;
	bh=Wuxxj4bwge54ZYe2uCBXoPkOWbz6PoQ+4ctiNB21S+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8hZVDAEYK3CrDmEUJ07/bHTrLadklKhHZTS8l1oTxzv6orjPCG8+keiZIRU/JUemYsdoZ/oyO3gLut09GKXT54nUJeney7nCgvRsWW0cNelmbi6HmhYjoN242u3UoYyyB8FByc2AGehVOKo7vQOAmCmIBc/Hfzvt632Nx438Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jo2J3qud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jo2J3qud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A9BC43330;
	Mon, 29 Jan 2024 17:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548091;
	bh=Wuxxj4bwge54ZYe2uCBXoPkOWbz6PoQ+4ctiNB21S+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jo2J3qudazhtwyXt9fNmHDgC0u3oGDses8aRE41G3FyMhMay5zkUzJcifYbFs+EEO
	 DMfSkVt84xmfu5a1ku02DbhoGesLYptZ6RVsSY3SeTYrlhegDxO1x0hvcW5nj1a3AM
	 L/xErvm5ObtxUojVGpfRZgKo/JcxjFdSrCngbCGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.7 106/346] arm64: errata: Add Cortex-A510 speculative unprivileged load workaround
Date: Mon, 29 Jan 2024 09:02:17 -0800
Message-ID: <20240129170019.517237797@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

commit f827bcdafa2a2ac21c91e47f587e8d0c76195409 upstream.

Implement the workaround for ARM Cortex-A510 erratum 3117295. On an
affected Cortex-A510 core, a speculatively executed unprivileged load
might leak data from a privileged load via a cache side channel. The
issue only exists for loads within a translation regime with the same
translation (e.g. same ASID and VMID). Therefore, the issue only affects
the return to EL0.

The erratum and workaround are the same as ARM Cortex-A520 erratum
2966298, so reuse the existing workaround.

Cc: stable@vger.kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20240110-arm-errata-a510-v1-2-d02bc51aeeee@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                          |   14 ++++++++++++++
 arch/arm64/kernel/cpu_errata.c              |   17 +++++++++++++++--
 3 files changed, 31 insertions(+), 2 deletions(-)

--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -71,6 +71,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A510     | #2658417        | ARM64_ERRATUM_2658417       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A510     | #3117295        | ARM64_ERRATUM_3117295       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A520     | #2966298        | ARM64_ERRATUM_2966298       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A53      | #826319         | ARM64_ERRATUM_826319        |
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1054,6 +1054,20 @@ config ARM64_ERRATUM_2966298
 
 	  If unsure, say Y.
 
+config ARM64_ERRATUM_3117295
+	bool "Cortex-A510: 3117295: workaround for speculatively executed unprivileged load"
+	select ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
+	default y
+	help
+	  This option adds the workaround for ARM Cortex-A510 erratum 3117295.
+
+	  On an affected Cortex-A510 core, a speculatively executed unprivileged
+	  load might leak data from a privileged level via a cache side channel.
+
+	  Work around this problem by executing a TLBI before returning to EL0.
+
+	  If unsure, say Y.
+
 config CAVIUM_ERRATUM_22375
 	bool "Cavium erratum 22375, 24313"
 	default y
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -416,6 +416,19 @@ static struct midr_range broken_aarch32_
 };
 #endif /* CONFIG_ARM64_WORKAROUND_TRBE_WRITE_OUT_OF_RANGE */
 
+#ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
+static const struct midr_range erratum_spec_unpriv_load_list[] = {
+#ifdef CONFIG_ARM64_ERRATUM_3117295
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A510),
+#endif
+#ifdef CONFIG_ARM64_ERRATUM_2966298
+	/* Cortex-A520 r0p0 to r0p1 */
+	MIDR_REV_RANGE(MIDR_CORTEX_A520, 0, 0, 1),
+#endif
+	{},
+};
+#endif
+
 const struct arm64_cpu_capabilities arm64_errata[] = {
 #ifdef CONFIG_ARM64_WORKAROUND_CLEAN_CACHE
 	{
@@ -715,10 +728,10 @@ const struct arm64_cpu_capabilities arm6
 #endif
 #ifdef CONFIG_ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD
 	{
-		.desc = "ARM erratum 2966298",
+		.desc = "ARM errata 2966298, 3117295",
 		.capability = ARM64_WORKAROUND_SPECULATIVE_UNPRIV_LOAD,
 		/* Cortex-A520 r0p0 - r0p1 */
-		ERRATA_MIDR_REV_RANGE(MIDR_CORTEX_A520, 0, 0, 1),
+		ERRATA_MIDR_RANGE_LIST(erratum_spec_unpriv_load_list),
 	},
 #endif
 #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38


