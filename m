Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15FC15F41B;
	Tue, 27 Aug 2024 14:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770137; cv=none; b=PecBJUBON4zoggE311Qv/+ItG5p2EKSu5OpzGwIknNUsGZhq7gLWqS2psbpZgYD2+E7M9KAItDCTMPjF0SU6zn0z/7cSeMeJ4ryqxF+Kd7eCaMJNm3gJJ1rZcueoArgCLieXX0q5qRZXiiiq6l3Zc7P71SWQdDABhHegc24Js4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770137; c=relaxed/simple;
	bh=asdvhJhx+Fb5IBU5n6nKPnA6xBrNR4jx82FwpTNEoXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXaGiuW/mLUEL3oVqVA2oXnmZzGV0npBJFikojJ6Ba8+NJRJFHvn2VdKUREyB0C0YM9k3DWFGV558bkl/oyq05Xbg4/n7OL6wCi0dt+3XYwheLwIcMdOVP95qkxNl+esQWu+evPm47iE1HNum95+hd3y/DO+m61g50T+tk/tfWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UxzKSis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UxzKSis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D3DC61047;
	Tue, 27 Aug 2024 14:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770137;
	bh=asdvhJhx+Fb5IBU5n6nKPnA6xBrNR4jx82FwpTNEoXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UxzKSissq4JG4YsWoK8oq+mALAWfB/WNwmtY5Lg/1GQUlO5ECOURwayO686wRAGm
	 4rdB4rTPJztP8k+vc1MUhTrv4H1HY4UR1J2N43KT+BbRjXe9tw0PBtYRBvjGTyeDut
	 lR6KaKrGqXI5CYjhbk1X/iQkDYq6sPYjbwAbIlCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/341] arm64: Fix KASAN random tag seed initialization
Date: Tue, 27 Aug 2024 16:36:09 +0200
Message-ID: <20240827143848.670165376@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index 417a8a86b2db5..c583d1f335f8c 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -371,9 +371,6 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	smp_init_cpus();
 	smp_build_mpidr_hash();
 
-	/* Init percpu seeds for random tags after cpus are set up. */
-	kasan_init_sw_tags();
-
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 	/*
 	 * Make sure init_thread_info.ttbr0 always generates translation
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 960b98b43506d..14365ef842440 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -459,6 +459,8 @@ void __init smp_prepare_boot_cpu(void)
 		init_gic_priority_masking();
 
 	kasan_init_hw_tags();
+	/* Init percpu seeds for random tags after cpus are set up. */
+	kasan_init_sw_tags();
 }
 
 /*
-- 
2.43.0



