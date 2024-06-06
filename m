Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16881A0B0D;
	Thu,  6 Jun 2024 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683655; cv=none; b=rVR/X96e3/fwVhN1Rq/l2lMjPM6SX8LdxED440Qb/PDSlocBXh3KvcjKr1Vz/EXEDXG7FEAICvqtN7xtV1ir6cXSY462EqkOSHilQunWP5L0bh948k6HZUwsLGbgCe0mkv5k4+HDHbAlFXqgbH3txGnhZyLqsbjeHmP13rfiroo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683655; c=relaxed/simple;
	bh=iKEQAkj5QJJsCJDfXNdTCPUb4M/BOTfPXDCY2s4qKvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QI1xnTTJyhr6X07REZnQYZeZ/06qNrcKoMzRFpwI7G3vmuYiITeMY7TLQlW2vBmbbsWK9iLK+8MJKYh5+RGP6VNkwFXTjKUSnDhElB6rLMS8E0waLerxd5XNyCTBHLSWP2lObo5pMbCLjJmpwr1GC+IH6cKU6bX/vi4nQ96Mo6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNGSfk1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNGSfk1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A044DC2BD10;
	Thu,  6 Jun 2024 14:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683655;
	bh=iKEQAkj5QJJsCJDfXNdTCPUb4M/BOTfPXDCY2s4qKvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNGSfk1eEP5KE3msIMpOyFknqU48rrQgdNJNkNVmfLH2k3FRAHFwwINy2rd6eFU7M
	 dBSTV2TJohvYQnwbNk++KQdQ7/d+ifVAq0i6pCkJIg4o1Jpl2qqDcSomNrh2NkaFim
	 SKa2q2E1ltyuThqaotJTLz28rkggbHBHiE9wLw5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 532/744] LoongArch: Fix callchain parse error with kernel tracepoint events again
Date: Thu,  6 Jun 2024 16:03:24 +0200
Message-ID: <20240606131749.512670641@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit d6af2c76399f98444a5b4de96baf4b362d9f102b ]

With commit d3119bc985fb645 ("LoongArch: Fix callchain parse error with
kernel tracepoint events"), perf can parse kernel callchain, but not
complete and sometimes maybe error. The reason is LoongArch's unwinders
(guess, prologue and orc) don't really need fp (i.e., regs[22]), and
they use sp (i.e., regs[3]) as the frame address rather than the current
stack pointer.

Fix that by removing the assignment of regs[22], and instead assign the
__builtin_frame_address(0) to regs[3].

Without fix:

  Children      Self  Command        Shared Object      Symbol
  ........  ........  .............  .................  ................
  33.91%    33.91%    swapper        [kernel.vmlinux]   [k] __schedule
            |
            |--33.04%--__schedule
            |
             --0.87%--__arch_cpu_idle
                       __schedule

With this fix:

  Children      Self  Command        Shared Object      Symbol
  ........  ........  .............  .................  ................
  31.16%    31.16%    swapper        [kernel.vmlinux]   [k] __schedule
            |
            |--20.63%--smpboot_entry
            |          cpu_startup_entry
            |          schedule_idle
            |          __schedule
            |
             --10.53%--start_kernel
                       cpu_startup_entry
                       schedule_idle
                       __schedule

Fixes: d3119bc985fb645 ("LoongArch: Fix callchain parse error with kernel tracepoint events")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/perf_event.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/loongarch/include/asm/perf_event.h b/arch/loongarch/include/asm/perf_event.h
index 52b638059e40b..f948a0676daf8 100644
--- a/arch/loongarch/include/asm/perf_event.h
+++ b/arch/loongarch/include/asm/perf_event.h
@@ -13,8 +13,7 @@
 
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->csr_era = (__ip); \
-	(regs)->regs[3] = current_stack_pointer; \
-	(regs)->regs[22] = (unsigned long) __builtin_frame_address(0); \
+	(regs)->regs[3] = (unsigned long) __builtin_frame_address(0); \
 }
 
 #endif /* __LOONGARCH_PERF_EVENT_H__ */
-- 
2.43.0



