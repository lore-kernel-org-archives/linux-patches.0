Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D54A1D0DE2;
	Wed,  2 Oct 2024 14:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877683; cv=none; b=daiVap9Rp3L80qJBvQsSctjMoGtRe0ZPQz+qKu06zhUgCvKEWCzbCb2ZCViH72Z+i4eo/Exb7MDmGgawpTU/Lt8dE6cGFi8Sjwis2Y+mMPDl/uiuA/dUDAkFaVSeT+QrbV8B5HUisIf+X9fE5O9ZY6Ayufn4UhkFVHawW3zNGlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877683; c=relaxed/simple;
	bh=pax0gG+FV3xWHRw0tgtq9R2lhfUG2ayk2rNPfckLku0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqUhzUlf5NIVd7ycDErlg9qaIxTHyZYOMGMPQKgX1I8gtOAOg91fODN14+RFyL6ludB4Xya2V7bOa8oCt8wMVLQIz5dT8DGqe7NxxuyZCyFev+G2S0thuVJmSBxyVRSybi0UX6aWVI69o3R9lx/i3lA3rKhT3gcKpgyXrScyBqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyqDOr1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyqDOr1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE4CC4CECD;
	Wed,  2 Oct 2024 14:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877683;
	bh=pax0gG+FV3xWHRw0tgtq9R2lhfUG2ayk2rNPfckLku0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyqDOr1SUE/ig4atWhrTzn5BqPjf6l9EbrXmLu6jjBtOcLkKKMim7WPkeYSSTrqbx
	 ae6xnvm+oQVI6eNTKLodgoJazX163SOOiYBPDVHLRbQ+vpNFyCjjWrufiWv2Wsz6DN
	 UYkijioNuDpLe2hmbtr76po+Kk35Bo5xbqcrtAIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 158/634] hwmon: (max16065) Fix alarm attributes
Date: Wed,  2 Oct 2024 14:54:18 +0200
Message-ID: <20241002125817.346942914@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



