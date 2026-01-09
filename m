Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F113191D2;
	Fri,  9 Jan 2026 12:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962021; cv=none; b=ZgnggWJ4pK+f2wa0pdP4brxdrkX7VoTkDokBELD7yfoW9UWiOlFHFC7bc8Co5W6a2ampezKqjm4nSgTIVOUrMGkCdsO5LeVYndReSTlPWh6az8lGKT7CRA49uk67G6SBUxs11XUpz/RjFym+LDU0MB8JWZFYMujCd/XpLcWAtzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962021; c=relaxed/simple;
	bh=y2MCf8ebwa0S6yphx8E9zrkpIiMCdR7VbwGcMvx4PO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCajojtE+wRwJ83BJNAwmez0VaflKNKEu/BXbyX0OMEDmkKeMjz4qGo08WCNkLkFLmf8+QAg8DSJx9mC2gCtTs17DeohYomjSurL9X3PeiSuafAMbcIWXJehL4L7+PWP3XpBSn4oIdRcOUUI7rScObsfsXqimqodkrUq8pvvM54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vd9f6EdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vd9f6EdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0EDC4CEF1;
	Fri,  9 Jan 2026 12:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962020;
	bh=y2MCf8ebwa0S6yphx8E9zrkpIiMCdR7VbwGcMvx4PO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vd9f6EdHxQnFgX7Et1K//BQ4f93ELuV5TUsk25kl6p1/IScyEETbmyeqekkRM/b7q
	 +ig9W3/skQXiO/HmmzE0GBuPO+p+Iv1detMuKy8uX7A6euGmak3NL3OngjvKhDzzew
	 jsBY3XH7Uv+kI7TpB+A+ax+YR/XscIlvlDYBDUo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 219/634] [PATCH 6.12] LoongArch: Add machine_kexec_mask_interrupts() implementation
Date: Fri,  9 Jan 2026 12:38:17 +0100
Message-ID: <20260109112125.673670115@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


