Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047101;
	b=3AzVa+shsUoCpGmHmywgmTDjukHvECfiSpE1pKQ4v1r0M4tskYht0ppH+SFNP2XO77GV
	 hUA5imkshdzEcrKIP/GeGL+irpADFOVjgzMJndIYqRtBSKrvyn7xkNBRNfEnqIWESDnPu
	 yg689Q0B10xcUXSL20rmAeTJaiwBLmw3dhY6LeL8AiMeTeNLzNt7rQXQpqP1rDzzEDpoK
	 p6DsNs3tIT4q3/J+7RZMDltC7usDGn0wJAKKcPs9TBAElOy07I8npd7VQSZaeLYUv9gAD
	 E4/W7Fq0ov5Zszmowrge6c5G4lX+uFV835cZLY1y+9pogRk106qBjd6NNI+v/hmqMjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y4UBvEfXf8FqrIo5iu++XINgwYqJnRGtHa3eCyxYinw=;
	b=VITFTit1JT7HZUgtSVPGTUjoALTi7MsdG/u/4Unvxta6zeJ7x3+jF/ubTHmhUbyfxw2P
	 9/2r7UZhb36sTyHiKGXcUqsJDzV2KulGeKj2iRWCd8tcm1IPaFn1hwgVryUX8HaEqA1jJ
	 22oo6nbKivYFI1UYfXV9Dn3ejaxYiLcLF0kudRdERbSdEDXY01X6ejNWPfDHPDbEyAIFq
	 iiJ26ek8WIp/Yh32F50Xy6K/Di2yER0Dsw/jOi16OYFlyeYHnkBA8fz8qzNGaTMarLLyF
	 PfEKFVtkPjm56sgni2YCtrdAYf8IfyGbcsXpUqVJjXLTMLrBtrin9zCsAudir7YjsqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IU0cVM3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A27E606A325;
	Thu, 19 Nov 2026 00:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IU0cVM3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9821F000C4;
	Thu, 19 Nov 2026 00:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047100;
	bh=Y4UBvEfXf8FqrIo5iu++XINgwYqJnRGtHa3eCyxYinw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IU0cVM3ls0Yk37oND08wSVpMwnO0exQ2rDMbRObYgN4aJXTP++igiP5vQFUs97UNu
	 qWkhkDbDWeqQNLy2SOyO6DeD2Lzu6AS0hDha/avyHmCbHfKy44qexNY98u35pQYAj/
	 N+DnlF+ZC2mstOdNRgilyXfu8ndB2iXyhUadY13M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1519/2857] gpio: pca953x: Handle direction register read errors in IRQ paths
Date: Wed, 18 Nov 2026 15:42:33 +0100
Message-ID: <20261118150256.019800842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sahaj Chaudhari <sahaj123.sc@gmail.com>

[ Upstream commit a0fe269293509acdd93b9cfb3f46636f7b91b33a ]

Three IRQ paths ignore the result of reading the direction registers
and then use the destination bitmap. pca953x_read_regs() does not populate
that bitmap when regmap_bulk_read() fails, leaving the callers to use
uninitialized stack data.

This can select incorrect GPIOs for direction changes during IRQ bus
synchronization, corrupt the saved input state during IRQ setup, or
produce incorrect pending interrupt decisions.

Check the read result at all three sites. Release irq_lock without
changing GPIO directions on failure, leave the IRQ history untouched
when pending detection fails, and propagate the error from IRQ setup.
The read helper already logs the error.

Fixes: 0f25fda840a9 ("gpio: pca953x: Zap ad-hoc reg_direction cache")
Cc: stable@vger.kernel.org
Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
Link: https://patch.msgid.link/20261018165003.3372368-1-sahaj123.sc@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 3ad235cd740be..5bf0964c16dde 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -766,6 +766,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	DECLARE_BITMAP(irq_mask, MAX_LINE);
 	DECLARE_BITMAP(reg_direction, MAX_LINE);
 	int level;
+	int ret;
 
 	guard(mutex)(&chip->i2c_lock);
 
@@ -780,7 +781,9 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	}
 
 	/* Switch direction to input if needed */
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	ret = pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	if (ret)
+		goto out;
 
 	bitmap_or(irq_mask, chip->irq_trig_fall, chip->irq_trig_raise, gc->ngpio);
 	bitmap_complement(reg_direction, reg_direction, gc->ngpio);
@@ -790,6 +793,7 @@ static void pca953x_irq_bus_sync_unlock(struct irq_data *d)
 	for_each_set_bit(level, irq_mask, gc->ngpio)
 		pca953x_gpio_direction_input_unlocked(&chip->gpio_chip, level);
 
+out:
 	mutex_unlock(&chip->irq_lock);
 }
 
@@ -856,7 +860,9 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 		return false;
 
 	/* Remove output pins from the equation */
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	ret = pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	if (ret)
+		return false;
 
 	bitmap_copy(old_stat, chip->irq_stat, gc->ngpio);
 
@@ -941,7 +947,9 @@ static int pca953x_irq_setup(struct pca953x_chip *chip, int irq_base)
 	 * interrupt.  We have to rely on the previous read for
 	 * this purpose.
 	 */
-	pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	ret = pca953x_read_regs(chip, chip->regs->direction, reg_direction);
+	if (ret)
+		return ret;
 	bitmap_and(chip->irq_stat, irq_stat, reg_direction, gc->ngpio);
 	mutex_init(&chip->irq_lock);
 
-- 
2.53.0



