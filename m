Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3852253358;
	Mon, 23 Jun 2025 13:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684753; cv=none; b=Dl4fkz18THmBNwIiZxYchQ9mARIoKV7O9rP6pETvgJr5luz3pDYvkThrQ5GM7hJb0q1SjjkbndYQeITfcxKoNT/Rr0nUZdMi06Y5vJx8z4gQxPwQg4ncN1tiwPn4pdV6yCvb+8X8ZxkZu/4xgjxMo2WKwIIUGEHa6Dr0CDoa8sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684753; c=relaxed/simple;
	bh=y0Ue1cc0J66Dx1b3Y86cpa4IPqHkEPB6koG76jC273E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSI3J2gwyjOZyKLJuzNRuCuLOvcuWi9MDVw0UIoTg+J/6ARIdfNYwJraVVjzVOTlTW2Wk3HUK9xx7y4KNxUfZJU6FQ1MpuKLrMtGeKzD3K7ncroSzcdpeElRm2/nxPBM60ZDBe9m9tDyEjGw8IsYYli0rCKZdFlE8oWeAAy1XCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHSTrOCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHSTrOCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D8FC4CEEA;
	Mon, 23 Jun 2025 13:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684753;
	bh=y0Ue1cc0J66Dx1b3Y86cpa4IPqHkEPB6koG76jC273E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHSTrOCB2j6wa92KFc592jP47H2u11bIMm9qauRJzuxEVvNMbyGOmEjnWFoaTeG96
	 EqeUSyEpHV8uhLRMYdQrM5I3orfa6S7vNGd4FF+lfho4a4cB3QdTdnQ0TanQ/KqYy7
	 3pTWbpwsP2V6BZAQFtL9HZJDw8Mq1va8ETgu+9H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.15 126/592] hwmon: (ftsteutates) Fix TOCTOU race in fts_read()
Date: Mon, 23 Jun 2025 15:01:24 +0200
Message-ID: <20250623130703.267199551@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

commit 14c9ede9ca4cd078ad76a6ab9617b81074eb58bf upstream.

In the fts_read() function, when handling hwmon_pwm_auto_channels_temp,
the code accesses the shared variable data->fan_source[channel] twice
without holding any locks. It is first checked against
FTS_FAN_SOURCE_INVALID, and if the check passes, it is read again
when used as an argument to the BIT() macro.

This creates a Time-of-Check to Time-of-Use (TOCTOU) race condition.
Another thread executing fts_update_device() can modify the value of
data->fan_source[channel] between the check and its use. If the value
is changed to FTS_FAN_SOURCE_INVALID (0xff) during this window, the
BIT() macro will be called with a large shift value (BIT(255)).
A bit shift by a value greater than or equal to the type width is
undefined behavior and can lead to a crash or incorrect values being
returned to userspace.

Fix this by reading data->fan_source[channel] into a local variable
once, eliminating the race condition. Additionally, add a bounds check
to ensure the value is less than BITS_PER_LONG before passing it to
the BIT() macro, making the code more robust against undefined behavior.

This possible bug was found by an experimental static analysis tool
developed by our team.

Fixes: 1c5759d8ce05 ("hwmon: (ftsteutates) Replace fanX_source with pwmX_auto_channels_temp")
Cc: stable@vger.kernel.org
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://lore.kernel.org/r/20250606071640.501262-1-hanguidong02@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/ftsteutates.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/ftsteutates.c
+++ b/drivers/hwmon/ftsteutates.c
@@ -423,13 +423,16 @@ static int fts_read(struct device *dev,
 		break;
 	case hwmon_pwm:
 		switch (attr) {
-		case hwmon_pwm_auto_channels_temp:
-			if (data->fan_source[channel] == FTS_FAN_SOURCE_INVALID)
+		case hwmon_pwm_auto_channels_temp: {
+			u8 fan_source = data->fan_source[channel];
+
+			if (fan_source == FTS_FAN_SOURCE_INVALID || fan_source >= BITS_PER_LONG)
 				*val = 0;
 			else
-				*val = BIT(data->fan_source[channel]);
+				*val = BIT(fan_source);
 
 			return 0;
+		}
 		default:
 			break;
 		}


