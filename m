Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D452E542B;
	Tue,  8 Jul 2025 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991881; cv=none; b=dlXZNduohNYYQITj2wIvFAXHBF/lJ3qXyrV7daFLzXyxgIrUUvr/UQQPtJ9ebjZmGMA48EXRqaa2p/wpWo9cheUcW4z9gwe6dXzAGEIeEmS+yF0TFgIQzTFnVOcYn0T+koHxegziFny/yWsDO3ku+7Je+t45XQrI9Q1P//dUKJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991881; c=relaxed/simple;
	bh=lQKESBdjjKN7fkwxihAXumKjCFMWiWRBPufD2MyYnIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SQ6lqB5bfsmtPFVmQt79tbeEpt5zBGZwXdN902KCDKfz98EvjhMMU8l1M/n+hYXHcyMp+s86jxxrvB6e+lW6pweIqcB80NGm685rYX6v1d0iestny/8U5JCZBndkszmKpMOvkG/lHwo+I9cww74qqrOFBAuKiTWhmTvPQgYCxn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tf0vHjZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tf0vHjZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8433CC4CEED;
	Tue,  8 Jul 2025 16:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991880;
	bh=lQKESBdjjKN7fkwxihAXumKjCFMWiWRBPufD2MyYnIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tf0vHjZnTZGp2V70RO1OFPnR8CZ54hYdX0DwypaaPZYGqxwaI9Pd1zeSZrcSWVQBi
	 o5n7SXRqpYtsXWTmgus+UpumH2pOS+sOafV1PwhnRdEwf3INRi0HcLdKQWzk4paQbe
	 jI52mIhKIFuv3gU9OzB364bp7wPtWhLXEHAXw2ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 003/232] rtc: cmos: use spin_lock_irqsave in cmos_interrupt
Date: Tue,  8 Jul 2025 18:19:59 +0200
Message-ID: <20250708162241.521214934@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -697,8 +697,12 @@ static irqreturn_t cmos_interrupt(int ir
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
@@ -732,7 +736,7 @@ static irqreturn_t cmos_interrupt(int ir
 			hpet_mask_rtc_irq_bit(RTC_AIE);
 		CMOS_READ(RTC_INTR_FLAGS);
 	}
-	spin_unlock(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	if (is_intr(irqstat)) {
 		rtc_update_irq(p, 1, irqstat);
@@ -1300,9 +1304,7 @@ static void cmos_check_wkalrm(struct dev
 	 * ACK the rtc irq here
 	 */
 	if (t_now >= cmos->alarm_expires && cmos_use_acpi_alarm()) {
-		local_irq_disable();
 		cmos_interrupt(0, (void *)cmos->rtc);
-		local_irq_enable();
 		return;
 	}
 


