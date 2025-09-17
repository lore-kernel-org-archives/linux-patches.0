Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A921F09A5;
	Wed, 17 Sep 2025 12:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112915; cv=none; b=mtKddNXZ+aNLOkQDwz/HNCAdNM5N1jb1OjMeTh7BNMFiS/xyx8zRO+2T73UAwhzipufhup8Bb2MrXF9WUTLCXgi6Mmy1K/EV1xtugnLdrvkkxjLnC0lRELcmIPQ/sPE89opu0fZMDdyAXYbYxP3qXdu+77DoyF9lJXKF44JpuoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112915; c=relaxed/simple;
	bh=x3KQH2/OvCWAvwEjaAQG1O62UoOfE1J6JP2bS75oLNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGoJkgH/jTmERTaKTkTDsTbmpmQEdcm2CpyujzJCEzfxs2ndCb+vSJDXIbQW/spX5Duv1I2cBYN5n7MZKH2NYiKTJa3r36KUc2Xv9BYmsiaqkAuTI3RLpHHq4bpPx3zlUeWzS+8+l0jAGQxDSqU0ZtYXMwxu4nZG4O58a8VCFPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P09PfcfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P09PfcfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6E7C4CEF0;
	Wed, 17 Sep 2025 12:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112914;
	bh=x3KQH2/OvCWAvwEjaAQG1O62UoOfE1J6JP2bS75oLNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P09PfcfOwxZo2SyIdME4Aot6N79D4L4Sc+Lbeh+g15XA3TIq6jbEYQE4NUeoS/dHE
	 oO+YfrxmkUWbYSVXEZpY/daZVw6fn2qDFXGctUWeJdsfQlT0jjgIr6UZVAM5HvF043
	 R/mca71wDi5iI4a9XHhhVrzGp9zS6Bj/JllYMzXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.16 115/189] x86/cpu/topology: Always try cpu_parse_topology_ext() on AMD/Hygon
Date: Wed, 17 Sep 2025 14:33:45 +0200
Message-ID: <20250917123354.674909691@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

commit cba4262a19afae21665ee242b3404bcede5a94d7 upstream.

Support for parsing the topology on AMD/Hygon processors using CPUID leaf 0xb
was added in

  3986a0a805e6 ("x86/CPU/AMD: Derive CPU topology from CPUID function 0xB when available").

In an effort to keep all the topology parsing bits in one place, this commit
also introduced a pseudo dependency on the TOPOEXT feature to parse the CPUID
leaf 0xb.

The TOPOEXT feature (CPUID 0x80000001 ECX[22]) advertises the support for
Cache Properties leaf 0x8000001d and the CPUID leaf 0x8000001e EAX for
"Extended APIC ID" however support for 0xb was introduced alongside the x2APIC
support not only on AMD [1], but also historically on x86 [2].

Similar to 0xb, the support for extended CPU topology leaf 0x80000026 too does
not depend on the TOPOEXT feature.

The support for these leaves is expected to be confirmed by ensuring

  leaf <= {extended_}cpuid_level

and then parsing the level 0 of the respective leaf to confirm EBX[15:0]
(LogProcAtThisLevel) is non-zero as stated in the definition of
"CPUID_Fn0000000B_EAX_x00 [Extended Topology Enumeration]
(Core::X86::Cpuid::ExtTopEnumEax0)" in Processor Programming Reference (PPR)
for AMD Family 19h Model 01h Rev B1 Vol1 [3] Sec. 2.1.15.1 "CPUID Instruction
Functions".

This has not been a problem on baremetal platforms since support for TOPOEXT
(Fam 0x15 and later) predates the support for CPUID leaf 0xb (Fam 0x17[Zen2]
and later), however, for AMD guests on QEMU, the "x2apic" feature can be
enabled independent of the "topoext" feature where QEMU expects topology and
the initial APICID to be parsed using the CPUID leaf 0xb (especially when
number of cores > 255) which is populated independent of the "topoext" feature
flag.

Unconditionally call cpu_parse_topology_ext() on AMD and Hygon processors to
first parse the topology using the XTOPOLOGY leaves (0x80000026 / 0xb) before
using the TOPOEXT leaf (0x8000001e).

While at it, break down the single large comment in parse_topology_amd() to
better highlight the purpose of each CPUID leaf.

Fixes: 3986a0a805e6 ("x86/CPU/AMD: Derive CPU topology from CPUID function 0xB when available")
Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org # Only v6.9 and above; depends on x86 topology rewrite
Link: https://lore.kernel.org/lkml/1529686927-7665-1-git-send-email-suravee.suthikulpanit@amd.com/ [1]
Link: https://lore.kernel.org/lkml/20080818181435.523309000@linux-os.sc.intel.com/ [2]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 [3]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/topology_amd.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -175,27 +175,30 @@ static void topoext_fixup(struct topo_sc
 
 static void parse_topology_amd(struct topo_scan *tscan)
 {
-	bool has_topoext = false;
-
 	/*
-	 * If the extended topology leaf 0x8000_001e is available
-	 * try to get SMT, CORE, TILE, and DIE shifts from extended
+	 * Try to get SMT, CORE, TILE, and DIE shifts from extended
 	 * CPUID leaf 0x8000_0026 on supported processors first. If
 	 * extended CPUID leaf 0x8000_0026 is not supported, try to
-	 * get SMT and CORE shift from leaf 0xb first, then try to
-	 * get the CORE shift from leaf 0x8000_0008.
+	 * get SMT and CORE shift from leaf 0xb. If either leaf is
+	 * available, cpu_parse_topology_ext() will return true.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_TOPOEXT))
-		has_topoext = cpu_parse_topology_ext(tscan);
+	bool has_xtopology = cpu_parse_topology_ext(tscan);
 
 	if (cpu_feature_enabled(X86_FEATURE_AMD_HTR_CORES))
 		tscan->c->topo.cpu_type = cpuid_ebx(0x80000026);
 
-	if (!has_topoext && !parse_8000_0008(tscan))
+	/*
+	 * If XTOPOLOGY leaves (0x26/0xb) are not available, try to
+	 * get the CORE shift from leaf 0x8000_0008 first.
+	 */
+	if (!has_xtopology && !parse_8000_0008(tscan))
 		return;
 
-	/* Prefer leaf 0x8000001e if available */
-	if (parse_8000_001e(tscan, has_topoext))
+	/*
+	 * Prefer leaf 0x8000001e if available to get the SMT shift and
+	 * the initial APIC ID if XTOPOLOGY leaves are not available.
+	 */
+	if (parse_8000_001e(tscan, has_xtopology))
 		return;
 
 	/* Try the NODEID MSR */


