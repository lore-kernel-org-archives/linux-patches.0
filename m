Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA5526AE8;
	Sun,  1 Sep 2024 17:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210027; cv=none; b=O2OSJzM3HxtFSCjo9K5zgPF4367O/ysM19oGhAU1e3nD5SEm5ZxhdoOKXtkBJWzlo3E9gWRaP6/GCchDwLj3TtbW79tPQ6yLr4Ps98Y467Ng8+s4VQo1weTdlkfE2GszGKdpegINlVd6U63SIN74ENJJ0NTm7GdyfEQTyblsllk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210027; c=relaxed/simple;
	bh=lttV5aAqU/UeEqYz/tTjsGMAOMNThwxuM/DpAPz2j2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTuRm5gaSiudrl/PNtLM24meWjPLdE0HukN6l9PhhTh1EHsPKjnOgbuxvoYnNmLEfd66/KjOIM5MeI65tDRen6biClFUrZ7KqT9BNXMq6TS0zOqath50B0tJmL8skTLUGRK1rLczOTTbl/NvcnTLKiMmHvNweZTnMcxSuZNdRjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KeRB+vo3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KeRB+vo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA859C4CEC3;
	Sun,  1 Sep 2024 17:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210027;
	bh=lttV5aAqU/UeEqYz/tTjsGMAOMNThwxuM/DpAPz2j2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KeRB+vo3hfJqPzUKqY7xQsF+kNOknQjC1mpiHRD4hwy/wl88dmEIxAoJYT+uGH2z1
	 efL/ltmMuZwS39lUDMHvcCZvVtvzcoTjvQSlFtBWcJiwng4sDmnKim+Qx56AEysb9q
	 /jJXPC9umxuYMNWg/q+nIcR6IKAPCL0j8jLv9pj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/215] arm64: Fix KASAN random tag seed initialization
Date: Sun,  1 Sep 2024 18:16:16 +0200
Message-ID: <20240901160825.774057847@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index be5f85b0a24de..6a9028bfd0434 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -364,9 +364,6 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	smp_init_cpus();
 	smp_build_mpidr_hash();
 
-	/* Init percpu seeds for random tags after cpus are set up. */
-	kasan_init_sw_tags();
-
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 	/*
 	 * Make sure init_thread_info.ttbr0 always generates translation
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index bc29cc044a4d7..47684a03c42f8 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -464,6 +464,8 @@ void __init smp_prepare_boot_cpu(void)
 		init_gic_priority_masking();
 
 	kasan_init_hw_tags();
+	/* Init percpu seeds for random tags after cpus are set up. */
+	kasan_init_sw_tags();
 }
 
 static u64 __init of_get_cpu_mpidr(struct device_node *dn)
-- 
2.43.0



