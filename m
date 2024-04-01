Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44ED93F8F4;
	Mon,  1 Apr 2024 16:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987726; cv=none; b=k/tsmPJ3mVRp+oq8DWjbYqUfdvBmrq0cIA6DnBaeiZRZ3Rjxbs9IYBqNDPyJTaDEdNi8FWGcOapI7x5xCCxcW1KelWWQ16dxfG++M40tp8YQcOijp71mt0UcB1Cra0R/4V5NUSOg52YN1ugY4UGphfumFVC7dbwA2IjaaGcqf5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987726; c=relaxed/simple;
	bh=jXuJO0LYonXLgzZeZrX76JkklRT8XAokDSl/uM1DXy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQ0blx5klb5rRfigHuccJBbAsBqvrW1NFEZL4Q6g7gRt+/wAr4B30zKehttjFnd4KXTSm/5+d82Va+hWBipqUAM0Boldcm44oW488w75LS/zwv50R1EnwNNILoyCfXgXP61LwNB410KSvnO5AxC/iZNBEN458mbv9NHv6Ct84ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aWuLnqu4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aWuLnqu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9B0C433C7;
	Mon,  1 Apr 2024 16:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987726;
	bh=jXuJO0LYonXLgzZeZrX76JkklRT8XAokDSl/uM1DXy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWuLnqu45BG+IF/I1QSV9priMXhE6LJesRQfnS5H1krW13ZJRyp0/ZO88AD/3/7z+
	 gTDQbhExLqd3j1dmu+HEdmm1ZB1a0QfubKvqcjtmmhOGO2f6bukXQ9jTX2FfGUwjFI
	 YAlvsVzacvkZZlDUoRX9U0XBJiLEHkj8USK/BtNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francisco Ayala Le Brun <francisco@videowindow.eu>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.8 356/399] genirq: Introduce IRQF_COND_ONESHOT and use it in pinctrl-amd
Date: Mon,  1 Apr 2024 17:45:22 +0200
Message-ID: <20240401152559.796951781@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit c2ddeb29612f7ca84ed10c6d4f3ac99705135447 upstream.

There is a problem when a driver requests a shared interrupt line to run a
threaded handler on it without IRQF_ONESHOT set if that flag has been set
already for the IRQ in question by somebody else.  Namely, the request
fails which usually leads to a probe failure even though the driver might
have worked just fine with IRQF_ONESHOT, but it does not want to use it by
default.  Currently, the only way to handle this is to try to request the
IRQ without IRQF_ONESHOT, but with IRQF_PROBE_SHARED set and if this fails,
try again with IRQF_ONESHOT set.  However, this is a bit cumbersome and not
very clean.

When commit 7a36b901a6eb ("ACPI: OSL: Use a threaded interrupt handler for
SCI") switched the ACPI subsystem over to using a threaded interrupt
handler for the SCI, it had to use IRQF_ONESHOT for it because that's
required due to the way the SCI handler works (it needs to walk all of the
enabled GPEs before the interrupt line can be unmasked). The SCI interrupt
line is not shared with other users very often due to the SCI handling
overhead, but on sone systems it is shared and when the other user of it
attempts to install a threaded handler, a flags mismatch related to
IRQF_ONESHOT may occur.

As it turned out, that happened to the pinctrl-amd driver and so commit
4451e8e8415e ("pinctrl: amd: Add IRQF_ONESHOT to the interrupt request")
attempted to address the issue by adding IRQF_ONESHOT to the interrupt
flags in that driver, but this is now causing an IRQF_ONESHOT-related
mismatch to occur on another system which cannot boot as a result of it.

Clearly, pinctrl-amd can work with IRQF_ONESHOT if need be, but it should
not set that flag by default, so it needs a way to indicate that to the
interrupt subsystem.

To that end, introdcuce a new interrupt flag, IRQF_COND_ONESHOT, which will
only have effect when the IRQ line is shared and IRQF_ONESHOT has been set
for it already, in which case it will be promoted to the latter.

This is sufficient for drivers sharing the interrupt line with the SCI as
it is requested by the ACPI subsystem before any drivers are probed, so
they will always see IRQF_ONESHOT set for the interrupt in question.

Fixes: 4451e8e8415e ("pinctrl: amd: Add IRQF_ONESHOT to the interrupt request")
Reported-by: Francisco Ayala Le Brun <francisco@videowindow.eu>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: 6.8+ <stable@vger.kernel.org> # 6.8+
Closes: https://lore.kernel.org/lkml/CAN-StX1HqWqi+YW=t+V52-38Mfp5fAz7YHx4aH-CQjgyNiKx3g@mail.gmail.com/
Link: https://lore.kernel.org/r/12417336.O9o76ZdvQC@kreacher
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-amd.c |    2 +-
 include/linux/interrupt.h     |    3 +++
 kernel/irq/manage.c           |    9 +++++++--
 3 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -1159,7 +1159,7 @@ static int amd_gpio_probe(struct platfor
 	}
 
 	ret = devm_request_irq(&pdev->dev, gpio_dev->irq, amd_gpio_irq_handler,
-			       IRQF_SHARED | IRQF_ONESHOT, KBUILD_MODNAME, gpio_dev);
+			       IRQF_SHARED | IRQF_COND_ONESHOT, KBUILD_MODNAME, gpio_dev);
 	if (ret)
 		goto out2;
 
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -67,6 +67,8 @@
  *                later.
  * IRQF_NO_DEBUG - Exclude from runnaway detection for IPI and similar handlers,
  *		   depends on IRQF_PERCPU.
+ * IRQF_COND_ONESHOT - Agree to do IRQF_ONESHOT if already set for a shared
+ *                 interrupt.
  */
 #define IRQF_SHARED		0x00000080
 #define IRQF_PROBE_SHARED	0x00000100
@@ -82,6 +84,7 @@
 #define IRQF_COND_SUSPEND	0x00040000
 #define IRQF_NO_AUTOEN		0x00080000
 #define IRQF_NO_DEBUG		0x00100000
+#define IRQF_COND_ONESHOT	0x00200000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1642,8 +1642,13 @@ __setup_irq(unsigned int irq, struct irq
 		}
 
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
-		    (oldtype != (new->flags & IRQF_TRIGGER_MASK)) ||
-		    ((old->flags ^ new->flags) & IRQF_ONESHOT))
+		    (oldtype != (new->flags & IRQF_TRIGGER_MASK)))
+			goto mismatch;
+
+		if ((old->flags & IRQF_ONESHOT) &&
+		    (new->flags & IRQF_COND_ONESHOT))
+			new->flags |= IRQF_ONESHOT;
+		else if ((old->flags ^ new->flags) & IRQF_ONESHOT)
 			goto mismatch;
 
 		/* All handlers must agree on per-cpuness */


