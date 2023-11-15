Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5358143ACE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJMUMBfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20A2C4AF7C;
	Wed, 15 Nov 2023 20:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081428;
	bh=SBT6Yh/08538qnMkQ6wGapy4F4IgCadeNs8/shimkLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJMUMBfy5z03pENT9V2dD+fHM0+HWfq1X3PgvL/lG8J9BLmTSSvEWjnZFVlEbpOJn
	 croCxIZtJLPL65mxFzSyqnUb6J4HxfERfwQfZT8v6kTBoNTqgfbbyue3rxccfjEntL
	 9fSaQp5Rkmj/8MPC4bWDDwO1miEH+gcLJOwpp3n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danny Kaehn <danny.kaehn@plexus.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/244] hid: cp2112: Fix IRQ shutdown stopping polling for all IRQs on chip
Date: Wed, 15 Nov 2023 15:35:40 -0500
Message-ID: <20231115203557.213631147@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danny Kaehn <danny.kaehn@plexus.com>

[ Upstream commit dc3115e6c5d9863ec1a9ff1acf004ede93c34361 ]

Previously cp2112_gpio_irq_shutdown() always cancelled the
gpio_poll_worker, even if other IRQs were still active, and did not set
the gpio_poll flag to false. This resulted in any call to _shutdown()
resulting in interrupts no longer functioning on the chip until a
_remove() occurred (a.e. the cp2112 is unplugged or system rebooted).

Only cancel polling if all IRQs are disabled/masked, and correctly set
the gpio_poll flag, allowing polling to restart when an interrupt is
next enabled.

Signed-off-by: Danny Kaehn <danny.kaehn@plexus.com>
Fixes: 13de9cca514e ("HID: cp2112: add IRQ chip handling")
Link: https://lore.kernel.org/r/20231011182317.1053344-1-danny.kaehn@plexus.com
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-cp2112.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1171,7 +1171,10 @@ static void cp2112_gpio_irq_shutdown(str
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct cp2112_device *dev = gpiochip_get_data(gc);
 
-	cancel_delayed_work_sync(&dev->gpio_poll_worker);
+	if (!dev->irq_mask) {
+		dev->gpio_poll = false;
+		cancel_delayed_work_sync(&dev->gpio_poll_worker);
+	}
 }
 
 static int cp2112_gpio_irq_type(struct irq_data *d, unsigned int type)


