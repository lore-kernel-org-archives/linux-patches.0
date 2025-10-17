Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5C4335073;
	Fri, 17 Oct 2025 15:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714293; cv=none; b=EIy7x4+eaeVlgfpUsi2E+599uAddvBmR4ZHqGP9/p63hqrHTQxdZj60FqLTsof2oiKQGGFaMky+oTAbZU4dSInX3dhCeMTkfQ8XKQxSXJFA5qYQhpF5A1iwnpPqTYjIuMsQULkKrcJWigfxh2cVXMDKZpShkRPpuFk2Zk7GTC0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714293; c=relaxed/simple;
	bh=zn2DIl2RFt3FWZcHjzBvEcKjCI9D92HHkM8dsEWstaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TThgrqRrfUH0F3R9YWx/sUQeqMancBfBHBrzP24nnt52T/TxlLm9VBPQc7y0y275j2p7UsL1MAKxBKMIc0IuhsowJiSI/ET/zUrZtJTeLQ2XkABQZvoNCCGXbwz/XOWfxaz7HcXiZ+AI3yF3ZH3I2iVzJrKDbNwaidqUxwgALDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uF6cYKqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uF6cYKqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0351EC4CEE7;
	Fri, 17 Oct 2025 15:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714293;
	bh=zn2DIl2RFt3FWZcHjzBvEcKjCI9D92HHkM8dsEWstaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uF6cYKqzt1wFx8eqA1aWzFBR84AbfPlLZF+7Wed9xWt43uXDKrs2m9JTA4NRmgA2L
	 2x7Zi+eHc9frn3m/67I/Qh3JsWeKm9PcwYlz2ggcjS0aPBi2G9S7Cun9LDROzgrpY9
	 cLdUoxcXtEVwXS1A3DHstrYJ2JnftaW9ZgRxbGtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 093/277] arm64: kprobes: call set_memory_rox() for kprobe page
Date: Fri, 17 Oct 2025 16:51:40 +0200
Message-ID: <20251017145150.530024860@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Yang Shi <yang@os.amperecomputing.com>

commit 195a1b7d8388c0ec2969a39324feb8bebf9bb907 upstream.

The kprobe page is allocated by execmem allocator with ROX permission.
It needs to call set_memory_rox() to set proper permission for the
direct map too. It was missed.

Fixes: 10d5e97c1bf8 ("arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/probes/kprobes.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) "kprobes: " fmt
 
+#include <linux/execmem.h>
 #include <linux/extable.h>
 #include <linux/kasan.h>
 #include <linux/kernel.h>
@@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kpr
 static void __kprobes
 post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs *);
 
+void *alloc_insn_page(void)
+{
+	void *addr;
+
+	addr = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
+	if (!addr)
+		return NULL;
+	set_memory_rox((unsigned long)addr, 1);
+	return addr;
+}
+
 static void __kprobes arch_prepare_ss_slot(struct kprobe *p)
 {
 	kprobe_opcode_t *addr = p->ainsn.api.insn;


