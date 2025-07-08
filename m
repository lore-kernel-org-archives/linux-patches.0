Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713442E5B25;
	Tue,  8 Jul 2025 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991866; cv=none; b=OeFGT83kAaKhokTy9zYMt8t26rIHuAxLTGBRkeXZlF6IN8xs1XSZJ7E8BjQLa93OOnAvG9XgsLSEQus7cF0Q4c2vAgRXuqUfuY4Ky/NE5yPIDHT1Aw67+T2LGMAP2Hr65+Dvj6ylP2culp18ZRWDFz6z/agdnT5K699gqjEsmuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991866; c=relaxed/simple;
	bh=o9wl5zXh5YHn3K3BsK11wxJYE7YM1nU6+g6zdRhKYj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kdI9IcyOWDeRZG8XrIcP3lkcEyiRNpZCSTye6fAPqVks5vPmwyWM48wqqiZiiL4Fq5Iwx9sf+bVVXDBm0yxAJahBNkB1o+QMUfDEusCLZwqobkLLx7PSEypygydFT7QfqibFmxaj6L2HTO+v06OBFJpBKAcGeHHNT/SK0StV0Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXCVBGDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXCVBGDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13DDC4CEED;
	Tue,  8 Jul 2025 16:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991866;
	bh=o9wl5zXh5YHn3K3BsK11wxJYE7YM1nU6+g6zdRhKYj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXCVBGDgjqbUPSSpvypya9GwcD4VgO1w7fZXz9NBjlyJiMOEFYblHo3QOLijN6Moo
	 7B3dhriVjmgWPe8qkSFZDMrIXJHK4Kb7pjJDRUPnhmex1r8cKElY+ZR5E4wjVXXXZ9
	 081Vn59WxuWPq4oXh97sqaXa3Y6wV65AgLXu9aHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Chris Bainbridge <chris.bainbridge@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 01/81] rtc: cmos: use spin_lock_irqsave in cmos_interrupt
Date: Tue,  8 Jul 2025 18:22:53 +0200
Message-ID: <20250708162224.863496004@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162224.795155912@linuxfoundation.org>
References: <20250708162224.795155912@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1289,9 +1293,7 @@ static void cmos_check_wkalrm(struct dev
 	 * ACK the rtc irq here
 	 */
 	if (t_now >= cmos->alarm_expires && cmos_use_acpi_alarm()) {
-		local_irq_disable();
 		cmos_interrupt(0, (void *)cmos->rtc);
-		local_irq_enable();
 		return;
 	}
 


