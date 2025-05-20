Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F0624A076;
	Tue, 20 May 2025 14:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750627; cv=none; b=hXQhn7FRwagpe4pVbApqYiKN57tuzKFBF7NeJ93cw9fkihYhASUnXdQlK6f2O8kk8z5U9KDjFlqAcKDjbJsqzrnPcSlEQ2p3xePJVuQ8N2ZiBsh1wSZwQ376MPg8rkMHglAWkFGzG4Pu9ZnsKv/zjn7chighr09ZLTWyWLfHVD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750627; c=relaxed/simple;
	bh=OLD7ZOOI/ID77ewyY7tloYakpyUjzHyvxYrNW7oiZNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0F5UIxlRg3rEj1IbQks9PP1Q61x0PYSsyVXe35kTRR+i9Y8ym+vTG1M9Mu7ZT/ySckjOQmDVAjB4DJ4v0q5iazqCQWzkBlw0wEBgnfWtncZsRzJUr5N/UtaTqZOYgPkty/fj5AjysO/wwdAUgKshuNMoZH/twER9klNwWN6aeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bb4ki4Dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bb4ki4Dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC1DC4CEE9;
	Tue, 20 May 2025 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750626;
	bh=OLD7ZOOI/ID77ewyY7tloYakpyUjzHyvxYrNW7oiZNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bb4ki4DwEllRsMMtNwDh7SAINvPvhJosmwZ68/NHBjSD3nrC/5Pr6yz++CbG1DX2n
	 ZSNzblSUtP8HIHO62GsrWk35XhAQBfodnYzuA81OHWSsc/R+wy7yJz5Gp6vASkAsE+
	 W1tFMi1oI1EveWz5Fv2ZfydiL2q8Bqj2e5cq8Ao4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 069/145] LoongArch: Prevent cond_resched() occurring within kernel-fpu
Date: Tue, 20 May 2025 15:50:39 +0200
Message-ID: <20250520125813.282508073@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianyang Zhang <zhangtianyang@loongson.cn>

commit 2468b0e3d5659dfde77f081f266e1111a981efb8 upstream.

When CONFIG_PREEMPT_COUNT is not configured (i.e. CONFIG_PREEMPT_NONE/
CONFIG_PREEMPT_VOLUNTARY), preempt_disable() / preempt_enable() merely
acts as a barrier(). However, in these cases cond_resched() can still
trigger a context switch and modify the CSR.EUEN, resulting in do_fpu()
exception being activated within the kernel-fpu critical sections, as
demonstrated in the following path:

dcn32_calculate_wm_and_dlg()
    DC_FP_START()
	dcn32_calculate_wm_and_dlg_fpu()
	    dcn32_find_dummy_latency_index_for_fw_based_mclk_switch()
		dcn32_internal_validate_bw()
		    dcn32_enable_phantom_stream()
			dc_create_stream_for_sink()
			   kzalloc(GFP_KERNEL)
				__kmem_cache_alloc_node()
				    __cond_resched()
    DC_FP_END()

This patch is similar to commit d02198550423a0b (x86/fpu: Improve crypto
performance by making kernel-mode FPU reliably usable in softirqs).  It
uses local_bh_disable() instead of preempt_disable() for non-RT kernels
so it can avoid the cond_resched() issue, and also extend the kernel-fpu
application scenarios to the softirq context.

Cc: stable@vger.kernel.org
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/kfpu.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/arch/loongarch/kernel/kfpu.c
+++ b/arch/loongarch/kernel/kfpu.c
@@ -18,11 +18,28 @@ static unsigned int euen_mask = CSR_EUEN
 static DEFINE_PER_CPU(bool, in_kernel_fpu);
 static DEFINE_PER_CPU(unsigned int, euen_current);
 
+static inline void fpregs_lock(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_disable();
+	else
+		local_bh_disable();
+}
+
+static inline void fpregs_unlock(void)
+{
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		preempt_enable();
+	else
+		local_bh_enable();
+}
+
 void kernel_fpu_begin(void)
 {
 	unsigned int *euen_curr;
 
-	preempt_disable();
+	if (!irqs_disabled())
+		fpregs_lock();
 
 	WARN_ON(this_cpu_read(in_kernel_fpu));
 
@@ -73,7 +90,8 @@ void kernel_fpu_end(void)
 
 	this_cpu_write(in_kernel_fpu, false);
 
-	preempt_enable();
+	if (!irqs_disabled())
+		fpregs_unlock();
 }
 EXPORT_SYMBOL_GPL(kernel_fpu_end);
 


