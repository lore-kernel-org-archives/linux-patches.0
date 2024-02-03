Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5372612E6D;
	Sat,  3 Feb 2024 04:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933721; cv=none; b=Z4ZAxHhH5mgu362MxjuSFyx0q5CKsKSV/6kThQi2cVeWv9AFJTtqXJSneB047hcMXNqNqOI7PXcHv5x5Uymg/czOg0tHIDvjpH5oyhFmGYCz8VmfQAZUs5alVIYM8uIy8hkTzjwQYNoRWRlTcd3SKQF5n2jVv8/jjHgD1KpflZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933721; c=relaxed/simple;
	bh=pEv86BzAivXO6GG4qpR7So2cmGwf+F2yi+Ic5kMGQfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNk23YdxrFrr0oq1t5Ja1EjLMwL7RWf5IUDoGPllo3envZyAOmBVRZmd5zMhQ0aJNtr/d3a2i0/7TCAdIW+1aVg2a87nLfATQcyBr1RNAMT1WRIlc5/b/OLKSdZ0LKhKEPy1+O5AjVdp+fFOa2sN6m78OQjZcK2yKxFvDlsMQjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E3nVOsw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E3nVOsw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168D2C43390;
	Sat,  3 Feb 2024 04:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933721;
	bh=pEv86BzAivXO6GG4qpR7So2cmGwf+F2yi+Ic5kMGQfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E3nVOsw4dGFKjHJUJrJzL87qElcaaEgAidCQpQfmtPEIuuXuTr0z4bJTNJS75FA3/
	 P44m+NqvAj9uRV8kV0Wahr632KC63JUsUkbEWLakWPdkjmbwQ4L6bMWFFeLtSzvtU7
	 PkKQodDy2isILely48zND8CipslxV973HllWyY+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 320/322] LoongArch/smp: Call rcutree_report_cpu_starting() at tlb_init()
Date: Fri,  2 Feb 2024 20:06:57 -0800
Message-ID: <20240203035409.374589337@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
@@ -506,7 +506,6 @@ asmlinkage void start_secondary(void)
 	sync_counter();
 	cpu = raw_smp_processor_id();
 	set_my_cpu_offset(per_cpu_offset(cpu));
-	rcu_cpu_starting(cpu);
 
 	cpu_probe();
 	constant_clockevent_init();
--- a/arch/loongarch/mm/tlb.c
+++ b/arch/loongarch/mm/tlb.c
@@ -284,12 +284,16 @@ static void setup_tlb_handler(int cpu)
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
@@ -305,8 +309,8 @@ static void setup_tlb_handler(int cpu)
 		csr_write64(pcpu_handlers[cpu], LOONGARCH_CSR_EENTRY);
 		csr_write64(pcpu_handlers[cpu], LOONGARCH_CSR_MERRENTRY);
 		csr_write64(pcpu_handlers[cpu] + 80*VECSIZE, LOONGARCH_CSR_TLBRENTRY);
-	}
 #endif
+	}
 }
 
 void tlb_init(int cpu)


