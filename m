Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547C61D0E19;
	Wed,  2 Oct 2024 14:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879451; cv=none; b=OJItqhVCOHqyNTNqX9bqdCTPhsNfZOesSAsyCa8DfkzP3hs1L1gE3FroTybAh1f9AE1Xw1xomZIO9Hb7CJcmX6sMWIZGFjz9TfQwN958cpys9Dt/D6H0wbPGhjmAll3iSRy0ntYxR8hgcvA5Vut9hw3f7Rx0Q1a5zW7lJYgtoqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879451; c=relaxed/simple;
	bh=4zp5fgi9PYLs65KZw1VdMKe1ZQKWLPZMGihqCEqV5OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4aPsx9SdgfiEST5+BqGpFKZc/moflol69HkabU093jZJ3DA4w8QlspveNzUhYuql/VHKYloCsPwifPAf5LJMNtI2a4ey3pnwcWrGYSShdNjiVEE+fvqRtuzGOxWiQNYORC8LDQXJt7qiFnlq+1WOOyu0ipYDTPgwQr0yIAcXLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGuQ1byR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGuQ1byR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E6BC4CECE;
	Wed,  2 Oct 2024 14:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879451;
	bh=4zp5fgi9PYLs65KZw1VdMKe1ZQKWLPZMGihqCEqV5OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PGuQ1byRTSWIqQiufRvv7tjnNAeuIolKi1bqsCwRLqhCZbyxLWxyp0oqx3WnFyx+/
	 c+BiZNy9VCrTC4XkWtrWWswjrDSNpza2oF8ZaNGaRCvy045PPneNnJcohmdT6LIHiP
	 /UKQDFYQ/dk+6agaGi/zIVvTLBq1YU63h8EU5kFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/538] hwmon: (max16065) Fix alarm attributes
Date: Wed,  2 Oct 2024 14:56:01 +0200
Message-ID: <20241002125757.061012666@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 119abf7d1815f098f7f91ae7abc84324a19943d7 ]

Chips reporting overcurrent alarms report it in the second alarm register.
That means the second alarm register has to be read, even if the chip only
supports 8 or fewer ADC channels.

MAX16067 and MAX16068 report undervoltage and overvoltage alarms in
separate registers. Fold register contents together to report both with
the existing alarm attribute. This requires actually storing the chip type
in struct max16065_data. Rename the variable 'chip' to match the variable
name used in the probe function.

Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Fixes: f5bae2642e3d ("hwmon: Driver for MAX16065 System Manager and compatibles")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max16065.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index 5b2a174c6bad3..0ccb5eb596fc4 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -79,7 +79,7 @@ static const bool max16065_have_current[] = {
 };
 
 struct max16065_data {
-	enum chips type;
+	enum chips chip;
 	struct i2c_client *client;
 	const struct attribute_group *groups[4];
 	struct mutex update_lock;
@@ -162,10 +162,17 @@ static struct max16065_data *max16065_update_device(struct device *dev)
 						     MAX16065_CURR_SENSE);
 		}
 
-		for (i = 0; i < DIV_ROUND_UP(data->num_adc, 8); i++)
+		for (i = 0; i < 2; i++)
 			data->fault[i]
 			  = i2c_smbus_read_byte_data(client, MAX16065_FAULT(i));
 
+		/*
+		 * MAX16067 and MAX16068 have separate undervoltage and
+		 * overvoltage alarm bits. Squash them together.
+		 */
+		if (data->chip == max16067 || data->chip == max16068)
+			data->fault[0] |= data->fault[1];
+
 		data->last_updated = jiffies;
 		data->valid = true;
 	}
@@ -514,6 +521,7 @@ static int max16065_probe(struct i2c_client *client)
 	if (unlikely(!data))
 		return -ENOMEM;
 
+	data->chip = chip;
 	data->client = client;
 	mutex_init(&data->update_lock);
 
-- 
2.43.0



