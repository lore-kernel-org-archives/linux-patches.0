Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B738F13DBBF;
	Tue, 27 Feb 2024 13:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041774; cv=none; b=Tc6YGthF0DIRDH0EL0Natqpzpyn8K1ThcnHW+vWXAljfilEusKl3UMilUU75TfC96R9HC+DCcfyQmqX5b48fPjKAZpnoRoBQp28Tyr7RDMaO4kjA2xku5WeigFNPI4Tk/+ZwV1Hp83M7xhH01rhV5AFcOLvAMzyCeMA639da5ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041774; c=relaxed/simple;
	bh=vVug46O5EeymUovq+1pspReTs0eWgrwZjtomCVXeM+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHSa5CmCZiIF6xWYHFQ7Ev0Bsu9kVD9r7/uALSD8Bq9YSd/+nWbpXf+QDboqyHOiTYhF2PnkFawBNf5S2/RdV4WHptSGPSeO5oMn4O927xbee4gXILAEfqdZ+mHNFxg0beJZ4LOmUpg1pWJ5bFTf49JRBGlLURWSmQAA+F3N3Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsEe/3kx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsEe/3kx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4460EC433F1;
	Tue, 27 Feb 2024 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041774;
	bh=vVug46O5EeymUovq+1pspReTs0eWgrwZjtomCVXeM+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsEe/3kxMX+CGN5atz5NEeCX+kxGgFLRvIwy3Rl2pidYSYIdFDt86NU259v542bpY
	 DsT71INAk1QZ4Jf8G5e2keD2L0ppl5uLxJ9ketxoi2Hova3JgOW2MgYSf8IT4T+eL4
	 9P1tI+2cii/JD1xJN6/2xwtB7gmEmItlAOZJRPG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/299] Input: goodix - accept ACPI resources with gpio_count == 3 && gpio_int_idx == 0
Date: Tue, 27 Feb 2024 14:22:27 +0100
Message-ID: <20240227131626.980452843@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



