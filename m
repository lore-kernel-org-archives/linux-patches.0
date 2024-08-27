Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E8812E4D;
	Tue, 27 Aug 2024 15:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771365; cv=none; b=dj11drkV6fx2msiwJpvGfI2Dad+NxUbMLqbmSxNXju4CjZEh1ersZZEhcmXtW28bNyrjcGzpGstuuUELkDtlGyK32NIIevtFEpByJk8qjpYR0iCz3IudlVsMFBjI8K9lH4ItW1NCucVUDLRfk0qpyxZbhvqFzdW3lm4VY+E0c6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771365; c=relaxed/simple;
	bh=QX+j5OUAKcyG07OrXWic3Mz1KLm5Sj20U3BPlnfHrBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5Qzw2yoMAyJXWk3NKRv47ZPHPGh/Spy2ZhmxvHIGw0SQYVpIM3HRhB9BNOy0FOASaKbtraMpgDBlcN0oNFoJTuOLPUkaAY0yvv4HoAIfhwQUpT8/5FBZ2TNPCRCSOImfERP8BFKY5pz36jCbitXWeRZf04svZCxictItTsIIXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EI0Sbv0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EI0Sbv0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE659C4AF18;
	Tue, 27 Aug 2024 15:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771365;
	bh=QX+j5OUAKcyG07OrXWic3Mz1KLm5Sj20U3BPlnfHrBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EI0Sbv0B+pkwAK3nUi0tf4pYZfs6hgvv2/mGhMlCQPC/770APwKExMim0B5u2RIfA
	 YqysnVDdE3wf3OjtenVklWkqZ8V65U7IETsvMrgsXaEzh7pw5N2YCO1c25pbo2MSGK
	 89tfvQ0z3ZfBAsCl1iN74MmBPr/uyyxiAss310m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 135/273] arm64: Fix KASAN random tag seed initialization
Date: Tue, 27 Aug 2024 16:37:39 +0200
Message-ID: <20240827143838.540692801@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit f75c235565f90c4a17b125e47f1c68ef6b8c2bce ]

Currently, kasan_init_sw_tags() is called before setup_per_cpu_areas(),
so per_cpu(prng_state, cpu) accesses the same address regardless of the
value of "cpu", and the same seed value gets copied to the percpu area
for every CPU. Fix this by moving the call to smp_prepare_boot_cpu(),
which is the first architecture hook after setup_per_cpu_areas().

Fixes: 3c9e3aa11094 ("kasan: add tag related helper functions")
Fixes: 3f41b6093823 ("kasan: fix random seed generation for tag-based mode")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/20240814091005.969756-1-samuel.holland@sifive.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/setup.c | 3 ---
 arch/arm64/kernel/smp.c   | 2 ++
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index a096e2451044d..b22d28ec80284 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -355,9 +355,6 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	smp_init_cpus();
 	smp_build_mpidr_hash();
 
-	/* Init percpu seeds for random tags after cpus are set up. */
-	kasan_init_sw_tags();
-
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 	/*
 	 * Make sure init_thread_info.ttbr0 always generates translation
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 5de85dccc09cd..05688f6a275f1 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -469,6 +469,8 @@ void __init smp_prepare_boot_cpu(void)
 		init_gic_priority_masking();
 
 	kasan_init_hw_tags();
+	/* Init percpu seeds for random tags after cpus are set up. */
+	kasan_init_sw_tags();
 }
 
 /*
-- 
2.43.0



