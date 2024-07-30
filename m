Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF9B1A6160;
	Tue, 30 Jul 2024 16:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356715; cv=none; b=F+k7V63yPoCf5roPba9j63xZIIacQXXBaa49novWBqz4RzNrMuKhmmaCRGNmsQxcCglYTkVS9bBee9QtZjcJdq+TZkBupSYTsYAVl5+sQUVJet4dJ9VN75RsNMcNv8FXrN/EWr3PWg67jCKXZFBM/n6ocnf6PGaDJfaB1lvOds4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356715; c=relaxed/simple;
	bh=KcpAaH95uQ02thuR/XppWSQGbic739iFf0bd9AsjQoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HaSHSfPdavUlFpkrjV7QteDxKMTKZTEt5uoIZ+myA3PRtPirOph1gS2xo2NowcgzJiv1dJdvr+a/LPePbTWTLUzFHbGCImOx9NzzDbHzQhXvKVRjDgtvnZgtxULwVHvog8PUIbmVgoJHgsubxh3B1V8cwZ4UL7fRA9XCJ9ARYNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWzdee8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWzdee8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFED9C4AF0A;
	Tue, 30 Jul 2024 16:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356715;
	bh=KcpAaH95uQ02thuR/XppWSQGbic739iFf0bd9AsjQoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AWzdee8N1SkXbar+nFHxfrtuf6Z5lQXAFk+HCvon6+TyvZ5T1R2xhzF3n5RzWJXCO
	 ANKnuj7mMgPrTJuW4cA2ZpY4AxIcQqf3/OUHfo8sBfjQ7IMY4+PSnXUgUp5g3eIe1O
	 y2dbw5IkzBcHOqkRRQIs535k33byXL6G6u08XgiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/440] powerpc/prom: Add CPU info to hardware description string later
Date: Tue, 30 Jul 2024 17:47:16 +0200
Message-ID: <20240730151623.798867587@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9531ab90feb8a..e5b90d67cd536 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -324,6 +324,7 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 					  void *data)
 {
 	const char *type = of_get_flat_dt_prop(node, "device_type", NULL);
+	const __be32 *cpu_version = NULL;
 	const __be32 *prop;
 	const __be32 *intserv;
 	int i, nthreads;
@@ -404,7 +405,7 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 		prop = of_get_flat_dt_prop(node, "cpu-version", NULL);
 		if (prop && (be32_to_cpup(prop) & 0xff000000) == 0x0f000000) {
 			identify_cpu(0, be32_to_cpup(prop));
-			seq_buf_printf(&ppc_hw_desc, "0x%04x ", be32_to_cpup(prop));
+			cpu_version = prop;
 		}
 
 		check_cpu_feature_properties(node);
@@ -415,6 +416,12 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
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
@@ -852,9 +859,6 @@ void __init early_init_devtree(void *params)
 
 	dt_cpu_ftrs_scan();
 
-	// We can now add the CPU name & PVR to the hardware description
-	seq_buf_printf(&ppc_hw_desc, "%s 0x%04lx ", cur_cpu_spec->cpu_name, mfspr(SPRN_PVR));
-
 	/* Retrieve CPU related informations from the flat tree
 	 * (altivec support, boot CPU ID, ...)
 	 */
-- 
2.43.0



