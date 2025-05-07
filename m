Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCB842A83;
	Wed,  7 May 2025 18:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643888; cv=none; b=F6yNWsoLkCAEPAHSOgwg16XfpmAfUZ/mBljpmoLT+rn2IodLiMLSzwCz2K4e/3uN1J3cubgsPjTninwuC4J1wbRy+sAQqD4e3gFE8WKroEpT2BO8nTMlFp2JppfJfQpkvrpEkecSxyJJjCeFdVCuo3o8Wpbb47NdDrbKdqtjFuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643888; c=relaxed/simple;
	bh=tgytx3BxH6VrqehhpvN9lSWfN7Ormsb7p6KAqY1Np5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USznQOCWt6Auq0oPfxY1UjAF9YYzwjxasgx7CKi6DZpkhXJIrUyFd9X++vRuBe7/tCPCCCu8nlWfM+x6rcFk0hx1CehfoswTzbGSEqF9wNJ3SKrGBeKI3f3co9VDGASFM5IEKoxvv2yIBjWfXJyt1CYZj4aH2O6C0mM4lsNDwiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bS/2GKjY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bS/2GKjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBC2C4CEE2;
	Wed,  7 May 2025 18:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643888;
	bh=tgytx3BxH6VrqehhpvN9lSWfN7Ormsb7p6KAqY1Np5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bS/2GKjYvGHKAGc7dhgVy3rlBU2EjP1htkQvW2ac5qf33+M6AnHro4fifHY62OWbZ
	 ROIA1vk6sq7Ha2uW3y8xuD77vX4Ebe/mNmfopNngulKw31gfHN7gI+Ezl94ocBzUTE
	 H3uXsn72/El7Wl5QKxB6gAxPabwIS3y1Fz4aIzSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.14 020/183] irqchip/qcom-mpm: Prevent crash when trying to handle non-wake GPIOs
Date: Wed,  7 May 2025 20:37:45 +0200
Message-ID: <20250507183825.509799206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephan Gerhold <stephan.gerhold@linaro.org>

commit 38a05c0b87833f5b188ae43b428b1f792df2b384 upstream.

On Qualcomm chipsets not all GPIOs are wakeup capable. Those GPIOs do not
have a corresponding MPM pin and should not be handled inside the MPM
driver. The IRQ domain hierarchy is always applied, so it's required to
explicitly disconnect the hierarchy for those. The pinctrl-msm driver marks
these with GPIO_NO_WAKE_IRQ. qcom-pdc has a check for this, but
irq-qcom-mpm is currently missing the check. This is causing crashes when
setting up interrupts for non-wake GPIOs:

 root@rb1:~# gpiomon -c gpiochip1 10
   irq: IRQ159: trimming hierarchy from :soc@0:interrupt-controller@f200000-1
   Unable to handle kernel paging request at virtual address ffff8000a1dc3820
   Hardware name: Qualcomm Technologies, Inc. Robotics RB1 (DT)
   pc : mpm_set_type+0x80/0xcc
   lr : mpm_set_type+0x5c/0xcc
   Call trace:
    mpm_set_type+0x80/0xcc (P)
    qcom_mpm_set_type+0x64/0x158
    irq_chip_set_type_parent+0x20/0x38
    msm_gpio_irq_set_type+0x50/0x530
    __irq_set_trigger+0x60/0x184
    __setup_irq+0x304/0x6bc
    request_threaded_irq+0xc8/0x19c
    edge_detector_setup+0x260/0x364
    linereq_create+0x420/0x5a8
    gpio_ioctl+0x2d4/0x6c0

Fix this by copying the check for GPIO_NO_WAKE_IRQ from qcom-pdc.c, so that
MPM is removed entirely from the hierarchy for non-wake GPIOs.

Fixes: a6199bb514d8 ("irqchip: Add Qualcomm MPM controller driver")
Reported-by: Alexey Klimov <alexey.klimov@linaro.org>
Signed-off-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250502-irq-qcom-mpm-fix-no-wake-v1-1-8a1eafcd28d4@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-qcom-mpm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/irqchip/irq-qcom-mpm.c
+++ b/drivers/irqchip/irq-qcom-mpm.c
@@ -227,6 +227,9 @@ static int qcom_mpm_alloc(struct irq_dom
 	if (ret)
 		return ret;
 
+	if (pin == GPIO_NO_WAKE_IRQ)
+		return irq_domain_disconnect_hierarchy(domain, virq);
+
 	ret = irq_domain_set_hwirq_and_chip(domain, virq, pin,
 					    &qcom_mpm_chip, priv);
 	if (ret)


