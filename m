Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56F1344DB5;
	Thu, 12 Mar 2026 20:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346869; cv=none; b=QTtRS5RsWhWSTFbL1U3wQwop7JoVCx0Ej/nXBA4fEUEm6bW9RGcQ6BgONmtZpPrCF19M0R2yvxbcYSNx1VKGz1ZkNxXPfKROQ8q6RrDj9hPiws7hDePD9HflRTqa5Zn/D06AtKKvSSh8lFmHWM8OsYiKIrf8w0u2dfjHyLqS9dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346869; c=relaxed/simple;
	bh=B5vuYVB214vlIyuXA9+X42BH+pKvrvY3UNMfNE6N9wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3A4rjPToiI00jB6MFN3MTe4q5c5GuGu/noQi4Y05t0Y2QqtspfCrWoPY0pvJTMrCMazcJMWVygSzyd+FTl96kptiUZeyslp+Iwm9pXbziBle9ZC7V0Wk3TAnqAPX7clAM6fux3uKRDMhlzaHj8WBpJDdy1P2ZQhDAs6P3CwkNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdgHk7oF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdgHk7oF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04457C4CEF7;
	Thu, 12 Mar 2026 20:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346869;
	bh=B5vuYVB214vlIyuXA9+X42BH+pKvrvY3UNMfNE6N9wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdgHk7oFIjkT0J5GkNrA4mCb5/KFhcV2ppxhfSX6+x8gQ3GATw/+3a+hgMGSUXDXZ
	 t/cxsiQkDFYTBX+CBza1SbJHItQUR4PI0Fq9E3ceL++eeN0V8tbJMjz7cJ8+hWu+rf
	 o/ZdIq96qhMXAtBf8/crOb9tkvOE+izyc74btkPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/265] LoongArch: Handle percpu handler address for ORC unwinder
Date: Thu, 12 Mar 2026 21:08:27 +0100
Message-ID: <20260312201022.576760383@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/setup.h |  3 +++
 arch/loongarch/kernel/unwind_orc.c | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/arch/loongarch/include/asm/setup.h b/arch/loongarch/include/asm/setup.h
index 3c2fb16b11b64..f81375e5e89c0 100644
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
diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel/unwind_orc.c
index 4924d1ecc4579..9512fa4fff0f9 100644
--- a/arch/loongarch/kernel/unwind_orc.c
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -359,6 +359,22 @@ static inline unsigned long bt_address(unsigned long ra)
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
-- 
2.51.0



