Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63FC1C6F57;
	Tue, 27 Aug 2024 15:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772214; cv=none; b=jKVQbDalJtdbYZA0Dj2AyKbwzfE19adqcMaG7PFIP7NcBy7lT3tkRn292+fgixel5bynStPo1dIpOo72Dc6DNhLQbsxJVEXTO+AEwlDwEpGaXHy8hMkeMtJ+AsEhQY6xBjc662tQFFJ+2gC6xOUEWZalWO4v7lpAHfymUivn2Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772214; c=relaxed/simple;
	bh=Elvz1pksPEEBT6aF9bdz+BXW4TcHuF2wHIMviPk1ulk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPLfTey8bN8232RayVlTmhkulYObZu7mgP5DoVxyNXVaWMNduDsNPpDnT1GQUt1Wm/GUX08JpEhkYjYzmlH3kwK4CwFcpnZkCSR4k5Gvy90G8ZtspJRD+nkoVV2YdDSVkW/ruZwvkBAvuenxnGEfAcR1algpT2za9CjIPwwIfSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aih1N8o/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aih1N8o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7955C61064;
	Tue, 27 Aug 2024 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772214;
	bh=Elvz1pksPEEBT6aF9bdz+BXW4TcHuF2wHIMviPk1ulk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aih1N8o/K89cVQEAciIx1sDH+qr+pENTfT3eFqTdGuac1gsYYcu8qwl+EezQUmps5
	 C3QMMioIq+WYBUuTPgTV0o/n0YsllyW73We8u+aiMHH4Zaroe/dUWnrSW5mVYbJNQz
	 1fwE1ss+QZlsLUgtdGrmtQwTSuijpQMxNZpFJw3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/321] arm64: Fix KASAN random tag seed initialization
Date: Tue, 27 Aug 2024 16:37:36 +0200
Message-ID: <20240827143843.870716007@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index fea3223704b63..44c4d79bd914c 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -360,9 +360,6 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	smp_init_cpus();
 	smp_build_mpidr_hash();
 
-	/* Init percpu seeds for random tags after cpus are set up. */
-	kasan_init_sw_tags();
-
 #ifdef CONFIG_ARM64_SW_TTBR0_PAN
 	/*
 	 * Make sure init_thread_info.ttbr0 always generates translation
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index d323621d14a59..b606093a5596c 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -464,6 +464,8 @@ void __init smp_prepare_boot_cpu(void)
 		init_gic_priority_masking();
 
 	kasan_init_hw_tags();
+	/* Init percpu seeds for random tags after cpus are set up. */
+	kasan_init_sw_tags();
 }
 
 /*
-- 
2.43.0



