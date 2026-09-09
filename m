Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3087652ED5E;
	Wed,  9 Sep 2026 14:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962557; cv=none; b=PVcXU0C4Br+6FoBM0cLQxhJkF9cJSXrx74oQdQh3H/JSWjiOX5WeYpGLFeswYhANjLypmUvC8AnpOcqdCwaaG4s5ViJBiOEdPwWrU7GowD5Ro2FnLPYT9xh8c9ipGwjNsaG5FNAgNS8ltH62Brbqmc8Z0/axPj0BdkzE8yvq4/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962557; c=relaxed/simple;
	bh=zv+mRF26LDaZcmNq2zzub01eIoWHuWuIOuEq3nSMeAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eI9Fa9fYjL3p/YX13Q2MDGa42vMgreMZ1xuGpD7454XY/U577czn9AnlUM+kQvNtVa6Y4q7eSPqsOpqoGtimVTGWTMUqXsZdaVf06KTIJy+UKFOMfIVqUzVOCaN0oay27fwSKex/w2KXy3EajQ7UW9i4Lejcwzeiy2RMP+iCXrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J17ZEs2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J17ZEs2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6D31F00A3A;
	Wed,  9 Sep 2026 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962556;
	bh=fh7rtaVDQ7GS33eANwvEeueMJL8hBTT715Sdiisy7fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J17ZEs2gv9OGTd+nXIhzjy7XpffaJfYpqSYwbpWz2tYbFu26eNtkpXF/8qa5gYwfl
	 jZkXvJJJkTL8aPVY7TlLNHk7ZzW99y7Jg/HAflQBfCDqW7PzQRSrnXRbWoBh50+Xro
	 USWlBDexup0/m0QZ3Hu6utfHtpsSvPr+tCWlMUBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 330/556] LoongArch: KVM: Fix resource leak in kvm_loongarch_env_init() error path
Date: Wed,  9 Sep 2026 15:40:10 +0200
Message-ID: <20260909134242.263717491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

commit 910132bc7d72f26a8b288c2a38c32445a48d5be0 upstream.

kvm_loongarch_env_init() allocates the per-CPU kvm_context (vmcs) and
kvm_loongarch_ops, registers the perf callbacks, and then registers
the IPI/EIOINTC/PCH-PIC/DMSINTC KVM devices. If any of those device
registrations fails, the function returned the error directly, leaving
everything acquired so far in place: vmcs and kvm_loongarch_ops are
never freed, the perf callbacks stay registered, and all previously
registered KVM device operations remain registered. kvm_loongarch_init()
propagates the errors without calling kvm_loongarch_env_exit(), so
nothing else cleans up either.

Unwind the error path in reverse order of registration, so that each
failure only undoes what had actually been set up. Use the same helpers
in kvm_loongarch_env_exit() to remove the device registrations during
normal teardown as well.

Cc: stable@vger.kernel.org
Fixes: c532de5a67a7 ("LoongArch: KVM: Add IPI device support")
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/main.c |   33 +++++++++++++++++++++++++++++----
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -385,27 +385,52 @@ static int kvm_loongarch_env_init(void)
 	/* Register LoongArch IPI interrupt controller interface. */
 	ret = kvm_loongarch_register_ipi_device();
 	if (ret)
-		return ret;
+		goto err_env;
 
 	/* Register LoongArch EIOINTC interrupt controller interface. */
 	ret = kvm_loongarch_register_eiointc_device();
 	if (ret)
-		return ret;
+		goto err_ipi;
 
 	/* Register LoongArch PCH-PIC interrupt controller interface. */
 	ret = kvm_loongarch_register_pch_pic_device();
 	if (ret)
-		return ret;
+		goto err_eiointc;
 
 	/* Register LoongArch DMSINTC interrupt contrroller interface */
-	if (cpu_has_msgint)
+	if (cpu_has_msgint) {
 		ret = kvm_loongarch_register_dmsintc_device();
+		if (ret)
+			goto err_pch_pic;
+	}
+
+	return 0;
+
+err_pch_pic:
+	kvm_loongarch_unregister_pch_pic_device();
+err_eiointc:
+	kvm_loongarch_unregister_eiointc_device();
+err_ipi:
+	kvm_loongarch_unregister_ipi_device();
+err_env:
+	kvm_unregister_perf_callbacks();
+	kfree(kvm_loongarch_ops);
+	kvm_loongarch_ops = NULL;
+	free_percpu(vmcs);
+	vmcs = NULL;
 
 	return ret;
 }
 
 static void kvm_loongarch_env_exit(void)
 {
+	if (cpu_has_msgint)
+		kvm_loongarch_unregister_dmsintc_device();
+
+	kvm_loongarch_unregister_pch_pic_device();
+	kvm_loongarch_unregister_eiointc_device();
+	kvm_loongarch_unregister_ipi_device();
+
 	if (vmcs)
 		free_percpu(vmcs);
 


