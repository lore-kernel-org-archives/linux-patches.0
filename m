Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC20810A31;
	Sat,  3 Feb 2024 04:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933474; cv=none; b=H6Dg22k7pyB+RvGVV8pisBrcOzxSUDUzA8qFIXsi7uqldRWPXkhc0YzylfBbIg7rYIPX3+BYJzUpPbOMFjVulVrYaCWZI5d9IvULxeGGYASpb6BPSxT7zHsku/FcCx5N7KiaqKTYvqjw/7jjW05dc6bQlnbviddAvP7HM5tZVVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933474; c=relaxed/simple;
	bh=IfibwIxtF1sIF9/qI5K+jrtligUv5BCcNZ9j2MR5aZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXxDBdyPJVD4J1/c1Tnl8l0XQmu1RqbcxwxaV17+vw/9XSuTX82YgET2UCqONUIMLRpTb2DUp3qZ2sOOK8VGERdYZD3kWIqFdX1b8ycSRQdqIsYLnD9aRty9oPsUd5/FTPOFVEiDHpcy1ZpFE0cCU7FfI0XGFfThNQKSNuPfqN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jq6Zzhhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jq6Zzhhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAD1C433C7;
	Sat,  3 Feb 2024 04:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933474;
	bh=IfibwIxtF1sIF9/qI5K+jrtligUv5BCcNZ9j2MR5aZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jq6ZzhhbvfaKaEYEHk+dESzDGhYt6FbbPFWK5F2+/nCkQK/QueIsB79g7Q0Tq9dAG
	 TcZD3f/8Ty0PtctF37gx7vbcT0a/Rvq8Hku0jZS/ia3MrpLAGhypcUIgmx6jjRnQqK
	 r3YO7HyjymMtN3q3ZF5FVojqlgwE7u1QAkv+VVRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 217/219] LoongArch/smp: Call rcutree_report_cpu_starting() at tlb_init()
Date: Fri,  2 Feb 2024 20:06:30 -0800
Message-ID: <20240203035347.163266681@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 5056c596c3d1848021a4eaa76ee42f4c05c50346 upstream.

Machines which have more than 8 nodes fail to boot SMP after commit
a2ccf46333d7b2cf96 ("LoongArch/smp: Call rcutree_report_cpu_starting()
earlier"). Because such machines use tlb-based per-cpu base address
rather than dmw-based per-cpu base address, resulting per-cpu variables
can only be accessed after tlb_init(). But rcutree_report_cpu_starting()
is now called before tlb_init() and accesses per-cpu variables indeed.

Since the original patch want to avoid the lockdep warning caused by
page allocation in tlb_init(), we can move rcutree_report_cpu_starting()
to tlb_init() where after tlb exception configuration but before page
allocation.

Fixes: a2ccf46333d7b2cf96 ("LoongArch/smp: Call rcutree_report_cpu_starting() earlier")
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/smp.c |    1 -
 arch/loongarch/mm/tlb.c     |   16 ++++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -473,7 +473,6 @@ asmlinkage void start_secondary(void)
 	sync_counter();
 	cpu = raw_smp_processor_id();
 	set_my_cpu_offset(per_cpu_offset(cpu));
-	rcu_cpu_starting(cpu);
 
 	cpu_probe();
 	constant_clockevent_init();
--- a/arch/loongarch/mm/tlb.c
+++ b/arch/loongarch/mm/tlb.c
@@ -271,12 +271,16 @@ void setup_tlb_handler(int cpu)
 		set_handler(EXCCODE_TLBNR * VECSIZE, handle_tlb_protect, VECSIZE);
 		set_handler(EXCCODE_TLBNX * VECSIZE, handle_tlb_protect, VECSIZE);
 		set_handler(EXCCODE_TLBPE * VECSIZE, handle_tlb_protect, VECSIZE);
-	}
+	} else {
+		int vec_sz __maybe_unused;
+		void *addr __maybe_unused;
+		struct page *page __maybe_unused;
+
+		/* Avoid lockdep warning */
+		rcu_cpu_starting(cpu);
+
 #ifdef CONFIG_NUMA
-	else {
-		void *addr;
-		struct page *page;
-		const int vec_sz = sizeof(exception_handlers);
+		vec_sz = sizeof(exception_handlers);
 
 		if (pcpu_handlers[cpu])
 			return;
@@ -292,8 +296,8 @@ void setup_tlb_handler(int cpu)
 		csr_write64(pcpu_handlers[cpu], LOONGARCH_CSR_EENTRY);
 		csr_write64(pcpu_handlers[cpu], LOONGARCH_CSR_MERRENTRY);
 		csr_write64(pcpu_handlers[cpu] + 80*VECSIZE, LOONGARCH_CSR_TLBRENTRY);
-	}
 #endif
+	}
 }
 
 void tlb_init(int cpu)


