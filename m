Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D084D1DE89F;
	Tue,  8 Oct 2024 13:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392836; cv=none; b=AMy6LTx8EucPiRxreLpPaAqFCqJCn8fW9CGE5FJ6XjyjoxzOmkiBuK5CGvCz4naFAqC6mEspQeAa170LY3PN+SUdaDn38TfxL93NV5/nfXG4n971sHfy7AF/pte85DUzGszmJ7Cf9zqV4t9PQTY2THx5o2BavyFr4HpA3SshnBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392836; c=relaxed/simple;
	bh=+lP00LHa104wwNgEnIizsTgQHld3f+QfEy+0aCaZmQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=us/RNQsB+wDWxReabtd1oe0sfTLsElzamrqSY7/wTq/IBCTkbXunzJEt9B2gl1mZYqupApqqFGthC7ZU0XMm5eW6Z/gc021/hzJa/0gcq8knOWrnJyVlQk6TR1Rrf6GfeFTG2yjzoRvtxhUvB53qdZKR5TFd1FADFgQvOOmLfdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3WOoYeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3WOoYeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E9EC4CEC7;
	Tue,  8 Oct 2024 13:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392836;
	bh=+lP00LHa104wwNgEnIizsTgQHld3f+QfEy+0aCaZmQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3WOoYeVXjoi7Boggnff1zWOPzlEpp3mh64zSmj1dAnkzdbaAWN6xml0phkDO5jU3
	 7tCCD6fakSdqZtF2HAE94BTFAcUuihVzX8vzrMN7ab2/dRTmOGxceu9TDRyqhcaubk
	 VPuQpVm9GSCvmm5uwzH3Y5fwcfUC5BwtNf6gPtk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 533/558] arm64: errata: Expand speculative SSBS workaround once more
Date: Tue,  8 Oct 2024 14:09:23 +0200
Message-ID: <20241008115723.198963607@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 081eb7932c2b244f63317a982c5e3990e2c7fbdd ]

A number of Arm Ltd CPUs suffer from errata whereby an MSR to the SSBS
special-purpose register does not affect subsequent speculative
instructions, permitting speculative store bypassing for a window of
time.

We worked around this for a number of CPUs in commits:

* 7187bb7d0b5c7dfa ("arm64: errata: Add workaround for Arm errata 3194386 and 3312417")
* 75b3c43eab594bfb ("arm64: errata: Expand speculative SSBS workaround")
* 145502cac7ea70b5 ("arm64: errata: Expand speculative SSBS workaround (again)")

Since then, a (hopefully final) batch of updates have been published,
with two more affected CPUs. For the affected CPUs the existing
mitigation is sufficient, as described in their respective Software
Developer Errata Notice (SDEN) documents:

* Cortex-A715 (MP148) SDEN v15.0, erratum 3456084
  https://developer.arm.com/documentation/SDEN-2148827/1500/

* Neoverse-N3 (MP195) SDEN v5.0, erratum 3456111
  https://developer.arm.com/documentation/SDEN-3050973/0500/

Enable the existing mitigation by adding the relevant MIDRs to
erratum_spec_ssbs_list, and update silicon-errata.rst and the
Kconfig text accordingly.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20240930111705.3352047-3-mark.rutland@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/arch/arm64/silicon-errata.rst | 4 ++++
 arch/arm64/Kconfig                          | 2 ++
 arch/arm64/kernel/cpu_errata.c              | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/Documentation/arch/arm64/silicon-errata.rst b/Documentation/arch/arm64/silicon-errata.rst
index 3bc51669ead7d..8cd4f365044b6 100644
--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -146,6 +146,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A715     | #2645198        | ARM64_ERRATUM_2645198       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A715     | #3456084        | ARM64_ERRATUM_3194386       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A720     | #3456091        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A725     | #3456106        | ARM64_ERRATUM_3194386       |
@@ -186,6 +188,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-N2     | #3324339        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Neoverse-N3     | #3456111        | ARM64_ERRATUM_3194386       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V1     | #1619801        | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Neoverse-V1     | #3324341        | ARM64_ERRATUM_3194386       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 09ce28ff9e871..89b331575ed49 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1079,6 +1079,7 @@ config ARM64_ERRATUM_3194386
 	  * ARM Cortex-A78C erratum 3324346
 	  * ARM Cortex-A78C erratum 3324347
 	  * ARM Cortex-A710 erratam 3324338
+	  * ARM Cortex-A715 errartum 3456084
 	  * ARM Cortex-A720 erratum 3456091
 	  * ARM Cortex-A725 erratum 3456106
 	  * ARM Cortex-X1 erratum 3324344
@@ -1089,6 +1090,7 @@ config ARM64_ERRATUM_3194386
 	  * ARM Cortex-X925 erratum 3324334
 	  * ARM Neoverse-N1 erratum 3324349
 	  * ARM Neoverse N2 erratum 3324339
+	  * ARM Neoverse-N3 erratum 3456111
 	  * ARM Neoverse-V1 erratum 3324341
 	  * ARM Neoverse V2 erratum 3324336
 	  * ARM Neoverse-V3 erratum 3312417
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index aec2867daadc2..a78f247029aec 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -439,6 +439,7 @@ static const struct midr_range erratum_spec_ssbs_list[] = {
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
+	MIDR_ALL_VERSIONS(MIDR_CORTEX_A715),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A720),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_A725),
 	MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
@@ -450,6 +451,7 @@ static const struct midr_range erratum_spec_ssbs_list[] = {
 	MIDR_ALL_VERSIONS(MIDR_MICROSOFT_AZURE_COBALT_100),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
+	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N3),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V2),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3),
-- 
2.43.0



