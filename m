Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065615;
	b=afafLjQ8n8aehk7N++lxr81ICoXmNHNFKz9I+9h89TR+wbzcr+pyIKvW6tv0c83hdYrn
	 T8HVbvVQgxzQ6MYIDE/btw4J2o0N7Qjjxi7bS1IdFDmtm+NoMuSRQsmvVLNlUFX5T0doa
	 EIQSOTSYgE51yIXLjgOs8wVcEuILj0aWYzEQLjbR4cHjlfcpHs1aj7BVBxzBled2V937h
	 kP61LXs6H8qhBPxfwz5bOTGKb3Ok/CspnWvqeFLiQ4Tau4D6YtvNguP/FNB0YW9wUKcD1
	 778ausgUKECda8OfNHff0iWLozC5OK4Nsrh7RgHxHvIZihPHFj/peVViLUsJyXQoLdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UGicuBDBQf1C5kaTOA3T2PNGZqal4IrChH4F0RIvers=;
	b=Sno2T0F4DRWVbodBg1OwG/Orq9uFWumX9ODVa5x4lRkac6M7yfGCQoneTrjLkF6ree39
	 sCzGM+LchrDq+Rbh9kuA40WKsQrDwmpPDNAYkh0oBnZoeaFqNsiR/dsiWcohg60Ob5h7Q
	 lFKYK84AwmM8Giosg7XVVKGDNaBJUllUjhbZ/wtM+mmLz4BkKZBqpnwnJcCGWrj8YBAWK
	 XhWtsX5HmuXHtnY2H/aAoEwEgMO21rXGf7XQ71GxrXMD3Nl4fvpOrHdeVtcbd7bm7zSF2
	 JKgJvMquY0aLbp+lkpOFlaA/2TVF+kIMJUyCSK+Cl/f+XfweD9KWcUYPDbH1SVYp92g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZcBjyl8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF507606A33F;
	Sat,  7 Nov 2026 15:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZcBjyl8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801501F008A5;
	Sat,  7 Nov 2026 15:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065614;
	bh=UGicuBDBQf1C5kaTOA3T2PNGZqal4IrChH4F0RIvers=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZcBjyl8f256gypuHBhQuo4B9rVtcO4tLUQZyrwnlwkYphW4SQLdHGpvDl6IgHCUH0
	 HPeDO6fW3cO/LeIGbGqiL4uwZHwZx/C5Tpfkh6MQHRxxqkJySu2snVezQY+duppQPv
	 ohIQw9MsaF11SHIKvTbFQHrthZanO8Epyn+BROv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1244/1257] arm64/gcs: release GCS on failed fork
Date: Sat,  7 Nov 2026 08:59:00 -0500
Message-ID: <20261107135013.686248118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>

[ Upstream commit 078e122f3bf000dd45965997b66deac10ee580fa ]

copy_thread() can map a CLONE_VM GCS and still return 0. A later
copy_process() failure calls exit_thread(), but arm64 did not
implement it, so the VMA stayed in the parent's mm. Wire
HAVE_EXIT_THREAD to gcs_free().

Kernel threads created with CLONE_VM (io_uring and vhost workers)
inherit the parent's gcs_base/gcs_size from arch_dup_task_struct()
without allocating their own GCS. When such a thread exits,
exit_mm() -> mm_release() -> deactivate_mm() -> gcs_free() unmaps the
parent's GCS. With the new exit_thread(), a failed copy_process() for
one of these threads would do the same. Clear these fields in
copy_thread().

Fixes: 506496bcbb42 ("arm64/gcs: Ensure that new threads have a GCS")
Cc: stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>
Assisted-by: LLM
Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig          |  1 +
 arch/arm64/kernel/process.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index cab741a695f52..70994918fab55 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -198,6 +198,7 @@ config ARM64
 	select HAVE_SAMPLE_FTRACE_DIRECT_MULTI
 	select HAVE_BUILDTIME_MCOUNT_SORT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
+	select HAVE_EXIT_THREAD
 	select HAVE_GUP_FAST
 	select HAVE_FTRACE_GRAPH_FUNC
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 581f80e9b9b73..42b15b0c069ff 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -320,9 +320,18 @@ static int copy_thread_gcs(struct task_struct *p,
 	return 0;
 }
 
+static void gcs_reset_thread(struct task_struct *task)
+{
+	task->thread.gcs_base = 0;
+	task->thread.gcs_size = 0;
+	task->thread.gcspr_el0 = 0;
+}
+
 #else
 
 static void flush_gcs(void) { }
+static void gcs_reset_thread(struct task_struct *task) { }
+
 static int copy_thread_gcs(struct task_struct *p,
 			   const struct kernel_clone_args *args)
 {
@@ -341,6 +350,12 @@ void flush_thread(void)
 	flush_gcs();
 }
 
+void exit_thread(struct task_struct *tsk)
+{
+	/* Failed fork after copy_thread(); deactivate_mm() does not run. */
+	gcs_free(tsk);
+}
+
 void arch_release_task_struct(struct task_struct *tsk)
 {
 	fpsimd_release_task(tsk);
@@ -503,6 +518,8 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 
 		p->thread.cpu_context.x19 = (unsigned long)args->fn;
 		p->thread.cpu_context.x20 = (unsigned long)args->fn_arg;
+		/* Kernel threads sharing the parent's mm must not free its GCS. */
+		gcs_reset_thread(p);
 
 		if (system_supports_poe())
 			p->thread.por_el0 = POR_EL0_INIT;
-- 
2.53.0



