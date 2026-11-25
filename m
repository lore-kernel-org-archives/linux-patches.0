Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623236;
	b=j6HbpNWfs9vLmfCVgeo2Cj05ygrCPcjJNDwnTSHuC4zn2Qclk7FtndLdRH0nGSrnfH3H
	 4u+ZafPOnOI0hkZIodmjbHjbmBwJOZDAj7zzJWqSy2QepB0eIfhjhxQmUgfRN2hZBO2BO
	 7QDVkf/s3L9ABWZCO3xRNKnHc/aZzs9MzPZkjkMFDRfxHjBbBNmgVCAB/MoP9zgRlzRtb
	 Q9KzejNVjebnxhWaCsyoix6wdVq6zknfBXQM55QRcHoFj42zfUmU+DpLFJ7oOQMfyegbf
	 2zsuyD/JCgJrjfrLfI5aehJPxFk0N3WzQWrtOGnrwVOU/X2K0SUghYDUFWTxAqtbbcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Afymv0xQiTTNAwHfrWP75QE8sWbmp8bWUAPTnI9OQQQ=;
	b=rsK9edDMO/ZQ+997vRQfhIiEqJ38Rxlf9g+N2Fh5NGzOigNnzl+Dk7vinJ6ALPVWbg2q
	 HJw6DUxidk/z86GRF0MIN36Eg0LduFdGqKMzaXYq1an6XdbFtwOQGun3mCBh6EnNl3ggF
	 3lCoe81nnHgB9y7+a7JA6QZAnAv93C5NPr4tkylee23TXapl15LsLtHZRNRxjScyqVUbH
	 +HfJoRa/SSwpwPB272JW85Z8UoHjJ7lmHMQWWwwWaYoDmohdvX8BHO4dL3AfOwOWOCQH+
	 UZwtPNUOlCt56SDGBiC9D5meUYujdtZEcWCyxA/In9diRJVJU70YtkDw+7V3X7EXh2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E0mJfLIh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7894606A332;
	Wed, 25 Nov 2026 16:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E0mJfLIh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E741F000CF;
	Wed, 25 Nov 2026 16:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623236;
	bh=Afymv0xQiTTNAwHfrWP75QE8sWbmp8bWUAPTnI9OQQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E0mJfLIhUpFOBPJx+s/89JDdW1RIcybiGRd9m2+8yUZUAaJEZv+4mgNPnEGMMEBkE
	 btzxJKnGTytyx0Sl576mJVbeg3wpsqIERUv8YkEAWRytLfBQWtHOWwZv6KfaLbfvpt
	 I9MMGY5zWVALZnCtFW8++DnFAEg6Edf913JRUymw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 795/990] LoongArch: kexec_file: Fix a modified cmdline leak
Date: Wed, 25 Nov 2026 15:36:02 +0100
Message-ID: <20261125143840.667771501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 arch/loongarch/kernel/machine_kexec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/kernel/machine_kexec.c b/arch/loongarch/kernel/machine_kexec.c
index 1883cae93bc3..19ccc91b6f2a 100644
--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -14,6 +14,7 @@
 #include <linux/mm.h>
 #include <linux/of_fdt.h>
 #include <linux/reboot.h>
+#include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 
@@ -56,6 +57,7 @@ int machine_kexec_prepare(struct kimage *kimage)
 		 */
 		memcpy((void *)KEXEC_CMDLINE_ADDR, (void *)kimage->arch.cmdline_ptr,
 					strlen((char *)kimage->arch.cmdline_ptr) + 1);
+		kfree((void *)kimage->arch.cmdline_ptr);
 		kimage->arch.cmdline_ptr = (unsigned long)KEXEC_CMDLINE_ADDR;
 	} else {
 		/* Find the command line */
-- 
2.56.1



