Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6821A6192;
	Tue, 30 Jul 2024 16:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357662; cv=none; b=YGUTdijHYZIxPqjPnUHzZmrPampH6O0NK1Vgb5guSct1RtqMAuRctcXF7zL/VL8knjigWRAx/s+55aZZYftR5EUy4yi6gSfiLq6U+v5VSRUaTm5rBeiyENfxnTIGKh3GJlGUEiWr49ngZX1Fb/puAsmYqPTgcTe6J6G63zpXWMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357662; c=relaxed/simple;
	bh=jR2V1zeeA9lAuftav9GmiOzbj4hGNlBn6JWZq2legFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SohDPU5tJabJo4cw6UEtX+Hq5dOX6tgkXCKpXLihYOcysKYgLZ2H0ZHAM6tLWIDcxMTUE8IGysAy7uultqwV681Fq4DylWS+n3atctIpLsKKlY9uT1wZT5rlZW5iUDPDQiD9ai4+LdWh2X3x8Tk/6HKz+s7MxDUrR2ZovR4rJ6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0RSETiJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0RSETiJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209ABC32782;
	Tue, 30 Jul 2024 16:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357662;
	bh=jR2V1zeeA9lAuftav9GmiOzbj4hGNlBn6JWZq2legFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0RSETiJo+FivbuM+V/D1JG+McE0zb+g4B/Wcq2po+pGjQwH7hkLwwUbrv9T903Yb
	 2AaR88Ct04OeUp/dhpKc68NpP3LbIeHAUZR3u6X9Ka502exnwp4aU9k4fOuyWolp2N
	 OMcU2Zk4p7peh8H4hpB/AgJKgNJTtwbtpWCVYzwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/568] powerpc/prom: Add CPU info to hardware description string later
Date: Tue, 30 Jul 2024 17:46:26 +0200
Message-ID: <20240730151650.781243905@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 7bdd1c6c87de758750d419eedab7285b95b66417 ]

cur_cpu_spec->cpu_name is appended to ppc_hw_desc before cur_cpu_spec
has taken on its final value. This is illustrated on pseries by
comparing the CPU name as reported at boot ("POWER8E (raw)") to the
contents of /proc/cpuinfo ("POWER8 (architected)"):

  $ dmesg | grep Hardware
  Hardware name: IBM,8408-E8E POWER8E (raw) 0x4b0201 0xf000004 \
    of:IBM,FW860.50 (SV860_146) hv:phyp pSeries

  $ grep -m 1 ^cpu /proc/cpuinfo
  cpu             : POWER8 (architected), altivec supported

Some 44x models would appear to be affected as well; see
identical_pvr_fixup().

This results in incorrect CPU information in stack dumps --
ppc_hw_desc is an input to dump_stack_set_arch_desc().

Delay gathering the CPU name until after all potential calls to
identify_cpu().

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Fixes: bd649d40e0f2 ("powerpc: Add PVR & CPU name to hardware description")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240603-fix-cpu-hwdesc-v1-1-945f2850fcaa@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/prom.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 77364729a1b61..bf6d8ad3819e9 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -327,6 +327,7 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 					  void *data)
 {
 	const char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	const __be32 *cpu_version = NULL;
 	const __be32 *prop;
 	const __be32 *intserv;
 	int i, nthreads;
@@ -410,7 +411,7 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 		prop = of_get_flat_dt_prop(node, "cpu-version", NULL);
 		if (prop && (be32_to_cpup(prop) & 0xff000000) == 0x0f000000) {
 			identify_cpu(0, be32_to_cpup(prop));
-			seq_buf_printf(&ppc_hw_desc, "0x%04x ", be32_to_cpup(prop));
+			cpu_version = prop;
 		}
 
 		check_cpu_feature_properties(node);
@@ -421,6 +422,12 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 	}
 
 	identical_pvr_fixup(node);
+
+	// We can now add the CPU name & PVR to the hardware description
+	seq_buf_printf(&ppc_hw_desc, "%s 0x%04lx ", cur_cpu_spec->cpu_name, mfspr(SPRN_PVR));
+	if (cpu_version)
+		seq_buf_printf(&ppc_hw_desc, "0x%04x ", be32_to_cpup(cpu_version));
+
 	init_mmu_slb_size(node);
 
 #ifdef CONFIG_PPC64
@@ -858,9 +865,6 @@ void __init early_init_devtree(void *params)
 
 	dt_cpu_ftrs_scan();
 
-	// We can now add the CPU name & PVR to the hardware description
-	seq_buf_printf(&ppc_hw_desc, "%s 0x%04lx ", cur_cpu_spec->cpu_name, mfspr(SPRN_PVR));
-
 	/* Retrieve CPU related informations from the flat tree
 	 * (altivec support, boot CPU ID, ...)
 	 */
-- 
2.43.0



