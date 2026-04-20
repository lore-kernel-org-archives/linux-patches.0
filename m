Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDBA3382C7;
	Mon, 20 Apr 2026 15:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699862; cv=none; b=aUqiYpwAhe/1Dtly0a9Nbd8YMK4Jizi8fpy79kp9vFTAEvmv6+9QNrGy1VAsak35G7LToEP/kI/jLKn0rpIFCawmMg4uatYiMPlRD5fjGBr1MnAPl3SY+dEPm0a/ZTJCs6S1I1mH0uRKlBDOHoCWzchZhDca8lH8IeWG9bUjY4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699862; c=relaxed/simple;
	bh=dUK6UkdFDF9BNm4MMv4tncD40AzS4sUzUcaNsM0oAwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5YtkqoaJReq7vgpGKoC+e7aMZURaq86Ag4HptO9K0dNSW33PzHDrDZeWAEjk3rGHDgvCDP2YZi597KK3KT4eMRDIU/sHYbR6v/Z2dCXel16laMw0QQnAebst3wyvMNiNFwjKliv050wJU9w/emG7UE9bFDMJPcqdbU6R7hnQuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UG6R/aPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UG6R/aPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D77C19425;
	Mon, 20 Apr 2026 15:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699862;
	bh=dUK6UkdFDF9BNm4MMv4tncD40AzS4sUzUcaNsM0oAwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UG6R/aPKJuoRG8t1oprOuIA1zwtgQdcjEvNqOSrlzsJ84eHRzSSN5HE+zWKHVmjRm
	 ea1dW8gEIbwlEEzteOIoS5uJKXKskQRf+HAefnBWrxoCIe19v1qPlLIjwvd0f1KCAD
	 BZKdC9mc9kf8gxE5axkGdSurmn9pV+bd6Q8iOr0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alexey Charkov <alchark@flipper.net>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogrerus@linux.intel.com>
Subject: [PATCH 7.0 26/76] usb: typec: fusb302: Switch to threaded IRQ handler
Date: Mon, 20 Apr 2026 17:41:37 +0200
Message-ID: <20260420153911.775662660@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@flipper.net>

commit 6b9db53197094f38a18797495df2e3c758ec51dc upstream.

FUSB302 fails to probe with -EINVAL if its interrupt line is connected via
an I2C GPIO expander, such as TI TCA6416.

Switch the interrupt handler to a threaded one, which also works behind
such GPIO expanders.

Cc: stable <stable@kernel.org>
Fixes: 309b6341d557 ("usb: typec: fusb302: Revert incorrect threaded irq fix")
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Heikki Krogerus <heikki.krogrerus@linux.intel.com>
Link: https://patch.msgid.link/20260317-fusb302-irq-v2-1-dbabd5c5c961@flipper.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/fusb302.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -1755,8 +1755,9 @@ static int fusb302_probe(struct i2c_clie
 		goto destroy_workqueue;
 	}
 
-	ret = request_irq(chip->gpio_int_n_irq, fusb302_irq_intn,
-			  IRQF_TRIGGER_LOW, "fsc_interrupt_int_n", chip);
+	ret = request_threaded_irq(chip->gpio_int_n_irq, NULL, fusb302_irq_intn,
+				   IRQF_ONESHOT | IRQF_TRIGGER_LOW,
+				   "fsc_interrupt_int_n", chip);
 	if (ret < 0) {
 		dev_err(dev, "cannot request IRQ for GPIO Int_N, ret=%d", ret);
 		goto tcpm_unregister_port;


