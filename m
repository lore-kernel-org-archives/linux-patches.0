Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2987D4B7A5B;
	Thu, 17 Sep 2026 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659652; cv=none; b=FMX74cmRhuyBj+0Zq6X35jN5LOFEz+JaqB237vsXA0xN5N/QWK9cVuk8FxdDhu9TUIYOcga7ufom6hutjImiGnLJ87C3vSmeRyg2z1cj0+8QzOt1KL5PFq1by2QjR2LFTNbTfZ+DQOpPM3cNjjUrqKQhirEf8vJItER11Qqyuos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659652; c=relaxed/simple;
	bh=NQHXHapKXZEg/1XzM/G/dW/B9hrtEMi5xN4ISx51E6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgXI/+DOyPXYi4EuEQid0KW8Y4b2cKcFPMCyBTnChBjTDaHep9X6RVmcT4f51F+WQaC5VT+voQ+JZqYemHFyM+h92SLOf3+e1+uCV7CXrYU2xnz88YW83f1wW8B898lui30twq+nCireXHkHpURIIymMKjJUpYuXqOA1RMuUtIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuwjiZD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuwjiZD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A681F0089B;
	Thu, 17 Sep 2026 15:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659643;
	bh=aiPqN35NGAFYny2lHXIP+iTh8NoafpqWzktg0WoFoKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuwjiZD4LShZJDQrSdnIO0QRpXjCLJeHNVgWO8E70j6rgVJbnFccjhrGXxUvStgi1
	 4KW5hi2VyKmIx1LQ4eD8MUtmxTuN8GdNwDuX6Q+GGUBmWUtgwwTN3Oc3amJbNYjJlU
	 2nRitEYJKXAi74Y4qmLdFMzG3o1VGrkbSa6/2xY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 324/733] hwmon: Fix potential UAF in pec_store
Date: Thu, 17 Sep 2026 16:10:32 +0100
Message-ID: <20260917151359.577109356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 354ccc99b2dc8ba0cf6d4de34e520bcf6ecca5c2 ]

Sashiko reports:

In pec_store(), a guard(mutex)(&hwdev->lock) is taken. If the chip write
operation returns an error other than -EOPNOTSUPP, the code jumps to the
put label, which calls put_device(hdev). If this drops the final reference,
the device is freed. When the function then returns, the guard cleanup
function runs and attempts to unlock the freed mutex.

Use scoped_guard() instead of guard() to avoid the problem.

Fixes: 3ad2a7b9b15d5 ("hwmon: Serialize accesses in hwmon core")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/hwmon.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 29dc90a2c3fe7..8cf717ae8b1dd 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -371,18 +371,17 @@ static ssize_t pec_store(struct device *dev, struct device_attribute *devattr,
 	 * handling is not required.
 	 */
 	hwdev = to_hwmon_device(hdev);
-	guard(mutex)(&hwdev->lock);
-	if (hwdev->chip->ops->write) {
-		err = hwdev->chip->ops->write(hdev, hwmon_chip, hwmon_chip_pec, 0, val);
-		if (err && err != -EOPNOTSUPP)
-			goto put;
+	scoped_guard(mutex, &hwdev->lock) {
+		if (hwdev->chip->ops->write) {
+			err = hwdev->chip->ops->write(hdev, hwmon_chip, hwmon_chip_pec, 0, val);
+			if (err && err != -EOPNOTSUPP)
+				goto put;
+		}
+		if (!val)
+			client->flags &= ~I2C_CLIENT_PEC;
+		else
+			client->flags |= I2C_CLIENT_PEC;
 	}
-
-	if (!val)
-		client->flags &= ~I2C_CLIENT_PEC;
-	else
-		client->flags |= I2C_CLIENT_PEC;
-
 	err = count;
 put:
 	put_device(hdev);
-- 
2.53.0



