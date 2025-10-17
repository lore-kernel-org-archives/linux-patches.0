Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80392F12D9;
	Fri, 17 Oct 2025 15:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715244; cv=none; b=QLyZ7SlA2o2yeZ0DSr9OyJPExZYJQZTklVU2SfNyEdkmyXp6xSrm2rlU7XNJWRII7Y7IJLc/lKCQ/nTh2n3wSD/SvwWajZZ7TG23i9pkcm6Nk5HJlHlRHsHYXH8rHw6AXk5EdqXh+ojcqZCvMXzfa+AY01s29vPFqHd9fzGb08w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715244; c=relaxed/simple;
	bh=CmbePvvRbwvoGkyaSzIj1xN9ADxBOOX4MOxY7PyzlB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqTAhEMIqiyByuJKR9RaNKII1G+MoK2M4ZhRIqgTqnXs/R9BdFnitTRKagUsWuUNBrrpZb2CF/icyQuvFw/ioXmoG5cbKcW+g4jlFbZLizveW0jBfrHIFOrCN+zhFHMH0p0lD0jqDI5W1QrhQpkse3EJbCB+gxvmObdBawbr2fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PesBmoNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PesBmoNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEB7C4CEE7;
	Fri, 17 Oct 2025 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715244;
	bh=CmbePvvRbwvoGkyaSzIj1xN9ADxBOOX4MOxY7PyzlB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PesBmoNSRbObknkEdtq/Ufv07jrmJUEclRLsQlzLayjGzKUN5+FZTR+C6wtgdzWT4
	 fTTdpNXJg6aFXonMDV93BSdMnsAzeWBG66LuwUETo6pwlLPzDalKB+fKtMw2dIw7ee
	 ZcvZbqKQF1wSxAh1EHYRbjZ/JmdxD9OPFp5WF9PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Shi <yang@os.amperecomputing.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.17 148/371] arm64: kprobes: call set_memory_rox() for kprobe page
Date: Fri, 17 Oct 2025 16:52:03 +0200
Message-ID: <20251017145207.288392262@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 	kprobe_opcode_t *addr = p->ainsn.xol_insn;


