Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED9415853A;
	Wed, 20 Nov 2024 12:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107539; cv=none; b=dmJaRPHc965SXjIqzA8TrNxwAsqZ5gPofKePZbP3In87kTN17e2Lblqv39q8ZtMBQLRBNTeOJN5IQlaP1iO42TPlYVhXIxkbIP5xR3UnF69uzSBsrSzuhrVR6ZydL48nqpKV4K3iyh36tfMHEmbi3C1pZ1Tzn5VyQh+aEEa+qZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107539; c=relaxed/simple;
	bh=+3uMi2jGQhurCrLEPBI69ARKEYcUzjGzcbDEdz6TgHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEbBCDgQGe3xcF05blAEfBc7FQgW2ulViil5JmvreSRCSg6oKdyaGp+cPoB2l2HwkvSPmFKJCm5SF7sTHGUBILnkDh1672tCaW8kVSZ60aZw7Zz+OOMoJovi0nHH6WrsgVADDnUzMWtXLYFMga88fo49r71RTeQARSmXsbfxetg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFx677b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFx677b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A7EC4CECD;
	Wed, 20 Nov 2024 12:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107539;
	bh=+3uMi2jGQhurCrLEPBI69ARKEYcUzjGzcbDEdz6TgHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YFx677b0dFL+vom1OQZEQz9wlhNYVaXgQ+rCvxvZGvc7tXO61S4p7D8hTYMYwS1vP
	 bWC1zBRf+AI+fuMCsyVpQqdWZ70kui58pqk8OJ3rDMmLtyo/aL0JdNG1him8++AG61
	 4uj1oX7D/RyF4T6jrWxha0zLYaDviSeX7jW18IgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.11 073/107] LoongArch: Fix AP booting issue in VM mode
Date: Wed, 20 Nov 2024 13:56:48 +0100
Message-ID: <20241120125631.328085204@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

commit 6ce031e5d6f475d476bab55ab7d8ea168fedc4c1 upstream.

Native IPI is used for AP booting, because it is the booting interface
between OS and BIOS firmware. The paravirt IPI is only used inside OS,
and native IPI is necessary to boot AP.

When booting AP, we write the kernel entry address in the HW mailbox of
AP and send IPI interrupt to it. AP executes idle instruction and waits
for interrupts or SW events, then clears IPI interrupt and jumps to the
kernel entry from HW mailbox.

Between writing HW mailbox and sending IPI, AP can be woken up by SW
events and jumps to the kernel entry, so ACTION_BOOT_CPU IPI interrupt
will keep pending during AP booting. And native IPI interrupt handler
needs be registered so that it can clear pending native IPI, else there
will be endless interrupts during AP booting stage.

Here native IPI interrupt is initialized even if paravirt IPI is used.

Cc: stable@vger.kernel.org
Fixes: 74c16b2e2b0c ("LoongArch: KVM: Add PV IPI support on guest side")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/paravirt.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/loongarch/kernel/paravirt.c
+++ b/arch/loongarch/kernel/paravirt.c
@@ -50,11 +50,18 @@ static u64 paravt_steal_clock(int cpu)
 }
 
 #ifdef CONFIG_SMP
+static struct smp_ops native_ops;
+
 static void pv_send_ipi_single(int cpu, unsigned int action)
 {
 	int min, old;
 	irq_cpustat_t *info = &per_cpu(irq_stat, cpu);
 
+	if (unlikely(action == ACTION_BOOT_CPU)) {
+		native_ops.send_ipi_single(cpu, action);
+		return;
+	}
+
 	old = atomic_fetch_or(BIT(action), &info->message);
 	if (old)
 		return;
@@ -74,6 +81,11 @@ static void pv_send_ipi_mask(const struc
 	if (cpumask_empty(mask))
 		return;
 
+	if (unlikely(action == ACTION_BOOT_CPU)) {
+		native_ops.send_ipi_mask(mask, action);
+		return;
+	}
+
 	action = BIT(action);
 	for_each_cpu(i, mask) {
 		info = &per_cpu(irq_stat, i);
@@ -141,6 +153,8 @@ static void pv_init_ipi(void)
 {
 	int r, swi;
 
+	/* Init native ipi irq for ACTION_BOOT_CPU */
+	native_ops.init_ipi();
 	swi = get_percpu_irq(INT_SWI0);
 	if (swi < 0)
 		panic("SWI0 IRQ mapping failed\n");
@@ -179,6 +193,7 @@ int __init pv_ipi_init(void)
 		return 0;
 
 #ifdef CONFIG_SMP
+	native_ops		= mp_ops;
 	mp_ops.init_ipi		= pv_init_ipi;
 	mp_ops.send_ipi_single	= pv_send_ipi_single;
 	mp_ops.send_ipi_mask	= pv_send_ipi_mask;


