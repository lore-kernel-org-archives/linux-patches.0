Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE31A342C8E;
	Tue, 16 Dec 2025 11:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884949; cv=none; b=u0jfkVXP1A7YZvOgjKQIZjswUn1ilNHwsmfGgCRamYAgAqIJACVshez0IoljS1Qinyd83OeFqnoIYtf1hUMcg7uW1GHge22om6On4AaYwRNymYkZ1MBxgKbDfL7dE2U794JHRlcTMEt5mNAQKq7s6bJ2VwH6m5WreQq/s1FSZA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884949; c=relaxed/simple;
	bh=G7j/5B2pldejXk7DTXy3vdiWGJDmFBWotjc7kfKEa2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THlFXNuN/5IlfvAXPutIQ5n4vhudGqYFgh1mrrLGOOudJJJyT/R0Cfzsj1yOuAsVtEKJI7dzc0OLFQXTOkHSOxhIUruo3/ZKWoLlagtHZs5OaFruQgar+UA7b0S3QmhaDHHENIq1F4IN+MmzdSKk+6DKHKEkgwMWrCM7QuBmL9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1W7VQYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1W7VQYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6103CC4CEF1;
	Tue, 16 Dec 2025 11:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884948;
	bh=G7j/5B2pldejXk7DTXy3vdiWGJDmFBWotjc7kfKEa2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1W7VQYCF2wz3h5E/xXEgDHwNmyxhAXLDqdlhXP759w8ZXuppfPPQO82u1QfZ1l2n
	 Ux0L7JdjM5hOvupIrRBLwxKlXSzUqC6qwLd6/9w05O2btuLWCp6a7xWedtU9svL2tc
	 PHz8MZLhyc1X/LOv7gx2nayhgGgn2czbgw/jRE34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 346/354] [PATCH 6.12] LoongArch: Add machine_kexec_mask_interrupts() implementation
Date: Tue, 16 Dec 2025 12:15:13 +0100
Message-ID: <20251216111333.441496428@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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


