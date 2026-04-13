Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795A226CE32;
	Mon, 13 Apr 2026 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096702; cv=none; b=mUs1v0gasQcRhnglbdLar8G4ZKjP8e3C14f2V81SxzlUyt3BHfBzFLvkzASvlulBK2wMYloH2dAGF+fZHtnzpE5QFzvFJWh2nxX+cCiMglFrdr0XR6FFqYi3ZRsKVXSGPm+OT1Jb166os4rDZI52c8Wj14aFYF6L4DeOZTl7mxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096702; c=relaxed/simple;
	bh=US/nLM1Xtlyl1VF4SMI8jUrDR3PbX7XJD29kIgQ6Uck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+FkYVCjSDI6OVHdIY+h7EknQFJEONamExwACvkr1GWw2fRBho3Hp4BFIVrbdFE/Kro5q1B1DAsgp02TbTMAnLm0nTS9eb0BD0y0WGoVxlfAgDNJr03NV2vpF7gFqOGHWbaIBRFGSEqerVdy7LiRV10JKn+UURfFdykE00CliNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDHVzQQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDHVzQQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F36C2BCAF;
	Mon, 13 Apr 2026 16:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096702;
	bh=US/nLM1Xtlyl1VF4SMI8jUrDR3PbX7XJD29kIgQ6Uck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDHVzQQe5QXZ6Q5pFUn2a8s5U5R9yt66NiIcOqNyw3wH0cqZmavTeElZ2DFxn3uEu
	 MOFuge2T7EynQebtNBq6MBPRostr/3/Ot8PwqZ2lj3K1S0i1H/ahDzM18zulBZ+UtG
	 psRUNHXxOFe6I2YC7fRmUlJ/JvEKYWotBuef6glk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 30/70] LoongArch: Handle percpu handler address for ORC unwinder
Date: Mon, 13 Apr 2026 18:00:25 +0200
Message-ID: <20260413155729.313688212@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 055c7e75190e0be43037bd663a3f6aced194416e ]

After commit 4cd641a79e69 ("LoongArch: Remove unnecessary checks for ORC
unwinder"), the system can not boot normally under some configs (such as
enable KASAN), there are many error messages "cannot find unwind pc".

The kernel boots normally with the defconfig, so no problem found out at
the first time. Here is one way to reproduce:

  cd linux
  make mrproper defconfig -j"$(nproc)"
  scripts/config -e KASAN
  make olddefconfig all -j"$(nproc)"
  sudo make modules_install
  sudo make install
  sudo reboot

The address that can not unwind is not a valid kernel address which is
between "pcpu_handlers[cpu]" and "pcpu_handlers[cpu] + vec_sz" due to
the code of eentry was copied to the new area of pcpu_handlers[cpu] in
setup_tlb_handler(), handle this special case to get the valid address
to unwind normally.

Cc: stable@vger.kernel.org
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
V2: Add upstream commit ID.

 arch/loongarch/include/asm/setup.h |    3 +++
 arch/loongarch/kernel/unwind_orc.c |   16 ++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/arch/loongarch/include/asm/setup.h
+++ b/arch/loongarch/include/asm/setup.h
@@ -7,6 +7,7 @@
 #define _LOONGARCH_SETUP_H
 
 #include <linux/types.h>
+#include <linux/threads.h>
 #include <asm/sections.h>
 #include <uapi/asm/setup.h>
 
@@ -14,6 +15,8 @@
 
 extern unsigned long eentry;
 extern unsigned long tlbrentry;
+extern unsigned long pcpu_handlers[NR_CPUS];
+extern long exception_handlers[VECSIZE * 128 / sizeof(long)];
 extern char init_command_line[COMMAND_LINE_SIZE];
 extern void tlb_init(int cpu);
 extern void cpu_cache_init(void);
--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -359,6 +359,22 @@ static inline unsigned long bt_address(u
 {
 	extern unsigned long eentry;
 
+#if defined(CONFIG_NUMA) && !defined(CONFIG_PREEMPT_RT)
+	int cpu;
+	int vec_sz = sizeof(exception_handlers);
+
+	for_each_possible_cpu(cpu) {
+		if (!pcpu_handlers[cpu])
+			continue;
+
+		if (ra >= pcpu_handlers[cpu] &&
+		    ra < pcpu_handlers[cpu] + vec_sz) {
+			ra = ra + eentry - pcpu_handlers[cpu];
+			break;
+		}
+	}
+#endif
+
 	if (ra >= eentry && ra < eentry +  EXCCODE_INT_END * VECSIZE) {
 		unsigned long func;
 		unsigned long type = (ra - eentry) / VECSIZE;


