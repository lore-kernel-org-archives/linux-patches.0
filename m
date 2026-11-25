Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620001;
	b=Zm8zeg52ezqG6Pz+RQtkH4xIPvMMFbe/HBoNSJHug0+ENazBpaNEcC4v6NVGdnW3XBFy
	 yaC58jXL2b8272ci99VnfqIViKdAAtB+Jitan3ajTA4zvVUxGwDrZN21PpdvRj1RQvDMy
	 5Y8MeJx+yetWsudA3AOlCWCV9bcKN8aIB+FrwqJu32cBURuSehmo4mW/8COi7zu8gXATE
	 SqOtQRN9C/wzwH1T7B6atQ2EVl1djfmW/j1Ol1kEQccmZwLUZaq5jHezM15talicJ0TjF
	 8lTnAoXJ/OAfNdIjg02mhpRyVbLVKwpR2Qs56kRiCE31IBuD2gDrsJmruKp9bb/GtKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37KatKu3ImRGd7stGJLdrLM6mHLaE/tFowVXPTED5Nk=;
	b=3h4H6CInQ58Q2ZwBnl+T5/+27llxdLSzUkbhTG7fk7n/b0ix0YdNZW+JXx/6ddOyjGx+
	 nfe9G7UsFAiuoCx5D+8G8uhEs6utkZ2JOiCSYIS1fOne04F5QEYjdHvkFJWpOpfbb6xor
	 A3cbH63RB9s7fB00U/PoCbQ5abv1plyv3niEIOOiDJHG0SPtJ0dROoQhx/L2r9u3NmvdC
	 budi0fCeSeZqw9m6t63aTrUdK7a70ZzXuZhtjs5g3W7qgO2lvikDJyJa5LPKnwm4wEWe1
	 zZDS3Ta4v3Us6246dMEcniaWYAmvZ2ycctDlQMtrsm0Kb2qEWUD5ChoUCMgOOlNaqMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d/2ziJ2l";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC05606A31E;
	Wed, 25 Nov 2026 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d/2ziJ2l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C310C1F000C0;
	Wed, 25 Nov 2026 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620001;
	bh=37KatKu3ImRGd7stGJLdrLM6mHLaE/tFowVXPTED5Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/2ziJ2l2iAnnv2eTAKnkMB3haudYdsJPA4gy5E3MlhGECGH4CVF02aCery/gbToA
	 Q/rpFGrREcWuJHVHjjstZUTCT8TdHKk8sXJ196sBk1QAaqZ3PWbzAApSrH1lwnwT8L
	 nVBCF81/s5R9zL75nBzT6PoZmog1RTiYLvai3BAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.3 0775/1005] LoongArch: kexec_file: Fix a modified cmdline leak
Date: Wed, 25 Nov 2026 15:35:13 +0100
Message-ID: <20261125143839.897889588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit b7000844b374a1ab75f0cc561f1d4d321cd6eeb0 upstream.

machine_kexec_prepare() copies it to KEXEC_CMDLINE_ADDR and overwrites
the pointer. Free the heap buffer after the copy here.

Cc: stable@vger.kernel.org
Fixes: d162feec6b6e ("LoongArch: Add preparatory infrastructure for kexec_file")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/machine_kexec.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/of_fdt.h>
 #include <linux/reboot.h>
+#include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 
@@ -56,6 +57,7 @@ int machine_kexec_prepare(struct kimage
 		 */
 		memcpy((void *)KEXEC_CMDLINE_ADDR, (void *)kimage->arch.cmdline_ptr,
 					strlen((char *)kimage->arch.cmdline_ptr) + 1);
+		kfree((void *)kimage->arch.cmdline_ptr);
 		kimage->arch.cmdline_ptr = (unsigned long)KEXEC_CMDLINE_ADDR;
 	} else {
 		/* Find the command line */


