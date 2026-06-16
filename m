Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F9F3C09E1;
	Tue, 16 Jun 2026 18:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633053; cv=none; b=eAFfsafxoql52cwaK0kmegA8YJ65xsd6w3L3Ri6LN89a/LXRm7ODHG+BO5al2JVTLOgIfg4ZyrmGZxUqs23nMRL63vSqKBT7Zoc070JwOe8/92yiWKSYHiTPsU6oQ/YFjqXwBRrVtj+W1gLPjk5yXXCii3DKiEBzN84JymMGK+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633053; c=relaxed/simple;
	bh=ZrF0zazPxSZpSiPsmZtMJQwJlIg1UDeYfRyVpuvm6Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VB4FvV73oDpmvybythqhLCUbn5YxdSWZ7dA+42xr8pubKobHlsSfR2P82D+XGDXYHfvP/Za/p0gCvoxljwHfBuPyc6AsZY4PyZcTLiyQADZa3wCcsa6BOZwDuM9fDZML2odOh265/H3tgpsENwf304NyBfgqgmr0V6ptJyD0KxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcDrXmAj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcDrXmAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C753F1F000E9;
	Tue, 16 Jun 2026 18:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633051;
	bh=oeHU75vfq0SEuO16FuEK0Sm9Mnmwq5pKhtTx72mFelY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcDrXmAj1lWhAG+X5NuYerlorRvKSnSUu6Vad+7yVgMFjD+miUeD660ZKfBhOL8CZ
	 UmT1mlYng1uBflBtQ4ySN/uKxpxVGwDim8FBXL+NvVUVQzAu4ShGPOg/0vUA31dQ/t
	 M6y3YQJymvAncgUteNiN5v+BgKnVWLhr/Goj7WqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 6.1 517/522] arm64: errata: Mitigate TLBI errata on NVIDIA Olympus CPU
Date: Tue, 16 Jun 2026 20:31:04 +0530
Message-ID: <20260616145149.908563640@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shanker Donthineni <sdonthineni@nvidia.com>

commit ec7216f92e4ebd485b1c6dc6aa3f6064b71a5768 upstream.

NVIDIA Olympus cores are affected by the TLBI completion issue tracked as
CVE-2025-10263. The existing ARM64_ERRATUM_4118414 handling already uses
ARM64_WORKAROUND_REPEAT_TLBI to issue an additional broadcast TLBI;DSB
sequence and ensure affected memory write effects are globally observed.

Add MIDR_NVIDIA_OLYMPUS to the repeat-TLBI match list so the same
mitigation is enabled on affected Olympus systems. Also document the
NVIDIA Olympus erratum in the arm64 silicon errata table and list it in
the Kconfig help text.

Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
[Mark: backport to v6.1.y]
Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                     |    3 ++-
 arch/arm64/kernel/cpu_errata.c         |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -263,6 +263,8 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | NVIDIA         | Carmel Core     | N/A             | NVIDIA_CARMEL_CNP_ERRATUM   |
 +----------------+-----------------+-----------------+-----------------------------+
+| NVIDIA         | Olympus core    | T410-OLY-1029   | ARM64_ERRATUM_4118414       |
++----------------+-----------------+-----------------+-----------------------------+
 | NVIDIA         | T241 GICv3/4.x  | T241-FABRIC-4   | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
 +----------------+-----------------+-----------------+-----------------------------+
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1054,7 +1054,7 @@ config ARM64_ERRATUM_4193714
 	  If unsure, say Y.
 
 config ARM64_ERRATUM_4118414
-	bool "Cortex-*/Neoverse-*/C1-*: Completion of affected memory accesses might not be guaranteed by completion of a TLBI"
+	bool "Various: Completion of affected memory accesses might not be guaranteed by completion of a TLBI"
 	default y
 	select ARM64_WORKAROUND_REPEAT_TLBI
 	help
@@ -1081,6 +1081,7 @@ config ARM64_ERRATUM_4118414
 	  * ARM Neoverse-V2 erratum 4193787
 	  * ARM Neoverse-V3 erratum 4193784
 	  * ARM Neoverse-V3AE erratum 4193784
+	  * NVIDIA Olympus erratum T410-OLY-1029
 
 	  On affected cores, some memory accesses might not be completed by
 	  broadcast TLB invalidation.
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -265,6 +265,7 @@ static const struct arm64_cpu_capabiliti
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V2),
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3),
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3AE),
+			MIDR_ALL_VERSIONS(MIDR_NVIDIA_OLYMPUS),
 			{}
 		})),
 	},


