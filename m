Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B13C359F99;
	Fri,  9 Jan 2026 12:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960118; cv=none; b=XqZa9quGxqCd7j5whHSIu0v4qxfZbgaZN06fItTzgumCg/cVdLWM0BqnyMlEU8OciKph322oPGZaHvu3zKS/gLtcpGbkp+qxhzUQPGN5JuKvrMazm60/epvBGzpmrQWeu8JQlNrGkOzYRHqGe8FwYqQMQ44UxTpHou4rNYiVysI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960118; c=relaxed/simple;
	bh=lUw0WdYhg7nugtaAia+13PRR3tk8bLLsnUsUhMNYFS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuECxQ+3UWXFZ2Ku6frXDU3yUCOLmv5eGNldvCV22QyjqgKTJVUBv+Jih+NPdWHF27FNgL310e3l1e66MlNbr1sEElt321gzpkM20k9EwpE9VLVkdScq0+YIM6hUf3gxAsKwQs9K+CchyYEDn5oaUARNyhi6vyjCETw7SJ+SO6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuYciDKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuYciDKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD009C4CEF1;
	Fri,  9 Jan 2026 12:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960118;
	bh=lUw0WdYhg7nugtaAia+13PRR3tk8bLLsnUsUhMNYFS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuYciDKe+KXjyBFO1iJZvvOC5zy+aJnPMJvjWTeWa/Wz5cV13ehzdvOWoJD1B18e2
	 9TYb73p6IcqUZcihD/e6jMi7zir+AQ7k2yQRRBLRZ9DkoxVasKkiuLmauTqHeYDKmA
	 DE8ube5WCBCbGg9fVY36z2Gk3Z+NO+cj4DDM9J6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 292/737] [PATCH 6.12] LoongArch: Add machine_kexec_mask_interrupts() implementation
Date: Fri,  9 Jan 2026 12:37:11 +0100
Message-ID: <20260109112144.995034291@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

Commit 863a320dc6fd7c855f47da4b ("LoongArch: Mask all interrupts during
kexec/kdump") is backported to LTS branches, but they lack a generic
machine_kexec_mask_interrupts() implementation, so add an arch-specific
one.

Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/machine_kexec.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/arch/loongarch/kernel/machine_kexec.c
+++ b/arch/loongarch/kernel/machine_kexec.c
@@ -136,6 +136,28 @@ void kexec_reboot(void)
 	BUG();
 }
 
+static void machine_kexec_mask_interrupts(void)
+{
+	unsigned int i;
+	struct irq_desc *desc;
+
+	for_each_irq_desc(i, desc) {
+		struct irq_chip *chip;
+
+		chip = irq_desc_get_chip(desc);
+		if (!chip)
+			continue;
+
+		if (chip->irq_eoi && irqd_irq_inprogress(&desc->irq_data))
+			chip->irq_eoi(&desc->irq_data);
+
+		if (chip->irq_mask)
+			chip->irq_mask(&desc->irq_data);
+
+		if (chip->irq_disable && !irqd_irq_disabled(&desc->irq_data))
+			chip->irq_disable(&desc->irq_data);
+	}
+}
 
 #ifdef CONFIG_SMP
 static void kexec_shutdown_secondary(void *regs)


