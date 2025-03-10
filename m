Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581EE23371F;
	Mon, 10 Mar 2025 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626506; cv=none; b=pZ05EhQkD5gS+Ih3suSNPSZXawY622nDAfwHcHJ8EO7wO8WA+OKmcxGE2CSIzf+0Hl5M+T19GVNxyfBKc16nd8LkoxBDYzzW60XY8DnGeRjdutB7BmPTzOEalE9W/GFdlC3xU3s25GhL+vceKY+V5oSINr1ILWT3ERsJahzTYdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626506; c=relaxed/simple;
	bh=ni0x/c0G48L7YPdl1cF98K+iTsVbJeAHjgkOW82SZGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsJIvBSsjQbiB1qi2xl+9hGQjUH0NLURA4PUUnH+B73R/LVwpjDPTVgftpakD2Zx0+8L+9oeRuZhT+JVx02NUKAhkv4Bf6gtuZRGdMvN5Ei2r3rbUGuAwq/4DfWxadQtjNc+d2CCIgjmKHhiCLWvdyBe2lJtbw87m9S9XtbMMeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oaBXaOsk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oaBXaOsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DACC4CEEB;
	Mon, 10 Mar 2025 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626506;
	bh=ni0x/c0G48L7YPdl1cF98K+iTsVbJeAHjgkOW82SZGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oaBXaOskcXm9mgyXoqq2ZBHsMNzZbY4dwG81DmI8oRDp+JJAeE/zFxH38lRUCT8k7
	 LEwZ/jhq3J1GVJs9tjjP2CDaP34qcTg8xAhDus8SLgGxPIZcMhMaYPrkfUDaP0db6z
	 IajrwNAoS3KpEkxEt++iQppKMGxstF6m8xkktOGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 016/207] LoongArch: KVM: Reload guest CSR registers after sleep
Date: Mon, 10 Mar 2025 18:03:29 +0100
Message-ID: <20250310170448.415310225@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 78d7bc5a02e1468df53896df354fa80727f35b7d upstream.

On host, the HW guest CSR registers are lost after suspend and resume
operation. Since last_vcpu of boot CPU still records latest vCPU pointer
so that the guest CSR register skips to reload when boot CPU resumes and
vCPU is scheduled.

Here last_vcpu is cleared so that guest CSR registers will reload from
scheduled vCPU context after suspend and resume.

Cc: stable@vger.kernel.org
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/main.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -299,6 +299,13 @@ int kvm_arch_enable_virtualization_cpu(v
 	kvm_debug("GCFG:%lx GSTAT:%lx GINTC:%lx GTLBC:%lx",
 		  read_csr_gcfg(), read_csr_gstat(), read_csr_gintc(), read_csr_gtlbc());
 
+	/*
+	 * HW Guest CSR registers are lost after CPU suspend and resume.
+	 * Clear last_vcpu so that Guest CSR registers forced to reload
+	 * from vCPU SW state.
+	 */
+	this_cpu_ptr(vmcs)->last_vcpu = NULL;
+
 	return 0;
 }
 


