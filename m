Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AAE2EEE60;
	Sat, 12 Sep 2026 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789233005; cv=none; b=p+dlH7Onv6j9WHC3a3DTJKgjhu1UrfgN9PEw7h8QDilKyCTfdRT0JMIpaEHaKR2yvOj0bHtqTES55XC97k50oW+7VFTfZrWlP+Y2OxgpggkvxRDspJlTbof2QuZX+9taqi2PzOhKuubBVGpZxZZngY2PaqcF7J+PvMis2wrtc24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789233005; c=relaxed/simple;
	bh=WmzDoe/rs1DpfwkCXK7qeO79eMAgBPsCzIRz9GQ+3DE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDZQ6BnbUPFRwCimS/r7JxZOgyra/NUtcoIWkuQaYTF0+VJ0JYBfNzNrawwbRb9AWRvNJDY4ijAdbuu91DkMcUDuz284PPgwN2FE84hRjMfbbB21EgL/lsh1Eub1zjllxe7Gnl6NIcN4GMT4VEmIS2G7FhMTPiryJmTf2/kzA/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKSAuJ4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKSAuJ4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D590C1F000FF;
	Sat, 12 Sep 2026 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789233003;
	bh=xljcgCr+IERLlckJlIhqeXf1mJ3FozHFKFTdxa7prNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CKSAuJ4/eSiaYZPc84a6niUfeiu88JE2NxZFcj2BbNutwtKnoeJetwYu7c5EOmlUT
	 V0AFXdkXq+YWYlOrtxnQGMJt/PTCn8a14ImcV30D3iKj0amyIflpYDVAICKZ0QD7td
	 2kuUjerhGbzQ66kJ6aV47cI+OitKsSHmNmkJ6qFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>
Subject: [PATCH 5.15 083/935] alpha: marvel: Fix lock ordering in init_io7_irqs()
Date: Sat, 12 Sep 2026 08:51:53 +0200
Message-ID: <20260912065528.732310794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Turner <mattst88@gmail.com>

commit 24d68db713d63dfe3660c56b50e887784844baea upstream.

Move irq_set_chip_and_handler() and irq_set_status_flags() calls
outside the io7->irq_lock raw spinlock.  These functions take
sparse_irq_lock, which is a mutex, and taking a sleeping lock while
holding a raw spinlock is invalid.  The raw spinlock only needs to
protect the hardware CSR accesses.

This fixes the following lockdep splat during boot:

  [ BUG: Invalid wait context ]
  swapper/0/0 is trying to lock:
  sparse_irq_lock{....}-{4:4}, at: irq_mark_irq
  other info that might help us debug this:
  context-{5:5}
  1 lock held by swapper/0/0:
   #0: &io7->irq_lock{....}-{2:2}, at: init_io7_irqs.constprop.0

Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Matt Turner <mattst88@gmail.com>
Reviewed-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20260528230516.1839694-2-mattst88@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/sys_marvel.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -263,6 +263,18 @@ init_io7_irqs(struct io7 *io7,
 	 */
 	printk("  Interrupts reported to CPU at PE %u\n", boot_cpuid);
 
+	/* Set up the lsi irqs.  */
+	for (i = 0; i < 128; ++i) {
+		irq_set_chip_and_handler(base + i, lsi_ops, handle_level_irq);
+		irq_set_status_flags(base + i, IRQ_LEVEL);
+	}
+
+	/* Set up the msi irqs.  */
+	for (i = 128; i < (128 + 512); ++i) {
+		irq_set_chip_and_handler(base + i, msi_ops, handle_level_irq);
+		irq_set_status_flags(base + i, IRQ_LEVEL);
+	}
+
 	raw_spin_lock(&io7->irq_lock);
 
 	/* set up the error irqs */
@@ -272,12 +284,6 @@ init_io7_irqs(struct io7 *io7,
 	io7_redirect_irq(io7, &io7->csrs->STV_CTL.csr, boot_cpuid);
 	io7_redirect_irq(io7, &io7->csrs->HEI_CTL.csr, boot_cpuid);
 
-	/* Set up the lsi irqs.  */
-	for (i = 0; i < 128; ++i) {
-		irq_set_chip_and_handler(base + i, lsi_ops, handle_level_irq);
-		irq_set_status_flags(base + i, IRQ_LEVEL);
-	}
-
 	/* Disable the implemented irqs in hardware.  */
 	for (i = 0; i < 0x60; ++i) 
 		init_one_io7_lsi(io7, i, boot_cpuid);
@@ -285,13 +291,6 @@ init_io7_irqs(struct io7 *io7,
 	init_one_io7_lsi(io7, 0x74, boot_cpuid);
 	init_one_io7_lsi(io7, 0x75, boot_cpuid);
 
-
-	/* Set up the msi irqs.  */
-	for (i = 128; i < (128 + 512); ++i) {
-		irq_set_chip_and_handler(base + i, msi_ops, handle_level_irq);
-		irq_set_status_flags(base + i, IRQ_LEVEL);
-	}
-
 	for (i = 0; i < 16; ++i)
 		init_one_io7_msi(io7, i, boot_cpuid);
 


