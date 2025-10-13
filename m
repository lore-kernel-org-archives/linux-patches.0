Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3861A9B46;
	Mon, 13 Oct 2025 15:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368738; cv=none; b=gi66+hg6gW9UdFlM2Az9tqm1r4x+utoNE+7rnsvBmzBIQQ3wv7TsyofsSAsq32R0+KoJMZNUOKAYExVJIGEoOJyNtUif4aoiObzm6y2J7SXXSuJ+QEXMUPf8g18Z7Y8R8Rd8kup/6XHVmI1DzUGS0LtdHTrUCMcuWIJI23i6ufE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368738; c=relaxed/simple;
	bh=wogoRCOl7GyFm0ggRkKiTVn+wuEddQ3ETk4K/S5GyCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsKktUadmemAbeXDKHBXDIIsswgv64Gtpg7HxWKbULfehCMQunkLGPFXbUs/1C07CijJMc72eEBV7FFpQh8W/sjK3q8+zqJLYZ8G7lSgy8iHQoiKl0JexsG2K3Zf4MsdemppMmcAlobLdNtaWiK+QjQWWv1ERAwRSO13vlo5qyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xz0ZyD4H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xz0ZyD4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9698FC4CEE7;
	Mon, 13 Oct 2025 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368738;
	bh=wogoRCOl7GyFm0ggRkKiTVn+wuEddQ3ETk4K/S5GyCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xz0ZyD4Hw60Q17RlXZI7z46ULBuqWE071Nr+3yK4r2KaxpJmZxj3Sh0tRNvO8CONa
	 w9ZU5gFdQBlz6b+J7FCGQlPg+9tY//jqjqbqmP6K7VCDuVT6lcI1LZz22FfQk5f58C
	 ifYcbBgJsv0k8lJi6yNsolOmsaujYcwW2vkDSCOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 251/262] Input: atmel_mxt_ts - allow reset GPIO to sleep
Date: Mon, 13 Oct 2025 16:46:33 +0200
Message-ID: <20251013144335.276339284@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3319,7 +3319,7 @@ static int mxt_probe(struct i2c_client *
 	if (data->reset_gpio) {
 		/* Wait a while and then de-assert the RESET GPIO line */
 		msleep(MXT_RESET_GPIO_TIME);
-		gpiod_set_value(data->reset_gpio, 0);
+		gpiod_set_value_cansleep(data->reset_gpio, 0);
 		msleep(MXT_RESET_INVALID_CHG);
 	}
 


