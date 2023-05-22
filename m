Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F86171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97BFC433D2;
	Mon, 22 May 2023 19:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783264;
	bh=XTwa66rXeun3FJNVUNs/JjnqChH4soW15p20BVIFlA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsCwpK5p4lGg26POJRga5CplwSOhJa58KcZtkq/VOJGDEfkfxzU8DFRGCi/HrAy6F
	 s1Vo1dFe8aeEqSYmZqxFkg4w9qYyH82ZyUhsd3cn0SRKX8mHdbCjnPvIBZ/S+mzPa/
	 LF8Mb+/1tDhvViwqrQxyVcujp03oER8oWQe5TOqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 192/203] serial: qcom-geni: fix enabling deactivated interrupt
Date: Mon, 22 May 2023 20:10:16 +0100
Message-Id: <20230522190400.340710275@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 5f949f140f73696f64acb89a1f16ff9153d017e0 upstream.

The driver have a race, experienced only with PREEMPT_RT patchset:

CPU0                         | CPU1
==================================================================
qcom_geni_serial_probe       |
  uart_add_one_port          |
                             | serdev_drv_probe
                             |   qca_serdev_probe
                             |     serdev_device_open
                             |       uart_open
                             |         uart_startup
                             |           qcom_geni_serial_startup
                             |             enable_irq
                             |               __irq_startup
                             |                 WARN_ON()
                             |                 IRQ not activated
  request_threaded_irq       |
    irq_domain_activate_irq  |

The warning:

  894000.serial: ttyHS1 at MMIO 0x894000 (irq = 144, base_baud = 0) is a MSM
  serial serial0: tty port ttyHS1 registered
  WARNING: CPU: 7 PID: 107 at kernel/irq/chip.c:241 __irq_startup+0x78/0xd8
  ...
  qcom_geni_serial 894000.serial: serial engine reports 0 RX bytes in!

Adding UART port triggers probe of child serial devices - serdev and
eventually Qualcomm Bluetooth hci_qca driver.  This opens UART port
which enables the interrupt before it got activated in
request_threaded_irq().  The issue originates in commit f3974413cf02
("tty: serial: qcom_geni_serial: Wakeup IRQ cleanup") and discussion on
mailing list [1].  However the above commit does not explain why the
uart_add_one_port() is moved above requesting interrupt.

[1] https://lore.kernel.org/all/5d9f3dfa.1c69fb81.84c4b.30bf@mx.google.com/

Fixes: f3974413cf02 ("tty: serial: qcom_geni_serial: Wakeup IRQ cleanup")
Cc: <stable@vger.kernel.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20230505152301.2181270-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1443,19 +1443,18 @@ static int qcom_geni_serial_probe(struct
 	platform_set_drvdata(pdev, port);
 	port->handle_rx = console ? handle_rx_console : handle_rx_uart;
 
-	ret = uart_add_one_port(drv, uport);
-	if (ret)
-		return ret;
-
 	irq_set_status_flags(uport->irq, IRQ_NOAUTOEN);
 	ret = devm_request_irq(uport->dev, uport->irq, qcom_geni_serial_isr,
 			IRQF_TRIGGER_HIGH, port->name, uport);
 	if (ret) {
 		dev_err(uport->dev, "Failed to get IRQ ret %d\n", ret);
-		uart_remove_one_port(drv, uport);
 		return ret;
 	}
 
+	ret = uart_add_one_port(drv, uport);
+	if (ret)
+		return ret;
+
 	/*
 	 * Set pm_runtime status as ACTIVE so that wakeup_irq gets
 	 * enabled/disabled from dev_pm_arm_wake_irq during system


