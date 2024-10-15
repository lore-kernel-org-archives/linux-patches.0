Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01D51E9068;
	Tue, 15 Oct 2024 11:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992668; cv=none; b=LmJZ5sWKhnVYl3R5URpAyuiAOn0eBk02bSDW9+aFYPq2YaQoKLCwPE8vYpGycVuRB3pQAfwq/lTVrHQL9KCMwepiY8SZLeFVwb/s4H/XxkGD0Op5rt0QbkC9RzsfqyZ1Dk75oYz94Tws7mtVDLmtqhjKJk/Nm1aLiUE17sK5nNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992668; c=relaxed/simple;
	bh=xzjkZkkw+eN7ENnkUbgDg2f+/E2p9vuZF65N7imy68U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TirA7N+Hpe2FU/uRaylsEIRp/dFXTruBjTDxcBYy9Xechp2iLx5EyNfroYGXtuSP5COVfZImiGvRIbZQwh/2XTTaD4mExJOt5LrQVDVc4iWixrYPfKnGAfUTUcuRwHW0j7ti+ZVMs2i5fabd5MO2WEGvHe2fMobg22k5f7Di7uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXPVFtt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXPVFtt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614E5C4CEC6;
	Tue, 15 Oct 2024 11:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992667;
	bh=xzjkZkkw+eN7ENnkUbgDg2f+/E2p9vuZF65N7imy68U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXPVFtt7vrm68YMXd6dcQR3eUvFXx2pDTEot2emTx7YNxWi8i9GPIR7VbAPgAfklT
	 tZ2ke6LrlPihT/LLxSvkNL90gtVSti757yR0riBi8GMgEKPY+RW634M62IRO3N3kj1
	 qpFq1DSRfqfXRkksaLPFFvzGGVw+43zVZpd5XzCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/691] hwmon: (max16065) Fix alarm attributes
Date: Tue, 15 Oct 2024 13:21:40 +0200
Message-ID: <20241015112446.389196688@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index 174a2b9ea2b80..25de0065bdedd 100644
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
 		data->valid = 1;
 	}
@@ -514,6 +521,7 @@ static int max16065_probe(struct i2c_client *client)
 	if (unlikely(!data))
 		return -ENOMEM;
 
+	data->chip = chip;
 	data->client = client;
 	mutex_init(&data->update_lock);
 
-- 
2.43.0



