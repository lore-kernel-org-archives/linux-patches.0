Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062266;
	b=cZNBtqpDZzGnRwxjQMEHhJj4rRZ8zFWukU5uqa5DYPCSsylgp/Kb5IrsatwlO/NBMkLm
	 7A3p8vjIihfXe8byf/bJf9vdZNPwLlePmNCG/WDOGPA6oxFdjjAA9xv6GhF7YyKPcvJSW
	 DsGJd+Iimy9xNFML8/nuPzSblfcUlWGXulYXVygAnCfmJgyTKLyU0Zxlb2EoK7g67R1bT
	 nUpSjGWi6d4qTuV2eUucDIRgcfmbMPFR/AStsw5GoculpAwdiYJZCczapb6k5/1c4mZnN
	 K5Ii06gqs4RKGPZN+Plg1BQO4kejgwZroooxkPcmpGNVk1ql10vmgYxEwYGbT/R4oqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MSQlQwKj+UL7gS5odfEU7MZc5dTsyHh4DCSmEzT/X2w=;
	b=R79QhurX0pAFnAHeOyG+hROm2+JOWHrnerHdr04P9syII5BjYLDmiRQpatoIhIja2Hvm
	 boKuwOh8/FfbDWPEdSIsLrAVHE/6yUitfe9WbrpaI05AAKk4TwaP5r4qXQ4/TKCYd0Ezw
	 82lAb1DFtGLlUqnjylBt6rJVBydLg4MM0w9/JCT0wwo7LqCLtlG+bAI8RVDa/hDfZmmXK
	 46rRbs1cTCzYWNYi8Ux5ZUAhJoXJbX6pA78ghSrQSs34Yl2l7l60k6OddoO3zwrn7qDxf
	 xSQuHFl+qkSYC4qZxG9YgttNquMCSw44H0Cbc2er+lCPobFiH35lq8k1ro4z5r5qiSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4iLnOKF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786A4606A320;
	Thu, 19 Nov 2026 04:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4iLnOKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A431F000C4;
	Thu, 19 Nov 2026 04:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062266;
	bh=MSQlQwKj+UL7gS5odfEU7MZc5dTsyHh4DCSmEzT/X2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4iLnOKFRGmVueTwAVK1O4/iVwWiQYVffGRgOYJR+yAFvsN+BN3PJnf3pNE81DpzY
	 rHjy0K9AsS3sVdmkzvlNcJJ3Zpl3Bw6J/fSOA05GK9kudT8g0L/lKej3G8r4niC9ha
	 F9fkrqqDxwtCRg4Hl7Bc9YNQLqpAtSkLU/Bw2z4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.10 1848/1848] power: supply: ab8500: Fix use-after-free in power_supply_changed()
Date: Wed, 18 Nov 2026 16:04:46 +0100
Message-ID: <20261118150036.904862176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waqar Hameed <waqar.hameed@axis.com>

commit c4af8a98bb52825a5331ae1d0604c0ea6956ba4b upstream.

Using the `devm_` variant for requesting IRQ _before_ the `devm_`
variant for allocating/registering the `power_supply` handle, means that
the `power_supply` handle will be deallocated/unregistered _before_ the
interrupt handler (since `devm_` naturally deallocates in reverse
allocation order). This means that during removal, there is a race
condition where an interrupt can fire just _after_ the `power_supply`
handle has been freed, *but* just _before_ the corresponding
unregistration of the IRQ handler has run.

This will lead to the IRQ handler calling `power_supply_changed()` with
a freed `power_supply` handle. Which usually crashes the system or
otherwise silently corrupts the memory...

Note that there is a similar situation which can also happen during
`probe()`; the possibility of an interrupt firing _before_ registering
the `power_supply` handle. This would then lead to the nasty situation
of using the `power_supply` handle *uninitialized* in
`power_supply_changed()`.

Commit 1c1f13a006ed ("power: supply: ab8500: Move to componentized
binding") introduced this issue during a refactorization. Fix this racy
use-after-free by making sure the IRQ is requested _after_ the
registration of the `power_supply` handle.

Fixes: 1c1f13a006ed ("power: supply: ab8500: Move to componentized binding")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/ccf83a09942cb8dda3dff70b2682f2c2e9cb97f2.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/ab8500_charger.c |   40 +++++++++++++++++-----------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3476,26 +3476,6 @@ static int ab8500_charger_probe(struct p
 		return ret;
 	}
 
-	/* Request interrupts */
-	for (i = 0; i < ARRAY_SIZE(ab8500_charger_irq); i++) {
-		irq = platform_get_irq_byname(pdev, ab8500_charger_irq[i].name);
-		if (irq < 0)
-			return irq;
-
-		ret = devm_request_threaded_irq(dev,
-			irq, NULL, ab8500_charger_irq[i].isr,
-			IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
-			ab8500_charger_irq[i].name, di);
-
-		if (ret != 0) {
-			dev_err(dev, "failed to request %s IRQ %d: %d\n"
-				, ab8500_charger_irq[i].name, irq, ret);
-			return ret;
-		}
-		dev_dbg(dev, "Requested %s IRQ %d: %d\n",
-			ab8500_charger_irq[i].name, irq, ret);
-	}
-
 	/* initialize lock */
 	spin_lock_init(&di->usb_state.usb_lock);
 	mutex_init(&di->usb_ipt_crnt_lock);
@@ -3553,6 +3533,26 @@ static int ab8500_charger_probe(struct p
 	INIT_DELAYED_WORK(&di->usb_charger_attached_work,
 			  ab8500_charger_usb_attached_work);
 
+	/* Request interrupts */
+	for (i = 0; i < ARRAY_SIZE(ab8500_charger_irq); i++) {
+		irq = platform_get_irq_byname(pdev, ab8500_charger_irq[i].name);
+		if (irq < 0)
+			return irq;
+
+		ret = devm_request_threaded_irq(dev,
+			irq, NULL, ab8500_charger_irq[i].isr,
+			IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
+			ab8500_charger_irq[i].name, di);
+
+		if (ret != 0) {
+			dev_err(dev, "failed to request %s IRQ %d: %d\n"
+				, ab8500_charger_irq[i].name, irq, ret);
+			return ret;
+		}
+		dev_dbg(dev, "Requested %s IRQ %d: %d\n",
+			ab8500_charger_irq[i].name, irq, ret);
+	}
+
 	/*
 	 * For ABB revision 1.0 and 1.1 there is a bug in the watchdog
 	 * logic. That means we have to continuously kick the charger


