Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFAF1DDF5;
	Thu, 15 Aug 2024 13:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728573; cv=none; b=pY75ee+j2v7ksJEBaTb38zYv71g+OPWBe61HHUT4g5WBdRsv7PPXZkEkKZjyjfiEbgxvm+8hDSOu9SHuDQoc6wGpsx2PyGRQ0foeCleTWuoVC3jtfbiAD4OjWpE0bOgD5w9CS2dYnJ73bdYqwzvQdxfIwn/YBK/6WoaG51v9bwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728573; c=relaxed/simple;
	bh=yJLpZIpegTTCny5cMvp1eKVP3r9uU7jwKlOf2nKcrMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmywEceRZRePyVwUb/U23K1IPqvahKI39bJMZQsYZB9undqTlVZVtO9fGOg+nQvnLWhfdHEWbR/FnBvXixz7uoSqB7N+9+4K7uVpmQ9uT982jmK8i/Gl88GjyWnUeTfAsbyq4BrSVmUdk9em5Ni8tTQyWrJWKNjhWP+3eE5kPBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=11h0h435; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="11h0h435"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F17C32786;
	Thu, 15 Aug 2024 13:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728573;
	bh=yJLpZIpegTTCny5cMvp1eKVP3r9uU7jwKlOf2nKcrMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=11h0h435vVFsCR3Yk6zyjizx8gk+eO6M4jGF/ZlQWB9okZjUZt+0AVjA/m3/kZG1I
	 PPjrnkXkb4fKiLsN3VGeZqQRWGp+Ff8Ye3BcEvdj4w1WJ9qFkZ3dAwNMDbpCZU3s09
	 p96D/SI98VMTQhaiStS/ECk/3gXr+iy/69RHeXs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/196] hwmon: (max6697) Fix swapped temp{1,8} critical alarms
Date: Thu, 15 Aug 2024 15:22:09 +0200
Message-ID: <20240815131852.544250473@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 1ea3fd1eb9869fcdcbc9c68f9728bfc47b9503f1 ]

The critical alarm bit for the local temperature sensor (temp1) is in
bit 7 of register 0x45 (not bit 6), and the critical alarm bit for remote
temperature sensor 7 (temp8) is in bit 6 (not bit 7).

This only affects MAX6581 since all other chips supported by this driver
do not support those critical alarms.

Fixes: 5372d2d71c46 ("hwmon: Driver for Maxim MAX6697 and compatibles")
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6697.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/max6697.c b/drivers/hwmon/max6697.c
index 2103ba45de745..14c34a2d36af3 100644
--- a/drivers/hwmon/max6697.c
+++ b/drivers/hwmon/max6697.c
@@ -368,14 +368,14 @@ static SENSOR_DEVICE_ATTR_RO(temp6_max_alarm, alarm, 20);
 static SENSOR_DEVICE_ATTR_RO(temp7_max_alarm, alarm, 21);
 static SENSOR_DEVICE_ATTR_RO(temp8_max_alarm, alarm, 23);
 
-static SENSOR_DEVICE_ATTR_RO(temp1_crit_alarm, alarm, 14);
+static SENSOR_DEVICE_ATTR_RO(temp1_crit_alarm, alarm, 15);
 static SENSOR_DEVICE_ATTR_RO(temp2_crit_alarm, alarm, 8);
 static SENSOR_DEVICE_ATTR_RO(temp3_crit_alarm, alarm, 9);
 static SENSOR_DEVICE_ATTR_RO(temp4_crit_alarm, alarm, 10);
 static SENSOR_DEVICE_ATTR_RO(temp5_crit_alarm, alarm, 11);
 static SENSOR_DEVICE_ATTR_RO(temp6_crit_alarm, alarm, 12);
 static SENSOR_DEVICE_ATTR_RO(temp7_crit_alarm, alarm, 13);
-static SENSOR_DEVICE_ATTR_RO(temp8_crit_alarm, alarm, 15);
+static SENSOR_DEVICE_ATTR_RO(temp8_crit_alarm, alarm, 14);
 
 static SENSOR_DEVICE_ATTR_RO(temp2_fault, alarm, 1);
 static SENSOR_DEVICE_ATTR_RO(temp3_fault, alarm, 2);
-- 
2.43.0



