Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8E646AEEF;
	Tue, 16 Jun 2026 15:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624706; cv=none; b=iJIkOs+ZuZIeiMcp9ane5EIBIijcKuMOg+UADKqwrU+nLZOER40yWo6HALNAcy2PxmgxDXGjQSatvWPetWpvMxh/INZKVPLsQE3/FX28wY5xv20WGtpAa9j7qkI5d12wb9ntWV9X8V9iT3sC6YFQu4300vo8LT+9jRiompCz09o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624706; c=relaxed/simple;
	bh=tOeX/Hb8RXTkhCs2CixhiMSAjwLpZyf/9Mn3bFnm43g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dd2T4fG5xSuvDnALLzMxd0n5S4ZI1n/cVi2MASJdr4Ays1gVOhW9HNocYaIsfb9B6H58GTQJBlOb1kceat8Z44xTxO1mSOVIj5ojEq33Z+VG0X00J+HRFn6Ev+HCQc0K+d0HdefGIolODIcFfYOSVEvfmq8NtQgRwvIq0HnfwYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdbGCTxz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdbGCTxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45E41F000E9;
	Tue, 16 Jun 2026 15:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624703;
	bh=I7U8sPHMCW0RylV/BW/SW1koEmkthQwjmOtOM1Q/RCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdbGCTxzXkpjmgxSK0SmGt2NMURLXa8r7qbgYaG6jkPT3y9TotdFqA+GEglZ3xcxr
	 uJWdOlK7Z0ObRXCbXKRXme6QqR3NEAmvzT0deW17ii4Z5ddJTDl/79PB2KN0xdt85d
	 GhuySYdl4pEYg7zPjVkxPYfWynOGzPuBwTUDaOCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 7.0 378/378] arm64: errata: Mitigate TLBI errata on Microsoft Azure Cobalt 100 CPU
Date: Tue, 16 Jun 2026 20:30:09 +0530
Message-ID: <20260616145129.968969573@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

commit 1940e70a8144bf75e6df26bf6f600862ea7f7ea1 upstream.

Commit fb091ff39479 ("arm64: Subscribe Microsoft Azure Cobalt 100 to ARM
Neoverse N2 errata") states that Microsoft Azure Cobalt 100 CPU "is a
Microsoft implemented CPU based on r0p0 of the ARM Neoverse N2 CPU, and
therefore suffers from all the same errata.".

So enable the workaround for the latest broadcast TLB invalidation bug
on these parts.

Signed-off-by: Will Deacon <will@kernel.org>
[Mark: backport to v7.0.y]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/arch/arm64/silicon-errata.rst |    2 ++
 arch/arm64/Kconfig                          |    1 +
 arch/arm64/kernel/cpu_errata.c              |    1 +
 3 files changed, 4 insertions(+)

--- a/Documentation/arch/arm64/silicon-errata.rst
+++ b/Documentation/arch/arm64/silicon-errata.rst
@@ -352,3 +352,5 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | Microsoft      | Azure Cobalt 100| #3324339        | ARM64_ERRATUM_3194386       |
 +----------------+-----------------+-----------------+-----------------------------+
+| Microsoft      | Azure Cobalt 100| #4193789        | ARM64_ERRATUM_4118414       |
++----------------+-----------------+-----------------+-----------------------------+
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1204,6 +1204,7 @@ config ARM64_ERRATUM_4118414
 	  * ARM Neoverse-V2 erratum 4193787
 	  * ARM Neoverse-V3 erratum 4193784
 	  * ARM Neoverse-V3AE erratum 4193784
+	  * Microsoft Azure Cobalt 100 4193789
 	  * NVIDIA Olympus erratum T410-OLY-1029
 
 	  On affected cores, some memory accesses might not be completed by
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -364,6 +364,7 @@ static const struct arm64_cpu_capabiliti
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3),
 			MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3AE),
 			MIDR_ALL_VERSIONS(MIDR_NVIDIA_OLYMPUS),
+			MIDR_ALL_VERSIONS(MIDR_MICROSOFT_AZURE_COBALT_100),
 			{}
 		})),
 	},


