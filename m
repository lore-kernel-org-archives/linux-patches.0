Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419C02E1C7C;
	Tue, 31 Mar 2026 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976823; cv=none; b=naiaPtd7uQ3oCJzQ0LgGac6Gvgxt7iG0z5lQYCYdFi5VRw019poqVVBDNnAzzUIDO4s3HVAXpgSgvQofWNSFUGhKjsaWoX7VPCQrzedQbE0RDwshkhG69blhaFMKYzykGQoWCpzvFTAOc6whfae0JQGwB3Eyck53kQ7cvL4uTEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976823; c=relaxed/simple;
	bh=LJiS5zKGhd2mEiK3+Vam+nr9v/oGTuN9alrOIlM1n7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeBa7Xmqcl7BFfWacxzsvONeHbU/u7GLv8moIVtq0SojdZaQdEFBCurfV78iHing5guEL2zvA289gpsOz0BEfe8vlhYhA+V0uaZ/RJSuGr9Yi3AhbC3oLvh2oymCJp4CfW47SdpWwVBEJrBm3Zh0jPmQqR1SbQVVAeSaMMcE8v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpWwsF/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpWwsF/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA963C19423;
	Tue, 31 Mar 2026 17:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976823;
	bh=LJiS5zKGhd2mEiK3+Vam+nr9v/oGTuN9alrOIlM1n7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpWwsF/E6/USuksewql4qIec0qDjkJ07DuW8zBO95HZkImGG3V8EhGW0I5xH+rwNz
	 o9qkqgBOY+ODHl3FXVJ1G8pmIT5bkQzpOuB9q53t72IQzk+KlBJq/q5WZbJ+FbvTv1
	 eh23zbS3cFRRy9zP6I89P/jIhotwe/7FAKDuTX+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 199/309] hwmon: (pmbus/ina233) Fix error handling and sign extension in shunt voltage read
Date: Tue, 31 Mar 2026 18:21:42 +0200
Message-ID: <20260331161800.778741739@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit f7e775c4694782844c66da5316fed82881835cf8 upstream.

ina233_read_word_data() reads MFR_READ_VSHUNT via pmbus_read_word_data()
but has two issues:

1. The return value is not checked for errors before being used in
   arithmetic. A negative error code from a failed I2C transaction is
   passed directly to DIV_ROUND_CLOSEST(), producing garbage data.

2. MFR_READ_VSHUNT is a 16-bit two's complement value. Negative shunt
   voltages (values with bit 15 set) are treated as large positive
   values since pmbus_read_word_data() returns them zero-extended in an
   int. This leads to incorrect scaling in the VIN coefficient
   conversion.

Fix both issues by adding an error check, casting to s16 for proper
sign extension, and clamping the result to a valid non-negative range.
The clamp is necessary because read_word_data callbacks must return
non-negative values on success (negative values indicate errors to the
pmbus core).

Fixes: b64b6cb163f16 ("hwmon: Add driver for TI INA233 Current and Power Monitor")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260319173055.125271-2-sanman.pradhan@hpe.com
[groeck: Fixed clamp to avoid losing the sign bit]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/ina233.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/ina233.c b/drivers/hwmon/pmbus/ina233.c
index 2d8b5a5347ed..7aebd854763a 100644
--- a/drivers/hwmon/pmbus/ina233.c
+++ b/drivers/hwmon/pmbus/ina233.c
@@ -72,7 +72,8 @@ static int ina233_read_word_data(struct i2c_client *client, int page,
 
 		/* Adjust returned value to match VIN coefficients */
 		/* VIN: 1.25 mV VSHUNT: 2.5 uV LSB */
-		ret = DIV_ROUND_CLOSEST(ret * 25, 12500);
+		ret = clamp_val(DIV_ROUND_CLOSEST((s16)ret * 25, 12500),
+				S16_MIN, S16_MAX) & 0xffff;
 		break;
 	default:
 		ret = -ENODATA;
-- 
2.53.0



