Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594971D0433;
	Wed,  2 Oct 2024 13:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875655; cv=none; b=cAx3KNDoGjCvKDCUuXrT8K+k5ZNOFohukvoafz1zy+9hJlaqWLRMAXr2/VezVXs4eaJcrU/Lr1N/r96kaMyI0UHUC5YFHG/JZfuDNNLL718B+EWeNE6x2Tz+aL/wEoPsyFKlRWcWCh1nO9YqVFdrxTWRKwQ/OuP/GjWEgnOGyn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875655; c=relaxed/simple;
	bh=s8bkJmPxwQh+WEAdg1/nQhUiziHEA8077MqwwZq6kEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anlYsfffcE3gXP1sYteQ2l6FVcgNIdl1bHHOrq5zKkgwBVhmM/U4MqgHRCmsEtIixhGD9r8bFxiWkpaazY8P65hwCSH3bHm/Uzj5rGAgTgkDLufdv4aTFcNHSnRblpm3ziMs165/6nL4v2ms0CayFjuzpGEEm2Ap+mDgHLeFEsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6aDnO4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6aDnO4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1538C4CED2;
	Wed,  2 Oct 2024 13:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875655;
	bh=s8bkJmPxwQh+WEAdg1/nQhUiziHEA8077MqwwZq6kEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6aDnO4lLSUgb17x++L6uyC1CjOmLnGG0naCOjRVzuf44eBqZXec7Qy/Du5AELPyd
	 1dXgW/1k0a7fAY5M11/QqfaNZL2cLFIbBfe3woQZDJ0nPyXbOfkT2Jr7dWZ0UTDUBj
	 whOGm2KJ7TAxeR7Zg3Vp22sH13oyMVjH16CvgtQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 175/695] hwmon: (max16065) Fix alarm attributes
Date: Wed,  2 Oct 2024 14:52:53 +0200
Message-ID: <20241002125829.457823154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



