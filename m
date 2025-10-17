Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EDD330B04;
	Fri, 17 Oct 2025 15:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716313; cv=none; b=hQlqC7ZuDAr4Nt1bZoZ4seG8MpM++O9PLyNucbDm3N4TVqA2Cdfd/WmYrv9ehpVjleytqfBh5gxqV92arYZdvINIu67Brx/H0jnkiMYp82DrZ2svUMCUIiNCxiAUky7Jy2a2dxEIVXZ5gARfuySG7mmQsEQA9Z7+jmGULnVovaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716313; c=relaxed/simple;
	bh=WRn28P7wpQKxh70++wg2Q83Hl33Zbo8eQlLGVV6H1zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e23xHRgFL+AjK7xySVnYKVCSrahQXmVJWPjt83JhnpTC4YsLhBx5P+NK87SmOXhpIFaCy62XI1kUhCVJiIs1OQk6R0pfh99rbM4+C7cOahpNfg3JHZZZO+tx8O1vO1cbm9OQX2CdlnpJAeeILdhynSG2W5aS22ygIVVwMOET/hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9Vc8oCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9Vc8oCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1826DC4CEE7;
	Fri, 17 Oct 2025 15:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716313;
	bh=WRn28P7wpQKxh70++wg2Q83Hl33Zbo8eQlLGVV6H1zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9Vc8oCpaJrZh9hnbMsxuBeYSDhmFefZY9/TJpgVEMitMOISMgiXctQeYT6qQHvHb
	 HVakWEyTHJljB9+2a/t4/i8qFHNTurciHRSQGPXfNMJnG6jVRHMlrVBiKoigiX+iso
	 8LwUEZ/WwS79jX59k/nitI5CrTFCygU0+AEaFaDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 115/276] Input: atmel_mxt_ts - allow reset GPIO to sleep
Date: Fri, 17 Oct 2025 16:53:28 +0200
Message-ID: <20251017145146.676785391@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut@mailbox.org>

commit c7866ee0a9ddd9789faadf58cdac6abd7aabf045 upstream.

The reset GPIO is not toggled in any critical section where it couldn't
sleep, allow the reset GPIO to sleep. This allows the driver to operate
reset GPIOs connected to I2C GPIO expanders.

Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Link: https://lore.kernel.org/r/20251005023335.166483-1-marek.vasut@mailbox.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -3239,7 +3239,7 @@ static int mxt_probe(struct i2c_client *
 	if (data->reset_gpio) {
 		/* Wait a while and then de-assert the RESET GPIO line */
 		msleep(MXT_RESET_GPIO_TIME);
-		gpiod_set_value(data->reset_gpio, 0);
+		gpiod_set_value_cansleep(data->reset_gpio, 0);
 		msleep(MXT_RESET_INVALID_CHG);
 	}
 


