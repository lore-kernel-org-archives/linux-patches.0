Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF2B1E1DF6;
	Wed,  7 May 2025 19:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644853; cv=none; b=ngDmLco5OhEmcaxAlBoNCq8pfDtup/Zs21LdLvxuuuZT769kbr7Z3t0ox1YLkr0Cmq3PBqPXzhLvrsfaxHGQZJ/flac0FaHAg553PCIgZ2b3rsf397Kc9+IKx1gy8fp0BEhn8bvP7Q2Auc6yLfGWEqNHoxrmSAgyw8oQc3ni4Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644853; c=relaxed/simple;
	bh=12aZVv5E2kZHdlj0W0xw/MktVpMiWVDXP5UQs+4sTT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xtr8AziG0TRjAgha/pEQIikkSjoVb12UOdnBpOfZHLN/3w8OCyyknztJZT/8W/vRzyZsiZgKhmZYMkpL/gO0FL157avdQheVH3gnn1ljmNb+bMxPIcG0pMIyw7ju++2+NOkZd3xRKwrUojJcUin0wd00nIgFr7oGTj1YoTlpPD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEsohCKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEsohCKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6677CC4CEE2;
	Wed,  7 May 2025 19:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644852;
	bh=12aZVv5E2kZHdlj0W0xw/MktVpMiWVDXP5UQs+4sTT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEsohCKyxC/kSEX/20mbALkqq2n6tw7dYT9//6zXYYkDkz0+OTGoy9Ed2WAcmCcRO
	 Qhov+4pF3X2KtykvjGSm2y5Cf2WhLVB6vt7bl+QJdw3S6Ky85RMdKFPrTNymVscrbz
	 czW4NffvpsN8CUzpaoL3ySL7SRczH6Pi55WZRcgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.6 014/129] irqchip/qcom-mpm: Prevent crash when trying to handle non-wake GPIOs
Date: Wed,  7 May 2025 20:39:10 +0200
Message-ID: <20250507183814.117871000@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -226,6 +226,9 @@ static int qcom_mpm_alloc(struct irq_dom
 	if (ret)
 		return ret;
 
+	if (pin == GPIO_NO_WAKE_IRQ)
+		return irq_domain_disconnect_hierarchy(domain, virq);
+
 	ret = irq_domain_set_hwirq_and_chip(domain, virq, pin,
 					    &qcom_mpm_chip, priv);
 	if (ret)


