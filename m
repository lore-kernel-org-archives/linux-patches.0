Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FAAB51EE1A;
	Thu, 17 Sep 2026 17:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665839; cv=none; b=J3woSgRAC4vWESkdPdHanBV4toFDP0EiVndRxZBVvjsAdZT8UupvpvS1ettkC+FkG71EDiuCUWI0M6BEwvfJL/NJIhFlf3eF9N6B+orpcNKVCYhA5rsVSpsARZB54/uFcYs4TZVzjSDbocfiRfkNDAaJmLIksJ7hRkRlVq5MRLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665839; c=relaxed/simple;
	bh=wOfYeaN1rkpcE9HJ1dhg8rkiG5F8bigna2Za1Oj6w5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj8wUc/3GWrCQITINS/HKBrXvXvJlc/2E2S5AmElk+rEV9JAFhcLfXXvUspilDrWu1KNQ6WKtzwGcSCAAYEcVNdK64b1nWnto7mnuc4jVLJol0IpNXPj5oc+NolOqbJR36TVsScM9s8WoQFN83QISR2i1EzF8h5XfRmoLC3/CSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVtkVUdL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVtkVUdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A823E1F000FF;
	Thu, 17 Sep 2026 17:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665838;
	bh=e3nD+b8yiGQ8PV7+nbcg54NIm+gkeAckjh8az7SPyso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZVtkVUdLxwzsab4ysc6HNmU9dUYw+jDjyIEbLlkMolzjguJpVIq/OSl/pRdrSxPJ3
	 xgroAYLA2HWh29fwqb02ZtTZBW8tWM+5/RVi7pVye1AL+7ChCAxqPBHT2YjeBQfUpn
	 Rjs42iTguTCOOWLu0qT3FXsLuuT1N+CKUiPrhVIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0837/1250] hwmon: Fix potential UAF in pec_store
Date: Thu, 17 Sep 2026 16:10:32 +0100
Message-ID: <20260917151614.636712194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 0b4bdcd33c7b8..0f6200410c868 100644
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



