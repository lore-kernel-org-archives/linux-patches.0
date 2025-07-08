Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EFEBE46;
	Tue,  8 Jul 2025 16:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993253; cv=none; b=TMIt7C17pMUQ5pHvNihkMwp+3SVCyMvS5YVOhKByl0SGXBK4cLKf1JeAQ42+VLrHzyGObgwezSQK3BCgd8bwDoxUvqZZFIBjTAw5NO9prn2yVL909ThLdpoOToxvYj354mE2bH/KvdsxtkkXw7PhL2IAEprHsK3MEesW02MCaLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993253; c=relaxed/simple;
	bh=7dcIg69mT+pimR9UP8IYm1M/kthISxlV668KpKGQ7gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C9Q82BK0ezF8ea+TyOUd5n+5DYPWqCMySK0ueNngvON8m1cJMatG5s8YygAePGx73VteTcvdT0sRXGUo8x8wcnIMwpXE2RTOH/w3KG1r/d+G3npvoBgvzEK3JhIhbGcpTKb+/s0J1oiNvFtUwMSVqpKKRnSOCOKBAIaauuTMPJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTIRh4z5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTIRh4z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD970C4CEED;
	Tue,  8 Jul 2025 16:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993253;
	bh=7dcIg69mT+pimR9UP8IYm1M/kthISxlV668KpKGQ7gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTIRh4z53i5O6Nt+s8YSUgLm+VS9JSwsksFjcRA3T524Wb1iFzJTJJYQ2IL5gfsvL
	 Gf1oBG4GExTWTDfIwJyAafSyHd4RL0/r6+AZHZXO8NhAI+TC6/J4oiTQhtCmUaRNRr
	 2R9D0R0M32YBGqvEtFXtmkRz+Jjot4RqvCzRaGoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.15 003/178] rtc: cmos: use spin_lock_irqsave in cmos_interrupt
Date: Tue,  8 Jul 2025 18:20:40 +0200
Message-ID: <20250708162236.642714888@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

commit 00a39d8652ff9088de07a6fe6e9e1893452fe0dd upstream.

cmos_interrupt() can be called in a non-interrupt context, such as in
an ACPI event handler (which runs in an interrupt thread). Therefore,
usage of spin_lock(&rtc_lock) is insecure. Use spin_lock_irqsave() /
spin_unlock_irqrestore() instead.

Before a misguided
commit 6950d046eb6e ("rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard IRQ")
the cmos_interrupt() function used spin_lock_irqsave(). That commit
changed it to spin_lock() and broke locking, which was partially fixed in
commit 13be2efc390a ("rtc: cmos: Disable irq around direct invocation of cmos_interrupt()")

That second commit did not take account of the ACPI fixed event handler
pathway, however. It introduced local_irq_disable() workarounds in
cmos_check_wkalrm(), which can cause problems on PREEMPT_RT kernels
and are now unnecessary.

Add an explicit comment so that this change will not be reverted by
mistake.

Cc: stable@vger.kernel.org
Fixes: 6950d046eb6e ("rtc: cmos: Replace spin_lock_irqsave with spin_lock in hard IRQ")
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Reported-by: Chris Bainbridge <chris.bainbridge@gmail.com>
Closes: https://lore.kernel.org/all/aDtJ92foPUYmGheF@debian.local/
Link: https://lore.kernel.org/r/20250607210608.14835-1-mat.jonczyk@o2.pl
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-cmos.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -692,8 +692,12 @@ static irqreturn_t cmos_interrupt(int ir
 {
 	u8		irqstat;
 	u8		rtc_control;
+	unsigned long	flags;
 
-	spin_lock(&rtc_lock);
+	/* We cannot use spin_lock() here, as cmos_interrupt() is also called
+	 * in a non-irq context.
+	 */
+	spin_lock_irqsave(&rtc_lock, flags);
 
 	/* When the HPET interrupt handler calls us, the interrupt
 	 * status is passed as arg1 instead of the irq number.  But
@@ -727,7 +731,7 @@ static irqreturn_t cmos_interrupt(int ir
 			hpet_mask_rtc_irq_bit(RTC_AIE);
 		CMOS_READ(RTC_INTR_FLAGS);
 	}
-	spin_unlock(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	if (is_intr(irqstat)) {
 		rtc_update_irq(p, 1, irqstat);
@@ -1295,9 +1299,7 @@ static void cmos_check_wkalrm(struct dev
 	 * ACK the rtc irq here
 	 */
 	if (t_now >= cmos->alarm_expires && cmos_use_acpi_alarm()) {
-		local_irq_disable();
 		cmos_interrupt(0, (void *)cmos->rtc);
-		local_irq_enable();
 		return;
 	}
 


