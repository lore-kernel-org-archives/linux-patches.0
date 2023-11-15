Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A1F3A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLgeoe3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3978CC43397;
	Wed, 15 Nov 2023 19:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077937;
	bh=k0EtvJYE6lHKRnFXLu0XrR2mM6diEyujEcClYGHFtrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLgeoe3RY9s/a9lJeXD5tAyQVtV9R5LumG3NS0QT9KMrPDrqsSCzTGcy3qdhcOxxV
	 P9/BWLTjColnSSUNt/JvG3OpnYOF3iG+uz/FzVw/1wVbBiw5z3LKagMnfxr/EpFIW1
	 uFpxWF/1rcM8+3szbgu8op3NalzwVa77GdGfRS6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zev Weiss <zev@bewilderbeest.net>,
	Thomas Zajic <zlatko@gmx.at>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 001/379] hwmon: (nct6775) Fix incorrect variable reuse in fan_div calculation
Date: Wed, 15 Nov 2023 14:21:16 -0500
Message-ID: <20231115192645.226433010@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zev Weiss <zev@bewilderbeest.net>

commit 920057ad521dc8669e534736c2a12c14ec9fb2d7 upstream.

In the regmap conversion in commit 4ef2774511dc ("hwmon: (nct6775)
Convert register access to regmap API") I reused the 'reg' variable
for all three register reads in the fan speed calculation loop in
nct6775_update_device(), but failed to notice that the value from the
first one (data->REG_FAN[i]) is actually used in the call to
nct6775_select_fan_div() at the end of the loop body.  Since that
patch the register value passed to nct6775_select_fan_div() has been
(conditionally) incorrectly clobbered with the value of a different
register than intended, which has in at least some cases resulted in
fan speeds being adjusted down to zero.

Fix this by using dedicated temporaries for the two intermediate
register reads instead of 'reg'.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Fixes: 4ef2774511dc ("hwmon: (nct6775) Convert register access to regmap API")
Reported-by: Thomas Zajic <zlatko@gmx.at>
Tested-by: Thomas Zajic <zlatko@gmx.at>
Cc: stable@vger.kernel.org # v5.19+
Link: https://lore.kernel.org/r/20230929200822.964-2-zev@bewilderbeest.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/nct6775-core.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -1528,17 +1528,21 @@ struct nct6775_data *nct6775_update_devi
 							  data->fan_div[i]);
 
 			if (data->has_fan_min & BIT(i)) {
-				err = nct6775_read_value(data, data->REG_FAN_MIN[i], &reg);
+				u16 tmp;
+
+				err = nct6775_read_value(data, data->REG_FAN_MIN[i], &tmp);
 				if (err)
 					goto out;
-				data->fan_min[i] = reg;
+				data->fan_min[i] = tmp;
 			}
 
 			if (data->REG_FAN_PULSES[i]) {
-				err = nct6775_read_value(data, data->REG_FAN_PULSES[i], &reg);
+				u16 tmp;
+
+				err = nct6775_read_value(data, data->REG_FAN_PULSES[i], &tmp);
 				if (err)
 					goto out;
-				data->fan_pulses[i] = (reg >> data->FAN_PULSE_SHIFT[i]) & 0x03;
+				data->fan_pulses[i] = (tmp >> data->FAN_PULSE_SHIFT[i]) & 0x03;
 			}
 
 			err = nct6775_select_fan_div(dev, data, i, reg);


