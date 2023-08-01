Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3594200A9
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26BF0C433C9;
	Tue,  1 Aug 2023 09:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882569;
	bh=EOcPMJZoLtZnOy37F9d1FWqpwOBnzt9+l+mZOqaTdkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rogH6+LTBZ3uN6SCsbq2/AC14H0678WsAilrFO3PIQmvwS1u9RMibpGB/kJnMabgi
	 oFPzvRkuAiU+n1x9NoAOTD+ZQc4KZhpDa3Jse+ZOfaPaXk6TiuX9SHUOcfLYQQtLs9
	 O0oP/Wg4kmC8SrM5Dk9MfbAMVGFeFoqFKONcRDFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 153/228] serial: qcom-geni: drop bogus runtime pm state update
Date: Tue,  1 Aug 2023 11:20:11 +0200
Message-ID: <20230801091928.426189137@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 4dd8752a14ca0303fbdf0a6c68ff65f0a50bd2fa upstream.

The runtime PM state should not be changed by drivers that do not
implement runtime PM even if it happens to work around a bug in PM core.

With the wake irq arming now fixed, drop the bogus runtime PM state
update which left the device in active state (and could potentially
prevent a parent device from suspending).

Fixes: f3974413cf02 ("tty: serial: qcom_geni_serial: Wakeup IRQ cleanup")
Cc: 5.6+ <stable@vger.kernel.org> # 5.6+
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1495,13 +1495,6 @@ static int qcom_geni_serial_probe(struct
 	if (ret)
 		return ret;
 
-	/*
-	 * Set pm_runtime status as ACTIVE so that wakeup_irq gets
-	 * enabled/disabled from dev_pm_arm_wake_irq during system
-	 * suspend/resume respectively.
-	 */
-	pm_runtime_set_active(&pdev->dev);
-
 	if (port->wakeup_irq > 0) {
 		device_init_wakeup(&pdev->dev, true);
 		ret = dev_pm_set_dedicated_wake_irq(&pdev->dev,


