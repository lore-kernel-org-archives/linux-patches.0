Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDEB13B79F;
	Tue, 27 Feb 2024 13:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040584; cv=none; b=e5DBRPwaTazceMIgwVrYtIjpRnCMqwh9uFYlX4PCSRk8+34eZGy7khgK4n4MP/7hj5IyFiiXrYOuLA5nGYc+DjspeocbZ8W7LpickLQOFqxwgr1YUewz7llU2np+bq1qo0u0zcfTHrsacT/43+h1fRfn+MBZlW0MPBpgccenfJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040584; c=relaxed/simple;
	bh=VEGvg/cd/8KpTcwTV+FXTW0RVt8WBdf2pc3fn9B5gTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/wMsvMO16LuGevEHWpMqxzzF6mWIZ94/RQmrB2WGmOshXE1kDe0a3LdT37pJdmEF1CgfWXtBsbbJ/RJXci7EjYNEGe0HUQYGtA421wZOY6LImfbFoc09jQ/gei4q1Weux0x1uvgsCeCqjdCG1vV2X7+t0lMHWaB3rAPuWKw1SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwmrvwtS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwmrvwtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF60C433A6;
	Tue, 27 Feb 2024 13:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040584;
	bh=VEGvg/cd/8KpTcwTV+FXTW0RVt8WBdf2pc3fn9B5gTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwmrvwtS68cFYdS5HlKCVGN7gnKxN566aqXArO//ZFzn550FZnVaAOEST7wIWCs1R
	 gqxQhEWiFn7UoEaGnCExiurCe76zEPhkg8K+MSXkK7T48HWpLV5fMhw41oHXj3B5Ev
	 j74aS/chfLmvU6bK9MdTmVD5jKUzeOOFiurO2A78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 037/334] Input: goodix - accept ACPI resources with gpio_count == 3 && gpio_int_idx == 0
Date: Tue, 27 Feb 2024 14:18:15 +0100
Message-ID: <20240227131631.791567167@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 180a8f12c21f41740fee09ca7f7aa98ff5bb99f8 ]

Some devices list 3 Gpio resources in the ACPI resource list for
the touchscreen:

1. GpioInt resource pointing to the GPIO used for the interrupt
2. GpioIo resource pointing to the reset GPIO
3. GpioIo resource pointing to the GPIO used for the interrupt

Note how the third extra GpioIo resource really is a duplicate
of the GpioInt provided info.

Ignore this extra GPIO, treating this setup the same as gpio_count == 2 &&
gpio_int_idx == 0 fixes the touchscreen not working on the Thunderbook
Colossus W803 rugged tablet and likely also on the CyberBook_T116K.

Reported-by: Maarten van der Schrieck
Closes: https://gitlab.com/AdyaAdya/goodix-touchscreen-linux-driver/-/issues/22
Suggested-by: Maarten van der Schrieck
Tested-by: Maarten van der Schrieck
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231223141650.10679-1-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/goodix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index af32fbe57b630..b068ff8afbc9a 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -884,7 +884,8 @@ static int goodix_add_acpi_gpio_mappings(struct goodix_ts_data *ts)
 		}
 	}
 
-	if (ts->gpio_count == 2 && ts->gpio_int_idx == 0) {
+	/* Some devices with gpio_int_idx 0 list a third unused GPIO */
+	if ((ts->gpio_count == 2 || ts->gpio_count == 3) && ts->gpio_int_idx == 0) {
 		ts->irq_pin_access_method = IRQ_PIN_ACCESS_ACPI_GPIO;
 		gpio_mapping = acpi_goodix_int_first_gpios;
 	} else if (ts->gpio_count == 2 && ts->gpio_int_idx == 1) {
-- 
2.43.0



