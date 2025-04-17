Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1B91D07BA;
	Thu, 17 Apr 2025 18:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915204; cv=none; b=W+6fi4z9nIOVkfypnmEW8/bztBp8dUIW2+tjchrGVBvTYZBYKDHT0wa5vET0aY/P9kNdQEvKJRDbtJ04j28A57jL+85osOJfxrlrrgeFqjOGYPmwVdzPvncwXa40GUqzLDegZSa8Bdb+fW7yk/YjFTCTs7vBDSrpyYZFc9DN6zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915204; c=relaxed/simple;
	bh=5ZSggvVIO9l7KRGT9JcnNC5OPiaL2vBh0qScxIhsNNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZWXCXk1EPxuIAJt7tW8iRTuQP4EF838C/Bc+KunnIIf8wZWZW+1YoHxC6FXQlUYEWKQWiI86YodtZMQURTi10bEHBfK88aUCO27QiQ3ZMtanSMwdJKKD8Fcn8PuqM8tlTlUu6ztyP4Fd9aC5oWO5fcrqCU9hZY34nLZkV7DHXPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsakHoAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsakHoAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4CDC4CEE4;
	Thu, 17 Apr 2025 18:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915204;
	bh=5ZSggvVIO9l7KRGT9JcnNC5OPiaL2vBh0qScxIhsNNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsakHoAutyutrqfXsCo0q73vTq0118Xnu/8MWw0Hy0d2w2AX4iKuZi7oxtDj1wFLz
	 0XDUbLAX2NYGG0ZvtW+xN+wHnjOt3ADcljHzs3Ncqy5Kxsl1mSNn2qr/yL+prRd67u
	 3Ywe8cNsKUginXIiK2VXvqhHVUIAsVI5xTn1iYi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Grobecker <max@grobecker.info>,
	Ingo Molnar <mingo@kernel.org>,
	linux-kernel@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/393] x86/cpu: Dont clear X86_FEATURE_LAHF_LM flag in init_amd_k8() on AMD when running in a virtual machine
Date: Thu, 17 Apr 2025 19:47:40 +0200
Message-ID: <20250417175109.640050377@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Grobecker <max@grobecker.info>

[ Upstream commit a4248ee16f411ac1ea7dfab228a6659b111e3d65 ]

When running in a virtual machine, we might see the original hardware CPU
vendor string (i.e. "AuthenticAMD"), but a model and family ID set by the
hypervisor. In case we run on AMD hardware and the hypervisor sets a model
ID < 0x14, the LAHF cpu feature is eliminated from the the list of CPU
capabilities present to circumvent a bug with some BIOSes in conjunction with
AMD K8 processors.

Parsing the flags list from /proc/cpuinfo seems to be happening mostly in
bash scripts and prebuilt Docker containers, as it does not need to have
additionals tools present – even though more reliable ways like using "kcpuid",
which calls the CPUID instruction instead of parsing a list, should be preferred.
Scripts, that use /proc/cpuinfo to determine if the current CPU is
"compliant" with defined microarchitecture levels like x86-64-v2 will falsely
claim the CPU is incapable of modern CPU instructions when "lahf_lm" is missing
in that flags list.

This can prevent some docker containers from starting or build scripts to create
unoptimized binaries.

Admittably, this is more a small inconvenience than a severe bug in the kernel
and the shoddy scripts that rely on parsing /proc/cpuinfo
should be fixed instead.

This patch adds an additional check to see if we're running inside a
virtual machine (X86_FEATURE_HYPERVISOR is present), which, to my
understanding, can't be present on a real K8 processor as it was introduced
only with the later/other Athlon64 models.

Example output with the "lahf_lm" flag missing in the flags list
(should be shown between "hypervisor" and "abm"):

    $ cat /proc/cpuinfo
    processor       : 0
    vendor_id       : AuthenticAMD
    cpu family      : 15
    model           : 6
    model name      : Common KVM processor
    stepping        : 1
    microcode       : 0x1000065
    cpu MHz         : 2599.998
    cache size      : 512 KB
    physical id     : 0
    siblings        : 1
    core id         : 0
    cpu cores       : 1
    apicid          : 0
    initial apicid  : 0
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 13
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
                      cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx rdtscp
                      lm rep_good nopl cpuid extd_apicid tsc_known_freq pni
                      pclmulqdq ssse3 fma cx16 sse4_1 sse4_2 x2apic movbe popcnt
                      tsc_deadline_timer aes xsave avx f16c hypervisor abm
                      3dnowprefetch vmmcall bmi1 avx2 bmi2 xsaveopt

... while kcpuid shows the feature to be present in the CPU:

    # kcpuid -d | grep lahf
         lahf_lm             - LAHF/SAHF available in 64-bit mode

[ mingo: Updated the comment a bit, incorporated Boris's review feedback. ]

Signed-off-by: Max Grobecker <max@grobecker.info>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 79d2e17f6582e..425bed00b2e07 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -627,7 +627,7 @@ static void init_amd_k8(struct cpuinfo_x86 *c)
 	 * (model = 0x14) and later actually support it.
 	 * (AMD Erratum #110, docId: 25759).
 	 */
-	if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM)) {
+	if (c->x86_model < 0x14 && cpu_has(c, X86_FEATURE_LAHF_LM) && !cpu_has(c, X86_FEATURE_HYPERVISOR)) {
 		clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
 		if (!rdmsrl_amd_safe(0xc001100d, &value)) {
 			value &= ~BIT_64(32);
-- 
2.39.5



